# M2EX Launcher

This native x64 launcher intentionally produces `M2TWEOP_GUI.exe` so old mod shortcuts remain useful after moving from M2TWEOP to M2EX. It accepts only this layout:

```text
Medieval II Total War/
  M2EX.exe
  mods/
    My_Mod/
      M2TWEOP_GUI.exe
      m2ex-launcher.json
      my-mod.cfg
```

The launcher starts `M2EX.exe` explicitly, uses the game root as the working directory, and passes `@mods/My_Mod/my-mod.cfg`. Before launch it checks that the CFG exists and that its `[features] mod` value names the launcher’s own mod directory. It never starts a retail executable or uses an EOP pipe.

## Manifest

Copy `m2ex-launcher.example.json` to the mod root as `m2ex-launcher.json`. Paths in `assets` and `themes` are relative to the mod root. Empty or omitted optional links are not shown. Discord Rich Presence remains unavailable until `discord.applicationId` is supplied and an optional compatible Discord SDK runtime is present.

A theme JSON can provide `windowRounding`, `frameRounding`, and RGBA arrays under `colors` for `text`, `window`, `button`, `buttonHovered`, `buttonActive`, `header`, `headerHovered`, and `checkMark`. Unknown JSON fields are ignored.

If the manifest is absent, the launcher can import the supported title, version, CFG, website, Discord invite, and music defaults from `eopData/config/uiCfg.json`. The legacy file is never modified.

Mutable choices are written to `%LOCALAPPDATA%\M2EX\Launcher\<mod-id>\settings.json`.

## Build and tests

This is a standalone Windows project and does not modify or depend on the M2EX engine source tree. It uses CMake with vcpkg for Dear ImGui and nlohmann-json; WIC, Media Foundation, and Direct3D 11 come from the Windows SDK.

From a Visual Studio developer shell with `VCPKG_ROOT` set:

```powershell
cmake -S . -B build -A x64 -DCMAKE_TOOLCHAIN_FILE="$env:VCPKG_ROOT/scripts/buildsystems/vcpkg.cmake"
cmake --build build --config Release
ctest --test-dir build -C Release --output-on-failure
```

The launcher is generated as `Release/M2TWEOP_GUI.exe`. `M2EXLauncherTests.exe` validates parsing, paths, CFG rules, quoting, and child-process behavior.
