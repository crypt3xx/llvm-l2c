// L2CBaseInfo.h

#include "llvm/ADT/StringTable.h"

namespace llvm {

namespace L2CSysReg {

struct SysReg {
  StringTable::Offset Name;
  uint16_t Encoding;
  bool ReadOnly;
};

#define GET_SysRegsList_DECL
#include "L2CGenSearchableTables.inc"

} // end namespace L2CSysReg

} // end namespace llvm