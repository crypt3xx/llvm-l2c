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
# CHECK: :[[@LINE-1]]:10: error: operand must be a valid system register name or an integer in the range [0, 65535]
slli a0, a0, 32
# CHECK: :[[@LINE-1]]:14: error: immediate must be an integer in the range [0, 31]
srai a0, a0, -1
# CHECK: :[[@LINE-1]]:14: error: immediate must be an integer in the range [0, 31]
lw a0, 32768(sp)
# CHECK: :[[@LINE-1]]:8: error: immediate must be an integer in the range [-32768, 32767]
sw a0, -32769(sp)
# CHECK: :[[@LINE-1]]:8: error: immediate must be an integer in the range [-32768, 32767]

## Lesson 7a/7b: operand count
lw a0, 4
# CHECK: :[[@LINE-1]]:1: error: too few operands for instruction
beq a0, a1
# CHECK: :[[@LINE-1]]:1: error: too few operands for instruction
ecall a0
# CHECK: :[[@LINE-1]]:7: error: invalid operand for instruction

## Lesson 7b: branch and jump targets (bytes, multiple of 4)
beq a0, a1, 6
# CHECK: :[[@LINE-1]]:13: error: branch target must be a multiple of 4 in the range [-131072, 131068]
bne a0, a1, 131072
# CHECK: :[[@LINE-1]]:13: error: branch target must be a multiple of 4 in the range [-131072, 131068]
blt a0, a1, -131076
# CHECK: :[[@LINE-1]]:13: error: branch target must be a multiple of 4 in the range [-131072, 131068]
jal 2
# CHECK: :[[@LINE-1]]:5: error: jump target must be a multiple of 4 in the range [-134217728, 134217724]
j 134217728
# CHECK: :[[@LINE-1]]:3: error: jump target must be a multiple of 4 in the range [-134217728, 134217724]
j -134217732
# CHECK: :[[@LINE-1]]:3: error: jump target must be a multiple of 4 in the range [-134217728, 134217724]
jal a0, 8
# CHECK: :[[@LINE-1]]:5: error: jump target must be a multiple of 4 in the range [-134217728, 134217724]
jalr a0, a1, 32768
# CHECK: :[[@LINE-1]]:14: error: immediate must be an integer in the range [-32768, 32767]
jalr a0, 0(a1)
# CHECK: :[[@LINE-1]]:10: error: register must be a GPR

## Lesson 8: CSR operands
csrr a0, foo
# CHECK: :[[@LINE-1]]:10: error: operand must be a valid system register name or an integer in the range [0, 65535]
csrr a0, -1
# CHECK: :[[@LINE-1]]:10: error: operand must be a valid system register name or an integer in the range [0, 65535]
csrw foo, a0
# CHECK: :[[@LINE-1]]:6: error: operand must be a valid system register name or an integer in the range [0, 65535]
csrw a0, a0
# CHECK: :[[@LINE-1]]:6: error: operand must be a valid system register name or an integer in the range [0, 65535]
csrr a0, a1
# CHECK: :[[@LINE-1]]:10: error: operand must be a valid system register name or an integer in the range [0, 65535]
csrr a0, Status
# CHECK: :[[@LINE-1]]:10: error: operand must be a valid system register name or an integer in the range [0, 65535]
csrw cycle, a0
# CHECK: :[[@LINE-1]]:6: error: cannot write read-only CSR 'cycle'
csrw ip, a0
# CHECK: :[[@LINE-1]]:6: error: cannot write read-only CSR 'ip'
csrw instreth, t0
# CHECK: :[[@LINE-1]]:6: error: cannot write read-only CSR 'instreth'

## Lesson 9: aliases and pseudo-instructions
nop a0
# CHECK: :[[@LINE-1]]:5: error: invalid operand for instruction
ret a0
# CHECK: :[[@LINE-1]]:5: error: invalid operand for instruction
mv a0, 5
# CHECK: :[[@LINE-1]]:8: error: register must be a GPR
beqz a0, 6
# CHECK: :[[@LINE-1]]:10: error: branch target must be a multiple of 4 in the range [-131072, 131068]
bgt a0, a1, 131072
# CHECK: :[[@LINE-1]]:13: error: branch target must be a multiple of 4 in the range [-131072, 131068]
li a0, a1
# CHECK: :[[@LINE-1]]:8: error: immediate must be an integer in the range [-2147483648, 4294967295]
li a0, 4294967296
# CHECK: :[[@LINE-1]]:8: error: immediate must be an integer in the range [-2147483648, 4294967295]
li a0, -2147483649
# CHECK: :[[@LINE-1]]:8: error: immediate must be an integer in the range [-2147483648, 4294967295]
not a0, 5
# CHECK: :[[@LINE-1]]:9: error: register must be a GPR
