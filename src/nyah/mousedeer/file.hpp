#ifndef NYAH_FILE_HPP
#define NYAH_FILE_HPP

#include <nyah/mousedeer/grammar/nyah.hpp>
#include <nyah/mousedeer/file_error.hpp>

#include <chilon/getset.hpp>

namespace nyah { namespace mousedeer {

class file {
    typedef grammar::nyah::Grammar    grammar_t;
    typedef chilon::parser::source_code_stream<
        chilon::parser::file_stream, grammar::nyah::Spacing>   stream_t;

    typename chilon::parser::stored<grammar_t>::type  ast_;
    stream_t   stream_;

    bool processed_;
  public:
    CHILON_GET_REF_CONST(ast)

    file() : processed_(false) {};

    bool parse_succeeded() const {
        return stream_.file_loaded() && stream_.empty();
    }

    void set_processed()   { processed_ = true; }
    bool processed() const { return processed_; }

    bool parse(char const * const file_path) {
        if (! stream_.load(file_path))
            throw cannot_open_file(file_path);

        stream_.skip_whitespace();

        if (chilon::parser::parse<grammar_t>::skip(stream_, ast_)) {
            stream_.skip_whitespace();
            return true;
        }
        else return false;
    }
};

} }

#endif

