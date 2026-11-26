// L2CMCTargetDesc.h

#ifndef LLVM_LIB_TARGET_L2C_MCTARGETDESC_L2CMCTARGETDESC_H
#define LLVM_LIB_TARGET_L2C_MCTARGETDESC_L2CMCTARGETDESC_H

#include "llvm/MC/MCContext.h"
#include "llvm/MC/MCInstrInfo.h"
#include "llvm/MC/MCRegisterInfo.h"
#include "llvm/MC/MCTargetOptions.h"
#include <memory>

namespace llvm {
class MCCodeEmitter;
class MCAsmBackend;
class MCContext;
class MCInstrInfo;
class MCObjectTargetWriter;
class MCSubtargetInfo;
class Target;

MCCodeEmitter *createL2CMCCodeEmitter(const MCInstrInfo &MCII, MCContext &Ctx);

MCAsmBackend *createL2CAsmBackend(const Target &T, const MCSubtargetInfo &STI,
                                  const MCRegisterInfo &MRI,
                                  const MCTargetOptions &Options);

std::unique_ptr<MCObjectTargetWriter> createL2CELFObjectWriter(uint8_t OSABI);

} // namespace llvm

#define GET_REGINFO_ENUM
#include "L2CGenRegisterInfo.inc"

#define GET_INSTRINFO_ENUM
#include "L2CGenInstrInfo.inc"

#define GET_SUBTARGETINFO_ENUM
#include "L2CGenSubtargetInfo.inc"

#endif // LLVM_LIB_TARGET_L2C_MCTARGETDESC_L2CMCTARGETDESC_H
