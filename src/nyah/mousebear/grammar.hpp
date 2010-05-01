#ifndef MOUSEBEAR_PARSER_HPP
#define MOUSEBEAR_PARSER_HPP

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
#include <chilon/parser/simple_node.hpp>
#include <chilon/parser/not.hpp>
#include <chilon/parser/optional.hpp>

#include <string>

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

// not_char matches any character except the given argument
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

// char_from matches any of the given characters once
typedef lexeme<
    store<char_<'\\'>>,
    char_from<s,S,n,N,t,T,w,W,'.','"','\'','&','!','+','*','\\'>> Escape;

// many_range is like many but forces the match to be a string
typedef choice<
    lexeme< char_<'"'>,
        many_range< choice<Escape, not_char<'"'> > >,
    char_<'"'> >,
    lexeme< char_<'\''>,
        many_range< choice<Escape, not_char<'\''> > >,
    char_<'\''> >
> String;

// simple_node is like node, but provides an inherited attribute called value_
// which stores the result of the sub-expression provided in the second
// template parameter.
// RuleName would also be stored as a string if it was not stored as a node
// creating ambiguity between the storage for this match and string matches.
struct RuleName : simple_node<RuleName,
    lexeme<char_range<A, Z>,
    many< char_range<a,z, A,Z> > >> {};

struct Expression;

typedef choice<
    String, CharacterRange, Escape, AnyCharacter,
    // not_ is equivalent to the not-predicate in PEG notation, it succeeds only
    // if the sub-expression does not match and never consumes input.
    // chilon::parser also provides try_ which succeeds only if the
    // sub-expression matches and never consumes input.
    sequence< node<RuleName>, not_< char_<'<'> > >,
    sequence< char_<'('>, node<Expression>, char_<')'> >
> Primary;

typedef choice<char_<'&', '!'>, char_from<'&', '!'> > Prefixes;

typedef choice<
    char_<'^', '+'>,
    char_<'^', '*'>,
    char_from<'+', '?', '*'> > Suffixes;

typedef sequence<Primary, optional<Suffixes>> Suffix;
typedef sequence<optional<Prefixes>, Suffix>  Prefix;
typedef Prefix Affix;

typedef joined_plus<
    char_<'^'>,
    choice<
        sequence<
            Affix,
            choice<
                sequence< store<char_<'^'>>, store<char_<'%'>> >,
                sequence< store<char_<'%'>>, store<char_<'+'>> >,
                char_<'%'> >,
            Affix>,
        Affix> >   Joined;

// many_plus is the same as many, but the sub-expression must match
// at least once.
typedef many_plus<Joined>                  Sequence;

// joined_plus is the same as joined, but the sub-expression must match
// at least once
typedef joined_plus<char_<'/'>, Sequence>  OrderedChoice;

// Using simple_node is an ideal way to break cycles in a grammar
// to allow a parsing expression to be used forward declared.
struct Expression : simple_node<Expression, OrderedChoice> {};

struct Rule : simple_node<
    Rule,
    sequence<node<RuleName>, char_<'<', '-'>, node<Expression>> > {};

struct NodeRule : simple_node<
    NodeRule,
    sequence<node<RuleName>, char_<'<', '='>, node<Expression>> > {};

typedef many< choice< node<Rule>, node<NodeRule> > > Grammar;

template <class O>
void print_tail(int const indent, O& stream, Expression const& value) {
    print_tail(indent, stream, value.value_);
}

template <class O>
void print_tail(int const indent, O& stream, Rule const& value) {
    print_tail(indent, stream, "rule: ", value.value_);
}

template <class O>
void print_tail(int const indent, O& stream, RuleName const& value) {
    print_tail(indent, stream, "rule name: ", value.value_);
}

template <class O>
void print_tail(int const indent, O& stream, NodeRule const& value) {
    print_tail(indent, stream, "node rule: ", value.value_);
}

} }
#endif
