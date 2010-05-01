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

#include <nyah/node.hpp>

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

NYAH_NODE(RuleName,
    lexeme<char_range<A, Z>, many< char_range<a,z, A,Z> > >)

struct Expression;

typedef choice<
    String, CharacterRange, Escape, AnyCharacter,
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

typedef many_plus<Joined>                  Sequence;

typedef joined_plus<char_<'/'>, Sequence>  OrderedChoice;

NYAH_NODE_INLINE(Expression, OrderedChoice)

NYAH_NODE(Rule,
    sequence<node<RuleName>, char_<'<', '-'>, node<Expression>>)

NYAH_NODE(NodeRule,
    sequence<node<RuleName>, char_<'<', '='>, node<Expression>>)

typedef many< choice< node<Rule>, node<NodeRule> > > Grammar;

} }
#endif
