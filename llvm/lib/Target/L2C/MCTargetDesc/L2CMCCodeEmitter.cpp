// L2CMCCodeEmitter.cpp

#include "MCTargetDesc/L2CMCTargetDesc.h"
#include "llvm/ADT/SmallVector.h"
#include "llvm/MC/MCCodeEmitter.h"
#include "llvm/MC/MCContext.h"
#include "llvm/MC/MCExpr.h"
#include "llvm/MC/MCFixup.h"
#include "llvm/MC/MCInst.h"
#include "llvm/MC/MCInstrInfo.h"
#include "llvm/MC/MCRegisterInfo.h"
#include "llvm/MC/MCSubtargetInfo.h"
#include "llvm/Support/EndianStream.h"
#include <cassert>
#include <cstdint>

#define DEBUG_TYPE "mccodeemitter"

namespace llvm {

namespace {

class L2CMCCodeEmitter : public MCCodeEmitter {

  L2CMCCodeEmitter(const L2CMCCodeEmitter &) = delete;
  void operator=(const L2CMCCodeEmitter &) = delete;
  MCContext &Ctx;

public:
  L2CMCCodeEmitter(MCInstrInfo const &MCII, MCContext &Ctx) : Ctx(Ctx) {}
  ~L2CMCCodeEmitter() override = default;

  // The functions below are called by TableGen generated functions for getting
  // the binary encoding of instructions/opereands.

  // getMachineOpValue - Return binary encoding of operand. If the machine
  // operand requires relocation, record the relocation and return zero.
  unsigned getMachineOpValue(const MCInst &Inst, const MCOperand &MCOp,
                             SmallVectorImpl<MCFixup> &Fixups,
                             const MCSubtargetInfo &SubtargetInfo) const;

  void encodeInstruction(const MCInst &Inst, SmallVectorImpl<char> &CB,
                         SmallVectorImpl<MCFixup> &Fixups,
                         const MCSubtargetInfo &SubtargetInfo) const override;

  // getBinaryCodeForInstr - TableGen'erated function for getting the
  // binary encoding for an instruction.
  uint64_t getBinaryCodeForInstr(const MCInst &Inst,
                                 SmallVectorImpl<MCFixup> &Fixups,
                                 const MCSubtargetInfo &SubtargetInfo) const;
};

} // end anonymous namespace

// getMachineOpValue - Return binary encoding of operand. If the machine
// operand requires relocation, record the relocation and return zero.
unsigned L2CMCCodeEmitter::getMachineOpValue(
    const MCInst &Inst, const MCOperand &MCOp, SmallVectorImpl<MCFixup> &Fixups,
    const MCSubtargetInfo &SubtargetInfo) const {

  if (MCOp.isReg())
    return Ctx.getRegisterInfo()->getEncodingValue(MCOp.getReg());
  if (MCOp.isImm())
    return MCOp.getImm();

  llvm_unreachable("fixups not supported for yet");
  return 0;
}

void L2CMCCodeEmitter::encodeInstruction(
    const MCInst &Inst, SmallVectorImpl<char> &CB,
    SmallVectorImpl<MCFixup> &Fixups,
    const MCSubtargetInfo &SubtargetInfo) const {

  // Get instruction encoding and emit it
  auto Bits = getBinaryCodeForInstr(Inst, Fixups, SubtargetInfo);

  support::endian::write<uint32_t>(CB, Bits, llvm::endianness::little);
}

#include "L2CGenMCCodeEmitter.inc"

} // end namespace llvm

llvm::MCCodeEmitter *llvm::createL2CMCCodeEmitter(const MCInstrInfo &InstrInfo,
                                                  MCContext &Context) {
  return new L2CMCCodeEmitter(InstrInfo, Context);
}
