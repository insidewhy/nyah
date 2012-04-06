module mousedeer.code_generator;

import bustin.core;
import mousedeer.parser.nyah;
import mousedeer.source_files : SourceFiles;

// generates several bytecode files from supplied source files.  Each source
// file becomes a bytecode file. Cyclic dependencies between modules cause them
// to become linked into one bytecode file.
class CodeGenerator {
    void apply(Ast ast) {
        // todo:
    }

    void createBytecodeFiles(SourceFiles files) {
        // todo:
    }

    void linkBytecodeFiles() {
        // todo: ...
    }
}
