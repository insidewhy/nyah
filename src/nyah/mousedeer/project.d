module mousedeer.project;

import mousedeer.code_generator : CodeGenerator;
import mousedeer.global_symbol_table : GlobalSymbolTable;
import mousedeer.source_file : SourceFile;
import mousedeer.options : Options;
import mousedeer.parser.nyah;

// Represents either an executable or a library. Holds the source file
// objects, symbol tables and compilation options relating to it.
class Project {
  private SourceFile[string] sources_;
  private Grammar            parser_;

  Options                    options;
  GlobalSymbolTable          symbols;

  this() {
    options = new Options;
    symbols = new GlobalSymbolTable;
  }

  // load file object but perform no further processing.
  SourceFile loadFile(string path) {
    return sources_[path] = new SourceFile(path, options.root);
  }

  // load file contents, parse them and import AST into symbol table.
  void importFile(string path) {
    auto source = loadFile(path);
    source.parse(parser_);
    symbols.import_(source);
  }

  void dumpAsts() {
    foreach (source ; sources_) source.dumpAst;
  }
}
// vim:ts=2 sw=2:
