#include "utils.h"

#include <Windows.h>
#include <io.h>
#include <stdio.h>
#include <iostream>
#include <fstream>
#include <shlobj.h>

#include "flutter_window.h"

namespace {

// Returns the path of the directory containing this executable, or an empty
// string if the directory cannot be found.
std::string GetExecutablePath() {
  char buffer[MAX_PATH];
  if (GetModuleFileNameA(nullptr, buffer, MAX_PATH) == 0) {
    return "";
  }
  std::string exe_path(buffer);
  size_t last_separator = exe_path.find_last_of('\\');
  if (last_separator != std::string::npos) {
    return exe_path.substr(0, last_separator + 1);
  }
  return "";
}

}  // namespace

void CreateAndAttachConsole() {
  if (::AllocConsole()) {
    FILE *unused;
    if (freopen_s(&unused, "CONOUT$", "w", stdout)) {
      _dup2(_fileno(stdout), 1);
    }
    if (freopen_s(&unused, "CONOUT$", "w", stderr)) {
      _dup2(_fileno(stdout), 2);
    }
    std::ios::sync_with_stdio();
    std::cout << "Attached console for debugging." << std::endl;
  }
}

std::vector<std::string> GetCommandLineArguments() {
  std::vector<std::string> command_line_arguments;

  // Extract command line arguments.
  int argc;
  wchar_t** argv = ::CommandLineToArgvW(::GetCommandLineW(), &argc);
  if (argv) {
    for (int i = 1; i < argc; i++) {
      wchar_t* argument = argv[i];
      // Convert wide string to UTF-8.
      int buffer_size = WideCharToMultiByte(CP_UTF8, 0, argument, -1, nullptr,
                                            0, nullptr, nullptr);
      if (buffer_size == 0) {
        continue;
      }
      std::string utf8_argument(buffer_size, 0);
      WideCharToMultiByte(CP_UTF8, 0, argument, -1, &utf8_argument[0],
                          buffer_size, nullptr, nullptr);
      // Remove the null terminator.
      utf8_argument.pop_back();
      command_line_arguments.push_back(utf8_argument);
    }
    ::LocalFree(argv);
  }

  return command_line_arguments;
}

std::string GetExecutableDirectory() {
  std::string exe_path = GetExecutablePath();
  if (exe_path.empty()) {
    return "";
  }
  return exe_path;
}