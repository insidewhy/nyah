#include <nyah/mousebear/grammar/nyah.hpp>
#include <nyah/mousebear/builder/cpp.hpp>

#include <cstring>
#include <stdexcept>

namespace nyah { namespace mousebear { namespace builder {

namespace grammar = grammar::grammar;
namespace nyah    = mousebear::grammar::nyah;

namespace {
    struct applier {
      protected:
        cpp& builder_;
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

        rule_apply(cpp& builder) : applier(builder) {}
    };
}

void cpp::operator()(std::string const& file_path) {
    using grammar::nyah_stream;
    using nyah::Grammar;

    proj_.opts().verbose("parsing file ", file_path);
    nyah_stream stream;
    if (! stream.load(file_path.c_str()))
        throw cannot_open_file(file_path);

    stream.skip_whitespace();

    Grammar ast;

    if (chilon::parser::parse<Grammar>::skip(stream, ast)) {
        stream.skip_whitespace();
        if (! stream.empty())
            throw parsing_error(file_path);
        else
            proj_.opts().verbose(file_path, ": parsed grammar");
    }
    else throw parsing_error("nothing parsed", file_path);

    if (proj_.opts().print_ast_) {
        chilon::println("file ", file_path);

        for (auto it = ast.value_.begin(); it != ast.value_.end(); ++it) {
            auto extends = std::get<1>(*it);
            if (extends.empty()) {
                chilon::println(
                    "grammar ", std::get<0>(*it), " = ", std::get<2>(*it));
            }
            else {
                chilon::println(
                    "grammar ", std::get<0>(*it), " extends ",
                    extends, " = ", std::get<2>(*it));
            }
        }
    }

#if 0
    int length = std::strlen(file_path);
    if (length < 1) {
        throw std::runtime_error("file path is empty");
    }

    std::unique_ptr<char> outputPath;

    if (! opts_.output_dir_.empty()) {
        auto const& outDir = opts_.output_dir_;
        if (outDir.size() < 1) {
            throw std::runtime_error("output directory is empty");
        }

        if ('/' == outDir[outDir.size() - 1]) {
            outputPath.reset(new char[length + outDir.size() + 1]);
            std::copy(
                outDir.begin(), outDir.begin() + outDir.size(), outputPath.get());
            std::copy(
                file_path, file_path + length, outputPath.get() + outDir.size());
            outputPath.get()[length + outDir.size()] = '\0';
        }
        else {
            outputPath.reset(new char[length + outDir.size() + 2]);
            std::copy(
                outDir.begin(), outDir.begin() + outDir.size(), outputPath.get());
            outputPath.get()[outDir.size()] = '/';
            std::copy(
                file_path, file_path + length, outputPath.get() + outDir.size() + 1);
            outputPath.get()[length + 1 + outDir.size()] = '\0';
        }

        opts_.verbose("creating file ", outputPath.get());
    }
    else {
        opts_.verbose("creating file ", file_path);
    }


    auto const& rules = std::get<1>(ast.value_);
    for (auto it = rules.begin(); it != rules.end(); ++it) {
        chilon::variant_apply(*it, rule_apply(*this));
    }
#endif
}

void cpp::operator()() {
    for (auto it = proj_.files().begin(); it != proj_.files().end(); ++it) {
        (*this)(*it);
    }
}

} } }
