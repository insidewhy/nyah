#ifndef NYAH_MOUSEBEAR_BUILDER_CPP_HPP
#define NYAH_MOUSEBEAR_BUILDER_CPP_HPP

#include <nyah/mousebear/project.hpp>

#include <chilon/getset.hpp>

#include <fstream>
#include <stdexcept>

namespace nyah { namespace mousebear {

namespace builder {

class cpp {
    project& proj_;

  public:
    // add file to project and process it and its includes
    void operator()(std::string const& file_path);

    cpp(decltype(proj_)& proj) : proj_(proj) {}

    CHILON_GET(proj)
};

} } }
#endif
