#ifndef NYAH_MOUSEBEAR_GRAMMAR_GRAMMAR_HPP
#define NYAH_MOUSEBEAR_GRAMMAR_GRAMMAR_HPP

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
#include <chilon/parser/tree_joined.hpp>
#include <chilon/parser/tree_many.hpp>

namespace nyah { namespace mousebear { namespace grammar { namespace grammar {

using namespace chilon::parser;
using namespace chilon::parser::ascii;

typedef choice<
    sequence<
        char_<'/', '/'>,
        until<any_char, char_<'\n'>>
    >,
    whitespace
> Spacing;

typedef char_<'.'> AnyCharacter;

struct CharacterRange : simple_node<CharacterRange, lexeme<
    char_<'['>,
    many<
        choice<
            lexeme<
                store<char_<'\\'>>,
                char_from<'\\',']',s,S,n,N,t,T,w,W> >,
            sequence< not_char<']'>, char_<'-'>, not_char<']'> >,
            not_char<']'> > >,
    char_<']'>
> > {};

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

typedef lexeme<char_range<A,Z>, many< char_range<a,z, A,Z> > > RuleIdentifier;

typedef lexeme<char_range<a,z, A,Z>, many< char_range<a,z, A,Z> > > FileIdentifier;

struct RuleName : simple_node<RuleName, RuleIdentifier> {};

struct ScopedRule : simple_node<ScopedRule,
    sequence< FileIdentifier, char_<':'>, RuleIdentifier > > {};

struct Expression;

typedef choice<
    String, CharacterRange, Escape, AnyCharacter, ScopedRule,
    sequence< RuleName, not_< char_<'<'> > >,
    sequence< char_<'('>, node<Expression>, char_<')'> >
> Primary;

typedef choice<
    char_<'^', '+'>,
    char_<'^', '*'>,
    char_from<'+', '?', '*'>,
    char_<'|', '+'>,
    char_<'|', '?'> > Suffixes;

struct Suffix
  : simple_node<Suffix, sequence<Primary, tree_optional<Suffixes>>> {};

typedef choice<char_<'&', '!'>, char_from<'&', '!'> > Prefixes;

struct Prefix
  : simple_node<Prefix, sequence<tree_optional<Prefixes>, Suffix>> {};

struct Join : simple_node<Join, sequence<
    Prefix,
    choice<
        char_<'^', '%'>,
        char_<'%', '+'>,
        char_<'%'>,
        char_<'|', '%'> >,
    Prefix> > {};

struct Joined : simple_node<Joined,
    tree_joined<char_<'^'>, choice<Join, Prefix> > > {};

struct Sequence : simple_node<Sequence, tree_many<Joined> > {};

struct OrderedChoice : simple_node<OrderedChoice,
    tree_joined<char_<'/'>, Sequence> > {};

struct Expression : simple_node<Expression, OrderedChoice> {};

struct Rule : simple_node<Rule,
    sequence<RuleName, char_<'<', '-'>, Expression >> {};

struct NodeRule : simple_node<NodeRule,
    sequence<RuleName, char_<'<', '='>, Expression> > {};

typedef sequence< many< choice<Rule, NodeRule> > > Grammar;

} } } }
#endif
