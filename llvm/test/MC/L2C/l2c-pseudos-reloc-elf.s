# Lesson 11b: the relocations produced by the pseudos.
# RUN: llvm-mc -triple=l2c -filetype=obj %s -o %t.o
# RUN: llvm-readobj -r %t.o | FileCheck %s

        .text
        la    a0, foo           # 0x00, 0x04
        call  bar               # 0x08, 0x0c
        tail  baz+4             # 0x10, 0x14

# CHECK:      Relocations [
# CHECK-NEXT:   Section ({{[0-9]+}}) .rela.text {
# CHECK-NEXT:     0x0 R_L2C_HI16 foo 0x0
# CHECK-NEXT:     0x4 R_L2C_LO16_I foo 0x0
# CHECK-NEXT:     0x8 R_L2C_PCREL_HI16 bar 0x0
# CHECK-NEXT:     0xC R_L2C_LO16_I bar 0x0
# CHECK-NEXT:     0x10 R_L2C_PCREL_HI16 baz 0x4
# CHECK-NEXT:     0x14 R_L2C_LO16_I baz 0x4
# CHECK-NEXT:   }
# CHECK-NEXT: ]
