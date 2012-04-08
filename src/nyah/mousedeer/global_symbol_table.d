module mousedeer.global_symbol_table;

import mousedeer.parser.nyah : Ast, Function, VariableDefinition, Class, Global;
import mousedeer.object_module : ObjectModule;
import beard.variant : Variant;

class GlobalSymbolTable {
  // import code from ast of single object module into global symbol table
  void opCall(ObjectModule module_, Ast ast) {
    // TODO: fill in symbols_ + table and object module for each global in ast
  }

  alias Global.Ptr Symbol;
  Symbol[string] symbols_;
};
// vim:ts=2 sw=2:
