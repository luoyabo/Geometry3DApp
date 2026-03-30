#include "win32_window.h"

#include <dwmapi.h>
#include <flutter_windows.h>

#include "resource.h"

namespace {

constexpr const wchar_t kWindowClassName[] = L"FLUTTER_RUNNER_WIN32_WINDOW";

// Scale helper to convert logical scaler values to physical using passed in
// scale factor
int Scale(int source, double scale_factor) {
  return static_cast<int>(source * scale_factor);
}

// Dynamically loads the |GetDpiForWindow| from the User32 module.
// This API is needed to per-monitor DPI for |CreateWindow|, and it is only
// available on Windows 10 version 1607 (Redstone 1) and later.
typedef UINT(WINAPI* GetDpiForWindowFunc)(HWND hwnd);
GetDpiForWindowFunc GetDpiForWindowDynamic() {
  static GetDpiForWindowFunc func_ptr = [] {
    HMODULE user32 = LoadLibraryA("User32.dll");
    return user32 ? reinterpret_cast<GetDpiForWindowFunc>(
                        GetProcAddress(user32, "GetDpiForWindow"))
                  : nullptr;
  }();
  return func_ptr;
}

// Dynamically loads the |EnableNonClientDpiScaling| from the User32 module.
// This API is needed to enable automatic non-client area scaling for windows,
// and it is only available on Windows 10 version 1607 (Redstone 1) and later.
typedef BOOL(WINAPI* EnableNonClientDpiScalingFunc)(HWND hwnd);
EnableNonClientDpiScalingFunc EnableNonClientDpiScalingDynamic() {
  static EnableNonClientDpiScalingFunc func_ptr = [] {
    HMODULE user32 = LoadLibraryA("User32.dll");
    return user32 ? reinterpret_cast<EnableNonClientDpiScalingFunc>(
                        GetProcAddress(user32, "EnableNonClientDpiScaling"))
                  : nullptr;
  }();
  return func_ptr;
}

}  // namespace

Win32Window::Win32Window() {}

Win32Window::~Win32Window() { Destroy(); }

bool Win32Window::CreateAndShow(const std::wstring& title,
                                const Point& origin, const Size& size) {
  Destroy();

  auto class_atom = WindowClassRegistrar::GetInstance().Register(
      kWindowClassName);
  if (class_atom == 0) {
    return false;
  }

  int dpi = GetDpi();
  double scale_factor = dpi / 96.0;

  HWND window = CreateWindow(
      MAKEINTATOM(class_atom), title.c_str(),
      WS_OVERLAPPEDWINDOW | WS_VISIBLE, Scale(origin.x, scale_factor),
      Scale(origin.y, scale_factor), Scale(size.width, scale_factor),
      Scale(size.height, scale_factor), nullptr, nullptr,
      GetModuleHandle(nullptr), this);

  if (!window) {
    return false;
  }

  return OnCreate();
}

void Win32Window::Destroy() {
  if (window_handle_) {
    DestroyWindow(window_handle_);
    window_handle_ = nullptr;
  }
}

HWND Win32Window::GetHandle() { return window_handle_; }

void Win32Window::SetChildContent(HWND content) {
  child_content_ = content;
  SetParent(content, window_handle_);
  RECT frame;
  GetClientRect(window_handle_, &frame);

  HDWP defer_pos_struct = BeginDeferWindowPos(1);
  defer_pos_struct =
      DeferWindowPos(defer_pos_struct, content, nullptr, frame.left, frame.top,
                     frame.right - frame.left, frame.bottom - frame.top,
                     SWP_NOZORDER | SWP_NOACTIVATE | SWP_FRAMECHANGED);
  EndDeferWindowPos(defer_pos_struct);
}

void Win32Window::SetQuitOnClose(bool quit_on_close) {
  quit_on_close_ = quit_on_close;
}

int Win32Window::GetDpi() {
  if (GetDpiForWindowDynamic) {
    return GetDpiForWindowDynamic()(window_handle_);
  }
  return USER_DEFAULT_SCREEN_DPI;
}

float Win32Window::GetScaleFactor() { return GetDpi() / 96.0f; }

bool Win32Window::OnCreate() {
  // No-op; provided for subclasses.
  return true;
}

