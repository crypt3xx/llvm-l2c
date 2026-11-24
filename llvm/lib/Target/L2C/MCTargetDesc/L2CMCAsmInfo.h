// L2CMCAsmInfo.h

#ifndef LLVM_LIB_TARGET_L2C_MCTARGETDESC_L2CMCASMINFO_H
#define LLVM_LIB_TARGET_L2C_MCTARGETDESC_L2CMCASMINFO_H

#include "llvm/MC/MCAsmInfoELF.h"

namespace llvm {
class Triple;

class L2CMCAsmInfo : public MCAsmInfoELF {
  void anchor() override;

public:
  explicit L2CMCAsmInfo(const Triple &TargetTriple,
                        const MCTargetOptions &Options);
};

} // namespace llvm

#endif // LLVM_LIB_TARGET_L2C_MCTARGETDESC_L2CMCASMINFO_H
