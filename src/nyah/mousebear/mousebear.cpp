#include <nyah/mousebear/grammar/nyah.hpp>
#include <nyah/mousebear/grammar/nyah.hpp>
#include <nyah/mousebear/builder/cpp.hpp>
#include <nyah/mousebear/project.hpp>

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
#define MOUSEBEAR_VERSION "993 (friendly beard)"

namespace nyah { namespace mousebear {

inline int main(int argc, char *argv[]) {
    options opts;

    char const header[] = "mousebear "   MOUSEBEAR_VERSION "\nusage: mousebear [arguments] <grammar files to process>";
    int nPositionals = opts.parse_command_line(header, argc, argv);

    if (0 == nPositionals) return 1;

    // cplusplus builder
    project project(opts);

    try {
        builder::cpp build_source(project);
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
    return nyah::mousebear::main(argc, argv);
}
