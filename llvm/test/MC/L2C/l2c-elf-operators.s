# Lesson 11a: every operator becomes a relocation, even for a label in the
# same section (the linker needs S and P separately for %pcrel_hi, and the
# absolute address for %hi/%lo).
# RUN: llvm-mc -triple=l2c -filetype=obj %s -o %t.o
# RUN: llvm-readobj -r %t.o | FileCheck %s

        .text
near:
        lui   a0, %hi(foo)              # 0x00
        addi  a0, a0, %lo(foo)          # 0x04
        lw    a1, %lo(foo+8)(a0)        # 0x08
        sw    a1, %lo(foo)(a0)          # 0x0c
        auipc t0, %pcrel_hi(foo)        # 0x10
        jalr  ra, t0, %lo(foo)          # 0x14
        auipc t1, %pcrel_hi(near)       # 0x18
        lui   a2, %hi(near)             # 0x1c

# CHECK:      Relocations [
# CHECK-NEXT:   Section ({{[0-9]+}}) .rela.text {
# CHECK-NEXT:     0x0 R_L2C_HI16 foo 0x0
# CHECK-NEXT:     0x4 R_L2C_LO16_I foo 0x0
# CHECK-NEXT:     0x8 R_L2C_LO16_I foo 0x8
# CHECK-NEXT:     0xC R_L2C_LO16_S foo 0x0
# CHECK-NEXT:     0x10 R_L2C_PCREL_HI16 foo 0x0
# CHECK-NEXT:     0x14 R_L2C_LO16_I foo 0x0
# CHECK-NEXT:     0x18 R_L2C_PCREL_HI16 .text 0x0
# CHECK-NEXT:     0x1C R_L2C_HI16 .text 0x0
# CHECK-NEXT:   }
# CHECK-NEXT: ]
