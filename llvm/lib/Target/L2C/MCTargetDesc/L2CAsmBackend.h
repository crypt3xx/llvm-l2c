// L2CAsmBackend.h

#include "MCTargetDesc/L2CMCTargetDesc.h"
#include "llvm/MC/MCAsmBackend.h"
#include "llvm/MC/MCSubtargetInfo.h"
#include <cstdint>
#include <optional>

namespace llvm {
class MCAssembler;
class MCObjectTargetWriter;
class raw_ostream;

class L2CAsmBackend : public MCAsmBackend {
  uint8_t OSABI;

public:
  L2CAsmBackend(uint8_t OSABI);
  ~L2CAsmBackend() override = default;

  MCFixupKindInfo getFixupKindInfo(MCFixupKind Kind) const override;

  void applyFixup(const MCFragment &, const MCFixup &, const MCValue &Target,
                  uint8_t *Data, uint64_t Value, bool IsResolved) override;

  std::optional<bool> evaluateFixup(const MCFragment &, MCFixup &Fixup,
                                    MCValue &, uint64_t &) override;

  bool writeNopData(raw_ostream &OS, uint64_t Count,
                    const MCSubtargetInfo *STI) const override;

  std::unique_ptr<MCObjectTargetWriter>
  createObjectTargetWriter() const override;
};
} // namespace llvm
