# Lesson 11b: la / call / tail expand into operator pairs (spec D10).
# RUN: llvm-mc -triple=l2c -show-encoding %s | FileCheck %s

la a0, foo
# CHECK: lui a0, %hi(foo)
# CHECK-NEXT: fixup A - offset: 0, value: %hi(foo), kind: fixup_l2c_hi16
# CHECK-NEXT: addi a0, a0, %lo(foo)
# CHECK-NEXT: fixup A - offset: 0, value: %lo(foo), kind: fixup_l2c_lo16_i

la t1, foo+8
# CHECK: lui t1, %hi(foo+8)
# CHECK-NEXT: fixup A - offset: 0, value: %hi(foo+8), kind: fixup_l2c_hi16
# CHECK-NEXT: addi t1, t1, %lo(foo+8)
# CHECK-NEXT: fixup A - offset: 0, value: %lo(foo+8), kind: fixup_l2c_lo16_i

call bar
# CHECK: auipc ra, %pcrel_hi(bar)
# CHECK-NEXT: fixup A - offset: 0, value: %pcrel_hi(bar), kind: fixup_l2c_pcrel_hi16
# CHECK-NEXT: jalr ra, ra, %lo(bar)
# CHECK-NEXT: fixup A - offset: 0, value: %lo(bar), kind: fixup_l2c_lo16_i

tail baz
# CHECK: auipc t0, %pcrel_hi(baz)
# CHECK-NEXT: fixup A - offset: 0, value: %pcrel_hi(baz), kind: fixup_l2c_pcrel_hi16
# CHECK-NEXT: jalr zero, t0, %lo(baz)
# CHECK-NEXT: fixup A - offset: 0, value: %lo(baz), kind: fixup_l2c_lo16_i
