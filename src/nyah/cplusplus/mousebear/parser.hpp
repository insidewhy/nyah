#ifndef MOUSEBEAR_PARSER_HPP
#define MOUSEBEAR_PARSER_HPP

#include <chilon/parser/parser.hpp>
#include <chilon/parser/whitespace.hpp>
#include <chilon/parser/sequence.hpp>
#include <chilon/parser/choice.hpp>
#include <chilon/parser/until.hpp>
#include <chilon/parser/any_char.hpp>
#include <chilon/parser/char.hpp>

#include <string>

namespace nyah { namespace mousebear {

namespace chpar = chilon::parser;

typedef chpar::skip_ws_and_comments_with_line_number<
    chpar::file_parser,
    chpar::sequence<
        chpar::choice<
            chpar::char_<'#', ' '>,
            chpar::char_<'/', '/'>
        >,
        chpar::until<chpar::any_char, chpar::char_<'\n'>>
    >,
    chpar::whitespace
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
