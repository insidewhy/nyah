#ifndef NYAH_MOUSEBEAR_GRAMMAR_NYAH_HPP
#define NYAH_MOUSEBEAR_GRAMMAR_NYAH_HPP

#include <nyah/mousebear/grammar/grammar.hpp>

namespace nyah { namespace mousebear { namespace grammar { namespace nyah {

using namespace chilon::parser;
using namespace chilon::parser::ascii;

typedef lexeme<
    choice<char_<'_'>, char_range<a,z, A,Z> >,
    many< choice<
        char_range<a,z, A,Z, '0','9'>,
        char_from<'_','.'>
    > > > MetaIdentifier;

struct Grammar : simple_node<Grammar, sequence<
    many< char_<'@',g,r,a,m,m,a,r>, MetaIdentifier, grammar::Grammar> > > {};

} } } }
#endif
