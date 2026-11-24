//===-- L2CTargetInfo.cpp - L2C Target Implementation ---------------------===//
//
// Registers the L2C target with the TargetRegistry, so tools can find it by
// name ("l2c") or by triple (l2c-unknown-elf).
//
//===----------------------------------------------------------------------===//

#include "TargetInfo/L2CTargetInfo.h"
#include "llvm/MC/TargetRegistry.h"
#include "llvm/Support/Compiler.h"

using namespace llvm;

Target &llvm::getTheL2CTarget() {
  static Target TheL2CTarget;
  return TheL2CTarget;
}

extern "C" LLVM_EXTERNAL_VISIBILITY void
LLVMInitializeL2CTargetInfo() { // NOLINT(readability-identifier-naming)
  RegisterTarget<Triple::l2c, /*HasJIT=*/false> X(
      getTheL2CTarget(), "l2c", "L2C custom 32-bit RISC", "L2C");
}
