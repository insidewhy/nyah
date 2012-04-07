module mousedeer.code_generator;

import bustin.core;
import mousedeer.parser.nyah : Ast;
import mousedeer.source_files : SourceFiles;

// generates several bytecode files from supplied source files.  Each source
// file becomes a bytecode file. Cyclic dependencies between modules cause them
// to become linked into one bytecode file.
class CodeGenerator {
  void opCall(Ast ast) {
    // todo:
  }

  void createBytecodeFiles(SourceFiles files) {
    // todo: first create symbol table

    // todo: compile asts to bytecode files one by one
  }

  void linkBytecodeFiles() {
    // todo: ...
  }
}

// vim:ts=2 sw=2:
