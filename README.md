# nyah

## nyah uses

 * [llvm](http://llvm.org) - code generation, optimisation + linking.
 * [bustin](https://github.com/nuisanceofcats/bustin) - d llvm wrapper.
 * [teg](https://github.com/nuisanceofcats/teg) - peg based parser metaprogramming library.
 * [beard](https://github.com/nuisanceofcats/beard) - d utility library.

## fetching
    totoro@localhost ~% git clone git://github.com/nuisanceofcats/nyah.git
    totoro@localhost ~% cd nyah
    totoro@localhost nyah% git submodule update --init --recursive

## building
    totoro@localhost nyah% make

This project requires a recent versin of dmd 2.
dmd 2.058 is currently used for development and 2.056 has worked in the past
and may still work.

dmd 2.057 does not work due to a critical compiler bug.

## testing
    make test

## more information
    http://chilon.net/nyah

## status
    Parsing and AST reading finished. D LLVM wrapper ready for use. Code generation in process.

## TODO
 * module parse/ast
 * code generation + improve llvm wrapper
 * TBPEG syntax
 * metaprogramming
 * rewrite mousedeer in nyah
