// L2CMCTargetDesc.cpp

#include "L2CMCTargetDesc.h"
#include "L2CInstPrinter.h"
#include "L2CMCAsmInfo.h"
#include "TargetInfo/L2CTargetInfo.h"
#include "llvm/ADT/StringRef.h"
#include "llvm/MC/MCInst.h"
#include "llvm/MC/MCInstrAnalysis.h"
#include "llvm/MC/MCInstrInfo.h"
#include "llvm/MC/MCRegisterInfo.h"
#include "llvm/MC/MCStreamer.h"
#include "llvm/MC/MCSubtargetInfo.h"
#include "llvm/MC/TargetRegistry.h"
#include "llvm/Support/Compiler.h"
#include "llvm/Support/ErrorHandling.h"
#include "llvm/TargetParser/Triple.h"
#include <string>

#define GET_INSTRINFO_MC_DESC
#include "L2CGenInstrInfo.inc"

#define GET_REGINFO_MC_DESC
#include "L2CGenRegisterInfo.inc"

#define GET_SUBTARGETINFO_MC_DESC
#include "L2CGenSubtargetInfo.inc"

using namespace llvm;

static MCInstrInfo *createL2CMCInstrInfo() {
  MCInstrInfo *X = new MCInstrInfo();
  InitL2CMCInstrInfo(X);
  return X;
}

static MCRegisterInfo *createL2CMCRegisterInfo(const Triple & /*TT*/) {
  MCRegisterInfo *X = new MCRegisterInfo();
  InitL2CMCRegisterInfo(X, L2C::R31);
  return X;
}

static MCSubtargetInfo *createL2CMCSubtargetInfo(const Triple &TT,
                                                 StringRef CPU, StringRef FS) {
  std::string CPUName = std::string(CPU);
  if (CPUName.empty())
    CPUName = "generic";

  return createL2CMCSubtargetInfoImpl(TT, CPUName, /*TuneCPU*/ CPUName, FS);
}

static MCAsmInfo *createL2CMCAsmInfo(const MCRegisterInfo &MRI,
                                     const Triple &TT,
                                     const MCTargetOptions &Options) {
  return new L2CMCAsmInfo(TT, Options);
}

static MCInstPrinter *createL2CMCInstPrinter(const Triple &T, unsigned,
                                             const MCAsmInfo &MAI,
                                             const MCInstrInfo &MII,
                                             const MCRegisterInfo &MRI) {
  return new L2CInstPrinter(MAI, MII, MRI);
}

// static MCStreamer *createMCStreamer(const Triple &T, MCContext &Context,
//                                     std::unique_ptr<MCAsmBackend> &&MAB,
//                                     std::unique_ptr<MCObjectWriter> &&OW,
//                                     std::unique_ptr<MCCodeEmitter> &&Emitter)
//                                     {
//   if (!T.isOSBinFormatELF())
//     llvm_unreachable("OS not supported");

//   return createELFStreamer(Context, std::move(MAB), std::move(OW),
//                            std::move(Emitter));
// }

// static MCRelocationInfo *createLanaiElfRelocation(const Triple &TheTriple,
//                                                   MCContext &Ctx) {
//   return createMCRelocationInfo(TheTriple, Ctx);
// }

// namespace {

// class LanaiMCInstrAnalysis : public MCInstrAnalysis {
// public:
//   explicit LanaiMCInstrAnalysis(const MCInstrInfo *Info)
//       : MCInstrAnalysis(Info) {}

//   bool evaluateBranch(const MCInst &Inst, uint64_t Addr, uint64_t Size,
//                       uint64_t &Target) const override {
//     if (Inst.getNumOperands() == 0)
//       return false;
//     if (!isConditionalBranch(Inst) && !isUnconditionalBranch(Inst) &&
//         !isCall(Inst))
//       return false;

//     if (Info->get(Inst.getOpcode()).operands()[0].OperandType ==
//         MCOI::OPERAND_PCREL) {
//       int64_t Imm = Inst.getOperand(0).getImm();
//       Target = Addr + Size + Imm;
//       return true;
//     } else {
//       int64_t Imm = Inst.getOperand(0).getImm();

//       // Skip case where immediate is 0 as that occurs in file that isn't
//       linked
//       // and the branch target inferred would be wrong.
//       if (Imm == 0)
//         return false;

//       Target = Imm;
//       return true;
//     }
//   }
// };

// } // end anonymous namespace

// static MCInstrAnalysis *createLanaiInstrAnalysis(const MCInstrInfo *Info) {
//   return new LanaiMCInstrAnalysis(Info);
// }

extern "C" LLVM_ABI LLVM_EXTERNAL_VISIBILITY void
LLVMInitializeL2CTargetMC() { // NOLINT(readability-identifier-naming)

  // Register the MC instruction info.
  TargetRegistry::RegisterMCInstrInfo(getTheL2CTarget(), createL2CMCInstrInfo);

  // Register the MC register info.
  TargetRegistry::RegisterMCRegInfo(getTheL2CTarget(), createL2CMCRegisterInfo);

  // Register the MC subtarget info.
  TargetRegistry::RegisterMCSubtargetInfo(getTheL2CTarget(),
                                          createL2CMCSubtargetInfo);

  // Register the MC asm info.
  TargetRegistry::RegisterMCAsmInfo(getTheL2CTarget(), createL2CMCAsmInfo);

  // Register the MCInstPrinter.
  TargetRegistry::RegisterMCInstPrinter(getTheL2CTarget(),
                                        createL2CMCInstPrinter);

  // Register the MC code emitter
  //   TargetRegistry::RegisterMCCodeEmitter(getTheL2CTarget(),
  //                                         createLanaiMCCodeEmitter);

  // Register the ASM Backend
  //   TargetRegistry::RegisterMCAsmBackend(getTheL2CTarget(),
  //                                        createLanaiAsmBackend);

  // Register the ELF streamer.
  //   TargetRegistry::RegisterELFStreamer(getTheL2CTarget(), createMCStreamer);

  // Register the MC relocation info.
  //   TargetRegistry::RegisterMCRelocationInfo(getTheL2CTarget(),
  //                                            createLanaiElfRelocation);

  // Register the MC instruction analyzer.
  //   TargetRegistry::RegisterMCInstrAnalysis(getTheL2CTarget(),
  //                                           createLanaiInstrAnalysis);
}
