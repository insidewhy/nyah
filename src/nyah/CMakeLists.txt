cmake_minimum_required(VERSION 2.6)

set(CHILON_DIR ${CMAKE_SOURCE_DIR}/../chilon)
set(CMAKE_MODULE_PATH ${CHILON_DIR}/cmake/modules)
set(CMAKE_ALLOW_LOOSE_LOOP_CONSTRUCTS true)

project(nyah)

include(C++0x)
include(Installer)
# configureFile(config.hpp)

include_directories(..)
add_subdirectory(mousedeer)
add_definitions(-Wall)
