#ifndef NYAH_MOUSEBEAR_BUILDER_CPP_HPP
#define NYAH_MOUSEBEAR_BUILDER_CPP_HPP

#include <nyah/mousebear/project.hpp>
#include <nyah/mousebear/file_error.hpp>

#include <chilon/getset.hpp>

#include <fstream>
#include <stdexcept>

namespace nyah { namespace mousebear {

class NodeRule;
class Rule;

namespace grammar { namespace nyah { class Grammar; } }

namespace builder {

class cpp {
    project& proj_;

  public:
    // process single file without includes
    void operator()(std::string const& file_path);

    // process all files in project
    void operator()();

    cpp(decltype(proj_)& proj) : proj_(proj) {}

    CHILON_GET(proj)
};

} } }
#endif
