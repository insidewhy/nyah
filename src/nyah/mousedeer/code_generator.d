module mousedeer.code_generator;

import bustin.core;
import mousedeer.parser.nyah : Ast;
import mousedeer.source_files : SourceFiles;
import mousedeer.global_symbol_table : GlobalSymbolTable;

// generates several bytecode files from supplied source files.  Each source
// file becomes a bytecode file. Cyclic dependencies between modules cause them
// to become linked into one bytecode file.
class CodeGenerator {
  GlobalSymbolTable symbols_;

  this(GlobalSymbolTable symbols) { symbols_ = symbols; }

  void opCall(Ast ast) {
    // todo:
  }

  void createBytecodeFiles(SourceFiles files) {
    // todo: compile asts to bytecode files one by one
  }

  void linkBytecodeFiles(string outputPath) {
    // todo: ...
  }
}

// vim:ts=2 sw=2:
