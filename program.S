.option norvc
.option norelax

.section .text
.globl _start

_start:
    addi x31, x0, 0          # Test status: 0 = pass

# ------------------------------------------------------------
# OP-IMM instructions
# ------------------------------------------------------------

    addi x1, x0, 10
    addi x2, x0, -3
    addi x3, x1, -3
    addi x4, x0, 7
    bne  x3, x4, fail

    slli x3, x1, 2           # 10 << 2 = 40
    addi x4, x0, 40
    bne  x3, x4, fail

    slti x3, x2, 0           # -3 < 0
    addi x4, x0, 1
    bne  x3, x4, fail

    sltiu x3, x2, 1          # 0xfffffffd < 1 unsigned = false
    bne   x3, x0, fail

    xori x3, x1, 15          # 10 XOR 15 = 5
    addi x4, x0, 5
    bne  x3, x4, fail

    srli x3, x2, 1           # 0xfffffffd >> 1 = 0x7ffffffe
    lui  x4, 0x80000
    addi x4, x4, -2
    bne  x3, x4, fail

    srai x3, x2, 1           # -3 >> 1 = -2
    addi x4, x0, -2
    bne  x3, x4, fail

    ori  x3, x1, 5           # 10 OR 5 = 15
    addi x4, x0, 15
    bne  x3, x4, fail

    andi x3, x1, 6           # 10 AND 6 = 2
    addi x4, x0, 2
    bne  x3, x4, fail

# ------------------------------------------------------------
# Register-register instructions
# ------------------------------------------------------------

    addi x1, x0, 20
    addi x2, x0, 6

    add  x3, x1, x2          # 26
    addi x4, x0, 26
    bne  x3, x4, fail

    sub  x3, x1, x2          # 14
    addi x4, x0, 14
    bne  x3, x4, fail

    sll  x3, x2, x2          # 6 << 6 = 384
    addi x4, x0, 384
    bne  x3, x4, fail

    slt  x3, x2, x1          # 6 < 20 signed
    addi x4, x0, 1
    bne  x3, x4, fail

    addi x5, x0, -1
    sltu x3, x1, x5          # 20 < 0xffffffff unsigned
    bne  x3, x4, fail

    xor  x3, x1, x2          # 20 XOR 6 = 18
    addi x4, x0, 18
    bne  x3, x4, fail

    srl  x3, x1, x2          # 20 >> 6 = 0
    bne  x3, x0, fail

    addi x5, x0, -16
    addi x2, x0, 2
    sra  x3, x5, x2          # -16 >> 2 = -4
    addi x4, x0, -4
    bne  x3, x4, fail

    addi x1, x0, 10
    addi x2, x0, 5

    or   x3, x1, x2          # 10 OR 5 = 15
    addi x4, x0, 15
    bne  x3, x4, fail

    and  x3, x1, x2          # 10 AND 5 = 0
    bne  x3, x0, fail

# ------------------------------------------------------------
# LUI
# ------------------------------------------------------------

    lui  x5, 0x12345
    lui  x6, 0x12345
    bne  x5, x6, fail

# ------------------------------------------------------------
# AUIPC
#
# Consecutive AUIPC instructions should differ by four.
# ------------------------------------------------------------

    auipc x5, 0
    auipc x6, 0
    addi  x5, x5, 4
    bne   x5, x6, fail

# ------------------------------------------------------------
# Branches: taken and not taken
# ------------------------------------------------------------

    addi x1, x0, 10
    addi x2, x0, 10
    addi x3, x0, 20
    addi x4, x0, -1

    beq  x1, x2, beq_taken
    jal  x0, fail
beq_taken:
    beq  x1, x3, fail

    bne  x1, x3, bne_taken
    jal  x0, fail
bne_taken:
    bne  x1, x2, fail

    blt  x4, x1, blt_taken
    jal  x0, fail
