.section .text
start:
    and $t1, $0, $0
    and $t2, $0, $0
    and $t3, $0, $0
    and $t4, $0, $0
    addi $t1, 0
    addi $t2, 4
    addi $t3, 8
    lw $s1, 0 ($t1)
    lw $s2, 0 ($t2)
    addi $t4, 20
loop:
    add $s2, $s2, $s1
    sw $s2, 0 ($t3)
    beq $s2, $t4, start
    j loop
