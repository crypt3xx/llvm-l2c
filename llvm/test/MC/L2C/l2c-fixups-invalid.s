# Lesson 10a: symbols are accepted only where a fixup exists (branch and jump
# targets). Everything else still requires a constant until Lesson 11.
# RUN: not llvm-mc -triple=l2c %s 2>&1 | FileCheck %s

addi a0, a0, foo
# CHECK: :[[@LINE-1]]:14: error: immediate must be an integer in the range [-32768, 32767]
sw a0, foo(a1)
# CHECK: :[[@LINE-1]]:8: error: immediate must be an integer in the range [-32768, 32767]
lui a0, foo
# CHECK: :[[@LINE-1]]:9: error: immediate must be an integer in the range [0, 65535]
slli a0, a0, foo
# CHECK: :[[@LINE-1]]:14: error: immediate must be an integer in the range [0, 31]
li a0, foo
# CHECK: :[[@LINE-1]]:8: error: immediate must be an integer in the range [-2147483648, 4294967295]
csrr a0, foo
# CHECK: :[[@LINE-1]]:10: error: operand must be a valid system register name or an integer in the range [0, 65535]
beq a0, a1, a0
# CHECK: :[[@LINE-1]]:13: error: branch target must be a multiple of 4 in the range [-131072, 131068]
j ra
# CHECK: :[[@LINE-1]]:3: error: jump target must be a multiple of 4 in the range [-134217728, 134217724]
