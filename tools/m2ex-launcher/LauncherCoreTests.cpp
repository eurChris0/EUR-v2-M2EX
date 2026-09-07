#include "LauncherCore.h"

#include <Windows.h>
#include <nlohmann/json.hpp>

#include <filesystem>
#include <fstream>
#include <iostream>
#include <string>

namespace fs = std::filesystem;
using namespace m2ex::launcher;

namespace {

int failures = 0;

void expect(bool condition, const char* description)
{
    if (!condition) {
        std::cerr << "FAIL: " << description << '\n';
        ++failures;
    }
}

void writeText(const fs::path& file, std::string_view text)
{
    fs::create_directories(file.parent_path());
    std::ofstream stream(file);
    stream << text;
}

fs::path makeTestRoot()
{
    const auto root = fs::temp_directory_path() / (L"m2ex-launcher-tests-" + std::to_wstring(GetCurrentProcessId()));
    std::error_code ignored;
    fs::remove_all(root, ignored);
    fs::create_directories(root / L"mods" / L"Unicode Mod Ω");
    return root;
}

int childMode(int argc, wchar_t** argv)
{
    if (argc != 4)
        return 90;
    std::ofstream stream(argv[2]);
    stream << wideToUtf8(fs::current_path().wstring()) << '\n' << wideToUtf8(argv[3]) << '\n';
    return stream ? 0 : 91;
}

} // namespace

int wmain(int argc, wchar_t** argv)
{
    if (argc > 1 && std::wstring_view(argv[1]) == L"--child")
        return childMode(argc, argv);

    const auto root = makeTestRoot();
    const auto mod = root / L"mods" / L"Unicode Mod Ω";
    writeText(root / L"M2EX.exe", "stub");
    writeText(mod / L"M2TWEOP_GUI.exe", "stub");
    writeText(mod / L"TATW.cfg", "[features]\nmod = mods/Unicode Mod Ω\n");
    writeText(mod / L"wrong.cfg", "[features]\nmod = mods/Other\n");
    writeText(mod / L"m2ex-launcher.json", R"({
      "schemaVersion": 1,
      "unknown": true,
      "mod": {"id":"test-mod","title":"Test Mod","version":"2","defaultConfig":"TATW.cfg"},
      "themes": [{"id":"gold","label":"Gold","path":"theme.json"}],
      "links": {"website":"https://example.invalid"}
    })");

    Layout layout;
    expect(inferLayout(mod / L"M2TWEOP_GUI.exe", layout).valid, "valid installed layout");
    expect(layout.gameRoot == root, "game root inference");
    expect(!inferLayout(root / L"M2TWEOP_GUI.exe", layout).valid, "reject launcher outside mods/<mod>");
    inferLayout(mod / L"M2TWEOP_GUI.exe", layout);
    expect(validateConfig(layout, L"TATW.cfg").valid, "valid [features] mod");
    expect(!validateConfig(layout, L"wrong.cfg").valid, "wrong [features] mod rejected");
    expect(!validateConfig(layout, L"..\\TATW.cfg").valid, "config traversal rejected");
    expect(discoverConfigs(mod).size() == 2, "config discovery");

    auto loaded = loadManifest(mod);
    expect(loaded.value.has_value(), "new manifest parsed");
    expect(loaded.value && loaded.value->themes.size() == 1, "theme parsed and unknown field ignored");
    expect(loaded.value && loaded.value->modTitle == "Test Mod", "manifest metadata parsed");

    writeText(mod / L"settings.json", R"({"selectedConfig":"wrong.cfg","launchDirectly":true,"musicVolume":4.0,"theme":"gold"})");
    const auto settings = loadSettings(mod / L"settings.json", *loaded.value);
    expect(settings.selectedConfig == L"wrong.cfg" && settings.launchDirectly, "user preferences override manifest defaults");
    expect(settings.musicVolume == 1.0f, "volume clamped");

    expect(quoteWindowsArgument(L"plain") == L"plain", "plain command argument");
    expect(quoteWindowsArgument(L"two words") == L"\"two words\"", "spaced command argument");
    expect(buildCommandLine(layout, L"TATW.cfg").find(L"@mods/Unicode Mod Ω/TATW.cfg") != std::wstring::npos,
        "Unicode response-file command line");

    fs::remove(mod / L"m2ex-launcher.json");
    writeText(mod / L"eopData/config/uiCfg.json", R"({"modTitle":"Legacy","modCfgFile":"TATW.cfg","useM2TWEOP":true,"hideLauncher":true})");
    loaded = loadManifest(mod);
    expect(loaded.value && loaded.value->fromLegacy && loaded.value->modTitle == "Legacy", "one-way legacy fallback");

    // Harmless process test: this test executable stands in for M2EX and records
    // the exact working directory and Unicode argument it received.
    wchar_t executable[32768]{};
    GetModuleFileNameW(nullptr, executable, static_cast<DWORD>(std::size(executable)));
    const auto output = root / L"child-output.txt";
    std::wstring command = quoteWindowsArgument(executable) + L" --child " + quoteWindowsArgument(output.wstring())
        + L" " + quoteWindowsArgument(L"@mods/Unicode Mod Ω/TATW.cfg");
    STARTUPINFOW startup{sizeof(startup)};
    PROCESS_INFORMATION process{};
    expect(CreateProcessW(executable, command.data(), nullptr, nullptr, FALSE, CREATE_NO_WINDOW, nullptr, root.c_str(), &startup, &process) != FALSE,
        "CreateProcessW child stub");
    if (process.hProcess) {
        CloseHandle(process.hThread);
        WaitForSingleObject(process.hProcess, 10000);
        DWORD code = 1;
        GetExitCodeProcess(process.hProcess, &code);
        CloseHandle(process.hProcess);
        expect(code == 0, "child stub lifecycle");
        std::ifstream stream(output);
        std::string cwd, argument;
        std::getline(stream, cwd);
        std::getline(stream, argument);
        expect(fs::u8path(cwd) == root, "child working directory");
        expect(argument == "@mods/Unicode Mod Ω/TATW.cfg", "child Unicode argument");
    }

    std::error_code ignored;
    fs::remove_all(root, ignored);
    if (failures == 0)
        std::cout << "All M2EX launcher tests passed.\n";
    return failures == 0 ? 0 : 1;
}
