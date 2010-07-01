#ifndef NYAH_MOUSEBEAR_DEPENDENCY_TRACKER_HPP
#define NYAH_MOUSEBEAR_DEPENDENCY_TRACKER_HPP

#include <chilon/getset.hpp>
#include <chilon/variant.hpp>
#include <chilon/iterator_range.hpp>

#include <boost/functional/hash.hpp>

#include <vector>
#include <unordered_set>
#include <unordered_map>
#include <sstream>

namespace nyah { namespace mousebear {

class NodeRule;
class Rule;

class dependency_tracker {
    typedef chilon::range                   range;
    typedef chilon::variant<Rule, NodeRule> rule_t;

    struct grammar_id {
        range           const rule_name_;
        rule_t  const * const rule_;

        bool operator==(grammar_id const& rhs) const {
            return rule_name_ == rhs.rule_name_;
        }

        grammar_id(range const& rule_name, rule_t const& rule)
          : rule_name_(rule_name), rule_(&rule) {};
    };

    struct grammar_rule_dep {
        grammar_id const dependent_;
        grammar_id const dependency_;
        std::stringstream  string_;

        grammar_rule_dep(grammar_id const& dependent,
                         grammar_id const& dependency)
          : dependent_(dependent_), dependency_(dependency_) {}
    };

    struct hash_grammar_dep {
        size_t operator()(grammar_rule_dep const& node_dep) {
            return chilon::hash_value(node_dep.dependency_.rule_name_);
        }
    };

    typedef std::vector<grammar_id>  dependency_list_t;
    struct cycle_error { dependency_list_t cycles_; };

    std::unordered_multiset<grammar_rule_dep, hash_grammar_dep>  grammar_deps_;

    // rule name against number of dependencies it currently has
    std::unordered_map<range, unsigned int>                      grammar_dep_count_;

  public:
    // add dependency, throws cycle_error
    void add_depdendency(range const& rule_name, rule_t const& grammar_id);
};

} }
#endif
