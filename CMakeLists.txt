cmake_minimum_required(VERSION 3.15)
project(swap VERSION 1.0 LANGUAGES CXX)

set(CMAKE_EXPORT_COMPILE_COMMANDS ON)

enable_language(CXX)

find_package(EASTL REQUIRED)

add_executable(${PROJECT_NAME} ./swap.cpp)
target_link_libraries(${PROJECT_NAME} EASTL::EASTL)