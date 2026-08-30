.section .text
.global _start

_start:
        la    t0, handler
        csrrw x0, mtvec, t0      # mtvec <- handler

        .word 0xFFFFFFFF         # illegal instruction -> mcause = 2

        addi  x29, x0, 99        # runs after mret returns here
loop:
        jal   x0, loop

handler:
        csrr  t0, mcause         # why did we trap?

        addi  t1, x0, 2
        beq   t0, t1, is_illegal

        addi  t2, x0, 11
        beq   t0, t2, is_ecall

        addi  x31, x0, 15        # unknown cause
        jal   x0, done

is_illegal:
        addi  x31, x0, 2         # x31 <- 2 proves cause 2 was seen
        jal   x0, done

is_ecall:
        addi  x31, x0, 11
        jal   x0, done

done:
        csrr  t0, mepc
        addi  t0, t0, 4          # skip the offending word
        csrw  mepc, t0
        mret