blt_taken:
    blt  x3, x1, fail

    bge  x3, x1, bge_taken
    jal  x0, fail
bge_taken:
    bge  x4, x1, fail

    bltu x1, x4, bltu_taken  # 10 < 0xffffffff
    jal  x0, fail
bltu_taken:
    bltu x4, x1, fail

    bgeu x4, x1, bgeu_taken
    jal  x0, fail
bgeu_taken:
    bgeu x1, x4, fail

# ------------------------------------------------------------
# SW and LW
#
# Address 768 is inside your 1024-byte memory.
# ------------------------------------------------------------

    addi x20, x0, 768

    lui  x5, 0x12345
    addi x5, x5, 0x678       # x5 = 0x12345678

    sw   x5, 0(x20)
    lw   x6, 0(x20)
    bne  x5, x6, fail

# ------------------------------------------------------------
# SB, LB and LBU at every byte offset
# ------------------------------------------------------------

    sw   x0, 4(x20)

    addi x5, x0, 0x11
    sb   x5, 4(x20)

    addi x5, x0, 0x22
    sb   x5, 5(x20)

    addi x5, x0, 0x33
    sb   x5, 6(x20)

    addi x5, x0, -128
    sb   x5, 7(x20)

    lbu  x6, 4(x20)
    addi x7, x0, 0x11
    bne  x6, x7, fail

    lbu  x6, 5(x20)
    addi x7, x0, 0x22
    bne  x6, x7, fail

    lbu  x6, 6(x20)
    addi x7, x0, 0x33
    bne  x6, x7, fail

    lb   x6, 7(x20)
    addi x7, x0, -128
    bne  x6, x7, fail

    lbu  x6, 7(x20)
    addi x7, x0, 128
    bne  x6, x7, fail

# ------------------------------------------------------------
# SH, LH and LHU at both aligned halfword offsets
# ------------------------------------------------------------

    sw   x0, 8(x20)

    lui  x5, 0xffff8          # x5 = 0xffff8000
    sh   x5, 8(x20)

    addi x5, x0, 0x123
    sh   x5, 10(x20)

    lh   x6, 8(x20)
    lui  x7, 0xffff8
    bne  x6, x7, fail

    lhu  x6, 8(x20)
    lui  x7, 0x8              # x7 = 0x00008000
    bne  x6, x7, fail

    lhu  x6, 10(x20)
    addi x7, x0, 0x123
    bne  x6, x7, fail

# ------------------------------------------------------------
# JAL
#
# JAL is eight bytes before jal_target:
# link address = target - 4
# ------------------------------------------------------------

    jal   x1, jal_target
    jal   x0, fail

jal_target:
    auipc x5, 0
    addi  x5, x5, -4
    bne   x1, x5, fail

# ------------------------------------------------------------
# JALR
#
# x5 receives the address 16 bytes after AUIPC.
# JALR should skip the following failure jump.
# ------------------------------------------------------------

jalr_test:
    auipc x5, 0
    addi  x5, x5, 16
    jalr  x1, 0(x5)
    jal   x0, fail

jalr_target:
    auipc x6, 0
    addi  x6, x6, -4          # Expected JALR link address
    bne   x1, x6, fail

# ------------------------------------------------------------
# JALR bit-zero clearing
#
# Make the target address odd. JALR must clear bit zero.
# ------------------------------------------------------------

    auipc x5, 0
    addi  x5, x5, 17
    jalr  x1, 0(x5)
    jal   x0, fail

jalr_odd_target:
    addi  x6, x0, 1
    bne   x6, x6, fail        # Harmless instruction

# ------------------------------------------------------------
# Passed
# ------------------------------------------------------------

pass:
    addi x31, x0, 0

pass_loop:
    beq  x0, x0, pass_loop

# ------------------------------------------------------------
# Failed
# ------------------------------------------------------------

fail:
    addi x31, x0, 1

fail_loop:
    beq  x0, x0, fail_loop
