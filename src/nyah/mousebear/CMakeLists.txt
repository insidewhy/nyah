include_directories(..)

add_executable(mousebear mousebear.cpp source_builder.cpp
                         dependency_tracker.cpp)

install(TARGETS mousebear
        RUNTIME DESTINATION ${BIN_DIR}
        LIBRARY DESTINATION ${LIB_DIR})
file(GLOB headers *.hpp)
install(FILES ${headers} DESTINATION ${HEADER_DIR}/nyah/mousebear)
