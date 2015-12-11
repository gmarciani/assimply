# The program allocates in data segment the array of the first 100 integers multiples of 3.

.data
msg1: .asciiz "Ho allocato in memoria l'array 100-dimensionale di interi multipli di 3. Dedico questo mio primo programma assembler MIPS a Laura. Volere e' potere."
.space 8 # allocates an empty 12bytes space
first_element: .word 1 # sets to 0 the first element

.text
.globl main

main:
add $t0,$zero,$zero # $t0=i=0
addi $s1,$zero,100 # $s1=100
addi $s2,$zero,3 # $s2=3
la $s3,first_element # $s3=address of the first element, so $s3=base index

allocate: # the loop
slt $t2,$t0,$s1 # $t2=1 iff i<100; $t2=0 iff i>=100
beq $t2,$zero,end_allocate # jumps to end_allocate if $t2=0, so if i>=100
sll $t1,$t0,2 # $t1=4i
add $t1,$t1,$s3 # $t1address(A[i])
mulou $t3,$s2,$t0 # $t3=3i
sw $t3,0($t1) # allocate $t3 in A[i]
addi $t0,$t0,1 # $t0=i=i+1
j allocate

end_allocate: # the end of the loop
ori $v0,$zero,4 # $v0= systems service queue for print_string
la $a0,msg1 # $a0=address(msg1)
syscall
