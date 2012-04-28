module mousedeer.options;

import beard.cmdline : CmdLineParser = Parser;
import beard.io : println;

import std.file : getcwd;

class Options {
  string[] includes;
  string outputPath; // path to output object files etc. too
  string root; // root of all source code, defaults to cwd
  string bytecodePath;

  void setDefaults() {
    // TODO: base name on top-most module instead?
    if (! outputPath.length) outputPath = "a.out";

    // remove slashes at end of root
    while (root.length && root[(root.length - 1)] == '/')
      root = root[0..($ - 1)];

    // convert explicit $PWD to '.'
    auto cwd = getcwd;
    if (root.length == cwd.length && root[0..$] == cwd) {
      root = ".";
    }
    else if (   root.length > cwd.length
             && root[0..(cwd.length + 1)] == (cwd ~ "/"))
    {
      root = root[(cwd.length + 1)..$];
      while (root.length && '/' == root[0]) root = root[1..$];
    }

    if (! root.length) root = ".";
    if (! bytecodePath.length) bytecodePath = root;
  }

  void dump() {
    println("includes:", includes);
    println("output path:", outputPath);
    println("root:", root);
    println("bytecode path:", bytecodePath);
  }

  void addOpts(CmdLineParser optParser) {
    optParser
      ("I,include", &includes, "add include path, can be used multiple times")
      ("o,output", &outputPath, "output library/executable path")
      ("b,bytecode", &bytecodePath, "root path at which to store byte code")
      ("r,root", &root, "root of source files (defaults to cwd)")
      ;
  }
}
// vim:ts=2 sw=2:
