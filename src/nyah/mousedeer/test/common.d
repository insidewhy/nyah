module mousedeer.test.common;

import teg.stores;
import beard.io;
import beard.metaio;
import std.stdio;

public import teg.all;
public import beard.io;
public import beard.meta;

auto nFailures = 0u;

alias ManyPlus!(CharFrom!"\n\t ") Whitespace;
alias Lexeme!(CharRange!"azAZ", Many!(CharRange!"azAZ09")) SimpleId;
alias Sequence!(Char!"var", SimpleId) SimpleVariable;

void parseTest(P, S)(string name, S s) {
    s.reset();
    s.skip_whitespace();
    auto parser = new P();
    stores!P value;
    write(name, ": ");
    printType!(stores!P)();

    write(" => ");
    if (parser.parse(s, value))
        println(value);
    else {
        println("failed to store");
        ++nFailures;
    }
}


