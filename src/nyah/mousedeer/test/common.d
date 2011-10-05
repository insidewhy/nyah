module mousedeer.test.common;

import teg.stores;
import beard.io;
import std.stdio;

auto nFailures = 0u;

void parseTest(P, S)(string name, S s) {
    s.reset();
    s.skip_whitespace();
    auto parser = new P();
    write(name, ": ", typeid(stores!P), " => ");
    if (parser.parse(s))
        println(parser.value_);
    else {
        println("failed to store");
        ++nFailures;
    }
}


