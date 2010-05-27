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

void cpp::operator()(char const * const filename) {
    using grammar::nyah_stream;
    using nyah::Grammar;

    opts_.verbose("parsing file ", filename);
    nyah_stream stream;
    if (! stream.load(filename))
        throw cannot_open_file(filename);

    stream.skip_whitespace();

    chilon::parser::store<Grammar> storer;

    if (storer(stream)) {
        stream.skip_whitespace();
        if (! stream.empty())
            throw parsing_error(filename);
        else
            opts_.verbose(filename, ": parsed grammar");
    }
    else throw parsing_error("nothing parsed", filename);

    if (opts_.print_ast_) {
        chilon::print("file ", filename);
        chilon::print("grammar ",
            std::get<0>(storer.value_.value_), ": ",
            std::get<1>(storer.value_.value_));
    }

    //
    int length = std::strlen(filename);
    if (length < 1) {
        throw std::runtime_error("filename is empty");
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
                filename, filename + length, outputPath.get() + outDir.size());
            outputPath.get()[length + outDir.size()] = '\0';
        }
        else {
            outputPath.reset(new char[length + outDir.size() + 2]);
            std::copy(
                outDir.begin(), outDir.begin() + outDir.size(), outputPath.get());
            outputPath.get()[outDir.size()] = '/';
            std::copy(
                filename, filename + length, outputPath.get() + outDir.size() + 1);
            outputPath.get()[length + 1 + outDir.size()] = '\0';
        }

        opts_.verbose("creating file ", outputPath.get());
    }
    else {
        opts_.verbose("creating file ", filename);
    }


    auto const& rules = std::get<1>(storer.value_.value_);
    for (auto it = rules.begin(); it != rules.end(); ++it) {
        chilon::variant_apply(*it, rule_apply(*this));
    }
}

} } }
