#ifndef MOUSEBEAR_PARSER_HPP
#define MOUSEBEAR_PARSER_HPP

#include <chilon/parser/parser.hpp>

#include <string>

namespace nyah { namespace mousebear {

typedef chilon::parser::file_parser parser_abstract;

struct parser : parser_abstract {

    void parse();
    bool load() { return parser_abstract::load(fileName_.c_str()); }

    parser(char const * const fileName) : fileName_(fileName) {}
  private:
    std::string fileName_;
};

} }
#endif
