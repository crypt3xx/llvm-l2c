// L2CMCTargetDesc.h

#ifndef LLVM_LIB_TARGET_L2C_MCTARGETDESC_L2CMCTARGETDESC_H
#define LLVM_LIB_TARGET_L2C_MCTARGETDESC_L2CMCTARGETDESC_H

// #include "llvm/MC/MCRegisterInfo.h"
// #include "llvm/MC/MCTargetOptions.h"
// #include "llvm/Support/DataTypes.h"

namespace llvm {
// class MCAsmBackend;
// class MCCodeEmitter;
// class MCContext;
// class MCInstrInfo;
// class MCObjectTargetWriter;
// class MCSubtargetInfo;
// class Target;

// MCCodeEmitter *createLanaiMCCodeEmitter(const MCInstrInfo &MCII,
//                                         MCContext &Ctx);

// MCAsmBackend *createLanaiAsmBackend(const Target &T, const MCSubtargetInfo
// &STI,
//                                     const MCRegisterInfo &MRI,
//                                     const MCTargetOptions &Options);

// std::unique_ptr<MCObjectTargetWriter> createLanaiELFObjectWriter(uint8_t
// OSABI);
} // namespace llvm

#define GET_REGINFO_ENUM
#include "L2CGenRegisterInfo.inc"

#define GET_INSTRINFO_ENUM
#include "L2CGenInstrInfo.inc"

#define GET_SUBTARGETINFO_ENUM
#include "L2CGenSubtargetInfo.inc"

#endif // LLVM_LIB_TARGET_L2C_MCTARGETDESC_L2CMCTARGETDESC_H
