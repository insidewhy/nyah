#include <mousebear/grammar.hpp>

#include <chilon/conf/cmd/command_line.hpp>
#include <chilon/print.hpp>

#include <iostream>

// #define MOUSEBEAR_VERSION "1000 (just don't get in a car, and stay away from my family)"
// #define MOUSEBEAR_VERSION "999 (she's also known as darwinius)"
// #define MOUSEBEAR_VERSION "998 (grind machine)"
// #define MOUSEBEAR_VERSION "997 (420 mishap)"
// #define MOUSEBEAR_VERSION "996 (super mousebear 4)"
#define MOUSEBEAR_VERSION "995 (ibuki mousebear)"

namespace nyah { namespace mousebear {

namespace cmd_line = chilon::conf::cmd;

inline int main(int argc, char *argv[]) {
    int nPositionals;
    bool verbose = false;
    bool doPrint = false;
    {
        using chilon::conf::value;
        using cmd_line::options_description;

        options_description options;
        options.add_options()
            .help("mousebear "   MOUSEBEAR_VERSION "\nusage: mousebear [arguments] <grammar files to process>")
            ("p,print",          doPrint, "print AST of grammar")
            ("v,verbose",        verbose, "increase verbosity")
            ;

        try {
            nPositionals = cmd_line::parser(argc, argv, options)(std::cerr).n_positionals();
        }
        catch (cmd_line::invalid_arguments& ) {
            return 1;
        }
        catch (cmd_line::bad_value& e) {
            std::cerr << "bad value reading command line options\n";
            std::cout << options << std::endl;
            return 1;
        }
        catch (cmd_line::expected_argument& e) {
            std::cerr << "expected command line argument\n";
            std::cout << options << std::endl;
            return 1;
        }

        if (nPositionals < 1) {
            std::cerr << "please supply at least one grammar to parse\n";
            std::cout << options << std::endl;
            return 1;
        }
    }

    for (int i = 1; i <= nPositionals; ++i) {
        if (verbose) std::cout << "parsing grammar " << argv[i] << std::endl;
        nyah_stream stream;
        if (! stream.load(argv[i])) {
            std::cerr << "could not load file " << argv[i] << " exiting\n";
            return 1;
        }

        stream.skip_whitespace();

        store<Grammar> storer;

        if (storer(stream)) {
            stream.skip_whitespace();
            if (! stream.empty()) {
                std::cerr << argv[i] << ": partial match\n";
                continue;
            }
            else if (verbose)
                std::cerr << argv[i] << ": parsed grammar\n";
        }
        else {
            std::cerr << argv[i] << ": invalid grammar\n";
            continue;
        }

        if (doPrint) {
            chilon::print(argv[i], " grammar: ", storer.value_);
        }
        else {
            std::cerr << "only -p is supported at the moment\n";
        }
    }

    return 0;
}

} }

int main(int argc, char *argv[]) {
    return nyah::mousebear::main(argc, argv);
}
