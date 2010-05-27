#include <nyah/mousebear/options.hpp>

#include <chilon/conf/cmd/command_line.hpp>
#include <chilon/parser/joined.hpp>
#include <chilon/parser/char_range.hpp>
#include <chilon/parser/char.hpp>
#include <chilon/parser/many.hpp>

namespace nyah { namespace mousebear {

namespace cmd_line = chilon::conf::cmd;

options::options() : verbose_(false), print_ast_(false), output_dir_(".") {}

int options::parse_command_line(char const *header, int argc, char *argv[]) {
    int nPositionals;

    using chilon::conf::value;
    using cmd_line::options_description;
    char const *output_namespace = 0;

    options_description opt_parser;
    opt_parser.add_options()
        .help(header)
        ("p,print",        print_ast_, "print AST of grammar")
        ("v,verbose",      verbose_, "increase verbosity")
        ("o,output-dir",   output_dir_, "directory to output code")
        ("n,namespace",    output_namespace, "namespace to use")
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

    if (nPositionals < 1) {
        std::cerr << "please supply at least one grammar to parse\n";
        std::cout << opt_parser << std::endl;
        return 0;
    }

    if (output_namespace) {
        using chilon::parser::parse;
        using chilon::parser::char_range;
        using chilon::parser::joined_plus_lexeme;
        using chilon::parser::char_;
        using chilon::parser::many_plus;
        using chilon::to_range;

        chilon::range ns_range = chilon::to_range(output_namespace);
        parse< joined_plus_lexeme<
            char_<'.'>,
            many_plus< char_range<'a', 'z', 'A', 'Z'> > > >::skip(
                ns_range, output_namespace_);

        if (! ns_range.empty()) {
            std::cerr << "invalid namespace string supplied\n";
            return 0;
        }
    }

    return nPositionals;
}

} }
