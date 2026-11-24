# AsmParser/CMakeLists.txt

add_llvm_component_library(LLVML2CAsmParser
  L2CAsmParser.cpp

  LINK_COMPONENTS
  MC
  MCParser
  L2CDesc
  L2CInfo
  Support
  TargetParser

  ADD_TO_COMPONENT
  L2C
)
