cmake_minimum_required(VERSION 3.25)

project(M2EXLauncher VERSION 1.0.0 LANGUAGES CXX RC)

if(NOT WIN32 OR NOT CMAKE_SIZEOF_VOID_P EQUAL 8)
    message(FATAL_ERROR "M2EX Launcher supports only 64-bit Windows.")
endif()

find_package(imgui CONFIG REQUIRED)
find_package(nlohmann_json CONFIG REQUIRED)

add_executable(M2EXLauncher WIN32
    LauncherCore.cpp
    LauncherCore.h
    main.cpp
    M2EXLauncher.rc
    resource.h
)

set_target_properties(M2EXLauncher PROPERTIES
    CXX_STANDARD 23
    CXX_STANDARD_REQUIRED YES
    CXX_EXTENSIONS NO
    OUTPUT_NAME M2TWEOP_GUI
)

target_compile_definitions(M2EXLauncher PRIVATE
    NOMINMAX
    STRICT
    UNICODE
    _UNICODE
    WIN32_LEAN_AND_MEAN
    _WIN32_WINNT=0x0A00
)

target_compile_options(M2EXLauncher PRIVATE
    $<$<CXX_COMPILER_ID:MSVC>:/utf-8 /W4 /permissive->
)

target_link_libraries(M2EXLauncher PRIVATE
    imgui::imgui
    nlohmann_json::nlohmann_json
    d3d11
    dxgi
    windowscodecs
    mf
    mfplat
    mfplay
    mfuuid
    ole32
    shell32
)

include(CTest)
if(BUILD_TESTING)
    add_executable(M2EXLauncherTests
        LauncherCore.cpp
        LauncherCore.h
        LauncherCoreTests.cpp
    )
    set_target_properties(M2EXLauncherTests PROPERTIES
        CXX_STANDARD 23
        CXX_STANDARD_REQUIRED YES
        CXX_EXTENSIONS NO
    )
    target_compile_definitions(M2EXLauncherTests PRIVATE
        NOMINMAX
        STRICT
        UNICODE
        _UNICODE
        WIN32_LEAN_AND_MEAN
        _WIN32_WINNT=0x0A00
    )
    target_compile_options(M2EXLauncherTests PRIVATE
        $<$<CXX_COMPILER_ID:MSVC>:/utf-8 /W4 /permissive->
    )
    target_link_libraries(M2EXLauncherTests PRIVATE
        nlohmann_json::nlohmann_json
        ole32
        shell32
    )
    add_test(NAME M2EXLauncherTests COMMAND M2EXLauncherTests)
endif()
