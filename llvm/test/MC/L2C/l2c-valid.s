# RUN: llvm-mc -triple=l2c %s | FileCheck %s

# Primary and ABI register names; output always uses ABI names.
# CHECK: add a2, a0, a1
add a2, a0, a1
# CHECK: add a2, a0, a1
add r3, r1, r2
# CHECK: add zero, zero, zero
add r0, r0, r0
# CHECK: add fp, fp, sp
add r29, r29, r30
# CHECK: add ra, s0, t7
add r31, r17, r16

# ';' separates statements (spec delta D1).
# CHECK:      add a0, a1, a2
# CHECK-NEXT: add a3, a0, a0
add a0, a1, a2; add a3, a0, a0