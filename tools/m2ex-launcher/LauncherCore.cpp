#include "LauncherCore.h"

#include <Windows.h>
#include <ShlObj.h>
#include <nlohmann/json.hpp>

#include <algorithm>
#include <cctype>
#include <cwctype>
#include <fstream>
#include <system_error>

namespace fs = std::filesystem;
using json = nlohmann::json;

namespace m2ex::launcher {
namespace {

std::string trim(std::string value)
{
    const auto isSpace = [](unsigned char c) { return std::isspace(c) != 0; };
    value.erase(value.begin(), std::find_if_not(value.begin(), value.end(), isSpace));
    value.erase(std::find_if_not(value.rbegin(), value.rend(), isSpace).base(), value.end());
    return value;
}

std::wstring lower(std::wstring value)
{
    std::ranges::transform(value, value.begin(), [](wchar_t c) { return static_cast<wchar_t>(::towlower(c)); });
    return value;
}

std::wstring normalized(const fs::path& value)
{
    auto text = value.lexically_normal().generic_wstring();
    while (text.starts_with(L"./"))
        text.erase(0, 2);
    return lower(text);
}

std::string optionalString(const json& object, const char* key)
{
    if (const auto it = object.find(key); it != object.end() && it->is_string())
        return it->get<std::string>();
    return {};
}

fs::path optionalPath(const json& object, const char* key)
{
    return fs::u8path(optionalString(object, key));
}

LoadResult loadNewManifest(const fs::path& file)
{
    try {
        std::ifstream stream(file);
        if (!stream)
            return {{}, L"Unable to open " + file.wstring()};
        const auto root = json::parse(stream, nullptr, true, true);
        if (!root.is_object())
            return {{}, L"The launcher manifest must contain a JSON object."};

        Manifest manifest;
        manifest.schemaVersion = root.value("schemaVersion", 0);
        if (manifest.schemaVersion != 1)
            return {{}, L"Unsupported m2ex-launcher.json schemaVersion. Expected 1."};

        const auto mod = root.value("mod", json::object());
        manifest.modId = optionalString(mod, "id");
        manifest.modTitle = optionalString(mod, "title");
        manifest.modVersion = optionalString(mod, "version");
        manifest.defaultConfig = optionalPath(mod, "defaultConfig");
        if (manifest.modId.empty() || manifest.modTitle.empty() || manifest.defaultConfig.empty())
            return {{}, L"m2ex-launcher.json requires mod.id, mod.title, and mod.defaultConfig."};

        const auto assets = root.value("assets", json::object());
        manifest.logo = optionalPath(assets, "logo");
        manifest.icon = optionalPath(assets, "icon");
        manifest.music = optionalPath(assets, "music");

        const auto links = root.value("links", json::object());
        manifest.website = optionalString(links, "website");
        manifest.discord = optionalString(links, "discord");
        manifest.documentation = optionalString(links, "documentation");

        const auto discord = root.value("discord", json::object());
        manifest.discordApplicationId = optionalString(discord, "applicationId");
        manifest.discordImageKey = optionalString(discord, "imageKey");

        if (const auto themes = root.find("themes"); themes != root.end() && themes->is_array()) {
            for (const auto& entry : *themes) {
                if (!entry.is_object())
                    continue;
                ThemeEntry theme{optionalString(entry, "id"), optionalString(entry, "label"), optionalPath(entry, "path")};
                if (!theme.id.empty() && !theme.label.empty() && !theme.file.empty())
                    manifest.themes.push_back(std::move(theme));
            }
        }
        return {std::move(manifest), {}};
    } catch (const std::exception& exception) {
        return {{}, L"Invalid m2ex-launcher.json: " + utf8ToWide(exception.what())};
    }
}

LoadResult loadLegacyManifest(const fs::path& file, const fs::path& modDirectory)
{
    try {
        std::ifstream stream(file);
        const auto root = json::parse(stream, nullptr, true, true);
        Manifest manifest;
        manifest.fromLegacy = true;
        manifest.modId = wideToUtf8(modDirectory.filename().wstring());
        manifest.modTitle = root.value("modTitle", manifest.modId);
        if (manifest.modTitle.empty())
            manifest.modTitle = manifest.modId;
        manifest.modVersion = root.value("modVersion", std::string{});
        manifest.defaultConfig = fs::u8path(root.value("modCfgFile", "TATW.cfg"));
        manifest.website = root.value("websiteLink", std::string{});
        manifest.discord = root.value("discordServerLink", std::string{});
        manifest.music = fs::path(L"eopData/resources/music/bkg.flac");
        return {std::move(manifest), {}};
    } catch (const std::exception& exception) {
        return {{}, L"Invalid legacy eopData/config/uiCfg.json: " + utf8ToWide(exception.what())};
    }
}

} // namespace

std::wstring utf8ToWide(std::string_view value)
{
    if (value.empty())
        return {};
    const int count = MultiByteToWideChar(CP_UTF8, MB_ERR_INVALID_CHARS, value.data(), static_cast<int>(value.size()), nullptr, 0);
    if (count <= 0)
        return L"(invalid UTF-8)";
    std::wstring result(static_cast<size_t>(count), L'\0');
    MultiByteToWideChar(CP_UTF8, MB_ERR_INVALID_CHARS, value.data(), static_cast<int>(value.size()), result.data(), count);
    return result;
}

std::string wideToUtf8(std::wstring_view value)
{
    if (value.empty())
        return {};
    const int count = WideCharToMultiByte(CP_UTF8, WC_ERR_INVALID_CHARS, value.data(), static_cast<int>(value.size()), nullptr, 0, nullptr, nullptr);
    if (count <= 0)
        return {};
    std::string result(static_cast<size_t>(count), '\0');
    WideCharToMultiByte(CP_UTF8, WC_ERR_INVALID_CHARS, value.data(), static_cast<int>(value.size()), result.data(), count, nullptr, nullptr);
    return result;
}

LoadResult loadManifest(const fs::path& modDirectory)
{
    const auto current = modDirectory / L"m2ex-launcher.json";
    if (fs::is_regular_file(current))
        return loadNewManifest(current);
    const auto legacy = modDirectory / L"eopData/config/uiCfg.json";
    if (fs::is_regular_file(legacy))
        return loadLegacyManifest(legacy, modDirectory);
    return {{}, L"No launcher configuration was found. Install m2ex-launcher.json beside M2TWEOP_GUI.exe."};
}

Settings loadSettings(const fs::path& file, const Manifest& manifest)
{
    Settings settings;
    settings.selectedConfig = manifest.defaultConfig;
    try {
        if (!fs::is_regular_file(file))
            return settings;
        std::ifstream stream(file);
        const auto root = json::parse(stream, nullptr, true, true);
        if (root.contains("selectedConfig") && root["selectedConfig"].is_string())
            settings.selectedConfig = fs::u8path(root["selectedConfig"].get<std::string>());
        settings.launchDirectly = root.value("launchDirectly", settings.launchDirectly);
        settings.musicEnabled = root.value("musicEnabled", settings.musicEnabled);
        settings.musicVolume = std::clamp(root.value("musicVolume", settings.musicVolume), 0.0f, 1.0f);
        settings.themeId = root.value("theme", settings.themeId);
        settings.presenceEnabled = root.value("presenceEnabled", settings.presenceEnabled);
    } catch (...) {
        // A bad mutable preference file must never make the shipped launcher unusable.
    }
    return settings;
}

bool saveSettings(const fs::path& file, const Settings& settings, std::wstring& error)
{
    try {
        fs::create_directories(file.parent_path());
        const auto temporary = file.wstring() + L".tmp";
        json root{
            {"selectedConfig", wideToUtf8(settings.selectedConfig.generic_wstring())},
            {"launchDirectly", settings.launchDirectly},
            {"musicEnabled", settings.musicEnabled},
            {"musicVolume", settings.musicVolume},
            {"theme", settings.themeId},
            {"presenceEnabled", settings.presenceEnabled},
        };
        std::ofstream stream(fs::path(temporary), std::ios::trunc);
        stream << root.dump(2) << '\n';
        stream.close();
        if (!stream)
            throw std::runtime_error("write failed");
        if (!MoveFileExW(temporary.c_str(), file.c_str(), MOVEFILE_REPLACE_EXISTING | MOVEFILE_WRITE_THROUGH))
            throw std::system_error(static_cast<int>(GetLastError()), std::system_category());
        return true;
    } catch (const std::exception& exception) {
        error = L"Could not save launcher preferences: " + utf8ToWide(exception.what());
        return false;
    }
}

fs::path settingsPath(const std::string& modId)
{
    PWSTR raw = nullptr;
    if (FAILED(SHGetKnownFolderPath(FOLDERID_LocalAppData, KF_FLAG_CREATE, nullptr, &raw)))
        return {};
    fs::path base(raw);
    CoTaskMemFree(raw);
    std::wstring safe = utf8ToWide(modId);
    std::ranges::replace_if(safe, [](wchar_t c) { return wcschr(L"<>:\"/\\|?*", c) != nullptr; }, L'_');
    return base / L"M2EX" / L"Launcher" / safe / L"settings.json";
}

ValidationResult inferLayout(const fs::path& launcherPath, Layout& layout)
{
    std::error_code error;
    layout.launcher = fs::weakly_canonical(launcherPath, error);
    if (error)
        layout.launcher = fs::absolute(launcherPath);
    layout.modDirectory = layout.launcher.parent_path();
    layout.modsDirectory = layout.modDirectory.parent_path();
    layout.gameRoot = layout.modsDirectory.parent_path();
    layout.m2exExecutable = layout.gameRoot / L"M2EX.exe";
    layout.modFolder = wideToUtf8(layout.modDirectory.filename().wstring());

    if (lower(layout.modsDirectory.filename().wstring()) != L"mods") {
        return {false, L"Invalid launcher location:\n\n" + layout.launcher.wstring()
            + L"\n\nInstall it as M2TW\\mods\\<mod>\\M2TWEOP_GUI.exe."};
    }
    if (lower(layout.launcher.filename().wstring()) != L"m2tweop_gui.exe") {
        return {false, L"Invalid launcher filename:\n\n" + layout.launcher.wstring()
            + L"\n\nThe compatibility filename must be M2TWEOP_GUI.exe."};
    }
    if (!fs::is_regular_file(layout.m2exExecutable)) {
        return {false, L"M2EX.exe was not found:\n\n" + layout.m2exExecutable.wstring()
            + L"\n\nInstall M2EX.exe in the Medieval II Total War game folder. Retail executables are not used as a fallback."};
    }
    return {true, {}};
}

std::vector<fs::path> discoverConfigs(const fs::path& modDirectory)
{
    std::vector<fs::path> result;
    std::error_code error;
    for (const auto& entry : fs::directory_iterator(modDirectory, error)) {
        if (entry.is_regular_file() && lower(entry.path().extension().wstring()) == L".cfg")
            result.push_back(entry.path().filename());
    }
    std::ranges::sort(result, [](const auto& left, const auto& right) {
        return lower(left.wstring()) < lower(right.wstring());
    });
    return result;
}

ValidationResult validateConfig(const Layout& layout, const fs::path& config)
{
    if (config.empty() || config.is_absolute() || config.has_parent_path())
        return {false, L"The selected configuration must be a .cfg file directly inside:\n\n" + layout.modDirectory.wstring()};
    const auto file = layout.modDirectory / config;
    if (lower(file.extension().wstring()) != L".cfg" || !fs::is_regular_file(file))
        return {false, L"The selected configuration was not found:\n\n" + file.wstring()};

    std::ifstream stream(file);
    std::string line;
    bool inFeatures = false;
    std::string modValue;
    while (std::getline(stream, line)) {
        const auto comment = line.find_first_of("#;");
        if (comment != std::string::npos)
            line.erase(comment);
        line = trim(line);
        if (line.empty())
            continue;
        if (line.front() == '[' && line.back() == ']') {
            auto section = trim(line.substr(1, line.size() - 2));
            std::ranges::transform(section, section.begin(), [](unsigned char c) { return static_cast<char>(std::tolower(c)); });
            inFeatures = section == "features";
            continue;
        }
        if (!inFeatures)
            continue;
        const auto equals = line.find('=');
        if (equals == std::string::npos)
            continue;
        auto key = trim(line.substr(0, equals));
        std::ranges::transform(key, key.begin(), [](unsigned char c) { return static_cast<char>(std::tolower(c)); });
        if (key == "mod") {
            modValue = trim(line.substr(equals + 1));
            if (modValue.size() >= 2 && ((modValue.front() == '"' && modValue.back() == '"') || (modValue.front() == '\'' && modValue.back() == '\'')))
                modValue = modValue.substr(1, modValue.size() - 2);
            break;
        }
    }
    const auto expected = fs::path(L"mods") / layout.modDirectory.filename();
    if (modValue.empty())
        return {false, L"The [features] section in this configuration has no mod value:\n\n" + file.wstring()
            + L"\n\nSet it to: mod = " + expected.generic_wstring()};
    if (normalized(fs::u8path(modValue)) != normalized(expected))
        return {false, L"The configuration points at the wrong mod.\n\nFile: " + file.wstring()
            + L"\nDetected: " + utf8ToWide(modValue) + L"\nExpected: " + expected.generic_wstring()};
    return {true, {}};
}

std::wstring quoteWindowsArgument(std::wstring_view argument)
{
    if (argument.empty())
        return L"\"\"";
    if (argument.find_first_of(L" \t\n\v\"") == std::wstring_view::npos)
        return std::wstring(argument);
    std::wstring result(1, L'"');
    size_t slashes = 0;
    for (const auto character : argument) {
        if (character == L'\\') {
            ++slashes;
        } else if (character == L'"') {
            result.append(slashes * 2 + 1, L'\\');
            result.push_back(L'"');
            slashes = 0;
        } else {
            result.append(slashes, L'\\');
            slashes = 0;
            result.push_back(character);
        }
    }
    result.append(slashes * 2, L'\\');
    result.push_back(L'"');
    return result;
}

std::wstring buildCommandLine(const Layout& layout, const fs::path& config)
{
    const auto responseFile = (fs::path(L"@mods") / layout.modDirectory.filename() / config).generic_wstring();
    return quoteWindowsArgument(layout.m2exExecutable.wstring()) + L" " + quoteWindowsArgument(responseFile);
}

} // namespace m2ex::launcher
