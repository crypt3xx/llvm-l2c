add_llvm_component_group(L2C)

#### TableGen ####

set(LLVM_TARGET_DEFINITIONS L2C.td)

llvm_tablegen(L2CGenRegisterInfo.inc -gen-register-info)
llvm_tablegen(L2CGenInstrInfo.inc -gen-instr-info)
llvm_tablegen(L2CGenSubtargetInfo.inc -gen-subtarget)
llvm_tablegen(L2CGenAsmMatcher.inc -gen-asm-matcher)
llvm_tablegen(L2CGenAsmWriter.inc -gen-asm-writer)
llvm_tablegen(L2CGenMCCodeEmitter.inc -gen-emitter)
llvm_tablegen(L2CGenDisassemblerTables.inc -gen-disassembler)

add_public_tablegen_target(L2CCommonTableGen)


add_llvm_target(L2CCodeGen
  L2CTargetMachine.cpp

  LINK_COMPONENTS
  Core
  MC
  Support
  Target
  L2CDesc
  L2CInfo

  ADD_TO_COMPONENT
  L2C
)

add_subdirectory(MCTargetDesc)
add_subdirectory(AsmParser)
add_subdirectory(TargetInfo)
add_subdirectory(Disassembler)
