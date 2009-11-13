add_executable(mousebear mousebear.cpp)

install(TARGETS mousebear
        RUNTIME DESTINATION ${BIN_DIR}
        LIBRARY DESTINATION ${LIB_DIR})
