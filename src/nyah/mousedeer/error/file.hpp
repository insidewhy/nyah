#ifndef NYAH_MOUSEDEER_ERROR_FILE_HPP
#define NYAH_MOUSEDEER_ERROR_FILE_HPP

#include <stdexcept>

namespace nyah { namespace mousedeer { namespace error {

struct file : std::runtime_error {
    file(char const * const error, std::string const& file_path)
      : std::runtime_error(error), file_path_(file_path) {}
    ~file() throw() {}
    std::string file_path_;
};

struct cannot_open_file : file {
    ~cannot_open_file() throw() {}
    cannot_open_file(std::string const& file_path)
      : file("cannot open input file", file_path) {}
};

struct parsing : file {
    ~parsing() throw() {}
    parsing(std::string const& file_path)
      : file("parsing error", file_path) {}
    parsing(char const * const error, std::string const& file_path)
      : file(error, file_path) {}
};

} } }
#endif
