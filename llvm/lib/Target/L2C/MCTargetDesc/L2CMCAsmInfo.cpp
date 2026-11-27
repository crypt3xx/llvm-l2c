// L2CMCAsmInfo.cpp

#include "L2CMCAsmInfo.h"
#include "llvm/ADT/StringRef.h"
#include "llvm/ADT/StringSwitch.h"
#include "llvm/BinaryFormat/Dwarf.h"
#include "llvm/MC/MCExpr.h"
#include "llvm/MC/MCStreamer.h"
#include "llvm/Support/ErrorHandling.h"
#include "llvm/TargetParser/Triple.h"

using namespace llvm;

void L2CMCAsmInfo::anchor() {}

L2CMCAsmInfo::L2CMCAsmInfo(const Triple &, const MCTargetOptions &Options)
    : MCAsmInfoELF(Options) {
  IsLittleEndian = true;
  CodePointerSize = CalleeSaveStackSlotSize = 4;
  CommentString = "#";
  AlignmentIsInBytes = false;
  SupportsDebugInformation = true;
  Data16bitsDirective = "\t.half\t";
  Data32bitsDirective = "\t.word\t";
}

void L2CMCAsmInfo::printSpecifierExpr(raw_ostream &OS,
                                      const MCSpecifierExpr &Expr) const {
  OS << '%';
  OS << L2C::getSpecifierName(static_cast<L2C::Specifier>(Expr.getSpecifier()));
  OS << '(';
  printExpr(OS, *Expr.getSubExpr());
  OS << ')';
}

L2C::Specifier L2C::parseSpecifierName(StringRef Name) {
  return StringSwitch<Specifier>(Name)
      .Case("hi", S_HI)
      .Case("lo", S_LO)
      .Case("pcrel_hi", S_PCREL_HI)
      .Default(S_None);
}

StringRef L2C::getSpecifierName(L2C::Specifier S) {
  switch (S) {
  case L2C::S_HI:
    return "hi";
  case L2C::S_LO:
    return "lo";
  case L2C::S_PCREL_HI:
    return "pcrel_hi";
  default:
    llvm_unreachable("invalid specifier!");
  }
}