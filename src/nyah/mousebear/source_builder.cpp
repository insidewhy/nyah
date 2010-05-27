#include <mousebear/grammar.hpp>
#include <mousebear/source_builder.hpp>

#include <cstring>
#include <stdexcept>

namespace nyah { namespace mousebear {

namespace {
    struct applier {
      protected:
        source_builder& builder_;
      public:
        applier(decltype(builder_)& builder) : builder_(builder) {}
    };

    struct rule_apply : applier {
        void operator()(Rule const& rule) const {
            auto& rule_name = std::get<0>(rule.value_).value_;
        }

        void operator()(NodeRule const& rule) const {
            auto& rule_name = std::get<0>(rule.value_).value_;
        }

        rule_apply(source_builder& builder) : applier(builder) {}
    };
}

void source_builder::operator()(char const * const filename,
                                Grammar const&     grammar)
{
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


    auto const& rules = std::get<1>(grammar.value_);
    for (auto it = rules.begin(); it != rules.end(); ++it) {
        chilon::variant_apply(*it, rule_apply(*this));
    }
}

} }
