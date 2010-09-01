#include <nyah/mousedeer/cpp/builder.hpp>
#include <nyah/mousedeer/options.hpp>

#include <chilon/print.hpp>

#include <iostream>
#include <stdexcept>

// #define MOUSEDEER_VERSION "1000 (just don't get in a car, and stay away from my family)"
// #define MOUSEDEER_VERSION "999 (she's also known as darwinius)"
// #define MOUSEDEER_VERSION "998 (grind machine)"
// #define MOUSEDEER_VERSION "997 (420 mishap)"
// #define MOUSEDEER_VERSION "996 (super mousedeer 4)"
// #define MOUSEDEER_VERSION "995 (ibuki mousedeer)"
// #define MOUSEDEER_VERSION "994 (maryam the butcher)"
#define MOUSEDEER_VERSION "993 (friendly beard)"

namespace nyah { namespace mousedeer {

inline int main(int argc, char *argv[]) {
    options opts;

    char const header[] = "mousedeer "   MOUSEDEER_VERSION "\nusage: mousedeer [arguments] <grammar files to process>";
    int nPositionals = opts.parse_command_line(header, argc, argv);

    if (0 == nPositionals) return 1;

    try {
        cpp::builder build_source(opts);
        for (int i = 1; i <= nPositionals; ++i) build_source(argv[i]);
    }
    catch (cannot_open_file const& e) {
        chilon::println(std::cerr, e.what(), ": ", e.file_path_);
    }
    catch (parsing_error const& e) {
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
