#include <mousebear/parser.hpp>

#include <chilon/parser/eg/is_mutable.hpp>
#include <chilon/parser/eg/char.hpp>
#include <chilon/parser/eg/char_range.hpp>
#include <chilon/parser/eg/choice.hpp>
#include <chilon/parser/eg/lexeme.hpp>
#include <chilon/parser/eg/until.hpp>
#include <chilon/parser/eg/sequence.hpp>
#include <chilon/parser/eg/parse.hpp>
#include <chilon/parser/eg/store.hpp>
#include <chilon/parser/eg/print.hpp>

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
        print(std::cout, "grammar (", grammar_store.value_, ")");
        skip_whitespace();
        return parse_classes();
    }
    else {
        std::cerr << "invalid grammar\n";
        std::cerr << begin();
        return false;
    }
}

bool parser::parse_classes() {
    eg::store<
        eg::make_lexeme<
            char_range<'A', 'Z'>,
            many<char_range<'a', 'z'>>
        >::type
    > class_store;

    if (class_store(*this)) {
        print(std::cout, "class (", class_store.value_, ")");
        return true;
    }
    else {
        std::cerr << "invalid grammar searching for class\n";
        std::cerr << begin();
        return false;
    }
}

} }
