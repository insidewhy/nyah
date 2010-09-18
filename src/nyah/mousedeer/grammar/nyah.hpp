#ifndef NYAH_MOUSEDEER_GRAMMAR_NYAH_HPP
#define NYAH_MOUSEDEER_GRAMMAR_NYAH_HPP

#include <nyah/mousedeer/grammar/grammar.hpp>

namespace nyah { namespace mousedeer { namespace grammar { namespace nyah {

using namespace chilon::parser;
using namespace chilon::parser::ascii;

using grammar::Spacing;

typedef lexeme<
    choice<char_<'_'>, char_range<a,z, A,Z> >,
    many< choice<
        char_range<a,z, A,Z, '0','9'>,
        char_<'_'>
    > > > MetaIdentifier;

typedef joined<char_<'.'>, MetaIdentifier> ScopedIdentifier;

typedef sequence<char_<'@',m,o,d,u,l,e>, ScopedIdentifier> ModuleDefinition;

struct MetaGrammar : simple_node<MetaGrammar,
    sequence<
        char_<'@',g,r,a,m,m,a,r>, key<MetaIdentifier>,
        optional<
            char_<'@',e,x,t,e,n,d,s>, ScopedIdentifier>,
        grammar::Grammar> > {};

struct Module : simple_node<Module,
    sequence<
        key_plus< optional<ModuleDefinition> >,
        many_plus<vector_hash<MetaGrammar>> > > {};

typedef many_plus<vector_hash<Module>> Grammar;

} } } }
#endif
