// L2CFixupKinds.h

#ifndef LLVM_LIB_TARGET_L2C_MCTARGETDESC_L2CFIXUPKINDS_H
#define LLVM_LIB_TARGET_L2C_MCTARGETDESC_L2CFIXUPKINDS_H

#include "llvm/MC/MCFixup.h"

namespace llvm::L2C {
enum Fixups {
  // imm_B (split field), value = (S + A - P) >> 2
  fixup_l2c_branch16 = FirstTargetFixupKind,
  // imm_J (bits 31-6), value = (S + A - P) >> 2
  fixup_l2c_jump26,

  fixup_l2c_invalid,
  NumTargetFixupKinds = fixup_l2c_invalid - FirstTargetFixupKind
};
} // namespace llvm::L2C

#endif