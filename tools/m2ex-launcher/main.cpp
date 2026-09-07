#include "LauncherCore.h"

#include <Windows.h>
#include <d3d11.h>
#include <mfapi.h>
#include <mfplay.h>
#include <shellapi.h>
#include <wincodec.h>
#include <wrl/client.h>

#include <imgui.h>
#include <imgui_impl_dx11.h>
#include <imgui_impl_win32.h>
#include <nlohmann/json.hpp>

#include <algorithm>
#include <filesystem>
#include <fstream>
#include <memory>

using Microsoft::WRL::ComPtr;
namespace fs = std::filesystem;
using namespace m2ex::launcher;

extern IMGUI_IMPL_API LRESULT ImGui_ImplWin32_WndProcHandler(HWND, UINT, WPARAM, LPARAM);

namespace {

ComPtr<ID3D11Device> device;
ComPtr<ID3D11DeviceContext> deviceContext;
ComPtr<IDXGISwapChain> swapChain;
ComPtr<ID3D11RenderTargetView> renderTarget;

void createRenderTarget()
{
    ComPtr<ID3D11Texture2D> buffer;
    if (SUCCEEDED(swapChain->GetBuffer(0, IID_PPV_ARGS(&buffer))))
        device->CreateRenderTargetView(buffer.Get(), nullptr, &renderTarget);
}

bool createDevice(HWND window)
{
    DXGI_SWAP_CHAIN_DESC description{};
    description.BufferCount = 2;
    description.BufferDesc.Format = DXGI_FORMAT_R8G8B8A8_UNORM;
    description.BufferUsage = DXGI_USAGE_RENDER_TARGET_OUTPUT;
    description.OutputWindow = window;
    description.SampleDesc.Count = 1;
    description.Windowed = TRUE;
    description.SwapEffect = DXGI_SWAP_EFFECT_DISCARD;
    constexpr D3D_FEATURE_LEVEL levels[]{D3D_FEATURE_LEVEL_11_0, D3D_FEATURE_LEVEL_10_0};
    D3D_FEATURE_LEVEL level{};
    if (FAILED(D3D11CreateDeviceAndSwapChain(nullptr, D3D_DRIVER_TYPE_HARDWARE, nullptr, 0, levels,
            static_cast<UINT>(std::size(levels)), D3D11_SDK_VERSION, &description, &swapChain, &device, &level, &deviceContext)))
        return false;
    createRenderTarget();
    return true;
}

LRESULT WINAPI windowProcedure(HWND window, UINT message, WPARAM wParam, LPARAM lParam)
{
    if (ImGui_ImplWin32_WndProcHandler(window, message, wParam, lParam))
        return true;
    switch (message) {
    case WM_SIZE:
        if (device && wParam != SIZE_MINIMIZED) {
            renderTarget.Reset();
            swapChain->ResizeBuffers(0, LOWORD(lParam), HIWORD(lParam), DXGI_FORMAT_UNKNOWN, 0);
            createRenderTarget();
        }
        return 0;
    case WM_DPICHANGED: {
        const auto* suggested = reinterpret_cast<const RECT*>(lParam);
        SetWindowPos(window, nullptr, suggested->left, suggested->top, suggested->right - suggested->left,
            suggested->bottom - suggested->top, SWP_NOZORDER | SWP_NOACTIVATE);
        return 0;
    }
    case WM_SYSCOMMAND:
        if ((wParam & 0xfff0) == SC_KEYMENU)
            return 0;
        break;
    case WM_DESTROY:
        PostQuitMessage(0);
        return 0;
    }
    return DefWindowProcW(window, message, wParam, lParam);
}

struct Texture {
    ComPtr<ID3D11ShaderResourceView> view;
    int width = 0;
    int height = 0;
};

Texture loadImage(const fs::path& file)
{
    Texture result;
    if (file.empty() || !fs::is_regular_file(file))
        return result;
    ComPtr<IWICImagingFactory> factory;
    ComPtr<IWICBitmapDecoder> decoder;
    ComPtr<IWICBitmapFrameDecode> frame;
    ComPtr<IWICFormatConverter> converter;
    if (FAILED(CoCreateInstance(CLSID_WICImagingFactory2, nullptr, CLSCTX_INPROC_SERVER, IID_PPV_ARGS(&factory)))
        || FAILED(factory->CreateDecoderFromFilename(file.c_str(), nullptr, GENERIC_READ, WICDecodeMetadataCacheOnLoad, &decoder))
        || FAILED(decoder->GetFrame(0, &frame))
        || FAILED(factory->CreateFormatConverter(&converter))
        || FAILED(converter->Initialize(frame.Get(), GUID_WICPixelFormat32bppRGBA, WICBitmapDitherTypeNone, nullptr, 0.0, WICBitmapPaletteTypeCustom)))
        return result;
    UINT width = 0, height = 0;
    converter->GetSize(&width, &height);
    std::vector<unsigned char> pixels(static_cast<size_t>(width) * height * 4);
    if (FAILED(converter->CopyPixels(nullptr, width * 4, static_cast<UINT>(pixels.size()), pixels.data())))
        return result;
    D3D11_TEXTURE2D_DESC textureDescription{};
    textureDescription.Width = width;
    textureDescription.Height = height;
    textureDescription.MipLevels = 1;
    textureDescription.ArraySize = 1;
    textureDescription.Format = DXGI_FORMAT_R8G8B8A8_UNORM;
    textureDescription.SampleDesc.Count = 1;
    textureDescription.Usage = D3D11_USAGE_DEFAULT;
    textureDescription.BindFlags = D3D11_BIND_SHADER_RESOURCE;
    D3D11_SUBRESOURCE_DATA imageData{pixels.data(), width * 4, 0};
    ComPtr<ID3D11Texture2D> texture;
    if (FAILED(device->CreateTexture2D(&textureDescription, &imageData, &texture))
        || FAILED(device->CreateShaderResourceView(texture.Get(), nullptr, &result.view)))
        return {};
    result.width = static_cast<int>(width);
    result.height = static_cast<int>(height);
    return result;
}

class MediaPlayer final : public IMFPMediaPlayerCallback {
public:
    ~MediaPlayer() { stop(); }
    STDMETHODIMP QueryInterface(REFIID id, void** object) override
    {
        if (id == IID_IUnknown || id == __uuidof(IMFPMediaPlayerCallback)) {
            *object = static_cast<IMFPMediaPlayerCallback*>(this);
            AddRef();
            return S_OK;
        }
        *object = nullptr;
        return E_NOINTERFACE;
    }
    STDMETHODIMP_(ULONG) AddRef() override { return static_cast<ULONG>(InterlockedIncrement(&references)); }
    STDMETHODIMP_(ULONG) Release() override
    {
        const auto value = InterlockedDecrement(&references);
        return static_cast<ULONG>(value);
    }
    void STDMETHODCALLTYPE OnMediaPlayerEvent(MFP_EVENT_HEADER* event) override
    {
        if (event && event->eEventType == MFP_EVENT_TYPE_MEDIAITEM_CREATED && SUCCEEDED(event->hrEvent)) {
            auto* created = MFP_GET_MEDIAITEM_CREATED_EVENT(event);
            player->SetMediaItem(created->pMediaItem);
            player->Play();
        } else if (event && event->eEventType == MFP_EVENT_TYPE_PLAYBACK_ENDED && player) {
            player->SetPosition(GUID_NULL, nullptr);
            player->Play();
        }
    }
    bool play(const fs::path& file, float volume)
    {
        stop();
        if (!fs::is_regular_file(file) || FAILED(MFStartup(MF_VERSION)))
            return false;
        mediaFoundationStarted = true;
        if (FAILED(MFPCreateMediaPlayer(nullptr, FALSE, 0, this, nullptr, &player)))
            return false;
        player->SetVolume(volume);
        return SUCCEEDED(player->CreateMediaItemFromURL(file.c_str(), FALSE, 0, nullptr));
    }
    void setVolume(float volume) { if (player) player->SetVolume(volume); }
    void stop()
    {
        if (player) {
            player->Shutdown();
            player.Reset();
        }
        if (mediaFoundationStarted) {
            MFShutdown();
            mediaFoundationStarted = false;
        }
    }
private:
    volatile long references = 1;
    bool mediaFoundationStarted = false;
    ComPtr<IMFPMediaPlayer> player;
};

void openLink(const std::string& address)
{
    const auto url = utf8ToWide(address);
    if (url.starts_with(L"https://") || url.starts_with(L"http://"))
        ShellExecuteW(nullptr, L"open", url.c_str(), nullptr, nullptr, SW_SHOWNORMAL);
}

void applyTheme(const fs::path& modDirectory, const Manifest& manifest, const std::string& selected)
{
    ImGui::StyleColorsDark();
    auto& style = ImGui::GetStyle();
    style.WindowPadding = {0.0f, 0.0f};
    style.FramePadding = {13.0f, 9.0f};
    style.ItemSpacing = {10.0f, 10.0f};
    style.ItemInnerSpacing = {8.0f, 6.0f};
    style.WindowRounding = 0.0f;
    style.ChildRounding = 14.0f;
    style.FrameRounding = 7.0f;
    style.PopupRounding = 8.0f;
    style.ScrollbarRounding = 8.0f;
    style.GrabRounding = 7.0f;
    style.ChildBorderSize = 1.0f;
    style.FrameBorderSize = 0.0f;
    style.Colors[ImGuiCol_Text] = {0.93f, 0.92f, 0.88f, 1.0f};
    style.Colors[ImGuiCol_TextDisabled] = {0.54f, 0.59f, 0.64f, 1.0f};
    style.Colors[ImGuiCol_WindowBg] = {0.035f, 0.047f, 0.063f, 1.0f};
    style.Colors[ImGuiCol_ChildBg] = {0.060f, 0.078f, 0.102f, 0.96f};
    style.Colors[ImGuiCol_PopupBg] = {0.055f, 0.070f, 0.092f, 0.99f};
    style.Colors[ImGuiCol_Border] = {0.18f, 0.23f, 0.29f, 0.85f};
    style.Colors[ImGuiCol_FrameBg] = {0.085f, 0.110f, 0.145f, 1.0f};
    style.Colors[ImGuiCol_FrameBgHovered] = {0.12f, 0.16f, 0.21f, 1.0f};
    style.Colors[ImGuiCol_FrameBgActive] = {0.15f, 0.20f, 0.26f, 1.0f};
    style.Colors[ImGuiCol_Button] = {0.12f, 0.19f, 0.27f, 1.0f};
    style.Colors[ImGuiCol_ButtonHovered] = {0.17f, 0.27f, 0.38f, 1.0f};
    style.Colors[ImGuiCol_ButtonActive] = {0.20f, 0.32f, 0.44f, 1.0f};
    style.Colors[ImGuiCol_Header] = {0.18f, 0.27f, 0.36f, 1.0f};
    style.Colors[ImGuiCol_HeaderHovered] = {0.23f, 0.35f, 0.47f, 1.0f};
    style.Colors[ImGuiCol_CheckMark] = {0.90f, 0.70f, 0.25f, 1.0f};
    style.Colors[ImGuiCol_SliderGrab] = {0.80f, 0.59f, 0.18f, 1.0f};
    style.Colors[ImGuiCol_SliderGrabActive] = {0.96f, 0.76f, 0.30f, 1.0f};
    style.Colors[ImGuiCol_Separator] = {0.18f, 0.23f, 0.29f, 0.75f};
    const auto found = std::ranges::find_if(manifest.themes, [&](const auto& theme) { return theme.id == selected; });
    if (found == manifest.themes.end())
        return;
    try {
        std::ifstream stream(modDirectory / found->file);
        const auto root = nlohmann::json::parse(stream);
        style.WindowRounding = root.value("windowRounding", style.WindowRounding);
        style.FrameRounding = root.value("frameRounding", style.FrameRounding);
        const auto colors = root.value("colors", nlohmann::json::object());
        const std::pair<const char*, ImGuiCol> names[]{
            {"text", ImGuiCol_Text}, {"window", ImGuiCol_WindowBg}, {"button", ImGuiCol_Button},
            {"buttonHovered", ImGuiCol_ButtonHovered}, {"buttonActive", ImGuiCol_ButtonActive},
            {"header", ImGuiCol_Header}, {"headerHovered", ImGuiCol_HeaderHovered}, {"checkMark", ImGuiCol_CheckMark},
        };
        for (const auto& [name, index] : names) {
            if (const auto it = colors.find(name); it != colors.end() && it->is_array() && it->size() == 4)
                style.Colors[index] = ImVec4((*it)[0], (*it)[1], (*it)[2], (*it)[3]);
        }
    } catch (...) {
        // A malformed optional theme falls back to the built-in theme.
    }
}

std::wstring modulePath()
{
    std::wstring result(32768, L'\0');
    const DWORD count = GetModuleFileNameW(nullptr, result.data(), static_cast<DWORD>(result.size()));
    result.resize(count);
    return result;
}

bool startM2ex(const Layout& layout, const fs::path& config, PROCESS_INFORMATION& process, std::wstring& error)
{
    auto command = buildCommandLine(layout, config);
    STARTUPINFOW startup{sizeof(startup)};
    if (!CreateProcessW(layout.m2exExecutable.c_str(), command.data(), nullptr, nullptr, FALSE, 0, nullptr,
            layout.gameRoot.c_str(), &startup, &process)) {
        error = L"M2EX could not be started.\n\nExecutable: " + layout.m2exExecutable.wstring()
            + L"\nWorking directory: " + layout.gameRoot.wstring()
            + L"\nArguments: @mods/" + layout.modDirectory.filename().wstring() + L"/" + config.wstring()
            + L"\n\nWindows error: " + std::to_wstring(GetLastError());
        return false;
    }
    CloseHandle(process.hThread);
    process.hThread = nullptr;
    return true;
}

int showFatal(const std::wstring& message)
{
    MessageBoxW(nullptr, message.c_str(), L"M2EX Launcher", MB_ICONERROR | MB_OK);
    return 1;
}

} // namespace

