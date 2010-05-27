#ifndef NYAH_MOUSEBEAR_FILE_ERROR_HPP
#define NYAH_MOUSEBEAR_FILE_ERROR_HPP

#include <nyah/mousebear/grammar/nyah.hpp>

namespace nyah { namespace mousebear {

struct file_error : std::runtime_error {
    file_error(char const * const error, char const * const file_path)
      : std::runtime_error(error), file_path_(file_path) {}
    ~file_error() throw() {}
    std::string file_path_;
};

struct cannot_open_file : file_error {
    ~cannot_open_file() throw() {}
    cannot_open_file(char const * const file_path)
      : file_error("cannot open input file", file_path) {}
};

struct parsing_error : file_error {
    ~parsing_error() throw() {}
    parsing_error(char const * const file_path)
      : file_error("parsing error", file_path) {}
    parsing_error(char const * const error, char const * const file_path)
      : file_error(error, file_path) {}
};

} }

#endif
