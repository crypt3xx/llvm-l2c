// L2CBaseInfo.cpp

#include "L2CBaseInfo.h"
#include "llvm/ADT/ArrayRef.h" // IWYU pragma: keep

namespace llvm {

namespace L2CSysReg {

#define GET_SysRegsList_IMPL
#include "L2CGenSearchableTables.inc"

} // end namespace L2CSysReg

} // end namespace llvm