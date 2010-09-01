#include <nyah/mousedeer/cpp/builder.hpp>

#include <cstring>
#include <stdexcept>

namespace nyah { namespace mousedeer { namespace cpp {

namespace nyah    = grammar::nyah;
namespace grammar = grammar::grammar;

namespace {
    struct applier {
      protected:
        builder& builder_;
      public:
        applier(decltype(builder_)& builder) : builder_(builder) {}
    };

    struct rule_apply : applier {
        void operator()(grammar::Rule const& rule) const {
            auto& rule_name = std::get<0>(rule.value_).value_;
        }

        void operator()(grammar::NodeRule const& rule) const {
            auto& rule_name = std::get<0>(rule.value_).value_;
        }

        rule_apply(builder& builder) : applier(builder) {}
    };
}

void builder::operator()(std::string const& file_path) {
    auto& file = proj_.add_file(file_path);
    if (file.success()) return;

    proj_.opts().verbose("parsing file ", file_path);

    if (file.parse(file_path.c_str())) {
        if (! file.success())
            throw parsing_error(file_path);
        else
            proj_.opts().verbose(file_path, ": parsed grammar");
    }
    else throw parsing_error("nothing parsed", file_path);

    if (proj_.opts().print_ast_) {
        chilon::println("file ", file_path);

        auto& ast = file.ast();
        for (auto it = ast.begin(); it != ast.end(); ++it) {
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

    // TODO: process dependencies

    // TODO: output grammar file to opts_.output_dir_
}

} } }
