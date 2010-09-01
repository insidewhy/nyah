#ifndef NYAH_MOUSEDEER_CPP_BUILDER_HPP
#define NYAH_MOUSEDEER_CPP_BUILDER_HPP

#include <nyah/mousedeer/options.hpp>
#include <nyah/mousedeer/file.hpp>

#include <chilon/getset.hpp>

#include <unordered_map>
#include <fstream>
#include <stdexcept>

namespace nyah { namespace mousedeer { namespace cpp {

class builder {
    options&                              options_;
    std::unordered_map<std::string, file> files_;

    typedef decltype(files_)              files_t;

    // if file doesn't exist in project, add it and return reference to it
    // otherwise return a reference to the existing file.
    file& add_file(std::string const& file_path) {
        return files_.insert(
            files_t::value_type(file_path, file())).first->second;
    }


  public:
    // add file to project and process it and its includes
    void operator()(std::string const& file_path);

    builder(decltype(options_)& options) : options_(options) {}
};

} } }
#endif
