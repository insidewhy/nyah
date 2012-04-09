module mousedeer.main;

import mousedeer.source_files : SourceFiles;
import mousedeer.code_generator : CodeGenerator;
import mousedeer.global_symbol_table : GlobalSymbolTable;
import mousedeer.parser.nyah;

import beard.io;
import beard.metaio : printType;

import std.stdio;

// configuration:
private bool verbose = false;
private string dump;

void dumpConfig() {
    println("verbose:", verbose);
    println("dump:", dump);
}

int main(string[] args) {
    auto sources = new SourceFiles;

    auto optParser = new beard.cmdline.Parser;
    optParser.banner("usage: mousedeer [options] {source files}")
             ("d,dump", &dump, "dump information (a = ast, s = symbol table)")
             ("v", &verbose, "increase verbosity")
        ;

    optParser.parse(&args);

    if (optParser.shownHelp) return 0;

    auto dumpAst = false;
    auto dumpSymbolTable = false;
    foreach (char c; dump) {
      switch (c) {
          case 'a':
              dumpAst = true;
              break;
          case 's':
              dumpSymbolTable = true;
              break;
          case 'c':
              dumpConfig();
              break;
          default:
              println("unknown dump request `" ~ c ~ "'");
              return 1;
      }
    }

    auto symbols = new GlobalSymbolTable;
    Grammar parser; auto gen = new CodeGenerator(symbols);
    foreach(arg ; args[1..$]) {
        auto source = sources.loadFile(arg);
        if (! source.parse(parser)) {
            println("failure parsing: " ~ arg);
            return 1;
        }

        if (dumpAst)
            source.dumpAst;

        symbols.import_(source.module_, source.ast);
    }

    if (dumpSymbolTable) symbols.dump;

    gen.createBytecodeFiles(sources);
    gen.linkBytecodeFiles;

    return 0;
}
