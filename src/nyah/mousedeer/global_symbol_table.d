module mousedeer.global_symbol_table;

import mousedeer.parser.nyah
  : Ast, Function, VariableDefinition, Class, Global, GlobalNamespace, Module;
import mousedeer.object_module : ObjectModule;
import mousedeer.io.symbol_table : SymbolTablePrinter;

import teg.range : Range;

class ExceptionWithLocation : Exception {
  this(Range loc, string msg) {
    loc_ = loc;
    super(msg);
  }

  // todo: override toString to give location better

  private Range loc_;
}

class SymbolRedefinition : ExceptionWithLocation {
  this(Range loc, string msg) { super(loc, msg); }
}

private struct SymbolTableBuilder {
  // current namespace and output module
 private:
  GlobalNamespace     namespace_;

  // TODO: look into extracting common base classes from variants
  private Global.Ptr  parent_; // same object above but in variant form
                               // rather than base class reference
  ObjectModule        objModule_;

  // call on every global the first time it is seen
  void initGlobal(Global g) {
    g.parent_ = parent_;
    g.setObjectModule(objModule_);
  }

 public:
  void opCall(T)(T v) {
    static if (is(T : Module)) {
      // re-use existing module if the current module was never used
      if (! namespace_.symbols_.length)
        objModule_ = new ObjectModule;

      auto namespaceBak = namespace_;
      auto parentBak = parent_;

      v.setObjectModule(objModule_);

      for (auto i = 0; i < v.ids.length; ++i) {
        auto id = v.ids[i];
        auto idStr = id.toString;
        auto ptr = idStr in namespace_.symbols_;
        if (ptr) {
          if (! ptr.isType!Module) {
            throw new SymbolRedefinition(id, "redefined as module");
          }
          namespace_ = ptr.as!Module;
          // TODO: update id location to current part of module?
        }
        else if (i == v.ids.length - 1) {
          // first time module is seen
          namespace_.symbols_[idStr] = v;
          namespace_ = v;
        }
        else {
          // empty module created to be parent of current module
          auto newNamespace = new Module;
          newNamespace.ids = v.ids[0..(i+1)];
          namespace_.symbols_[idStr] = newNamespace;
          namespace_ = newNamespace;
        }

        namespace_.parent_ = parent_;
        parent_ = cast(Module)namespace_;
      }

      foreach (node ; v.members)
        node.apply(this);

      namespace_ = namespaceBak;
      parent_    = parentBak;
      return;
    }
    else static if (is(T : Global)) {
      initGlobal(v);
      namespace_.symbols_[v.id] = v;
    }

    static if (is(T : Class)) {
      auto namespaceBak = namespace_;
      auto parentBak    = parent_;
      namespace_ = v;
      parent_ = v;

      foreach (node ; v.block.value_)
        node.apply(this);

      namespace_ = namespaceBak;
      parent_ = parentBak;
    }
  }

  void empty() { assert(false, "cannot be empty"); }

  // Import an AST into the symbol table. This also sets the parents and
  // object module references within all global ast nodes.
  void import_(Ast ast) {
    objModule_ = new ObjectModule;
    foreach (node ; ast)
      node.apply(this);
  }
}

class GlobalSymbolTable : GlobalNamespace {
  // import code from ast of single object module into global symbol table
  void import_(Ast ast) {
    SymbolTableBuilder builder;
    builder.namespace_ = this;
    builder.import_(ast);
  }

  void dump() {
    SymbolTablePrinter p;
    p.dump(this);
  }
};
// vim:ts=2 sw=2:
