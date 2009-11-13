#include <mousebear/parser.hpp>

#include <chilon/parser/eg/is_mutable.hpp>
#include <chilon/parser/eg/char.hpp>
#include <chilon/parser/eg/choice.hpp>
#include <chilon/parser/eg/lexeme.hpp>
#include <chilon/parser/eg/until.hpp>
#include <chilon/parser/eg/sequence.hpp>

namespace nyah { namespace mousebear {

bool parser::parse() {
    skip_whitespace();

    typedef eg::choice<
        eg::lexeme< eg::char_<'"'>, eg::until<eg::any_char, eg::char_<'"'>> >,
        eg::lexeme< eg::char_<'\''>, eg::until<eg::any_char, eg::char_<'\''>> > >
    quoted_string_match;

    range res;
    if (store< 
            eg::sequence<
                eg::char_<'g','r','a', 'm', 'm', 'a', 'r'>,
                quoted_string_match>
        >(res)) 
    {
    }
    else {
        std::cerr << "invalid grammar\n";
        return false;
    }

    return true;
}

} }
