#ifndef NYAH_MOUSEBEAR_BUILDER_CPP_HPP
#define NYAH_MOUSEBEAR_BUILDER_CPP_HPP

#include <nyah/mousebear/dependency_tracker.hpp>
#include <nyah/mousebear/options.hpp>
#include <nyah/mousebear/file_error.hpp>

#include <chilon/getset.hpp>

#include <fstream>
#include <stdexcept>

namespace nyah { namespace mousebear {

namespace grammar { namespace nyah { class Grammar; } }

namespace builder {

class cpp {
    dependency_tracker  dependencies_;
    options const&      opts_;

  public:
    void operator()(char const * const filename);

    cpp(decltype(opts_)& opts) : opts_(opts) {}

    CHILON_GET(opts)
};

} } }
#endif
