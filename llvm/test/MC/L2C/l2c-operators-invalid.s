# Lesson 11a: each operator is accepted only by its own instructions.
# RUN: not llvm-mc -triple=l2c %s 2>&1 | FileCheck %s

# Wrong operator for the instruction
ori a0, a0, %lo(foo)
# CHECK: :[[@LINE-1]]:13: error: immediate must be an integer in the range [0, 65535]
addi a0, a0, %hi(foo)
# CHECK: :[[@LINE-1]]:14: error: immediate must be an integer in the range [-32768, 32767]
sw a0, %pcrel_hi(foo)(a1)
# CHECK: :[[@LINE-1]]:8: error: immediate must be an integer in the range [-32768, 32767]
lui a0, %lo(foo)
# CHECK: :[[@LINE-1]]:9: error: operand must be a symbol with %hi specifier or an integer in the range [0, 65535]
auipc a0, %hi(foo)
# CHECK: :[[@LINE-1]]:11: error: operand must be a symbol with %pcrel_hi specifier or an integer in the range [0, 65535]
beq a0, a1, %lo(foo)
# CHECK: :[[@LINE-1]]:13: error: branch target must be a multiple of 4 in the range [-131072, 131068]
j %hi(foo)
# CHECK: :[[@LINE-1]]:3: error: jump target must be a multiple of 4 in the range [-134217728, 134217724]

# A bare symbol needs an operator
lui a0, foo
# CHECK: :[[@LINE-1]]:9: error: operand must be a symbol with %hi specifier or an integer in the range [0, 65535]
auipc a0, foo
# CHECK: :[[@LINE-1]]:11: error: operand must be a symbol with %pcrel_hi specifier or an integer in the range [0, 65535]

# Syntax errors
addi a0, a0, %foo(x)
# CHECK: :[[@LINE-1]]:15: error: invalid relocation specifier
lw a0, %pcrel_lo(foo)(t0)
# CHECK: :[[@LINE-1]]:9: error: invalid relocation specifier
lui a0, %hi foo
# CHECK: :[[@LINE-1]]:13: error: expected '('
lui a0, %
# CHECK: :[[@LINE-1]]:10: error: expected relocation specifier
auipc a0, %pcrel_hi(5)
# CHECK: :[[@LINE-1]]:11: error: %pcrel_hi operand must be a symbol
