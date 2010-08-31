#ifndef NYAH_FILE_HPP
#define NYAH_FILE_HPP

#include <nyah/mousebear/grammar/nyah.hpp>
#include <nyah/mousebear/file_error.hpp>

#include <chilon/getset.hpp>

namespace nyah { namespace mousebear {

class file {
    typedef grammar::nyah::Grammar    grammar_t;
    typedef chilon::parser::source_code_stream<
        chilon::parser::file_stream, grammar::nyah::Spacing>   stream_t;

    typename chilon::parser::stored<grammar_t>::type  ast_;
    bool       processed_;
    stream_t   stream_;
  public:
    CHILON_GET(processed)
    CHILON_GET_REF_CONST(ast)

    file& operator=(bool const processed) {
        processed_ = processed;
        return *this;
    }
    file() : processed_(false) {};

    bool at_end() const { return ! stream_.empty(); }

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

