module mousedeer.global_symbol_table;

import mousedeer.parser.nyah
  : Function, VariableDefinition, Class, Global, GlobalNamespace, Module;
import mousedeer.object_module : ObjectModule;
import mousedeer.io.symbol_table : SymbolTablePrinter;
import mousedeer.source_file : SourceFile;

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
 private:
  Global.NamespacePtr parent_; // parent of current global objects
  ObjectModule        objModule_; // current object module

  void childOfGlobal(T)(auto ref T v) {
    // TODO: create new object module if namespace is empty
    opCall(v);
  }

 public:
  void opCall(T)(auto ref T v) {
    GlobalNamespace namespace = parent_.base!GlobalNamespace;
    static if (is(T : Module)) {
      // re-use existing module if the current module was never used
      if (! namespace.symbols_.length)
        objModule_ = new ObjectModule;

      auto parentBak = parent_;

      v.setObjectModule(objModule_);

      for (auto i = 0; i < v.ids.length; ++i) {
        auto id = v.ids[i];
        auto idStr = id.str;
        auto ptr = idStr in namespace.symbols_;
        if (ptr) {
          if (! ptr.isType!Module) {
            throw new SymbolRedefinition(id, "redefined as module");
          }
          namespace = ptr.as!Module;
          // TODO: append members if module?
        }
        else if (i == v.ids.length - 1) {
          // first time module is seen
          namespace.symbols_[idStr] = v;
          namespace = v;
        }
        else {
          // empty module created to be parent of current module
          auto newNamespace = new Module;
          newNamespace.ids = v.ids[0..(i+1)];
          namespace.symbols_[idStr] = newNamespace;
          namespace = newNamespace;
        }

        namespace.parent = parent_;
        parent_ = cast(Module)namespace;
      }

      foreach (node ; v.members)
        node.apply(this);

      parent_    = parentBak;
      return;
    }
    else static if (is(T : Global)) {
      v.parent = parent_;
      v.setObjectModule(objModule_);
      namespace.symbols_[v.id] = v;
    }

    static if (is(T : Class)) {
      auto parentBak    = parent_;
      namespace = v;
      parent_ = v;

      foreach (node ; v.block.value_)
        node.apply(this);

      parent_ = parentBak;
    }
  }

  void empty() { assert(false, "cannot be empty"); }

  // Import an AST into the symbol table. This also sets the parents and
  // object module references within all global ast nodes.
  void import_(SourceFile file) {
    objModule_ = new ObjectModule;
    foreach (node ; file.ast)
      node.apply(
          (Class v) { childOfGlobal(v); },
          (VariableDefinition v) { childOfGlobal(v); },
          (Function v) { childOfGlobal(v); },
          this); // intercept global non-modules specially
  }
}

class GlobalSymbolTable : Module {
  // import code from ast of single object module into global symbol table
  void import_(SourceFile file) {
    SymbolTableBuilder builder;
    builder.parent_ = cast(Module)this;
    builder.import_(file);
  }

  void dump(bool verbose = false) {
    SymbolTablePrinter p;
    p.verbose = verbose;
    p.dump(this);
  }
};
// vim:ts=2 sw=2:
