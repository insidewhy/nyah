#ifndef MOUSEBEAR_PARSER_HPP
#define MOUSEBEAR_PARSER_HPP

#include <chilon/parser/source_code_stream.hpp>
#include <chilon/parser/sequence.hpp>
#include <chilon/parser/choice.hpp>
#include <chilon/parser/until.hpp>
#include <chilon/parser/any_char.hpp>
#include <chilon/parser/char.hpp>

#include <string>

namespace nyah { namespace mousebear {

namespace chpar = chilon::parser;

typedef chpar::source_code_stream<
    chpar::file_stream,
    chpar::sequence<
        chpar::choice<
            chpar::char_<'#', ' '>,
            chpar::char_<'/', '/'>
        >,
        chpar::until<chpar::any_char, chpar::char_<'\n'>>
    >,
    chpar::whitespace
> nyah_stream;

using chilon::range;

} }
#endif
