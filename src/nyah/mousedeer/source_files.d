module mousedeer.source_files;

import teg.stream : FileStream;
import mousedeer.parser.nyah;

class SourceFiles {
    alias FileStream!Whitespace     SourceFileStream;
    alias SourceFileStream[string]  StreamMap;

    SourceFileStream loadFile(string path) {
        return streams_[path] = new SourceFileStream(path);
    }

  private:
    StreamMap  streams_;
}
