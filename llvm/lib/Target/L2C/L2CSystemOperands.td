// L2CSystemOperands.td

include "llvm/TableGen/SearchableTable.td"

//===----------------------------------------------------------------------===//
// CSR (control and status register read/write) instruction options.
//===----------------------------------------------------------------------===//

class SysReg<string name, bits<12> op, bit readOnly = false> {
  string Name = name;
  bits<12> Encoding = op;
  bit ReadOnly = readOnly;
}

def SysRegsList : GenericTable {
  let FilterClass = "SysReg";

  let Fields = [
    "Name", "Encoding", "ReadOnly"
  ];

  let PrimaryKey = [ "Encoding" ];
  let PrimaryKeyName = "lookupSysRegByEncoding";
}

def lookupSysRegByName : SearchIndex {
  let Table = SysRegsList;
  let Key = [ "Name" ];
}



// Trap and interrupt state (read/write)
def : SysReg<"status",   0x0000>;
def : SysReg<"tvec",     0x0001>;
def : SysReg<"epc",      0x0002>;
def : SysReg<"cause",    0x0003>;
def : SysReg<"badaddr",  0x0004>;
def : SysReg<"scratch",  0x0005>;
def : SysReg<"ie",       0x0006>;

// Read-only: interrupt pending bits and counters
def : SysReg<"ip",       0x0007, true>;
def : SysReg<"cycle",    0x0008, true>;
def : SysReg<"cycleh",   0x0009, true>;
def : SysReg<"instret",  0x000A, true>;
def : SysReg<"instreth", 0x000B, true>;