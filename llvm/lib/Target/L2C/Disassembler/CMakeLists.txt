add_llvm_component_library(LLVML2CDisassembler
  L2CDisassembler.cpp

  LINK_COMPONENTS
  MC
  MCDisassembler
  L2CDesc
  L2CInfo
  Support

  ADD_TO_COMPONENT
  L2C
  )
