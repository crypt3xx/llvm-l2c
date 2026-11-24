//===-- L2CTargetMachine.cpp - Define TargetMachine for L2C ---------------===//
//
// Step 1 stub: this only provides the entry point that LLVM's tools call for
// every registered target (InitializeAllTargets). Step 2 replaces the body
// with RegisterTargetMachine<L2CTargetMachine>.
//
//===----------------------------------------------------------------------===//

#include "llvm/Support/Compiler.h"

extern "C" LLVM_EXTERNAL_VISIBILITY void
LLVMInitializeL2CTarget() { // NOLINT(readability-identifier-naming)
  // Step 2: RegisterTargetMachine<L2CTargetMachine> X(getTheL2CTarget());
}
