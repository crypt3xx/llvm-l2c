// L2CInstPrinter.cpp

#include "L2CInstPrinter.h"
#include "L2CBaseInfo.h"
#include "L2CMCTargetDesc.h"
#include "llvm/MC/MCAsmInfo.h"
#include "llvm/MC/MCInst.h"

using namespace llvm;

#define DEBUG_TYPE "asm-printer"

// Include the auto-generated portion of the assembly writer.
#include "L2CGenAsmWriter.inc"

L2CInstPrinter::L2CInstPrinter(const MCAsmInfo &MAI, const MCInstrInfo &MII,
                               const MCRegisterInfo &MRI)
    : MCInstPrinter(MAI, MII, MRI) {}

void L2CInstPrinter::printInst(const MCInst *MI, uint64_t Address,
                               StringRef Annot, const MCSubtargetInfo &STI,
                               raw_ostream &O) {
  printInstruction(MI, Address, STI, O);
  printAnnotation(O, Annot);
}

void L2CInstPrinter::printRegName(raw_ostream &O, MCRegister Reg) {
  markup(O, Markup::Register) << getRegisterName(Reg);
}

void L2CInstPrinter::printOperand(const MCInst *MI, unsigned OpNo,
                                  const MCSubtargetInfo &STI, raw_ostream &O) {
  const MCOperand &MO = MI->getOperand(OpNo);

  if (MO.isReg()) {
    printRegName(O, MO.getReg());
    return;
  }

  if (MO.isImm()) {
    printImm(MI, OpNo, STI, O);
    return;
  }

  assert(MO.isExpr() && "Unknown operand kind in printOperand");

  MAI.printExpr(O, *MO.getExpr());
}

void L2CInstPrinter::printBranchOperand(const MCInst *MI, uint64_t Address,
                                        unsigned OpNo,
                                        const MCSubtargetInfo &STI,
                                        raw_ostream &O) {
  const MCOperand &MO = MI->getOperand(OpNo);

  // A label or other expression: print it as is
  if (!MO.isImm())
    return printOperand(MI, OpNo, STI, O);

  if (PrintBranchImmAsAddress) {
    // Offsets are relative to the instruction itself, so the target is Address
    // + offset. Note: must truncate to 32 bits (L2C addresses wrap)
    uint32_t Target = static_cast<uint32_t>(Address + MO.getImm());
    markup(O, Markup::Target) << formatHex(static_cast<uint64_t>(Target));
    return;
  }

  // Default (llvm-mc): print the byte offset, exactly like any immediate
  printImm(MI, OpNo, STI, O);
}

void L2CInstPrinter::printCSRSystemRegister(const MCInst *MI, unsigned OpNo,
                                            const MCSubtargetInfo &STI,
                                            raw_ostream &O) {
  unsigned Imm = MI->getOperand(OpNo).getImm();
  const L2CSysReg::SysReg *Reg = L2CSysReg::lookupSysRegByEncoding(Imm);

  // If it's a csrw instr and the sysreg is readonly print it as a number
  if (MI->getOpcode() == L2C::CSRW && Reg && Reg->ReadOnly) {
    markup(O, Markup::Immediate) << formatImm(Imm);
    return;
  }

  if (Reg) {
    markup(O, Markup::Register) << L2CSysReg::getSysRegStr(Reg->Name);
    return;
  }

  markup(O, Markup::Immediate) << formatImm(Imm);
}

void L2CInstPrinter::printImm(const MCInst *MI, unsigned OpNo,
                              const MCSubtargetInfo &STI, raw_ostream &O) {
  const MCOperand &Op = MI->getOperand(OpNo);
  int64_t Imm = Op.getImm();
  markup(O, Markup::Immediate) << formatImm(Imm);
}

const char *L2CInstPrinter::getRegisterName(MCRegister Reg) {
  return getRegisterName(Reg, L2C::ABIRegAltName);
}