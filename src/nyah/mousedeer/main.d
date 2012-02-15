module mousedeer.main;

import mousedeer.parser.nyah;

import teg.stream : FileStream;
import teg.stores : stores;

import beard.io;
import beard.metaio : printType;

import std.stdio;

int main(string[] args) {
    auto s = new FileStream!Whitespace();
    Grammar        parser;
    stores!Grammar ast;

    bool verbose = false;
    bool dumpAst = false;

    auto optParser = new beard.cmdline.Parser;
    optParser.banner("usage: mousedeer [options] {source files}")
             ("d,dump", &dumpAst, "dump ast after parsing")
             ("v", &verbose, "increase verbosity")
        ;

    optParser.parse(&args);

    foreach(arg ; args[1..$]) {
        s.open(arg);
        s.skip_whitespace();

        if (! parser.parse(s, ast)) {
            print("failure parsing: " ~ arg);
            return 1;
        }
    }

    if (dumpAst) {
        printType!(stores!Grammar)();
        print(" => ");
        println(ast);
    }

    // parse arguments
    return 0;
}
