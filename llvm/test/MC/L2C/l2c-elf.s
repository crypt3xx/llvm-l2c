# Lesson 10b: object files. Checks the ELF header, the relocations for
# unresolved fixups, and llvm-objdump on the resolved ones.
# RUN: llvm-mc -triple=l2c -filetype=obj %s -o %t.o
# RUN: llvm-readobj -h %t.o | FileCheck --check-prefix=HDR %s
# RUN: llvm-readobj -r %t.o | FileCheck --check-prefix=REL %s
# RUN: llvm-objdump -d --no-show-raw-insn %t.o | FileCheck --check-prefix=DIS %s

# HDR:      Class: 32-bit (0x1)
# HDR-NEXT: DataEncoding: LittleEndian (0x1)
# HDR:      Machine: EM_L2C (0x4C32)
# HDR:      Flags [ (0x0)

        .text
        .globl _start
_start:
        nop                     # 0x00
loop:
        addi  a0, a0, -1        # 0x04
        bnez  a0, loop          # 0x08  resolved by the assembler
        beq   a0, a1, done      # 0x0c  resolved (forward)
        j     loop              # 0x10  resolved (backward)
        jal   helper            # 0x14  undefined: R_L2C_JUMP26
        beq   a0, a1, ext       # 0x18  undefined: R_L2C_BRANCH16
        j     helper+8          # 0x1c  undefined, with addend
done:
        ret                     # 0x20

        .data
ptr:
        .word loop              # 0x00  absolute: R_L2C_32 (local label -> .text + 4)
        .word helper+8          # 0x04  absolute: R_L2C_32 with addend

# REL:      Relocations [
# REL-NEXT:   Section ({{[0-9]+}}) .rela.text {
# REL-NEXT:     0x14 R_L2C_JUMP26 helper 0x0
# REL-NEXT:     0x18 R_L2C_BRANCH16 ext 0x0
# REL-NEXT:     0x1C R_L2C_JUMP26 helper 0x8
# REL-NEXT:   }
# REL-NEXT:   Section ({{[0-9]+}}) .rela.data {
# REL-NEXT:     0x0 R_L2C_32 .text 0x4
# REL-NEXT:     0x4 R_L2C_32 helper 0x8
# REL-NEXT:   }
# REL-NEXT: ]

# DIS:      file format elf32-l2c
# DIS:      <_start>:
# DIS-NEXT:   0: nop
# DIS:      <loop>:
# DIS-NEXT:   4: addi a0, a0, -0x1
# DIS-NEXT:   8: bnez a0, 0x4 <loop>
# DIS-NEXT:   c: beq a0, a1, 0x20 <done>
# DIS-NEXT:  10: j 0x4 <loop>
# Unresolved: the field is still 0, so the target is the instruction itself.
# DIS-NEXT:  14: jal 0x14
# DIS-NEXT:  18: beq a0, a1, 0x18
# DIS-NEXT:  1c: j 0x1c
# DIS:      <done>:
# DIS-NEXT:  20: ret
