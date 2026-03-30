#ifndef WIN32_WINDOW_H_
#define WIN32_WINDOW_H_

#include <windows.h>

#include <functional>
#include <memory>
#include <string>

// A class abstraction for a high DPI-aware Win32 Window. Intended to be
// inherited from by classes that wish to specialize with custom
// rendering and input handling
class Win32Window {
 public:
  struct Point {
    unsigned int x;
    unsigned int y;
    Point(unsigned int x, unsigned int y) : x(x), y(y) {}
  };

  struct Size {
    unsigned int width;
    unsigned int height;
    Size(unsigned int width, unsigned int height)
        : width(width), height(height) {}
  };

  Win32Window();
  virtual ~Win32Window();

  // Creates a win32 window with |title| that is positioned and sized using
  // |origin| and |size|. |on_create| is called after the window is created but
  // before it is shown. Returns false if window creation fails.
  bool CreateAndShow(const std::wstring& title,
                     const Point& origin,
                     const Size& size);

  // Releases OS resources associated with window.
  void Destroy();

  // Inserts |content| into the window tree.
  void SetChildContent(HWND content);

  // Returns the backing Window handle.
  HWND GetHandle();

  // If true, closing this window will quit the application.
  void SetQuitOnClose(bool quit_on_close);

  // Returns the current DPI for the window
  int GetDpi();

  // Returns the scale factor for the window, where 1.0 is 96 DPI.
  float GetScaleFactor();

 protected:
  // Called when CreateAndShow is called, allowing subclass window-related
  // setup. Subclasses should return false if setup fails.
  virtual bool OnCreate();

  // Called when Destroy is called.
  virtual void OnDestroy();

  // Called when the window receives a WM_SIZE message.
  virtual void OnResize(unsigned int width, unsigned int height) {}

  // Called when the window should paint itself.
  virtual void OnPaint() {}

  // Called when the window receives a WM_DESTROY message.
  virtual void OnDestroyed() {}

  // Called when the window receives a WM_DPICHANGED message.
  virtual void OnDpiChanged(unsigned int dpi) {}

  // Called when the window should close.
  virtual void OnClose() {}

  // Processes and routes salient window messages for customization.
  virtual LRESULT MessageHandler(HWND window,
                                 UINT const message,
                                 WPARAM const wparam,
                                 LPARAM const lparam) noexcept;

 private:
  friend class WindowClassRegistrar;

  // OS callback called by message pump.
  static LRESULT CALLBACK WndProc(HWND const window,
                                  UINT const message,
                                  WPARAM const wparam,
                                  LPARAM const lparam) noexcept;

  // Manages the window class registration.
  class WindowClassRegistrar {
   public:
    ~WindowClassRegistrar();
    static WindowClassRegistrar& GetInstance();
    ATOM Register(std::wstring const& class_name) noexcept;

   private:
    WindowClassRegistrar() = default;
    ATOM class_atom_ = 0;
  };

  HWND window_handle_ = nullptr;
  HWND child_content_ = nullptr;

  bool quit_on_close_ = false;
};

#endif  // WIN32_WINDOW_H_