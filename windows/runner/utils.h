#ifndef RUNNER_UTILS_H_
#define RUNNER_UTILS_H_

#include <string>
#include <vector>

// Creates a console for the process, and redirects stdout and stderr to
// it for both the runner and the Flutter engine.
void CreateAndAttachConsole();

// Gets the command line arguments passed in as a std::vector<std::string>
std::vector<std::string> GetCommandLineArguments();

// Gets the directory where the executable is located
std::string GetExecutableDirectory();

#endif  // RUNNER_UTILS_H_