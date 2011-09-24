module teg.range;

import teg.stream;

class range {
    void parsing(basic_stream src) {
        sourceStream_ = src;
        begin_ = src.idx();
    }
    void parsed() { end_ = sourceStream_.idx(); }

    string toString() {
        if (sourceStream_)
            return '"' ~ sourceStream_.sub(begin_, end_) ~ '"';
        else
            return "<unset>";
    }

    this() {}
    this(basic_stream src) { parsing(src); }

    basic_stream  sourceStream_;
    size_t        begin_;
    size_t        end_;
}
