module mousedeer.source_files;
import mousedeer.source_file : SourceFile;

class SourceFiles {
  SourceFile loadFile(string path) {
    return sources_[path] = new SourceFile(path);
  }

 private:
  SourceFile[string] sources_;
}
// vim:ts=2 sw=2:
