module teg.range;

import teg.stream;

struct Range {
    void parsing(BasicStream src) {
        sourceStream_ = src;
        begin_ = src.idx();
    }
    void parsed() { end_ = sourceStream_.idx(); }

    // if i call this reset() code won't compile... not sure
    // if i should still be using d
    void clear() { sourceStream_ = null; }

    size_t length() @property const {
        return sourceStream_ ? end_ - begin_ : 0u;
    }

    string toString() {
        if (sourceStream_)
            return '"' ~ sourceStream_.sub(begin_, end_) ~ '"';
        else
            return "<unset>";
    }

    this(BasicStream src) { parsing(src); }

    BasicStream  sourceStream_;
    size_t       begin_;
    size_t       end_;
}