int WINAPI wWinMain(HINSTANCE instance, HINSTANCE, PWSTR, int)
{
    SetProcessDpiAwarenessContext(DPI_AWARENESS_CONTEXT_PER_MONITOR_AWARE_V2);
    if (FAILED(CoInitializeEx(nullptr, COINIT_APARTMENTTHREADED)))
        return showFatal(L"Windows initialization failed.");

    Layout layout;
    if (const auto validation = inferLayout(modulePath(), layout); !validation.valid) {
        CoUninitialize();
        return showFatal(validation.message);
    }
    const auto loaded = loadManifest(layout.modDirectory);
    if (!loaded.value) {
        CoUninitialize();
        return showFatal(loaded.error);
    }
    const auto manifest = *loaded.value;
    const auto preferenceFile = settingsPath(manifest.modId);
    auto settings = loadSettings(preferenceFile, manifest);
    auto configs = discoverConfigs(layout.modDirectory);
    if (configs.empty()) {
        CoUninitialize();
        return showFatal(L"No .cfg files were found in:\n\n" + layout.modDirectory.wstring());
    }
    if (std::ranges::find(configs, settings.selectedConfig) == configs.end())
        settings.selectedConfig = manifest.defaultConfig;
    if (std::ranges::find(configs, settings.selectedConfig) == configs.end())
        settings.selectedConfig = configs.front();

    PROCESS_INFORMATION child{};
    if (settings.launchDirectly) {
        const auto validation = validateConfig(layout, settings.selectedConfig);
        std::wstring error;
        if (!validation.valid || !startM2ex(layout, settings.selectedConfig, child, error)) {
            CoUninitialize();
            return showFatal(validation.valid ? error : validation.message);
        }
        if (!settings.presenceEnabled || manifest.discordApplicationId.empty()) {
            CloseHandle(child.hProcess);
            CoUninitialize();
            return 0;
        }
    }

    WNDCLASSEXW windowClass{sizeof(windowClass), CS_CLASSDC, windowProcedure, 0, 0, instance,
        LoadIconW(instance, MAKEINTRESOURCEW(101)), nullptr, nullptr, nullptr, L"M2EXLauncherWindow", nullptr};
    RegisterClassExW(&windowClass);
    const auto title = utf8ToWide(manifest.modTitle) + L" — M2EX Launcher";
    HWND window = CreateWindowW(windowClass.lpszClassName, title.c_str(), WS_OVERLAPPEDWINDOW,
        CW_USEDEFAULT, CW_USEDEFAULT, 900, 620, nullptr, nullptr, instance, nullptr);
    if (!window || !createDevice(window)) {
        CoUninitialize();
        return showFatal(L"The launcher could not initialize Direct3D 11.");
    }
    HICON customIcon = nullptr;
    if (!manifest.icon.empty()) {
        customIcon = static_cast<HICON>(LoadImageW(nullptr, (layout.modDirectory / manifest.icon).c_str(), IMAGE_ICON,
            0, 0, LR_LOADFROMFILE | LR_DEFAULTSIZE));
        if (customIcon) {
            SendMessageW(window, WM_SETICON, ICON_BIG, reinterpret_cast<LPARAM>(customIcon));
            SendMessageW(window, WM_SETICON, ICON_SMALL, reinterpret_cast<LPARAM>(customIcon));
        }
    }

    IMGUI_CHECKVERSION();
    ImGui::CreateContext();
    auto& io = ImGui::GetIO();
    io.ConfigFlags |= ImGuiConfigFlags_NavEnableKeyboard;
    const float initialScale = std::clamp(static_cast<float>(GetDpiForWindow(window)) / 96.0f, 1.0f, 2.5f);
    wchar_t windowsDirectory[MAX_PATH]{};
    GetWindowsDirectoryW(windowsDirectory, static_cast<UINT>(std::size(windowsDirectory)));
    const auto fontsDirectory = fs::path(windowsDirectory) / L"Fonts";
    ImFont* bodyFont = io.Fonts->AddFontFromFileTTF(wideToUtf8((fontsDirectory / L"segoeui.ttf").wstring()).c_str(), 16.0f * initialScale);
    ImFont* headingFont = io.Fonts->AddFontFromFileTTF(wideToUtf8((fontsDirectory / L"seguisb.ttf").wstring()).c_str(), 23.0f * initialScale);
    ImFont* labelFont = io.Fonts->AddFontFromFileTTF(wideToUtf8((fontsDirectory / L"segoeui.ttf").wstring()).c_str(), 13.0f * initialScale);
    if (!bodyFont)
        bodyFont = io.Fonts->AddFontDefault();
    if (!headingFont)
        headingFont = bodyFont;
    if (!labelFont)
        labelFont = bodyFont;
    io.FontDefault = bodyFont;
    ImGui_ImplWin32_Init(window);
    ImGui_ImplDX11_Init(device.Get(), deviceContext.Get());
    applyTheme(layout.modDirectory, manifest, settings.themeId);

    Texture logo = loadImage(layout.modDirectory / manifest.logo);
    MediaPlayer music;
    bool musicFailed = false;
    if (settings.musicEnabled && !manifest.music.empty())
        musicFailed = !music.play(layout.modDirectory / manifest.music, settings.musicVolume);

    ShowWindow(window, SW_SHOWDEFAULT);
    UpdateWindow(window);
    bool done = false;
    bool settingsOpen = false;
    std::wstring status;
    while (!done) {
        MSG message;
        while (PeekMessageW(&message, nullptr, 0, 0, PM_REMOVE)) {
            TranslateMessage(&message);
            DispatchMessageW(&message);
            if (message.message == WM_QUIT)
                done = true;
        }
        if (done)
            break;
        if (child.hProcess && WaitForSingleObject(child.hProcess, 0) == WAIT_OBJECT_0) {
            CloseHandle(child.hProcess);
            child.hProcess = nullptr;
            done = true;
            continue;
        }

        ImGui_ImplDX11_NewFrame();
        ImGui_ImplWin32_NewFrame();
        ImGui::NewFrame();
        ImGui::SetNextWindowPos({0, 0});
        ImGui::SetNextWindowSize(io.DisplaySize);
        ImGui::Begin("M2EX Launcher", nullptr, ImGuiWindowFlags_NoDecoration | ImGuiWindowFlags_NoMove
            | ImGuiWindowFlags_NoResize | ImGuiWindowFlags_NoBackground);
        const float scale = std::clamp(static_cast<float>(GetDpiForWindow(window)) / 96.0f, 1.0f, 2.5f);
        auto* background = ImGui::GetWindowDrawList();
        const ImVec2 display = io.DisplaySize;
        background->AddRectFilledMultiColor({0, 0}, display,
            IM_COL32(8, 14, 22, 255), IM_COL32(12, 22, 34, 255),
            IM_COL32(7, 10, 16, 255), IM_COL32(6, 9, 14, 255));
        background->AddRectFilledMultiColor({0, 0}, {display.x, 116.0f * scale},
            IM_COL32(18, 38, 58, 255), IM_COL32(12, 28, 45, 255),
            IM_COL32(9, 20, 32, 255), IM_COL32(12, 26, 41, 255));
        background->AddRectFilled({0, 112.0f * scale}, {display.x, 116.0f * scale}, IM_COL32(208, 155, 50, 255));
        background->AddCircleFilled({display.x - 42.0f * scale, 28.0f * scale}, 96.0f * scale, IM_COL32(208, 155, 50, 12));
        background->AddCircleFilled({display.x - 138.0f * scale, 76.0f * scale}, 68.0f * scale, IM_COL32(55, 111, 154, 15));

        const ImVec2 badgeMin{30.0f * scale, 27.0f * scale};
        const ImVec2 badgeMax{105.0f * scale, 78.0f * scale};
        background->AddRectFilled(badgeMin, badgeMax, IM_COL32(218, 166, 60, 255), 10.0f * scale);
        background->AddText(headingFont, 20.0f * scale, {47.0f * scale, 39.0f * scale}, IM_COL32(21, 28, 35, 255), "M2EX");
        background->AddText(headingFont, 23.0f * scale, {125.0f * scale, 24.0f * scale}, IM_COL32(240, 239, 232, 255), manifest.modTitle.c_str());
        background->AddText(labelFont, 13.0f * scale, {126.0f * scale, 63.0f * scale}, IM_COL32(153, 171, 185, 255), "NATIVE LAUNCHER  /  WINDOWS x64");
        if (!manifest.modVersion.empty())
            background->AddText(labelFont, 13.0f * scale, {display.x - 112.0f * scale, 84.0f * scale},
                IM_COL32(153, 171, 185, 255), manifest.modVersion.c_str());

        const float margin = 28.0f * scale;
        const float gap = 16.0f * scale;
        const float contentTop = 140.0f * scale;
        const float contentHeight = std::max(360.0f * scale, display.y - contentTop - margin);
        const float sideWidth = std::clamp(280.0f * scale, 240.0f * scale, display.x * 0.38f);
        const float launchWidth = display.x - margin * 2.0f - gap - sideWidth;

        ImGui::SetCursorPos({margin, contentTop});
        ImGui::BeginChild("Launch card", {launchWidth, contentHeight}, true, ImGuiWindowFlags_NoScrollbar);
        ImGui::Dummy({0, 7.0f * scale});
        if (logo.view) {
            const float logoWidth = std::min(launchWidth - 48.0f * scale, 320.0f * scale);
            const float logoHeight = std::min(92.0f * scale,
                logoWidth * static_cast<float>(logo.height) / static_cast<float>(std::max(1, logo.width)));
            ImGui::SetCursorPosX((launchWidth - logoWidth) * 0.5f);
            ImGui::Image(reinterpret_cast<ImTextureID>(logo.view.Get()), {logoWidth, logoHeight});
            ImGui::Dummy({0, 5.0f * scale});
        }
        ImGui::PushFont(labelFont);
        ImGui::TextDisabled("READY TO PLAY");
        ImGui::PopFont();
        ImGui::PushFont(headingFont);
        ImGui::TextUnformatted("Launch Epic Unity Rework");
        ImGui::PopFont();
        ImGui::TextDisabled("M2EX will load the selected mod configuration.");
        ImGui::Dummy({0, 10.0f * scale});
        ImGui::Separator();
        ImGui::Dummy({0, 9.0f * scale});
        ImGui::TextDisabled("SELECTED CONFIGURATION");
        ImGui::PushStyleColor(ImGuiCol_Button, ImVec4(0.075f, 0.098f, 0.128f, 1.0f));
        ImGui::PushStyleColor(ImGuiCol_ButtonHovered, ImVec4(0.075f, 0.098f, 0.128f, 1.0f));
        ImGui::Button(wideToUtf8(settings.selectedConfig.wstring()).c_str(), {-1.0f, 43.0f * scale});
        ImGui::PopStyleColor(2);
        ImGui::Dummy({0, 8.0f * scale});

        ImGui::PushStyleColor(ImGuiCol_Button, ImVec4(0.84f, 0.63f, 0.22f, 1.0f));
        ImGui::PushStyleColor(ImGuiCol_ButtonHovered, ImVec4(0.96f, 0.75f, 0.30f, 1.0f));
        ImGui::PushStyleColor(ImGuiCol_ButtonActive, ImVec4(0.72f, 0.51f, 0.14f, 1.0f));
        ImGui::PushStyleColor(ImGuiCol_Text, ImVec4(0.07f, 0.09f, 0.11f, 1.0f));
        const bool launchPressed = ImGui::Button("LAUNCH WITH M2EX", {-1.0f, 58.0f * scale});
        ImGui::PopStyleColor(4);
        if (launchPressed) {
            const auto validation = validateConfig(layout, settings.selectedConfig);
            if (!validation.valid) {
                status = validation.message;
            } else {
                std::wstring error;
                if (startM2ex(layout, settings.selectedConfig, child, error)) {
                    music.stop();
                    if (!settings.presenceEnabled || manifest.discordApplicationId.empty()) {
                        CloseHandle(child.hProcess);
                        child.hProcess = nullptr;
                        done = true;
                    } else {
                        ShowWindow(window, SW_HIDE);
                    }
                } else {
                    status = error;
                }
            }
        }
        if (ImGui::Button(settingsOpen ? "Close settings" : "Launcher settings", {-1.0f, 42.0f * scale}))
            settingsOpen = !settingsOpen;
        ImGui::Dummy({0, 6.0f * scale});
        ImGui::TextDisabled("M2EX.exe only  |  No retail executable fallback");
        if (!status.empty()) {
            ImGui::Dummy({0, 6.0f * scale});
            ImGui::PushStyleColor(ImGuiCol_ChildBg, ImVec4(0.16f, 0.10f, 0.05f, 0.95f));
            ImGui::PushStyleColor(ImGuiCol_Border, ImVec4(0.75f, 0.43f, 0.16f, 0.85f));
            ImGui::BeginChild("Status", {0, 74.0f * scale}, true);
            ImGui::PushTextWrapPos();
            ImGui::TextWrapped("%s", wideToUtf8(status).c_str());
            ImGui::PopTextWrapPos();
            ImGui::EndChild();
            ImGui::PopStyleColor(2);
        }
        ImGui::EndChild();

        ImGui::SetCursorPos({margin + launchWidth + gap, contentTop});
        ImGui::BeginChild("Side card", {sideWidth, contentHeight}, true);
        if (!settingsOpen) {
            ImGui::PushFont(labelFont);
            ImGui::TextDisabled("LAUNCHER STATUS");
            ImGui::PopFont();
            ImGui::PushFont(headingFont);
            ImGui::TextColored({0.48f, 0.80f, 0.58f, 1.0f}, "Ready");
            ImGui::PopFont();
            ImGui::TextWrapped("M2EX and %s were detected in the expected locations.", wideToUtf8(settings.selectedConfig.wstring()).c_str());
            ImGui::Dummy({0, 12.0f * scale});
            ImGui::SeparatorText("Community");
            if (!manifest.website.empty() && ImGui::Button("Open website", {-1.0f, 40.0f * scale})) openLink(manifest.website);
            if (!manifest.discord.empty() && ImGui::Button("Join Discord", {-1.0f, 40.0f * scale})) openLink(manifest.discord);
            if (!manifest.documentation.empty() && ImGui::Button("Documentation", {-1.0f, 40.0f * scale})) openLink(manifest.documentation);
            ImGui::Dummy({0, 12.0f * scale});
            ImGui::Separator();
            ImGui::Dummy({0, 8.0f * scale});
            ImGui::TextDisabled("SAFE LAUNCH");
            ImGui::TextWrapped("Uses the exact M2EX executable and monitors only the process it starts.");
        } else {
            ImGui::PushFont(labelFont);
            ImGui::TextDisabled("PREFERENCES");
            ImGui::PopFont();
            ImGui::PushFont(headingFont);
            ImGui::TextUnformatted("Launcher settings");
            ImGui::PopFont();
            ImGui::Dummy({0, 5.0f * scale});
            if (ImGui::BeginCombo("Configuration", wideToUtf8(settings.selectedConfig.wstring()).c_str())) {
                for (const auto& config : configs) {
                    const bool selected = config == settings.selectedConfig;
                    if (ImGui::Selectable(wideToUtf8(config.wstring()).c_str(), selected))
                        settings.selectedConfig = config;
                    if (selected) ImGui::SetItemDefaultFocus();
                }
                ImGui::EndCombo();
            }
            ImGui::Checkbox("Launch directly next time", &settings.launchDirectly);
            bool oldMusic = settings.musicEnabled;
            ImGui::Checkbox("Background music", &settings.musicEnabled);
            if (oldMusic != settings.musicEnabled) {
                musicFailed = false;
                if (settings.musicEnabled && !manifest.music.empty()) musicFailed = !music.play(layout.modDirectory / manifest.music, settings.musicVolume);
                else music.stop();
            }
            if (ImGui::SliderFloat("Music volume", &settings.musicVolume, 0.0f, 1.0f, "%.0f%%"))
                music.setVolume(settings.musicVolume);
            if (!manifest.themes.empty() && ImGui::BeginCombo("Theme", settings.themeId.c_str())) {
                if (ImGui::Selectable("Built-in dark", settings.themeId == "default")) {
                    settings.themeId = "default";
                    applyTheme(layout.modDirectory, manifest, settings.themeId);
                }
                for (const auto& theme : manifest.themes) {
                    if (ImGui::Selectable(theme.label.c_str(), settings.themeId == theme.id)) {
                        settings.themeId = theme.id;
                        applyTheme(layout.modDirectory, manifest, settings.themeId);
                    }
                }
                ImGui::EndCombo();
            }
            if (manifest.discordApplicationId.empty()) {
                settings.presenceEnabled = false;
                ImGui::BeginDisabled();
                ImGui::Checkbox("Discord Rich Presence", &settings.presenceEnabled);
                ImGui::EndDisabled();
                ImGui::TextDisabled("Unavailable: this mod has no Discord Application ID.");
            } else {
                ImGui::Checkbox("Discord Rich Presence", &settings.presenceEnabled);
                ImGui::TextDisabled("Presence support requires the optional Discord Game SDK runtime.");
            }
            if (musicFailed)
                ImGui::TextColored({1.0f, 0.65f, 0.2f, 1.0f}, "Music could not be loaded; launching is unaffected.");
            ImGui::Dummy({0, 4.0f * scale});
            if (ImGui::Button("Save preferences", {-1.0f, 42.0f * scale})) {
                std::wstring error;
                status = saveSettings(preferenceFile, settings, error) ? L"Preferences saved." : error;
            }
        }
        ImGui::EndChild();
        ImGui::End();
        ImGui::Render();
        const float clear[]{0.035f, 0.035f, 0.045f, 1.0f};
        deviceContext->OMSetRenderTargets(1, renderTarget.GetAddressOf(), nullptr);
        deviceContext->ClearRenderTargetView(renderTarget.Get(), clear);
        ImGui_ImplDX11_RenderDrawData(ImGui::GetDrawData());
        swapChain->Present(1, 0);
    }

    if (child.hProcess) CloseHandle(child.hProcess);
    music.stop();
    ImGui_ImplDX11_Shutdown();
    ImGui_ImplWin32_Shutdown();
    ImGui::DestroyContext();
    renderTarget.Reset();
    swapChain.Reset();
    deviceContext.Reset();
    device.Reset();
    DestroyWindow(window);
    if (customIcon) DestroyIcon(customIcon);
    UnregisterClassW(windowClass.lpszClassName, instance);
    CoUninitialize();
    return 0;
}
