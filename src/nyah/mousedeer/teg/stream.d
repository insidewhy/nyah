module teg.stream;

import std.stream;

class BasicStream {
    bool empty() const { return idx_ >= data_.length; }
    void reset() { idx_ = 0u; }
    char front() const { return data_[idx_]; }
    size_t length() @property const { return data_.length - idx_; }
    char opIndex(size_t idx) const { return data_[idx_ + idx]; }
    // for this offsets are absolute, not relative to idx_
    string sub(size_t beg, size_t end) { return data_[beg..end]; }

    void advance() {
        if (++idx_ > data_.length) idx_ = data_.length;
    }

    void advance(size_t offset) {
        idx_ += offset;
        if (idx_ > data_.length) idx_ = data_.length;
    }

    auto set(string data) {
        reset();
        data_ = data;
        return this;
    }

    size_t idx() const { return idx_; }
    size_t save() const { return idx_; }
    void restore(size_t idx) { idx_ = idx; }

    this(string data) { this.set(data); }
    this() {}

  protected:
    string data_;
    size_t idx_;
}

class BasicFileStream : BasicStream {
    void open(string filepath) {
        filepath_ = filepath;
    }

    this(string filepath) { open(filepath); }
    this() {}

  protected:
    string filepath_;
}

private class _Stream(W, P) : P {
    void skip_whitespace() {
        if (! empty()) W.skip(this);
    }

    this(string str) { super(str); }
    this() {}
}

class Stream(W) : _Stream!(W, BasicStream) {
    this(string str) { super(str); }
    this() {}
}

class FileStream(W) : _Stream!(W, BasicFileStream) {
    this(string str) { super(str); }
    this() {}
}
