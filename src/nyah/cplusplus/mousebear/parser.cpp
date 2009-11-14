#include <mousebear/parser.hpp>

#include <chilon/parser/eg/is_mutable.hpp>
#include <chilon/parser/eg/char.hpp>
#include <chilon/parser/eg/choice.hpp>
#include <chilon/parser/eg/lexeme.hpp>
#include <chilon/parser/eg/until.hpp>
#include <chilon/parser/eg/sequence.hpp>
#include <chilon/parser/eg/store.hpp>

namespace nyah { namespace mousebear {

bool parser::parse() {
    skip_whitespace();

    // typedef eg::make_choice<
    //     eg::make_lexeme< eg::char_<'"'>, eg::until<eg::any_char, eg::char_<'"'>> >::type,
    //     eg::make_lexeme< eg::char_<'\''>, eg::until<eg::any_char, eg::char_<'\''>> >::type >::type
    // quoted_string_match;

    typedef eg::make_lexeme< eg::char_<'\''>, eg::until<eg::any_char, eg::char_<'\''>> >::type quoted_string_match;

    typedef eg::make_sequence<
        eg::char_<'g','r','a', 'm', 'm', 'a', 'r'>,
        quoted_string_match>::type grammar_begin_match;

    eg::store<grammar_begin_match>::type res;

    if (store<grammar_begin_match>(res)) {
        std::cout << "cowboy (" << res << ")\n";
    }
    else {
        std::cerr << "invalid grammar\n";
        return false;
    }

    return true;
}

} }
