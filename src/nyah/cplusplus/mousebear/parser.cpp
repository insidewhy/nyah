#include <mousebear/parser.hpp>

#include <chilon/parser/eg/is_mutable.hpp>
#include <chilon/parser/eg/char.hpp>
#include <chilon/parser/eg/choice.hpp>
#include <chilon/parser/eg/lexeme.hpp>
#include <chilon/parser/eg/until.hpp>
#include <chilon/parser/eg/sequence.hpp>
#include <chilon/parser/eg/parse.hpp>
#include <chilon/parser/eg/store.hpp>

namespace nyah { namespace mousebear {

using namespace chilon::parser::eg;

bool parser::parse() {
    skip_whitespace();

    // typedef make_choice<
    //     make_lexeme< char_<'"'>, until<any_char, char_<'"'>> >::type,
    //     make_lexeme< char_<'\''>, until<any_char, char_<'\''>> >::type >::type
    // quoted_string_match;

    typedef make_lexeme<
        char_<'\''>,
        until< any_char, char_<'\''> > >::type quoted_string_match;

    eg::store<
        char_<'g','r','a', 'm', 'm', 'a', 'r'>,
        quoted_string_match> grammar_store;

    if (grammar_store(*this)) {
        std::cout << "cowboy (" << grammar_store.value_ << ")\n";
    }
    else {
        std::cerr << "invalid grammar\n";
        return false;
    }

    return true;
}

} }
