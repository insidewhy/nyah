#ifndef NYAH_NODE_HPP
#define NYAH_NODE_HPP

#include <chilon/parser/simple_node.hpp>

#define NYAH_NODE_PRINT(name) \
    template <class O> \
    void print_tail(int const indent, O& stream, name const& value) { \
        print_tail(indent, stream, #name ": ", value.value_); \
    }

#define NYAH_NODE_PRINT_INLINE(name) \
    template <class O> \
    void print_tail(int const indent, O& stream, name const& value) { \
        print_tail(indent, stream, value.value_); \
    }

#define NYAH_NODE_CLASS(name, ...) \
    struct name : simple_node<name, __VA_ARGS__ > \

#define NYAH_NODE(name, ...) \
    NYAH_NODE_CLASS(name, __VA_ARGS__) {}; \
    NYAH_NODE_PRINT(name)

#define NYAH_NODE_INLINE(name, ...) \
    NYAH_NODE_CLASS(name, __VA_ARGS__) {}; \
    NYAH_NODE_PRINT_INLINE(name)

#endif
