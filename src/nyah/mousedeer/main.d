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
private string[] includes;
private string outputPath;

void dumpConfig() {
    println("verbose:", verbose);
    println("dump:", dump);
    println("includes:", includes);
    println("output path:", outputPath);
}

int main(string[] args) {
    auto sources = new SourceFiles;

    auto optParser = new beard.cmdline.Parser;
    optParser.banner("usage: mousedeer [options] {source files}")
        ("I,include", &includes,
         "add include path, can be used multiple times")
        ("d,dump", &dump,
         "dump information (a = ast, s = symbol table, c = config)")
        ("o,output", &outputPath, "output file")
        ("v,verbose", &verbose, "increase verbosity")
        ;

    optParser.parse(&args);

    if (optParser.shownHelp) return 0;

    // TODO: base name on top-most module instead?
    if (! outputPath.length) outputPath = "a.out";

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
              println("positional parameters:", args);
              break;
          default:
              println("unknown dump request `" ~ c ~ "'");
              return 1;
      }
    }

    auto symbols = new GlobalSymbolTable;
    Grammar parser;
    foreach(arg ; args[1..$]) {
        auto source = sources.loadFile(arg);
        if (! source.parse(parser)) {
            println("failure parsing:", arg);
            return 1;
        }

        if (dumpAst) source.dumpAst;
        symbols.import_(source.ast);
    }

    if (dumpSymbolTable) symbols.dump;

    auto gen = new CodeGenerator(symbols);
    gen.createBytecodeFiles(sources);
    gen.linkBytecodeFiles(outputPath);

    return 0;
}
