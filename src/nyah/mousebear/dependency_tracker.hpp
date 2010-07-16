#ifndef NYAH_MOUSEBEAR_DEPENDENCY_TRACKER_HPP
#define NYAH_MOUSEBEAR_DEPENDENCY_TRACKER_HPP

#include <chilon/getset.hpp>
#include <chilon/iterator_range.hpp>
#include <chilon/meta/identity.hpp>

#include <vector>
#include <unordered_map>
#include <sstream>

namespace nyah { namespace mousebear {

// tracks "named dependency" relationships
template <class K, class T = K, class GetKey = chilon::meta::identity>
class dependency_tracker {
    typedef K  key_t;
    typedef T  dep_t;

    typedef std::vector<dep_t>  dependency_list_t;
    struct cycle_error { dependency_list_t cycles_; };

    // dependency name against dependant
    std::unordered_multimap<key_t, dep_t *>  dependencies_;

    // dependant name against dependant
    std::unordered_map<key_t, dep_t>                dependants_;

  public:
    // add dependency, throws cycle_error
    void add_depdendency(key_t const& dependency, dep_t const& dependant) {
    }
};

} }
#endif
