cmake_minimum_required(VERSION 2.6)

set(CHILON_DIR ${CMAKE_SOURCE_DIR}/../chilon)
set(CMAKE_MODULE_PATH ${CHILON_DIR}/cmake/modules)
set(CMAKE_ALLOW_LOOSE_LOOP_CONSTRUCTS true)

project(nyah)

include(C++0x)
include(Installer)
# configureFile(config.hpp)

include_directories(..)
add_subdirectory(mousebear)
add_definitions(-Wall)

set(nyah_sources options.cpp)
add_library(nyah-dynamic SHARED ${nyah_sources})
set_target_properties(nyah-dynamic PROPERTIES OUTPUT_NAME nyah CLEAN_DIRECT_OUTPUT 1)

install(TARGETS nyah-dynamic
        RUNTIME DESTINATION ${BIN_DIR}
        LIBRARY DESTINATION ${LIB_DIR})
