#include <mousebear/parser.hpp>

#include <chilon/parser/char.hpp>
#include <chilon/parser/char_range.hpp>
#include <chilon/parser/choice.hpp>
#include <chilon/parser/lexeme.hpp>
#include <chilon/parser/until.hpp>
#include <chilon/parser/sequence.hpp>
#include <chilon/parser/parse.hpp>
#include <chilon/parser/store.hpp>
#include <chilon/parser/print.hpp>
#include <chilon/parser/many.hpp>
#include <chilon/parser/ascii.hpp>

namespace nyah { namespace mousebear {

using namespace chilon::parser;
using namespace chilon::parser::ascii;

bool parser::parse() {
    skip_whitespace();

    // typedef choice<
    //     lexeme< char_<'"'>, until<any_char, char_<'"'>> >,
    //     lexeme< char_<'\''>, until<any_char, char_<'\''>> >
    // > // quoted_string_match;

    typedef lexeme<
        char_<'\''>,
        until< any_char, char_<'\''> > > quoted_string_match;

    typedef lexeme<
        char_range<A, Z>,
        many<char_range<a, z>> >  class_name;

    typedef lexeme<
        char_range<a, z>,
        many<char_range<a, z>> >  rule_name;

    typedef store<
        char_<g, r, a, m, m, a, r>,
        quoted_string_match,
        many<class_name, char_<'='>, rule_name> > project_parser;

    project_parser project;
    if (project(*this)) {
        print(project.value_);
        return true;
    }
    else {
        std::cerr << "invalid grammar searching for class\n";
        print("class", project.value_);
        std::cerr << begin();
        return false;
    }
}

} }
