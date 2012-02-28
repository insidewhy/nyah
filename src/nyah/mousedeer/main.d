module mousedeer.main;

import mousedeer.source_files : SourceFiles;
import mousedeer.parser.nyah;

import teg.stores : stores;

import beard.io;
import beard.metaio : printType;

import std.stdio;

int main(string[] args) {
    auto sources = new SourceFiles;

    bool verbose = false;
    bool dumpAst = false;

    auto optParser = new beard.cmdline.Parser;
    optParser.banner("usage: mousedeer [options] {source files}")
             ("d,dump", &dumpAst, "dump ast after parsing")
             ("v", &verbose, "increase verbosity")
        ;

    optParser.parse(&args);

    if (optParser.shownHelp) return 0;

    Grammar        parser;
    stores!Grammar ast;
    foreach(arg ; args[1..$]) {
        auto s = sources.loadFile(arg);
        s.skip_whitespace();

        if (! parser.parse(s, ast) || ! s.empty) {
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
