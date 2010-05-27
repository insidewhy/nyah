#ifndef NYAH_SOURCE_BUILDER_HPP
#define NYAH_SOURCE_BUILDER_HPP

#include <mousebear/dependency_tracker.hpp>

#include <nyah/options.hpp>

#include <chilon/getset.hpp>

#include <fstream>

namespace nyah { namespace mousebear {

class Grammar;

class source_builder {
    dependency_tracker  dependencies_;
    options const&      opts_;
    std::ofstream       output_;

  public:
    void operator()(char const * const filename, Grammar const& grammar);

    source_builder(decltype(opts_)& opts) : opts_(opts) {}

    CHILON_GET(opts)
    CHILON_GET_REF(output)
};

} }
#endif
