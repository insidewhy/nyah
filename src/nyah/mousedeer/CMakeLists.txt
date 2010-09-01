add_executable(mousedeer mousedeer.cpp cpp/builder.cpp options.cpp)

install(TARGETS mousedeer
        RUNTIME DESTINATION ${BIN_DIR}
        LIBRARY DESTINATION ${LIB_DIR})
file(GLOB headers *.hpp)
install(FILES ${headers} DESTINATION ${HEADER_DIR}/nyah/mousedeer)
