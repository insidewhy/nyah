module mousedeer.test.common;

import teg.stores;
import beard.io;
import std.stdio;

auto nFailures = 0u;

void parseTest(P, S)(string name, S s) {
    s.reset();
    s.skip_whitespace();
    auto parser = new P();
    stores!P value;
    write(name, ": ", typeid(stores!P), " => ");
    if (parser.parse(s, value))
        println(value);
    else {
        println("failed to store");
        ++nFailures;
    }
}


