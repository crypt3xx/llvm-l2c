// L2CAsmBackend.cpp

#include "L2CAsmBackend.h"
#include "L2CFixupKinds.h"
#include "llvm/ADT/APInt.h"
#include "llvm/MC/MCAsmInfo.h"
#include "llvm/MC/MCAssembler.h"
#include "llvm/MC/MCContext.h"
#include "llvm/MC/MCELFObjectWriter.h"
#include "llvm/MC/MCExpr.h"
#include "llvm/MC/MCObjectWriter.h"
#include "llvm/MC/MCSymbol.h"
#include "llvm/MC/MCValue.h"
#include "llvm/MC/TargetRegistry.h"
#include "llvm/Support/EndianStream.h"
#include "llvm/Support/ErrorHandling.h"
#include "llvm/Support/raw_ostream.h"
#include <cstdint>

using namespace llvm;

L2CAsmBackend::L2CAsmBackend(uint8_t OSABI)
    : MCAsmBackend(llvm::endianness::little), OSABI(OSABI) {}

static uint64_t adjustFixupValue(const MCFixup &Fixup, uint64_t Value,
                                 MCContext &Ctx) {
  switch (Fixup.getKind()) {
  default:
    llvm_unreachable("Unknown fixup kind!");
  case FK_Data_1:
  case FK_Data_2:
  case FK_Data_4:
  case FK_Data_8:
  case FK_Data_leb128:
    return Value;
  case L2C::fixup_l2c_branch16: {
    int64_t SVal = static_cast<int64_t>(Value);
    if (SVal % 4 != 0) {
      Ctx.reportError(Fixup.getLoc(), "fixup value must be 4-byte aligned");
      return 0;
    }

    if (!isInt<18>(SVal)) {
      Ctx.reportError(Fixup.getLoc(), "fixup value out of range");
      return 0;
    }

    uint16_t Out = (Value >> 2) & 0xFFFF;
    return ((Out >> 5) << 21) | ((Out & 0x1F) << 6);
  }
  case L2C::fixup_l2c_jump26: {
    if (Value % 4 != 0)
      Ctx.reportError(Fixup.getLoc(), "fixup value must be 4-byte aligned");

    if (!isInt<28>(Value))
      Ctx.reportError(Fixup.getLoc(), "fixup value out of range");

    return ((Value >> 2) & 0x3FFFFFF) << 6;
  }
  }
}

MCFixupKindInfo L2CAsmBackend::getFixupKindInfo(MCFixupKind Kind) const {
  const static MCFixupKindInfo Infos[] = {
      // This table *must* be in the order that the fixup_* kinds are defined in
      // L2CFixupKinds.h.
      //
      // name                      offset bits  flags
      {"fixup_l2c_branch16", 0, 32, 0},
      {"fixup_l2c_jump26", 0, 32, 0},
  };

  static_assert((std::size(Infos)) == L2C::NumTargetFixupKinds,
                "Not all fixup kinds added to Infos array");

  // Fixup kinds from raw relocation types and .reloc directives force
  // relocations and do not use these fields.
  if (mc::isRelocation(Kind))
    return {};

  if (Kind < FirstTargetFixupKind)
    return MCAsmBackend::getFixupKindInfo(Kind);

  assert(unsigned(Kind - FirstTargetFixupKind) < L2C::NumTargetFixupKinds &&
         "Invalid kind!");
  return Infos[Kind - FirstTargetFixupKind];
}

void L2CAsmBackend::applyFixup(const MCFragment &F, const MCFixup &Fixup,
                               const MCValue &Target, uint8_t *Data,
                               uint64_t Value, bool IsResolved) {
  // Hand unresolved fixups to the object writer (becomes a relocation)
  maybeAddReloc(F, Fixup, Target, Value, IsResolved);

  MCFixupKind Kind = Fixup.getKind();
  if (mc::isRelocation(Kind))
    return;

  MCContext &Ctx = getContext();
  // Apply any target-specific value adjustments
  uint64_t Bits = adjustFixupValue(Fixup, Value, Ctx);

  if (!Bits)
    return; // Doesn't change encoding

  MCFixupKindInfo Info = getFixupKindInfo(Kind);
  // Shift the Bits into position
  Bits <<= Info.TargetOffset;

  unsigned NumBytes = alignTo(Info.TargetSize + Info.TargetOffset, 8) / 8;
  assert(Fixup.getOffset() + NumBytes <= F.getSize() &&
         "Invalid fixup offset!");

  // For each byte of the fragment that the fixup touches, mask in the
  // bits from the fixup value.
  // For big endian cores, data fixup should be swapped.
  for (unsigned I = 0; I != NumBytes; ++I)
    Data[I] |= uint8_t((Bits >> (I * 8)) & 0xff);
}

bool L2CAsmBackend::writeNopData(raw_ostream &OS, uint64_t Count,
                                 const MCSubtargetInfo *STI) const {

  // Instructions should always be 4 bytes aligned
  OS.write_zeros(Count % 4);

  for (unsigned I = 0; I < Count / 4; ++I) {
    // NOP instruction: add zero, zero, zero
    support::endian::write<uint32_t>(OS, 0x00000001, llvm::endianness::little);
  }

  return true;
}

std::unique_ptr<MCObjectTargetWriter>
L2CAsmBackend::createObjectTargetWriter() const {
  return createL2CELFObjectWriter(OSABI);
}

MCAsmBackend *llvm::createL2CAsmBackend(const Target &T,
                                        const MCSubtargetInfo &STI,
                                        const MCRegisterInfo &MRI,
                                        const MCTargetOptions &Options) {
  uint8_t OSABI =
      MCELFObjectTargetWriter::getOSABI(STI.getTargetTriple().getOS());
  return new L2CAsmBackend(OSABI);
}