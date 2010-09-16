#include <nyah/mousedeer/options.hpp>
#include <nyah/mousedeer/config.hpp>

#include <chilon/conf/cmd/command_line.hpp>
#include <chilon/parser/joined.hpp>
#include <chilon/parser/char_range.hpp>
#include <chilon/parser/char.hpp>
#include <chilon/parser/many.hpp>

namespace nyah { namespace mousedeer {

namespace cmd_line = chilon::conf::cmd;

options::options() : verbose_(false), print_ast_(false), output_dir_(".") {}

int options::parse_command_line(char const *header, int argc, char *argv[]) {
    int nPositionals;

    using chilon::conf::value;
    using cmd_line::options_description;

    options_description opt_parser;
    opt_parser.add_options()
        .help(header)
        ("p,print",      print_ast_, "print AST of grammar")
        ("v,verbose",    verbose_, "increase verbosity")
        ("o,output-dir", output_dir_, "directory to output code")
        ("I,include",    include_paths_, "include paths")
        ;

    try {
        nPositionals = cmd_line::parser(argc, argv, opt_parser)(std::cerr).n_positionals();
    }
    catch (cmd_line::invalid_arguments& ) {
        return 0;
    }
    catch (cmd_line::bad_value& e) {
        std::cerr << "bad value reading command line options\n";
        std::cout << opt_parser << std::endl;
        return 0;
    }
    catch (cmd_line::expected_argument& e) {
        std::cerr << "expected command line argument\n";
        std::cout << opt_parser << std::endl;
        return 0;
    }

    include_paths_.push_back(std::string(MOUSEDEER_SYSTEM_INCLUDE_PATH));

    if (nPositionals < 1) {
        std::cerr << "please supply at least one grammar to parse\n";
        std::cout << opt_parser << std::endl;
        return 0;
    }

    return nPositionals;
}

} }
