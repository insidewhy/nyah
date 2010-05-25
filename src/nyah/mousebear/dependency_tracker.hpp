#ifndef NYAH_DEPENDENCY_TRACKER_HPP
#define NYAH_DEPENDENCY_TRACKER_HPP

#include <chilon/getset.hpp>
#include <chilon/variant.hpp>
#include <chilon/iterator_range.hpp>

#include <boost/functional/hash.hpp>

#include <vector>
#include <unordered_set>
#include <sstream>

namespace nyah { namespace mousebear {

class NodeRule;
class Rule;

class dependency_tracker {
    typedef chilon::range                   range;
    typedef chilon::variant<Rule, NodeRule> rule_t;

    struct identifier {
        range           const rule_name_;
        rule_t  const * const rule_;

        bool operator==(identifier const& rhs) const {
            return rule_name_ == rhs.rule_name_;
        }

        identifier(range const& rule_name, rule_t const& rule)
          : rule_name_(rule_name), rule_(&rule) {};
    };

    // first identifier is dependent, second is dependency
    struct  node_dependency {
        identifier const dependent_;
        identifier const dependency_;
        std::stringstream  string_;

        node_dependency(identifier const& dependent,
                        identifier const& dependency)
          : dependent_(dependent_), dependency_(dependency_) {}
    };

    struct hash_node_dependency {
        size_t operator()(node_dependency const& node_dep) {
            return chilon::hash_value(node_dep.dependency_.rule_name_);
        }
    };

    typedef std::vector<identifier>  dependency_list_t;
    struct cycle_error { dependency_list_t cycles_; };

    std::unordered_set<node_dependency, hash_node_dependency>  dependencies_;

  public:
    void add_depdendency(range const& rule_name, rule_t const& identifier);
};

} }
#endif
