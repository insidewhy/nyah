module teg.stream;

import std.stream;

class basic_stream {
    bool empty() const { return idx_ >= data_.length; }
    void reset() { idx_ = 0u; }
    void set_data(string data) { data_ = data; }
    char front() const { return data_[idx_]; }
    size_t length() const { return data_.length - idx_; }
    char opIndex(size_t idx) const { return data_[idx_ + idx]; }

    void advance() {
        if (++idx_ >= data_.length) idx_ = data_.length;
    }

    void advance(size_t offset) {
        idx_ += offset;
        if (idx_ >= data_.length) idx_ = data_.length;
    }

    size_t backup() const { return idx_; }
    void restore(size_t idx) { idx_ = idx; }

    this(string data) { set_data(data); }
    this() {}

  protected:
    string data_;
    size_t idx_ = 0;
}

class basic_file_stream : basic_stream {
    void open(string filepath) {
        filepath_ = filepath;
    }

    this(string filepath) { open(filepath); }
    this() {}

  protected:
    string filepath_;
}

private class _stream(W, P) : P {
    void skip_whitespace() {
        W.skip(this);
    }

    this(string str) { super(str); }
    this() {}
}

class stream(W) : _stream!(W, basic_stream) {
    this(string str) { super(str); }
    this() {}
}

class file_stream(W) : _stream!(W, basic_file_stream) {
    this(string str) { super(str); }
    this() {}
}
