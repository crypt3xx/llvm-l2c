# Lesson 10a: label operands on branches and jumps create fixups.
# The text streamer cannot resolve them, so it prints each fixup under the
# instruction. Resolution is checked in Lesson 10b, on object files.
# RUN: llvm-mc -triple=l2c -show-encoding %s | FileCheck %s

# CHECK-LABEL: foo:
foo:
beq a0, a1, foo
# CHECK: beq a0, a1, foo
# CHECK-NEXT: fixup A - offset: 0, value: foo, kind: fixup_l2c_branch16
bne a0, a1, foo
# CHECK: bne a0, a1, foo
# CHECK-NEXT: fixup A - offset: 0, value: foo, kind: fixup_l2c_branch16
blt a0, a1, foo
# CHECK: blt a0, a1, foo
# CHECK-NEXT: fixup A - offset: 0, value: foo, kind: fixup_l2c_branch16
bge a0, a1, foo
# CHECK: bge a0, a1, foo
# CHECK-NEXT: fixup A - offset: 0, value: foo, kind: fixup_l2c_branch16
bltu a0, a1, foo
# CHECK: bltu a0, a1, foo
# CHECK-NEXT: fixup A - offset: 0, value: foo, kind: fixup_l2c_branch16
bgeu a0, a1, foo
# CHECK: bgeu a0, a1, foo
# CHECK-NEXT: fixup A - offset: 0, value: foo, kind: fixup_l2c_branch16

# Symbol plus constant offset.
beq a0, a1, foo+8
# CHECK: beq a0, a1, foo+8
# CHECK-NEXT: fixup A - offset: 0, value: foo+8, kind: fixup_l2c_branch16

# Aliases keep working with label operands.
beqz a0, foo
# CHECK: beqz a0, foo
# CHECK-NEXT: fixup A - offset: 0, value: foo, kind: fixup_l2c_branch16
bgtz a0, foo
# CHECK: bgtz a0, foo
# CHECK-NEXT: fixup A - offset: 0, value: foo, kind: fixup_l2c_branch16
bgt a0, a1, foo
# CHECK: blt a1, a0, foo
# CHECK-NEXT: fixup A - offset: 0, value: foo, kind: fixup_l2c_branch16

# Jumps use the 26-bit fixup. bar is a forward reference.
j bar
# CHECK: j bar
# CHECK-NEXT: fixup A - offset: 0, value: bar, kind: fixup_l2c_jump26
jal bar
# CHECK: jal bar
# CHECK-NEXT: fixup A - offset: 0, value: bar, kind: fixup_l2c_jump26
j foo
# CHECK: j foo
# CHECK-NEXT: fixup A - offset: 0, value: foo, kind: fixup_l2c_jump26

# CHECK-LABEL: bar:
bar:
nop
# CHECK: nop
# CHECK-NOT: fixup
