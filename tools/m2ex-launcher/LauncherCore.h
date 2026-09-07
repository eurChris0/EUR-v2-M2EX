#pragma once

#include <filesystem>
#include <optional>
#include <string>
#include <vector>

namespace m2ex::launcher {

struct ThemeEntry {
    std::string id;
    std::string label;
    std::filesystem::path file;
};

struct Manifest {
    int schemaVersion = 1;
    std::string modId;
    std::string modTitle;
    std::string modVersion;
    std::filesystem::path defaultConfig;
    std::filesystem::path logo;
    std::filesystem::path icon;
    std::filesystem::path music;
    std::vector<ThemeEntry> themes;
    std::string website;
    std::string discord;
    std::string documentation;
    std::string discordApplicationId;
    std::string discordImageKey;
    bool fromLegacy = false;
};

struct Settings {
    std::filesystem::path selectedConfig;
    bool launchDirectly = false;
    bool musicEnabled = false;
    float musicVolume = 0.15f;
    std::string themeId = "default";
    bool presenceEnabled = false;
};

struct Layout {
    std::filesystem::path launcher;
    std::filesystem::path modDirectory;
    std::filesystem::path modsDirectory;
    std::filesystem::path gameRoot;
    std::filesystem::path m2exExecutable;
    std::string modFolder;
};

struct ValidationResult {
    bool valid = false;
    std::wstring message;
};

struct LoadResult {
    std::optional<Manifest> value;
    std::wstring error;
};

LoadResult loadManifest(const std::filesystem::path& modDirectory);
Settings loadSettings(const std::filesystem::path& file, const Manifest& manifest);
bool saveSettings(const std::filesystem::path& file, const Settings& settings, std::wstring& error);
std::filesystem::path settingsPath(const std::string& modId);

ValidationResult inferLayout(const std::filesystem::path& launcherPath, Layout& layout);
std::vector<std::filesystem::path> discoverConfigs(const std::filesystem::path& modDirectory);
ValidationResult validateConfig(const Layout& layout, const std::filesystem::path& config);

std::wstring quoteWindowsArgument(std::wstring_view argument);
std::wstring buildCommandLine(const Layout& layout, const std::filesystem::path& config);
std::wstring utf8ToWide(std::string_view value);
std::string wideToUtf8(std::wstring_view value);

} // namespace m2ex::launcher
