#ifndef NYAH_SOURCE_BUILDER_HPP
#define NYAH_SOURCE_BUILDER_HPP
namespace nyah {

class Grammar;

struct source_builder {
    void operator()(Grammar const& grammar);
};

}
#endif
