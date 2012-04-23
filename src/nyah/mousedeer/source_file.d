module mousedeer.source_file;

import mousedeer.parser.nyah;

import teg.stream : FileStream;

import beard.metaio : printType;
import beard.io : print, println;

class SourceFile {
  alias FileStream!Whitespace Stream;

  this(const string path, const string root) {
    stream_ = new Stream(path);
    if ("." == root) {
      if (path.length == 1)
        pathFromRoot_ = path;
      else if (path[0..2] == "./") {
        for (int i = 2; i + 1 < path.length; ++i) {
          if (path[i..(i + 2)] != "./") {
            pathFromRoot_ = path[i..$];
            break;
          }
        }
        assert(pathFromRoot_.length > 0, "something messed up");
      }
      else if (path[0] != '/')
        pathFromRoot_ = path;
      else {
        // TODO:
      }
    }

    // TODO: calculate pathFromRoot_ using path and root
  }

  void dumpAst() {
    print("ast ");
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

  string path() { return stream_.path; }
  string pathFromRoot() { return pathFromRoot_; }

  Ast          ast;
 private:
  Stream       stream_;
  string       pathFromRoot_; // offset of path from project root
}
// vim:ts=2 sw=2:
