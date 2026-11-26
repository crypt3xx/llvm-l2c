# Lesson 10b: fixups that have no L2C relocation type (spec §10.1 only
# defines R_L2C_32 for data) must be rejected by getRelocType.
# RUN: not llvm-mc -triple=l2c -filetype=obj %s -o /dev/null 2>&1 | FileCheck %s

        .data
        .half ext
# CHECK: error: unsupported relocation type
        .byte ext
# CHECK: error: unsupported relocation type
        .word ext - .
# CHECK: error: unsupported relocation type
