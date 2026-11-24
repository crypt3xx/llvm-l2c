# RUN: not llvm-mc -triple=l2c %s 2>&1 | FileCheck %s

## Lesson 4b: operand parsing and matching
add a2, a0
# CHECK: :[[@LINE-1]]:1: error: too few operands for instruction
add a2, a0, 5
# CHECK: :[[@LINE-1]]:13: error: register must be a GPR
add a2, a0, x9
# CHECK: :[[@LINE-1]]:13: error: unknown operand
foo a0
# CHECK: :[[@LINE-1]]:1: error: unrecognized instruction mnemonic
add a0 a1 a2
# CHECK: :[[@LINE-1]]:8: error: unexpected token
add a0, a1, a2 ; foo
# CHECK: :[[@LINE-1]]:18: error: unrecognized instruction mnemonic

## Lesson 7a: immediate ranges
addi a0, a0, 32768
# CHECK: :[[@LINE-1]]:14: error: immediate must be an integer in the range [-32768, 32767]
addi a0, a0, -32769
# CHECK: :[[@LINE-1]]:14: error: immediate must be an integer in the range [-32768, 32767]
addi a0, a0, a1
# CHECK: :[[@LINE-1]]:14: error: immediate must be an integer in the range [-32768, 32767]
slti a0, a0, 0xffff
# CHECK: :[[@LINE-1]]:14: error: immediate must be an integer in the range [-32768, 32767]
ori a0, a0, -1
# CHECK: :[[@LINE-1]]:13: error: immediate must be an integer in the range [0, 65535]
andi a0, a0, 65536
# CHECK: :[[@LINE-1]]:14: error: immediate must be an integer in the range [0, 65535]
lui a0, 65536
# CHECK: :[[@LINE-1]]:9: error: immediate must be an integer in the range [0, 65535]
csrr a0, 65536
# CHECK: :[[@LINE-1]]:10: error: immediate must be an integer in the range [0, 65535]
slli a0, a0, 32
# CHECK: :[[@LINE-1]]:14: error: immediate must be an integer in the range [0, 31]
srai a0, a0, -1
# CHECK: :[[@LINE-1]]:14: error: immediate must be an integer in the range [0, 31]
lw a0, 32768(sp)
# CHECK: :[[@LINE-1]]:8: error: immediate must be an integer in the range [-32768, 32767]
sw a0, -32769(sp)
# CHECK: :[[@LINE-1]]:8: error: immediate must be an integer in the range [-32768, 32767]

## Lesson 7a: operand count
lw a0, 4
# CHECK: :[[@LINE-1]]:1: error: too few operands for instruction
ecall a0
# CHECK: :[[@LINE-1]]:7: error: invalid operand for instruction
