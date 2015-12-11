# @Name: QuicksortRecursive
# @Description: The program implements the recursive Quicksort algorithm.
#
# @Author: Giacomo Marciani <giacomo.marciani@gmail.com>


.data
msg_welcome: .asciiz "Il programma ordina gli elementi di un array 10-dimensionale tramite lalgoritmo QuickSort ricorsivo.\n\n"
A: .word 2,4,6,8,10,3,6,9,12,15
dimensione_array: .word 10

.text
.globl main

### MAIN ###
main:
la $a0,msg_welcome #carica l'indirizzo di msg_welcome.
addi $v0,$zero,4 #codice servizio print string.
syscall

la $a0,dimensione_array #carica l'indirizzo di dimensione_array.
lw $s0,0($a0) #$s0=dimensione_array=n.
la $s1,A #$s0=(A), cioè indirizzo di base di A.

subu $a0,$s0,1 #$a0=(n-1).
addiu $a1,$s1,0 #$a1=(A+0).
addiu $s0,$zero,0 #$s0=m=0.

jal quicksort
nop

exit_program:
addi $v0,$zero,10 #codice servizio exit.
syscall
### FINE MAIN ###



### FUNZIONE void quicksort(int n, int *A, int m): $a0=n, $a1=(A+0), $s0=m ###
quicksort:
subu $sp,$sp,24
sw $ra,0($sp)
sw $a0,4($sp)
sw $a1,8($sp)
sw $s0,12($sp)

slt $t0,$s0,$a0 #$t0=1 iff m<n. $t0=0 iff m=>n.
beq $t0,$zero,m_maggiore_uguale_n #salta a m_maggiore_n sse m=>n.

m_minore_n:

addiu $t1,$s0,0 #$t1=m, argomento m per indice_perno(m,n).
addiu $t2,$a0,0 #$t2=n, argomento n per indice_perno(m,n).
jal indice_perno #chiama indice_perno(m,n).
nop

addiu $t6,$s2,0 #$t6=k=indice_perno(m,n).

sll $t4,$s0,2 #$t4=4*m.
add $t4,$a1,$t4 #$t4=&A[m], argomento per swap_item(&A[m],&A[k]).
sll $t5,$t6,2 #$t5=4*k.
add $t5,$a1,$t5 #t5=&A[k], argomento per swap_item(&A[m],&A[k]).

jal swap_item #chiama swap_item()
nop

lw $s3,0($t4) #$s3=key=A[m].

addiu $t1,$s0,1 #$t1=i=(m+1).
addiu $t2,$a0,0 #$t2=j=n.

ciclo_while_1:
slt $t0,$t2,$t1 #$t0=1 iff j<i. $t0=0 iff i<=j.
bne $t0,$zero,exit_ciclo_while_1 #salta a exit_ciclo_while_1 sse j<i.

sll $t1,$t1,2 #$t1=4*i.
add $t1,$a1,$t1 #$t1=&A[i].
lw $s6,0($t1) #$s6=A[i].
sub $t1,$t1,$a1 #$t1=4*i.
srl $t1,$t1,2 #t1=i.

sll $t2,$t2,2 #$t2=4*j.
add $t2,$a1,$t2 #$t2=&A[j].
lw $s7,0($t2) #$s7=A[j].
sub $t2,$t2,$a1 #$t2=4*j.
srl $t2,$t2,2 #t2=j.

ciclo_while_2:
slt $t0,$a0,$t1 #$t0=1 iff n<i. $t0=0 iff n=>i.
bne $t0,$zero,exit_ciclo_while_2 #salta a exit_ciclo_while_2 sse n<i.

slt $t0,$s3,$s6 #$t0=1 iff key<A[i]. $t0=0 iff key=>A[i].
bne $t0,$zero,exit_ciclo_while_2 #salta a exit_ciclo_while_2 sse key<A[i].

addiu $t1,$t1,1 #i++.

exit_ciclo_while_2:
nop

ciclo_while_3:
slt $t0,$t2,$s0 #$t0=1 iff j<m. $t0=0 iff j=>m.
bne $t0,$zero,exit_ciclo_while_3 #salta a exit_ciclo_while_3 sse j<m.
slt $t0,$s3,$s7 #$t0=1 iff key<A[j]. $t0=0 iff key=>A[j].
beq $t0,$zero,exit_ciclo_while_3 #salta a exit_ciclo_while_3 sse key=>A[j].

subu $t2,$t2,1 #j--.

exit_ciclo_while_3:
nop

slt $t0,$t1,$t2 #$t0=1 iff i<j. $t0=0 iff i=>j.
beq $t0,$zero,exit_ciclo_while_1 #salta a exit_ciclo_while_1 sse i=>j.

sll $t4,$t1,2 #$t4=4*i.
add $t4,$a1,$t4 #$t4=&A[i], argomento per swap_item(&A[i],&A[j]).
sll $t5,$t2,2 #$t5=4*j.
add $t5,$a1,$t5 #$t5=&A[j], argomento per swap_item(&A[i],&A[j]).

jal swap_item #chiama swap_item(&A[i],&A[j]).
nop

exit_ciclo_while_1:
nop

sll $s0,$s0,2 #$s0=4*m.
add $t4,$a1,$s0 #$t4=&A[m], argomento per swap_item(&A[m],&A[j]).
srl $s0,$s0,2 #$s0=m.

sll $t2,$t2,2 #$t2=4*j.
add $t5,$a1,$t2 #$t5=&A[j], argomento per swap_item(&A[m],&A[j]).
srl $t2,$t2,2 #$t2=j.

jal swap_item #chiama swap_item(&A[m],&A[j]).
nop


subu $a0,$t2,1 #$a0=n=j-1, argomento per quicksort(A,m,j-1).
jal quicksort #chiama quicksort(A,m,j-1).
nop

addiu $s0,$t2,1 #$s0=m=j+1, argomento per quicksort(A,m,j-1).
jal quicksort #chiama quicksort(A,j+1,n).
nop

m_maggiore_uguale_n:
lw $ra,0($sp)
lw $a0,4($sp)
lw $a1,8($sp)
lw $s0,12($sp)
addiu $sp,$sp,24
jr $ra
### FINE FUNZIONE quicksort(int n, int *A, int m) ###



### FUNZIONE void swap_item(int *x, int *y): $t4=&x, $t5=&y ###
swap_item:
subu $sp,$sp,20
sw $ra,0($sp)
sw $t4,4($sp)
sw $t5,8($sp)
lw $t3,0($t4) #$t3=*x
sw $t3,12($sp)
lw $t3,0($t5) #$t3=*y
sw $t3,16($sp)

lw $t3,12($sp) #$t3=*x
sw $t3,0($t5) #*y=*x

lw $t3,16($sp) #$t3=*y
sw $t3,0($t4) #*x=*y

lw $ra,0($sp)
addiu $sp,$sp,20
jr $ra
### FINE FUNZIONE void swap_item(int *x, int *y)) ###



### FUNZIONE int indice_perno(int i, int f): $t1=i, $t2=f, $s2=indice_perno(i,f) ###
indice_perno:
subu $sp,$sp,16
sw $ra,0($sp)
sw $t1,4($sp)
sw $t2,8($sp)

add $s2,$t1,$t2 #$s2=(i+f)
srl $s2,$s2,1 #$s2=(i+f)/2

lw $ra,0($sp)
addiu $sp,$sp,16
jr $ra
### FINE FUNZIONE int perno(int i, int f) ###
