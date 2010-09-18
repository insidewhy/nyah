#ifndef NYAH_MOUSEDEER_CPP_BUILDER_HPP
#define NYAH_MOUSEDEER_CPP_BUILDER_HPP

#include <nyah/mousedeer/options.hpp>
#include <nyah/mousedeer/file.hpp>

#include <chilon/getset.hpp>

#include <unordered_map>
#include <fstream>
#include <stdexcept>

namespace nyah { namespace mousedeer { namespace cpp {

// TODO: add nodes involved in cycle to exception.
class file_dependency_cycle {};

class builder {
    typedef grammar::nyah::Grammar                    grammar_t;
    typename chilon::parser::stored<grammar_t>::type  ast_;
    options&                                          options_;
    std::unordered_map<std::string, file>             files_;

    typedef decltype(files_) files_t;

    typedef typename chilon::parser::stored<
        grammar::nyah::Grammar>::type::value_type  module_type;

    typedef typename chilon::parser::stored<
        grammar::nyah::ScopedIdentifier>::type  grammar_identifier;

    // if file doesn't exist in project, add it and return reference to it
    // otherwise return a reference to the existing file.
    file& add_file(std::string const& file_path) {
        return files_.insert(
            files_t::value_type(file_path, file())).first->second;
    }


  public:
    // parse file, return true if parsed, false if already parsed,
    // throw error on parse failure
    bool parse_file(std::string const& file_path);

    void operator()(module_type const& module);
    void grammar_dep(module_type const& module, grammar_identifier const& id);

    void print_ast() const;
    void generate_code();

    builder(decltype(options_)& options) : options_(options) {}
};

} } }
#endif
