module mousedeer.io.symbol_table;

import mousedeer.parser.nyah
  : Function, VariableDefinition, Class, GlobalNamespace, Module, Global;
import mousedeer.function_overloads : FunctionOverloads;

import beard.io : println, print;
import std.stdio : writeln;

struct SymbolTablePrinter {
  enum TAB_SIZE = 2;
  bool verbose;

  static private void printModule(Module v) {
    print("module(");
    if (v.isGlobal) {
      print("global");
    }
    else {
      print(v.ids()[0].str);
      foreach (id ; v.ids()[1..$])
        print("." ~ id.str);
    }
    print(")");
  }

  private void printGlobal(Global v) {
    if (! verbose) return;
    print(" { parent: ");
    v.parent.apply(
        (Class v) { print("class (" ~ v.id.str ~ ")"); },
        &printModule,
        (Function v) { print("func (" ~ v.id.str ~ ")"); },
        () { assert(false, "unreachable"); });
    print(", ");

    // not sure...
    if (v.objectModule) {
      print("bytecode: '");
      print(v.objectModule.path);
      print("'");
    }
    else {
      // a package is a module that only contains modules
      print("package: true");
    }
    print(" }");
  }

  void opCall(Function v) {
    print("function");
    printGlobal(v);
    writeln();
  }
  void opCall(VariableDefinition v) {
    print("variable");
    printGlobal(v);
    writeln();
  }
  void opCall(Module v) {
    print("module");
    printGlobal(v);
    children(v);
  }
  void opCall(Class v) {
    print("class");
    printGlobal(v);
    children(v);
  }
  void opCall(FunctionOverloads v) {
    print("functions");
    printGlobal(v.functions[0]);
    writeln();
    // TODO: print overloads table
  }

  private void printIndent() {
    for (int i = 0; i < indent_; ++i)
      for (int j = 0; j < TAB_SIZE; ++j)
        print(' ');
  }

  private void children(GlobalNamespace val) {
    println(" {");
    ++indent_;
    foreach(k, v; val.symbols_) {
      printIndent();
      print(k ~ ": ");
      v.apply(this);
    }
    --indent_;
    printIndent();
    println("}");
  }

  void dump(GlobalNamespace root) {
    print("global");
    children(root);
  }

  void empty() { assert(false, "cannot be empty"); }

  private int indent_ = 0;
}
// vim:ts=2 sw=2:
