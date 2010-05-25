#ifndef NYAH_SOURCE_BUILDER_HPP
#define NYAH_SOURCE_BUILDER_HPP

#include <mousebear/dependency_tracker.hpp>

#include <chilon/getset.hpp>

namespace nyah { namespace mousebear {

class Grammar;

class source_builder {
    std::string         output_dir_;
    dependency_tracker  dependencies_;

  public:
    void operator()(Grammar const& grammar);

    CHILON_GETSET_REF(output_dir)
};

} }
#endif
