#include <nyah/mousedeer/cpp/builder.hpp>

#include <cstring>
#include <stdexcept>

namespace nyah { namespace mousedeer { namespace cpp {

namespace nyah    = grammar::nyah;
namespace grammar = grammar::grammar;

void builder::operator()(std::string const& file_path) {
    auto& file = add_file(file_path);

    if (file.processed()) return;
    else if (file.parse_succeeded()) throw file_dependency_cycle();

    options_.verbose("parsing file ", file_path);

    if (file.parse(file_path.c_str(), ast_)) {
        if (! file.parse_succeeded())
            throw parsing_error(file_path);
        else
            options_.verbose(file_path, ": parsed grammar");
    }
    else throw parsing_error("nothing parsed", file_path);

    file.set_processed();
}

void builder::operator()(module_type const& module) {
    auto& moduleId = module.first;
    auto& grammar = module.second.value_;

    for (auto it = grammar.safe_ordered_begin(); ! it.at_end(); ++it) {
        auto extends = std::get<0>(it->second.value_);
        if (! extends.empty()) {
            std::string depFile =
                options_.find_grammar_file(extends.at<chilon::range>());

            if (depFile.empty()) {
                // TODO: replace for better error
                throw parsing_error(
                    "could not find depdendency",
                    extends.at<chilon::range>());
            }
            else (*this)(depFile);
        }

        // TODO: now process the grammar
    }
}

void builder::print_ast() const {
    chilon::println(ast_);
}

void builder::generate_code() {
    for (auto it = ast_.safe_ordered_begin(); ! it.at_end(); ++it) {
        (*this)(*it);
    }
}

} } }
