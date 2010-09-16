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

    if (file.parse(file_path.c_str())) {
        if (! file.parse_succeeded())
            throw parsing_error(file_path);
        else
            options_.verbose(file_path, ": parsed grammar");
    }
    else throw parsing_error("nothing parsed", file_path);

    auto& grammar = std::get<1>(file.ast());
    auto& module = std::get<0>(file.ast());

    for (auto it = grammar.begin(); it != grammar.end(); ++it) {
        auto extends = std::get<1>(it->value_);
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

    file.set_processed();

    if (options_.print_ast_) {
        chilon::println("file ", file_path);

        if (! module.empty()) chilon::println("module ", module);

        for (auto it = grammar.begin(); it != grammar.end(); ++it) {
            auto extends = std::get<1>(it->value_);
            if (extends.empty()) {
                chilon::println(
                    "grammar ", std::get<0>(it->value_), " = ", std::get<2>(it->value_));
            }
            else {
                chilon::println(
                    "grammar ", std::get<0>(it->value_), " extends ",
                    extends, " = ", std::get<2>(it->value_));
            }
        }
    }
}

} } }
