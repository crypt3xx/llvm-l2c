# MCTargetDesc/CMakeLists.txt

add_llvm_component_library(LLVML2CDesc
  L2CMCTargetDesc.cpp
  L2CMCAsmInfo.cpp
  L2CInstPrinter.cpp
  L2CMCCodeEmitter.cpp
  L2CBaseInfo.cpp

  LINK_COMPONENTS
  MC
  Support
  L2CInfo
  TargetParser

  ADD_TO_COMPONENT
  L2C
)
