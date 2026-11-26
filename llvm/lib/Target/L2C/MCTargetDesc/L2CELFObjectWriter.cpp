// L2CELFObjectWriter.cpp

#include "L2CFixupKinds.h"
#include "MCTargetDesc/L2CMCTargetDesc.h"
#include "llvm/BinaryFormat/ELF.h"
#include "llvm/MC/MCELFObjectWriter.h"
#include "llvm/MC/MCFixup.h"
#include "llvm/MC/MCObjectWriter.h"
#include "llvm/MC/MCValue.h"
#include "llvm/Support/ErrorHandling.h"

using namespace llvm;

namespace {
class L2CELFObjectWriter : public MCELFObjectTargetWriter {
public:
  L2CELFObjectWriter(uint8_t OSABI);
  ~L2CELFObjectWriter() override;

  unsigned getRelocType(const MCFixup &Fixup, const MCValue &Target,
                        bool IsPCRel) const override;
};
} // end anonymous namespace

L2CELFObjectWriter::L2CELFObjectWriter(uint8_t OSABI)
    : MCELFObjectTargetWriter(/*Is64Bit=*/false, OSABI, ELF::EM_L2C,
                              /*HasRelocationAddend=*/true) {}

L2CELFObjectWriter::~L2CELFObjectWriter() = default;

unsigned L2CELFObjectWriter::getRelocType(const MCFixup &Fixup,
                                          const MCValue &Target,
                                          bool IsPCRel) const {
  auto Kind = Fixup.getKind();

  // Extract the relocation type from the fixup kind
  if (mc::isRelocation(Kind))
    return Kind;

  if (IsPCRel) {
    switch (Kind) {

    case L2C::fixup_l2c_branch16:
      return ELF::R_L2C_BRANCH16;

    case L2C::fixup_l2c_jump26:
      return ELF::R_L2C_JUMP26;

    default: {
      reportError(Fixup.getLoc(), "unsupported relocation type");
      return ELF::R_L2C_NONE;
    }
    }
  }

  switch (Kind) {

  case FK_Data_4:
    return ELF::R_L2C_32;

  default: {
    reportError(Fixup.getLoc(), "unsupported relocation type");
    return ELF::R_L2C_NONE;
  }
  }
}

std::unique_ptr<MCObjectTargetWriter>
llvm::createL2CELFObjectWriter(uint8_t OSABI) {
  return std::make_unique<L2CELFObjectWriter>(OSABI);
}