#ifndef NYAH_OPTIONS_HPP
#define NYAH_OPTIONS_HPP

#include <string>

namespace nyah {

struct options {
    bool verbose_;
    bool print_ast_;
    std::string output_dir_;
    std::string output_namespace_;

    // number of positionals, 0 for failure, prints errors to stderr
    int parse_command_line(char const *header, int argc, char *argv[]);

    options();
};

}

#endif
