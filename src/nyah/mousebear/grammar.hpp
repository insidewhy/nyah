#ifndef MOUSEBEAR_GRAMMAR_HPP
#define MOUSEBEAR_GRAMMAR_HPP

#include <chilon/parser/source_code_stream.hpp>
#include <chilon/parser/sequence.hpp>
#include <chilon/parser/ascii.hpp>
#include <chilon/parser/joined.hpp>
#include <chilon/parser/choice.hpp>
#include <chilon/parser/until.hpp>
#include <chilon/parser/any_char.hpp>
#include <chilon/parser/not_char.hpp>
#include <chilon/parser/char.hpp>
#include <chilon/parser/char_range.hpp>
#include <chilon/parser/lexeme.hpp>
#include <chilon/parser/not.hpp>
#include <chilon/parser/optional.hpp>
#include <chilon/parser/simple_node.hpp>

namespace nyah { namespace mousebear {

using namespace chilon::parser;
using namespace chilon::parser::ascii;

typedef source_code_stream<
    file_stream,
    sequence<
        char_<'#', ' '>,
        until<any_char, char_<'\n'>>
    >,
    whitespace
> nyah_stream;

typedef char_<'.'> AnyCharacter;

typedef lexeme<
    char_<'['>,
    many<
        choice<
            lexeme<
                store<char_<'\\'>>,
                char_from<'\\',']',s,S,n,N,t,T,w,W> >,
            sequence< not_char<']'>, char_<'-'>, not_char<']'> >,
            not_char<']'> > >,
    char_<']'>
> CharacterRange;

typedef lexeme<
    store<char_<'\\'>>,
    char_from<s,S,n,N,t,T,w,W,'.','"','\'','&','!','+','*','\\'>> Escape;

typedef choice<
    lexeme< char_<'"'>,
        many_range< choice<Escape, not_char<'"'> > >,
    char_<'"'> >,
    lexeme< char_<'\''>,
        many_range< choice<Escape, not_char<'\''> > >,
    char_<'\''> >
> String;

struct RuleName : simple_node<RuleName,
    lexeme<char_range<A, Z>, many< char_range<a,z, A,Z> > > > {};

struct Expression;

typedef choice<
    String, CharacterRange, Escape, AnyCharacter,
    sequence< RuleName, not_< char_<'<'> > >,
    sequence< char_<'('>, node<Expression>, char_<')'> >
> Primary;

typedef choice<char_<'&', '!'>, char_from<'&', '!'> > Prefixes;

typedef choice<
    char_<'^', '+'>,
    char_<'^', '*'>,
    char_from<'+', '?', '*'>,
    char_<'|', '+'> > Suffixes;

typedef sequence<Primary, optional<Suffixes>> Suffix;
typedef sequence<optional<Prefixes>, Suffix>  Prefix;
typedef Prefix Affix;

struct Join : simple_node<Join, sequence<
    Affix,
    choice<
        char_<'^', '%'>,
        char_<'%', '+'>,
        char_<'%'>,
        char_<'|', '%'> >,
    Affix> > {};

struct Joined : simple_node<Joined, joined_plus<char_<'^'>, choice<Join, Affix> > > {};

struct Sequence : simple_node<Sequence, many_plus<Joined> > {};

struct OrderedChoice : simple_node<OrderedChoice, joined_plus<char_<'/'>, Sequence> > {};

struct Expression : simple_node<Expression, OrderedChoice> {};

struct Rule : simple_node<Rule,
    sequence<RuleName, char_<'<', '-'>, Expression >> {};

struct NodeRule : simple_node<NodeRule,
    sequence<RuleName, char_<'<', '='>, Expression> > {};

typedef many< choice<Rule, NodeRule> > Grammar;

template <class O>
void print_tail(int const indent, O& stream, Expression const& expr) {
    print_tail(indent, stream, expr.value_);
}

} }
#endif
