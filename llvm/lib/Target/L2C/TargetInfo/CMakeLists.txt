add_llvm_component_library(LLVML2CInfo
  L2CTargetInfo.cpp

  LINK_COMPONENTS
  MC
  Support

  ADD_TO_COMPONENT
  L2C
)
