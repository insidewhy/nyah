module mousedeer.source_file;

import mousedeer.parser.nyah;
import teg.stream : FileStream;

import beard.metaio : printType;
import beard.io : print, println;

class SourceFile {
  alias FileStream!Whitespace Stream;

  this(string path) {
    stream_ = new Stream(path);
  }

  void dumpAst() {
    printType!Ast();
    print(" => ");
    println(ast);
  }

  bool parse(ref Grammar parser) {
    stream_.skip_whitespace();

    if (! parser.parse(stream_, ast) || ! stream_.empty)
      return false;

    return true;
  }

  Ast    ast;
 private:
  Stream stream_;
}
// vim:ts=2 sw=2:
