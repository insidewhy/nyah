#include <nyah/mousedeer/cpp/builder.hpp>
#include <nyah/mousedeer/options.hpp>

#include <chilon/print.hpp>

#include <iostream>
#include <stdexcept>

// #define MOUSEBEAR_VERSION "1000 (just don't get in a car, and stay away from my family)"
// #define MOUSEBEAR_VERSION "999 (she's also known as darwinius)"
// #define MOUSEBEAR_VERSION "998 (grind machine)"
// #define MOUSEBEAR_VERSION "997 (420 mishap)"
// #define MOUSEBEAR_VERSION "996 (super mousebear 4)"
// #define MOUSEBEAR_VERSION "995 (ibuki mousebear)"
// #define MOUSEBEAR_VERSION "994 (maryam the butcher)"
// #define MOUSEBEAR_VERSION "993 (friendly beard)"
// #define MOUSEDEER_VERSION "992 (rose almost 3000 mousedear)"
#define MOUSEDEER_VERSION "991 (raging mousedeer)"

namespace nyah { namespace mousedeer {

inline int main(int argc, char *argv[]) {
    options opts;

    char const header[] = "mousedeer "   MOUSEDEER_VERSION "\nusage: mousedeer [arguments] <grammar files to process>";
    int nPositionals = opts.parse_command_line(header, argc, argv);

    if (0 == nPositionals) return 1;

    try {
        cpp::builder build_source(opts);
        for (int i = 1; i <= nPositionals; ++i) build_source.parse_file(argv[i]);

        build_source.generate_code();
        if (opts.print_ast_) build_source.print_ast();
    }
    catch (error::cannot_open_file const& e) {
        chilon::println(std::cerr, e.what(), ": ", e.file_path_);
    }
    catch (error::parsing const& e) {
        chilon::println(std::cerr, e.what(), ": ", e.file_path_);
    }
    catch (std::runtime_error const& e) {
        chilon::println(std::cerr, e.what());
        return 1;
    }

    return 0;
}

} }

int main(int argc, char *argv[]) {
    return nyah::mousedeer::main(argc, argv);
}
