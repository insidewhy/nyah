#ifndef NYAH_OPTIONS_HPP
#define NYAH_OPTIONS_HPP

#include <string>
#include <vector>

#include <chilon/print.hpp>

namespace nyah {

struct options {
    bool verbose_;
    bool print_ast_;
    std::string output_dir_;
    std::vector<std::string> output_namespace_;

    // number of positionals, 0 for failure, prints errors to stderr
    int parse_command_line(char const *header, int argc, char *argv[]);

    template <class... T>
    void verbose(T const&... t) const {
        if (verbose_) chilon::print(std::cerr, t...);
    }

    options();
};

}

#endif
