# RUN: llvm-mc -triple=l2c -show-encoding %s | FileCheck %s

# Primary and ABI register names; output always uses ABI names.
# CHECK: add a2, a0, a1 # encoding: [0xc1,0x08,0x02,0x00]
add a2, a0, a1
# CHECK: add a2, a0, a1 # encoding: [0xc1,0x08,0x02,0x00]
add r3, r1, r2
# CHECK: add zero, zero, zero # encoding: [0x01,0x00,0x00,0x00]
add r0, r0, r0
# CHECK: add fp, fp, sp # encoding: [0x41,0xef,0x1e,0x00]
add r29, r29, r30
# CHECK: add ra, s0, t7 # encoding: [0xc1,0x8f,0x10,0x00]
add r31, r17, r16

# ';' separates statements (spec delta D1).
# CHECK:      add a0, a1, a2 # encoding: [0x41,0x10,0x03,0x00]
# CHECK-NEXT: add a3, a0, a0 # encoding: [0x01,0x09,0x01,0x00]
add a0, a1, a2; add a3, a0, a0