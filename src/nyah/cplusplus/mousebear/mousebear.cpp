#include <chilon/conf/cmd/command_line.hpp>
#define MOUSEBEAR_VERSION "0 (just don't get in a car, and stay away from my family)"

namespace nyah { namespace mousebear {

namespace cmd_line = chilon::conf::cmd;

inline int main(int argc, char *argv[]) {
    return 0;
}

} }

int main(int argc, char *argv[]) {
    return nyah::mousebear::main(argc, argv);
}
