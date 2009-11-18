#include <mousebear/parser.hpp>

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
    //     lexeme< char_<'"'>, until<any_char, char_<'"'>> >,
    //     lexeme< char_<'\''>, until<any_char, char_<'\''>> >::type >
    // quoted_string_match;

    typedef lexeme<
        char_<'\''>,
        until< any_char, char_<'\''> > > quoted_string_match;

    eg::store<
        char_<'g','r','a', 'm', 'm', 'a', 'r'>,
        quoted_string_match> grammar_store;

    if (grammar_store(*this)) {
        print(std::cout, "grammar", grammar_store.value_);
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
    typedef lexeme<
        char_range<'A', 'Z'>,
        many<char_range<'a', 'z'>> >  class_name;

    typedef lexeme<
        char_range<'a', 'z'>,
        many<char_range<'a', 'z'>> >  rule_name;

    eg::store<
        many<class_name, char_<'='>, rule_name>
    > class_store;

    if (class_store(*this)) {
        print(std::cout, "class", class_store.value_);
        return true;
    }
    else {
        std::cerr << "invalid grammar searching for class\n";
        print(std::cout, "class", class_store.value_);
        std::cerr << begin();
        return false;
    }
}

} }
