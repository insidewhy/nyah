module mousedeer.main;

import mousedeer.code_generator : CodeGenerator;
import mousedeer.options : Options;
import mousedeer.project : Project, ImportException;

import beard.io : println;
import beard.cmdline : CmdLineParser = Parser;

import std.stdio;

// configuration:
private bool verbose = false;
private string dump;

private void dumpConfig(Options options) {
  println("verbose:", verbose);
  println("dump:", dump);
  println("includes:", options.includes);
  println("output path:", options.outputPath);
}

private int _main(string[] args) {
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
        dumpConfig(project.options);
        println("positional parameters:", args);
        break;
      default:
        println("unknown dump request `" ~ c ~ "'");
        return 1;
    }
  }

  foreach(arg ; args[1..$])
    project.importFile(arg);

  auto gen = new CodeGenerator(project);
  gen.createBytecodeFiles;
  gen.linkBytecodeFiles;

  if (dumpAst) project.dumpAsts;
  if (dumpSymbolTable) project.symbols.dump;

  return 0;
}

int main(string[] args) {
  try {
    return _main(args);
  }
  catch (ImportException e) {
    println(e.msg);
  }
  return 1;
}
// vim:ts=2 sw=2:
