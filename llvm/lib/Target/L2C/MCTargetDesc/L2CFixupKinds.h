// L2CFixupKinds.h

#ifndef LLVM_LIB_TARGET_L2C_MCTARGETDESC_L2CFIXUPKINDS_H
#define LLVM_LIB_TARGET_L2C_MCTARGETDESC_L2CFIXUPKINDS_H

#include "llvm/MC/MCFixup.h"

namespace llvm::L2C {
enum Fixups {
  fixup_l2c_hi16 = FirstTargetFixupKind,
  fixup_l2c_lo16_i,
  fixup_l2c_lo16_s,
  fixup_l2c_pcrel_hi16,
  fixup_l2c_branch16,
  fixup_l2c_jump26,

  fixup_l2c_invalid,

  NumTargetFixupKinds = fixup_l2c_invalid - FirstTargetFixupKind
};
} // namespace llvm::L2C

#endif