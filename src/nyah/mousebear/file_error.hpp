#ifndef NYAH_MOUSEBEAR_FILE_ERROR_HPP
#define NYAH_MOUSEBEAR_FILE_ERROR_HPP

#include <nyah/mousebear/grammar/nyah.hpp>

namespace nyah { namespace mousebear {

struct file_error : std::runtime_error {
    file_error(char const * const error, char const * const file_name)
      : std::runtime_error(error), file_name_(file_name) {}
    ~file_error() throw() {}
    std::string file_name_;
};

struct cannot_open_file : file_error {
    ~cannot_open_file() throw() {}
    cannot_open_file(char const * const file_name)
      : file_error("cannot open input file", file_name) {}
};

struct parsing_error : file_error {
    ~parsing_error() throw() {}
    parsing_error(char const * const file_name)
      : file_error("parsing error", file_name) {}
    parsing_error(char const * const error, char const * const file_name)
      : file_error(error, file_name) {}
};

} }

#endif
