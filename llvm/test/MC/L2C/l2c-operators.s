# Lesson 11a: relocation operators %hi, %lo, %pcrel_hi (spec D9-D11).
# With a symbol they create fixups; with a constant they are folded by the
# parser.
# RUN: llvm-mc -triple=l2c -show-encoding %s | FileCheck %s

# Absolute address: lui + addi (both halves of the same symbol)
lui a0, %hi(foo)
# CHECK: lui a0, %hi(foo)
# CHECK-NEXT: fixup A - offset: 0, value: %hi(foo), kind: fixup_l2c_hi16
addi a0, a0, %lo(foo)
# CHECK: addi a0, a0, %lo(foo)
# CHECK-NEXT: fixup A - offset: 0, value: %lo(foo), kind: fixup_l2c_lo16_i
lui a0, %hi(foo+4)
# CHECK: lui a0, %hi(foo+4)
# CHECK-NEXT: fixup A - offset: 0, value: %hi(foo+4), kind: fixup_l2c_hi16

# %lo is accepted by every sign-extended 16-bit operand
slti a0, a1, %lo(foo)
# CHECK: slti a0, a1, %lo(foo)
# CHECK-NEXT: fixup A - offset: 0, value: %lo(foo), kind: fixup_l2c_lo16_i
jalr ra, t0, %lo(foo)
# CHECK: jalr ra, t0, %lo(foo)
# CHECK-NEXT: fixup A - offset: 0, value: %lo(foo), kind: fixup_l2c_lo16_i

# Loads use the I-format field, stores the split B-format field
lw a1, %lo(foo)(a0)
# CHECK: lw a1, %lo(foo)(a0)
# CHECK-NEXT: fixup A - offset: 0, value: %lo(foo), kind: fixup_l2c_lo16_i
lbu a1, %lo(foo+3)(a0)
# CHECK: lbu a1, %lo(foo+3)(a0)
# CHECK-NEXT: fixup A - offset: 0, value: %lo(foo+3), kind: fixup_l2c_lo16_i
sw a1, %lo(foo)(a0)
# CHECK: sw a1, %lo(foo)(a0)
# CHECK-NEXT: fixup A - offset: 0, value: %lo(foo), kind: fixup_l2c_lo16_s
sb a1, %lo(foo)(a0)
# CHECK: sb a1, %lo(foo)(a0)
# CHECK-NEXT: fixup A - offset: 0, value: %lo(foo), kind: fixup_l2c_lo16_s

# PC-relative (page-based auipc): the low half is the same %lo
auipc t0, %pcrel_hi(foo)
# CHECK: auipc t0, %pcrel_hi(foo)
# CHECK-NEXT: fixup A - offset: 0, value: %pcrel_hi(foo), kind: fixup_l2c_pcrel_hi16
auipc t0, %pcrel_hi(foo-8)
# CHECK: auipc t0, %pcrel_hi(foo-8)
# CHECK-NEXT: fixup A - offset: 0, value: %pcrel_hi(foo-8), kind: fixup_l2c_pcrel_hi16

# Constants are folded: %hi rounds, %lo is sign-extended
lui a0, %hi(0x12345678)
# CHECK: lui a0, 4660
# CHECK-NOT: fixup
addi a0, a0, %lo(0x12345678)
# CHECK: addi a0, a0, 22136
# CHECK-NOT: fixup
lui a0, %hi(0x12348000)
# CHECK: lui a0, 4661
# CHECK-NOT: fixup
addi a0, a0, %lo(0x12348000)
# CHECK: addi a0, a0, -32768
# CHECK-NOT: fixup
lui a0, %hi(0xFFFFFFFF)
# CHECK: lui a0, 0
# CHECK-NOT: fixup
addi a0, a0, %lo(0xFFFFFFFF)
# CHECK: addi a0, a0, -1
# CHECK-NOT: fixup

# A .set symbol defined earlier is a constant too
.set ADDR, 0x1FFFF
lui a0, %hi(ADDR)
# CHECK: lui a0, 2
# CHECK-NOT: fixup
addi a0, a0, %lo(ADDR)
# CHECK: addi a0, a0, -1
# CHECK-NOT: fixup
nop
# CHECK: nop
