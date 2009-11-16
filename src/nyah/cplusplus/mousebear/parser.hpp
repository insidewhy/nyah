#ifndef MOUSEBEAR_PARSER_HPP
#define MOUSEBEAR_PARSER_HPP

#include <chilon/parser/parser.hpp>
#include <chilon/parser/whitespace.hpp>

#include <string>

namespace nyah { namespace mousebear {

namespace eg = chilon::parser::eg;

typedef chilon::parser::skip_ws_and_comments_with_line_number<
    chilon::parser::file_parser,
    chilon::parser::comment< 
        chilon::parser::or_< eg::char_<'#', ' '>, eg::char_<'/', '/'> >, eg::char_<'\n'> >,
    chilon::parser::whitespace
> parser_abstract;

using chilon::range;

struct parser : parser_abstract {

    bool parse_classes();
    bool parse();
    bool load() { return parser_abstract::load(fileName_.c_str()); }

    parser(char const * const fileName) : fileName_(fileName) {}
  private:
    std::string fileName_;
};

} }
#endif
