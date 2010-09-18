#ifndef NYAH_OPTIONS_HPP
#define NYAH_OPTIONS_HPP

#include <chilon/print.hpp>

#include <string>
#include <vector>

#include <unistd.h>

namespace nyah { namespace mousedeer {

struct options {
    bool                       verbose_;
    bool                       print_ast_;
    std::string                output_dir_;
    std::vector<std::string>   include_paths_;

    // returns number of positionals, 0 for failure, prints errors to
    // stderr
    int parse_command_line(char const *header, int argc, char *argv[]);

    template <class... T>
    void verbose(T const&... t) const {
        if (verbose_) chilon::println(std::cerr, t...);
    }

    std::string include(std::vector<chilon::range> const& path);

    options();
};

} }

#endif
