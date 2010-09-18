#ifndef NYAH_MOUSEDEER_ERROR_NOT_FOUND_HPP
#define NYAH_MOUSEDEER_ERROR_NOT_FOUND_HPP

#include <stdexcept>

namespace nyah { namespace mousedeer { namespace error {

template <class T>
struct not_found : std::runtime_error {
    ~not_found() throw() {}
    not_found(std::string const& message, T const& data)
      : std::runtime_error(message), data_(data) {}

    T const& data_;
};

template <class T>
void throw_not_found(std::string const& msg, T const& t) {
    throw error::not_found<T>(msg, t);
}

} } }
#endif
