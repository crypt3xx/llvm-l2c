# Lesson 11b: la / call / tail take a symbol (use li for constants).
# RUN: not llvm-mc -triple=l2c %s 2>&1 | FileCheck %s

la a0, 5
# CHECK: :[[@LINE-1]]:8: error: operand must be a bare symbol name
la a0, %hi(foo)
# CHECK: :[[@LINE-1]]:8: error: operand must be a bare symbol name
la a0, a1
# CHECK: :[[@LINE-1]]:8: error: operand must be a bare symbol name
call 0x100
# CHECK: :[[@LINE-1]]:6: error: operand must be a bare symbol name
call a0
# CHECK: :[[@LINE-1]]:6: error: operand must be a bare symbol name
tail %lo(foo)
# CHECK: :[[@LINE-1]]:6: error: operand must be a bare symbol name
la a0
# CHECK: :[[@LINE-1]]:1: error: too few operands for instruction
