module mousedeer.options;

import beard.cmdline : CmdLineParser = Parser;

class Options {
  string[] includes;
  string outputPath;

  void setDefaults() {
    // TODO: base name on top-most module instead?
    if (! outputPath.length) outputPath = "a.out";
  }

  void addOpts(CmdLineParser optParser) {
    optParser
      ("I,include", &includes, "add include path, can be used multiple times")
      ("o,output", &outputPath, "output file")
      ;
  }
}
// vim:ts=2 sw=2:
