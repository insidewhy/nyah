#ifndef NYAH_PROJECT_HPP
#define NYAH_PROJECT_HPP

#include <nyah/mousebear/options.hpp>
#include <nyah/mousebear/file.hpp>

#include <chilon/getset.hpp>

#include <unordered_map>
#include <string>

namespace nyah { namespace mousebear {

class project {
    options&                              opts_;
    std::unordered_map<std::string, file> files_;
    typedef decltype(files_)              files_t;

  public:
    // if file doesn't exist in project, add it and return reference to it
    // otherwise return a reference to the existing file.
    file& add_file(std::string const& file_path) {
        return files_.insert(
            files_t::value_type(file_path, file())).first->second;
    }

    project(decltype(opts_)& opts) : opts_(opts) {}

    CHILON_GET(opts)
    CHILON_GET_REF_CONST(files)
};

} }

#endif

