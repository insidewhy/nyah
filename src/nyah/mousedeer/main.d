module mousedeer.main;

import mousedeer.code_generator : CodeGenerator;
import mousedeer.project : Project;
import mousedeer.source_file : UnexpectedContent, ParsingFailure;

import beard.io : println;
import beard.cmdline : CmdLineParser = Parser, UnknownCommandLineArgument;

import std.stdio;
import std.file : attrIsFile, getAttributes;

class SourceFileNotFound : Exception {
  this(string err) { super(err); }
}

// configuration:
private int _main(string[] args) {
  bool verbose = false;
  string dump;

  auto project = new Project;

  auto optParser = new CmdLineParser;
  optParser.banner("usage: mousedeer [options] {source files}");

  project.options.addOpts(optParser);
  optParser
    ("d,dump", &dump,
     "dump information (a = ast, s = symbol table, c = config)")
    ("v,verbose", &verbose, "increase verbosity")
    ;

  optParser.parse(&args);

  if (optParser.shownHelp) return 0;

  project.options.setDefaults;

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
        println("verbose:", verbose);
        println("dump:", dump);
        project.options.dump;
        println("positional parameters:", args);
        break;
      default:
        println("unknown dump request `" ~ c ~ "'");
        return 1;
    }
  }

  foreach(arg ; args[1..$]) {
    if (! attrIsFile(getAttributes(arg)))
      throw new SourceFileNotFound(arg);

    project.importFile(arg);
  }

  auto gen = new CodeGenerator(project);
  gen.createBytecodeFiles;
  gen.linkBytecodeFiles;

  if (dumpAst) project.dumpAsts;
  if (dumpSymbolTable) project.symbols.dump(verbose);

  return 0;
}

int main(string[] args) {
  try {
    return _main(args);
  }
  catch (ParsingFailure e) {
    println(e.msg);
  }
  catch (UnexpectedContent e) {
    println(e.msg);
  }
  catch (UnknownCommandLineArgument e) {
    println("unknown command line argument:", e.msg);
  }
  catch (SourceFileNotFound e) {
    println("source file not found:", e.msg);
  }
  return 1;
}
// vim:ts=2 sw=2:
