# Lesson 10b: range and alignment checks in applyFixup, for fixups the
# assembler resolves itself (same section).
# RUN: not llvm-mc -triple=l2c -filetype=obj %s -o /dev/null 2>&1 | FileCheck %s

        .text
start:
        beq   a0, a1, start+2
# CHECK: error: fixup value must be 4-byte aligned
        j     start+6
# CHECK: error: fixup value must be 4-byte aligned
        beq   a0, a1, far
# CHECK: error: fixup value out of range
        .space 131072
far:
        nop
