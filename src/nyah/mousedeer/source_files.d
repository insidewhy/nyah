module mousedeer.source_files;

import teg.stream : FileStream;
import mousedeer.parser.nyah;

class SourceFiles {
    alias FileStream!Whitespace SourceFileStream;

    SourceFileStream loadFile(string path) {
        return streams_[path] = new SourceFileStream(path);
    }

  private:
    SourceFileStream[string] streams_;
}
