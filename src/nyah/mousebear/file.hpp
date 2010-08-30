#ifndef NYAH_FILE_HPP
#define NYAH_FILE_HPP

#include <chilon/getset.hpp>

namespace nyah { namespace mousebear {

class file {
    bool processed_;

  public:
    bool processed() const { return processed_; }

    file& operator=(bool const processed) {
        processed_ = processed; return *this;
    }
    file() : processed_(false) {};
};

} }

#endif

