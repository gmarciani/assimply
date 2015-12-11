# @Name: ModifyArray
# @Description: The program allocates three arrays A[],B[] and C[].
# It modifies C[], as stated by the following function:
# C[i]=A[i]+max(C[i]-B[i],0)
#
# @Author: Giacomo Marciani <giacomo.marciani@gmai.com>


.data
msg_welcome: .asciiz "Il programma alloca in memoria tre array 10-dimensionali A[],B[],C[]. Modifica gli elementi dell'array C, secondo la seguente funzione: C[i]=A[i]+max(C[i]-B[i],0).\n\n"
A: .word 1,2,3,4,5,6,7,8,9,10
B: .word 2,4,6,8,10,12,14,16,18,20
C: .word 3,6,9,12,15,18,21,24,27,30

dimensione_array: .word 10

.text
.globl main



### MAIN ###
main:
la $a0,msg_welcome #carica l'indirizzo di msg_welcome.
addi $v0,$zero,4 #codice servizio print string.
syscall

la $a0,dimensione_array #carica l'indirizzo di dimensione_array.
lw $s0,0($a0) #$s0=n=10.
la $s1,A #$s1=indirizzo di base di A[].
la $s2,B #$s2=indirizzo di base di B[].
la $s3,C #$s3=indirizzo di base di C[].

jal modifica
nop

exit_program:
addi $v0,$zero,10 #codice servizio exit.
syscall
### FINE MAIN ###



### FUNZIONE void modifica(int A[], int B[], int C[]): $s1=(A+0), $s2=(B+0), $s3=(C+0). ###
modifica:
subu $sp,$sp,20 #alloca lo stack frame da 20 byte per modifica((A+0),(B+0),(C+0)): 1 locazione per $ra, 1 locazione per $s1=(A+0), 1 locazione per $s2=(B+0), 1 locazione per $s3=(C+0), 1 locazione per $s0=n.
sw $ra,0($sp) #carica l'indirizzo di ritorno nello stack frame.
sw $s1,4($sp) #carica $s1=(A+0) nello stack frame.
sw $s2,8($sp) #carica $s2=(B+0) nello stack frame.
sw $s3,12($sp) #carica $s3=(C+0) nello stack frame.
sw $s0,16($sp) #carica $s0=dimensione_array=n nello stack frame.

addi $t1,$zero,0 #$t1=i=0.

ciclo_for_modifica:
slt $t3,$t1,$s0 #$t3=1 iff i<n.
beq $t3,$zero,exit_ciclo_for_modifica #salta alla fine del ciclo sse i=>n.
sll $t4,$t1,2 #$t4=4*i, cioè $t4=indice scorrimento array.
add $t5,$s1,$t4 #$t5=indirizzo A[i].
add $t6,$s2,$t4 #$t6=indirizzo B[i].
add $t7,$s3,$t4 #$t7=indirizzo C[i].

lw $s5,0($t5) #$s5=elemento A[i].
lw $s6,0($t6) #$s6=elemento B[i].
lw $s7,0($t7) #$s7=elemento C[i].

sub $a0,$s7,$s6 #$a0=(C[i]-B[i]), argomento per max((C[i]-B[i]),0).
addi $a1,$zero,0 #$a1=0, argomento per max((C[i]-B[i]),0).
jal max #chiama max((C[i]-B[i]),0).
nop

add $t2,$s5,$v0 #$t2=A[i]+funzione_max((C[i]-B[i]),0).
sw $t2,0($t7) #C[i]=A[i]+funzione_max((C[i]-B[i]),0).

addi $t1,$t1,1 #$t1=$t1+1, cioè i++.
j ciclo_for_modifica

exit_ciclo_for_modifica:
lw $ra,0($sp) #carica l'indirizzo di ritorno.
addi $sp,$sp,20 #dealloca lo stack frame per modifica((A+0),(B+0),(C+0)).
jr $ra
### FINE FUNZIONE void modifica(int A[], int B[], int C[]) ###



### FUNZIONE int max(int x, int y): $a0=x, $a1=y, $v0=max(x,y). ###
max:
subu $sp,$sp,4 #alloca uno stack frame da 4 byte. 1 locazione per $ra.
sw $ra,0($sp) #carica nello stack frame l'indirizzo di ritorno.
slt $t0,$a0,$a1 #$t0=1 iff $a0<$a1, cioè $t0=1 sse x<y.
bne $t0,$zero,max_y #salta a max_y sse $t0!=0, cioè sse y>x.

max_x:
addi $v0,$a0,0 #$v0=max(x,y)=$a0=x, cioè return x.
lw $ra,0($sp) #carica l'indirizzo di ritorno alla funzione modifica(A[],B[],C[]).
addi $sp,$sp,4 #dealloca lo stack frame di max(x,y).
jr $ra

max_y:
addi $v0,$a1,0 #$v0=max(x,y)=$a1=y, cioè return y.
lw $ra,0($sp) #carica l'indirizzo di ritorno alla funzione modifica(A[],B[],C[]).
addi $sp,$sp,4 #dealloca lo stack frame di max(x,y).
jr $ra
### FINE FUNZIONE int max(int x, int y) ###
