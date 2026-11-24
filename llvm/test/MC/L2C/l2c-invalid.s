# RUN: not llvm-mc -triple=l2c %s 2>&1 | FileCheck %s

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

# ';' is a separator, not a comment (D1): "foo" becomes a new statement.
add a0, a1, a2 ; foo
# CHECK: :[[@LINE-1]]:18: error: unrecognized instruction mnemonic