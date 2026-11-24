// L2CDisassembler.cpp

#include "MCTargetDesc/L2CMCTargetDesc.h"
#include "TargetInfo/L2CTargetInfo.h"
#include "llvm/MC/MCDecoder.h"
#include "llvm/MC/MCDecoderOps.h"
#include "llvm/MC/MCInst.h"
#include "llvm/MC/MCRegister.h"
#include "llvm/MC/MCSubtargetInfo.h"
#include "llvm/MC/TargetRegistry.h"
#include "llvm/Support/Compiler.h"
#include "llvm/Support/Debug.h"
#include "llvm/Support/MathExtras.h"

using namespace llvm;
using namespace llvm::MCD;

#define DEBUG_TYPE "l2c-disassembler"

typedef MCDisassembler::DecodeStatus DecodeStatus;

namespace {

class L2CDisassembler : public MCDisassembler {
public:
  L2CDisassembler(const MCSubtargetInfo &STI, MCContext &Ctx)
      : MCDisassembler(STI, Ctx) {}

  DecodeStatus getInstruction(MCInst &Instr, uint64_t &Size,
                              ArrayRef<uint8_t> Bytes, uint64_t Address,
                              raw_ostream &CStream) const override;
};

} // end anonymous namespace

static MCDisassembler *createL2CDisassembler(const Target &T,
                                             const MCSubtargetInfo &STI,
                                             MCContext &Ctx) {
  return new L2CDisassembler(STI, Ctx);
}

extern "C" LLVM_ABI LLVM_EXTERNAL_VISIBILITY void
LLVMInitializeL2CDisassembler() { // NOLINT(readability-identifier-naming)
  TargetRegistry::RegisterMCDisassembler(getTheL2CTarget(),
                                         createL2CDisassembler);
}

static DecodeStatus
DecodeGPRRegisterClass( // NOLINT(readability-identifier-naming)
    MCInst &Inst, unsigned RegNo, uint64_t /*Address*/,
    const MCDisassembler * /*Decoder*/) {

  if (RegNo > 31)
    return MCDisassembler::Fail;

  static_assert(L2C::R31 == L2C::R0 + 31, "GPR enum must be contiguous");

  MCRegister Reg = L2C::R0 + RegNo;
  Inst.addOperand(MCOperand::createReg(Reg));

  return MCDisassembler::Success;
}

static DecodeStatus decodeSImm16(MCInst &Inst, unsigned Imm, uint64_t,
                                 const MCDisassembler *) {
  Inst.addOperand(MCOperand::createImm(SignExtend64<16>(Imm)));
  return MCDisassembler::Success;
}

static DecodeStatus decodeUImm16(MCInst &Inst, unsigned Imm, uint64_t,
                                 const MCDisassembler *) {
  Inst.addOperand(MCOperand::createImm(Imm));
  return MCDisassembler::Success;
}

static DecodeStatus decodeUImm5(MCInst &Inst, unsigned Imm, uint64_t,
                                const MCDisassembler *) {
  Inst.addOperand(MCOperand::createImm(Imm));
  return MCDisassembler::Success;
}

template <int N>
static DecodeStatus decodeSImmLsl2(MCInst &Inst, unsigned Imm, uint64_t,
                                   const MCDisassembler *) {
  Inst.addOperand(MCOperand::createImm(SignExtend64<N>(Imm) * 4));
  return MCDisassembler::Success;
}

#include "L2CGenDisassemblerTables.inc"

static DecodeStatus readInstruction32(ArrayRef<uint8_t> Bytes, uint64_t &Size,
                                      uint32_t &Insn) {

  // We want to read exactly 4 bytes of data.
  if (Bytes.size() < 4) {
    Size = 0;
    return MCDisassembler::Fail;
  }

  // Encoded as little-endian 32-bit word in the stream.
  Insn = support::endian::read32le(Bytes.data());

  return MCDisassembler::Success;
}

DecodeStatus L2CDisassembler::getInstruction(MCInst &Instr, uint64_t &Size,
                                             ArrayRef<uint8_t> Bytes,
                                             uint64_t Address,
                                             raw_ostream & /*CStream*/) const {
  uint32_t Insn;

  DecodeStatus Result = readInstruction32(Bytes, Size, Insn);

  if (Result == MCDisassembler::Fail)
    return MCDisassembler::Fail;

  Size = 4;

  // Call auto-generated decoder function
  return decodeInstruction(DecoderTable32, Instr, Insn, Address, this, STI);
}
