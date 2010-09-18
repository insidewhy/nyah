#ifndef NYAH_MOUSEDEER_GRAMMAR_NYAH_HPP
#define NYAH_MOUSEDEER_GRAMMAR_NYAH_HPP

#include <nyah/mousedeer/grammar/grammar.hpp>

namespace nyah { namespace mousedeer { namespace grammar { namespace nyah {

using namespace chilon::parser;
using namespace chilon::parser::ascii;

using grammar::Spacing;

typedef grammar::Identifier MetaIdentifier;

typedef joined_plus<char_<'.'>, MetaIdentifier> ScopedIdentifier;

typedef sequence<char_<'@',m,o,d,u,l,e>, ScopedIdentifier> ModuleDefinition;

struct MetaGrammar : simple_node<MetaGrammar,
    char_<'@',g,r,a,m,m,a,r>, key<MetaIdentifier>,
    optional<char_<':'>, ScopedIdentifier>,
    grammar::Grammar> {};

struct Module : simple_node<Module,
    key_plus< optional<ModuleDefinition> >,
    many_plus<vector_hash<MetaGrammar>> > {};

typedef sequence< char_<'@',i,n,c,l,u,d,e>, ScopedIdentifier > Include;

typedef sequence<
    many<Include>, many_plus<vector_hash<Module> > > Grammar;

} } } }
#endif
