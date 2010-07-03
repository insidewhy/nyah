#ifndef NYAH_MOUSEBEAR_DEPENDENCY_TRACKER_HPP
#define NYAH_MOUSEBEAR_DEPENDENCY_TRACKER_HPP

#include <chilon/getset.hpp>

#include <vector>
#include <unordered_map>
#include <sstream>

namespace nyah { namespace mousebear {

// tracks "named dependency" relationships
template <class K, class T>
class dependency_tracker {
    typedef K  key_t;
    typedef T  dep_t;

    struct dependant {
        std::stringstream   output_;
        dep_t               dep_;
        unsigned int        dep_count_;

        dependant(dep_t& dep, unsigned int dep_count = 0)
          : dep_(dep), dep_count_(dep_count) {}
    };

    typedef std::vector<dep_t>  dependency_list_t;
    struct cycle_error { dependency_list_t cycles_; };

    // dependency name against dependant
    std::unordered_multimap<key_t, dependant const *>  dependencies_;

    // dependant name against number of dependencies it currently has
    std::unordered_map<key_t, dependant>   dependants_;

  public:
    // add dependency, throws cycle_error
    void add_depdendency(key_t const& dependency_key,
                         dep_t const& dependant)
    {
    }
};

} }
#endif
