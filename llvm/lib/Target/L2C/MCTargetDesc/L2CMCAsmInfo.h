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

  void printSpecifierExpr(raw_ostream &OS,
                          const MCSpecifierExpr &Expr) const override;
};

namespace L2C {

enum Specifier : uint16_t {
  S_None = 0,
  S_HI,       // %hi
  S_LO,       // %lo
  S_PCREL_HI, // %pcrel_hi
};
Specifier parseSpecifierName(StringRef Name);
StringRef getSpecifierName(Specifier S);

} // end namespace L2C
} // end namespace llvm

#endif // LLVM_LIB_TARGET_L2C_MCTARGETDESC_L2CMCASMINFO_H
