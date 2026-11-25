// L2C.td

include "llvm/Target/Target.td"
include "L2CRegisterInfo.td"
include "L2CInstrInfo.td"
include "L2CSystemOperands.td"

def : ProcessorModel<"generic", NoSchedModel, []>;

defm : RemapAllTargetPseudoPointerOperands<GPR>;

/**************************/
/* Define the L2C target. */
/**************************/

def L2CInstrInfo : InstrInfo {
  let guessInstructionProperties = false;
}

def L2CAsmParser : AsmParser {
  let ShouldEmitMatchRegisterAltName = true;
}

def L2CAsmWriter : AsmWriter {
  int PassSubtarget = 1;
}


def L2C : Target {
  let InstructionSet = L2CInstrInfo;
  let AssemblyParsers = [L2CAsmParser];
  let AssemblyWriters = [L2CAsmWriter];
  let AllowRegisterRenaming = true;
}
