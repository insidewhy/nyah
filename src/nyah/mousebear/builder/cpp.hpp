#ifndef NYAH_MOUSEBEAR_BUILDER_CPP_HPP
#define NYAH_MOUSEBEAR_BUILDER_CPP_HPP

#include <nyah/mousebear/dependency_tracker.hpp>
#include <nyah/mousebear/options.hpp>

#include <chilon/getset.hpp>

#include <fstream>
#include <stdexcept>

namespace nyah { namespace mousebear {

namespace grammar { namespace nyah { class Grammar; } }

namespace builder {

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

class cpp {
    dependency_tracker  dependencies_;
    options const&      opts_;
    std::ofstream       output_;

  public:
    void operator()(char const * const filename);

    cpp(decltype(opts_)& opts) : opts_(opts) {}

    CHILON_GET(opts)
    CHILON_GET_REF(output)
};

} } }
#endif
