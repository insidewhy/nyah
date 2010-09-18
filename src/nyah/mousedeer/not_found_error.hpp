#ifndef NYAH_MOUSEDEER_NOT_FOUND_ERROR_HPP
#define NYAH_MOUSEDEER_NOT_FOUND_ERROR_HPP

#include <stdexcept>

namespace nyah { namespace mousedeer {

template <class T>
struct not_found_error : std::runtime_error {
    ~not_found_error() throw() {}
    not_found_error(std::string const& message, T const& data)
      : std::runtime_error(message), data_(data) {}

    T const& data_;
};

} }
#endif
