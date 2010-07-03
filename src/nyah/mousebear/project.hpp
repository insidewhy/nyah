#ifndef NYAH_PROJECT_HPP
#define NYAH_PROJECT_HPP

#include <nyah/mousebear/options.hpp>

#include <vector>
#include <string>

namespace nyah { namespace mousebear {

class project {
    options&                 opts_;
    std::vector<std::string> files_;

  public:
    void add_file(char const * const file_path) {
        files_.push_back(file_path);
    }

    project(decltype(opts_)& opts) : opts_(opts) {}

    CHILON_GET(opts)
    CHILON_GET_REF_CONST(files)
};

} }

#endif

