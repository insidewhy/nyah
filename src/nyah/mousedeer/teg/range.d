module teg.range;

import teg.stream;

class range {
    this(stream sourceStream, size_t begin, size_t end) {
        sourceStream_ = sourceStream;
        begin_ = begin;
        end_ = end;
    }

    stream sourceStream_;
    size_t begin_;
    size_t end_;
}
