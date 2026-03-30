# Project-level CMake file for Flutter application

cmake_minimum_required(VERSION 3.14)
project(geometry_3d_app LANGUAGES CXX)

# Set build type if not provided
if(NOT CMAKE_BUILD_TYPE)
  set(CMAKE_BUILD_TYPE "Release")
endif()

# Define source files
set(SOURCES
  "flutter/generated_plugin_registrant.cc"
  "runner/main.cpp"
  "runner/flutter_window.cpp"
  "runner/win32_window.cpp"
  "runner/utils.cpp"
)

# Define header files
set(HEADERS
  "flutter/generated_plugin_registrant.h"
  "runner/flutter_window.h"
  "runner/win32_window.h"
  "runner/utils.h"
)

# Define resource files
set(RESOURCES
  "runner/resources.rc"
)

# Flutter library
add_subdirectory(flutter)

# Application executable
add_executable(${PROJECT_NAME} WIN32
  ${SOURCES}
  ${HEADERS}
  ${RESOURCES}
)

# Target include directories
target_include_directories(${PROJECT_NAME} PRIVATE
  "${CMAKE_CURRENT_SOURCE_DIR}"
  "${CMAKE_CURRENT_SOURCE_DIR}/runner"
)

# Link Flutter library
target_link_libraries(${PROJECT_NAME} PRIVATE
  flutter
  flutter_wrapper_app
)

# Link system libraries
target_link_libraries(${PROJECT_NAME} PRIVATE
  comctl32
  dwmapi
  ole32
  oleaut32
  shell32
  uuid
  windowsapp
  winspool
)

# Copy Flutter assets and AOT library to build output directory
add_custom_command(TARGET ${PROJECT_NAME} POST_BUILD
  COMMAND ${CMAKE_COMMAND} -E copy_directory
    "${CMAKE_BINARY_DIR}/flutter/ephemeral/flutter_assets"
    "$<TARGET_FILE_DIR:${PROJECT_NAME}>/flutter_assets"
  COMMAND ${CMAKE_COMMAND} -E copy
    "${CMAKE_BINARY_DIR}/flutter/ephemeral/$<IF:$<CONFIG:Debug>,libflutter_windows.dll,libflutter_windows.dll>"
    "$<TARGET_FILE_DIR:${PROJECT_NAME}>/$<IF:$<CONFIG:Debug>,libflutter_windows.dll,libflutter_windows.dll>"
  COMMAND ${CMAKE_COMMAND} -E copy
    "${CMAKE_BINARY_DIR}/flutter/ephemeral/flutter_windows.dll"
    "$<TARGET_FILE_DIR:${PROJECT_NAME}>/flutter_windows.dll"
)

# Generate build info
configure_file(
  "${CMAKE_CURRENT_SOURCE_DIR}/runner/flutter_window.h.in"
  "${CMAKE_CURRENT_BINARY_DIR}/generated/flutter_window.h"
  @ONLY
)