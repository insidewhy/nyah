module teg.stream;

import std.stream;

class stream {
    void set_data(string data) { data_ = data; }
    char current() const { return data_[idx_]; }

    void advance() {
        if (++idx_ >= data_.length) idx_ = data_.length;
    }

    void advance(size_t offset) {
        idx_ += offset;
        if (idx_ >= data_.length) idx_ = data_.length;
    }

    this(InputStream stream) {
        // todo: read stream contents
    }

    this(string data = "") { set_data(data); }

  protected:
    string data_;
    size_t idx_ = 0;
}

class file_stream : stream {
    void open(string filepath) {
        filepath_ = filepath;
    }

    this(string filepath) { open(filepath); }

  protected:
    string filepath_;
}
