# nyah

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

## Testing
    make test

## More Information
    http://chilon.net/nyah

## TODO
 * modle parse/ast
 * code generation
 * TBPEG syntax
