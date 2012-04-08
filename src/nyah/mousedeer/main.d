module mousedeer.main;

import mousedeer.source_files : SourceFiles;
import mousedeer.code_generator : CodeGenerator;
import mousedeer.global_symbol_table : GlobalSymbolTable;
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

    auto symbols = new GlobalSymbolTable;
    Grammar parser;
    auto gen = new CodeGenerator(symbols);
    foreach(arg ; args[1..$]) {
        auto source = sources.loadFile(arg);
        if (! source.parse(parser)) {
            println("failure parsing: " ~ arg);
            return 1;
        }

        if (dumpAst)
            source.dumpAst();

        symbols(source.module_, source.ast);
    }

    gen.createBytecodeFiles(sources);
    gen.linkBytecodeFiles();

    return 0;
}