void Win32Window::OnDestroy() {
  // No-op; provided for subclasses.
}

void Win32Window::OnResize(unsigned int width, unsigned int height) {}

void Win32Window::OnPaint() {}

void Win32Window::OnDestroyed() {
  if (quit_on_close_) {
    PostQuitMessage(0);
  }
}

void Win32Window::OnClose() {}

LRESULT Win32Window::MessageHandler(HWND hwnd, UINT const message,
                                    WPARAM const wparam,
                                    LPARAM const lparam) noexcept {
  switch (message) {
    case WM_DESTROY:
      OnDestroyed();
      return 0;

    case WM_DPICHANGED: {
      OnDpiChanged(LOWORD(wparam));
      RECT* const new_rect = reinterpret_cast<RECT*>(lparam);
      SetWindowPos(hwnd, nullptr, new_rect->left, new_rect->top,
                   new_rect->right - new_rect->left,
                   new_rect->bottom - new_rect->top,
                   SWP_NOZORDER | SWP_NOACTIVATE);
      break;
    }

    case WM_SIZE: {
      RECT rect;
      GetClientRect(hwnd, &rect);
      if (child_content_ != nullptr) {
        // Size and position the child window.
        MoveWindow(child_content_, rect.left, rect.top,
                   rect.right - rect.left, rect.bottom - rect.top, TRUE);
      }
      OnResize(rect.right - rect.left, rect.bottom - rect.top);
      break;
    }

    case WM_PAINT:
      OnPaint();
      break;

    case WM_CLOSE:
      OnClose();
      return 0;

    case WM_NCCREATE: {
      // Enable automatic non-client area scaling for windows that support it.
      if (EnableNonClientDpiScalingDynamic()) {
        EnableNonClientDpiScalingDynamic()(hwnd);
      }
      break;
    }
  }

  return DefWindowProc(hwnd, message, wparam, lparam);
}

LRESULT CALLBACK Win32Window::WndProc(HWND const window, UINT const message,
                                      WPARAM const wparam,
                                      LPARAM const lparam) noexcept {
  if (message == WM_NCCREATE) {
    auto window_struct = reinterpret_cast<CREATESTRUCT*>(lparam);
    SetWindowLongPtr(window, GWLP_USERDATA,
                     reinterpret_cast<LONG_PTR>(window_struct->lpCreateParams));

    auto that = static_cast<Win32Window*>(window_struct->lpCreateParams);
    that->window_handle_ = window;
  } else if (Win32Window* that = GetThisFromHandle(window)) {
    return that->MessageHandler(window, message, wparam, lparam);
  }

  return DefWindowProc(window, message, wparam, lparam);
}

Win32Window* Win32Window::GetThisFromHandle(HWND const window) noexcept {
  return reinterpret_cast<Win32Window*>(
      GetWindowLongPtr(window, GWLP_USERDATA));
}

Win32Window::WindowClassRegistrar::~WindowClassRegistrar() {
  if (class_atom_ != 0) {
    UnregisterClass(MAKEINTATOM(class_atom_), GetModuleHandle(nullptr));
  }
}

Win32Window::WindowClassRegistrar&
Win32Window::WindowClassRegistrar::GetInstance() {
  static WindowClassRegistrar instance;
  return instance;
}

ATOM Win32Window::WindowClassRegistrar::Register(
    std::wstring const& class_name) noexcept {
  if (class_atom_ != 0) {
    return class_atom_;
  }

  WNDCLASSEX wc = {};
  wc.cbSize = sizeof(WNDCLASSEX);
  wc.style = CS_HREDRAW | CS_VREDRAW;
  wc.lpfnWndProc = Win32Window::WndProc;
  wc.hInstance = GetModuleHandle(nullptr);
  wc.hIcon = LoadIcon(nullptr, IDI_APPLICATION);
  wc.hCursor = LoadCursor(nullptr, IDC_ARROW);
  wc.hbrBackground = reinterpret_cast<HBRUSH>(COLOR_WINDOW + 1);
  wc.lpszClassName = class_name.c_str();
  wc.hIconSm = LoadIcon(nullptr, IDI_APPLICATION);

  class_atom_ = RegisterClassEx(&wc);
  return class_atom_;
}