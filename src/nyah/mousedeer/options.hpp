#ifndef NYAH_OPTIONS_HPP
#define NYAH_OPTIONS_HPP

#include <string>
#include <vector>

#include <chilon/print.hpp>

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
        if (verbose_) chilon::print(std::cerr, t...);
    }

    std::string find_grammar_file(chilon::range const& module) {
        for (auto it = include_paths_.begin(); it != include_paths_.end();
             ++it)
        {
            std::string search = *it + "/" + std::string(module) + ".nyah";
            if (! access(search.c_str(), R_OK)) return search;
        }

        return "";
    }

    options();
};

} }

#endif
