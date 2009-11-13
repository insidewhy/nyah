#include <mousebear/parser.hpp>
#include <chilon/parser/eg/is_mutable.hpp>
#include <chilon/parser/eg/char.hpp>

namespace nyah { namespace mousebear {

namespace eg = chilon::parser::eg;

bool parser::parse() {
    std::cout << "is_mutable<char_<'a'>>::value = " << 
                 eg::is_mutable<eg::char_<'a'>>::value << std::endl;
    std::cout << "is_mutable<char_<'a', 'b'>>::value = " << 
                 eg::is_mutable<eg::char_<'a', 'b'>>::value << std::endl;
    std::cout << "is_mutable<float>::value = " << 
                 eg::is_mutable<float>::value << std::endl;

    range res;
    if (store< 
            eg::char_<'g','r','a','m','m','a','r'> 
        >(res)) 
    {
    }
    else {
        std::cerr << "invalid grammar\n";
        return false;
    }

    return true;
}

} }
