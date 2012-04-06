module mousedeer.main;

import mousedeer.source_files : SourceFiles;
import mousedeer.code_generator : CodeGenerator;
import mousedeer.parser.nyah;

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

    Grammar parser;
    auto gen = new CodeGenerator;
    foreach(arg ; args[1..$]) {
        auto source = sources.loadFile(arg);
        if (! source.parse(parser)) {
            print("failure parsing: " ~ arg);
            return 1;
        }

        if (dumpAst)
            source.dumpAst();
    }

    gen.createBytecodeFiles(sources);
    gen.linkBytecodeFiles();

    return 0;
}
