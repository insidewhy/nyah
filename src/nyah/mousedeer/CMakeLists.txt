add_executable(mousedeer mousedeer.cpp cpp/builder.cpp options.cpp)

install(TARGETS mousedeer
        RUNTIME DESTINATION ${BIN_DIR}
        LIBRARY DESTINATION ${LIB_DIR})
file(GLOB headers *.hpp)
install(FILES ${headers} DESTINATION ${HEADER_DIR}/nyah/mousedeer)

set(MOUSEDEER_SYSTEM_INCLUDE_PATH
    "${CMAKE_INSTALL_PREFIX}/include/mousedeer"
    CACHE STRING "mousedeer default include path")

configureFile(config.hpp)
