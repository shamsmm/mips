.section .text
start:
    addi $t1, 0
    addi $t2, 4
    lw $s1, 0 ($t1)
    lw $s2, 0 ($t2)
    add $s3, $s2, $s1
    sw $s3, 0 ($t1)
