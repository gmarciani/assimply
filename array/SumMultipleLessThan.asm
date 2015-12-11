# @Name: SumMultipleLessThan
# @Description: The program computes the sum of N integers multiple of M strictly less than T.
#
# @Author: Giacomo Marciani <giacomo.marciani@gmai.com>

.data
msg0_0: .asciiz "Il programma alloca nel data segment un array n-dimensionale di interi multipli di m. L'utente può scegliere di visualizzare i dettagli di allocamnto. Il programma esegue poi la somma degli n interi multipli di m strettamente inferiori a t.\n\n"

msg1_1: .asciiz "Quanti interi (n)?"
msg1_2: .asciiz "Multipli di (m)?"
msg1_3: .asciiz "Strettamente inferiori a (t)?"
msg1_4: .asciiz "Vuoi visualizzare i dettagli di allocamento? (1/0)"
msg1_5: .asciiz " allocato all'indirizzo di memoria "
msg1_6: .asciiz "\n"

msg2_1: .asciiz "Ho allocato in memoria l'array "
msg2_2: .asciiz "-dimensionale di interi multipli di "
msg2_3: .asciiz " in [0,"
msg2_4: .asciiz "]."

msg3_1: .asciiz "La somma dei "
msg3_2: .asciiz " interi multipli di "
msg3_3: .asciiz " strettamente inferiori a "
msg3_4: .asciiz " vale "
msg3_5: .asciiz "."

primo_elemento_array: .word 1 #pone a zero il primo elemento dell'array

.text
.globl main

main:

ori $v0,$zero,4 #$v0=codice servizio di sistema print_string
la $a0,msg0_0 #$a0=address(msg0_0)
syscall

la $s0, primo_elemento_array #$s0=indice di base dell'array

input_interi:
ori $v0,$zero,4 #$v0=codice servizio di sistema print_string
la $a0,msg1_1 #$a0=address(msg1_1)
syscall

ori $v0,$zero,5 #v0=codice servizio di sistema read_int
syscall
addi $s1,$v0,0 #$s1=n

input_multipli_di:
ori $v0,$zero,4 #$v0=codice servizio di sistema print_string
la $a0,msg1_2 #$a0=address(msg1_2)
syscall

ori $v0,$zero,5 #v0=codice servizio di sistema read_int
syscall
addi $s2,$v0,0 #$s2=m

input_inferiori_a:
ori $v0,$zero,4 #$v0=codice servizio di sistema print_string
la $a0,msg1_3 #$a0=address(msg1_3)
syscall

ori $v0,$zero,5 #v0=codice servizio di sistema read_int
syscall
addi $s3,$v0,0 #$s3=t

input_dettagli_allocamento:
ori $v0,$zero,4 #$v0=codice servizio di sistema print_string
la $a0,msg1_4 #$a0=address(msg1_4)
syscall

ori $v0,$zero,5 #v0=codice servizio di sistema read_int
syscall
addi $s5,$v0,0 #$s5=1/0


addi $t0,$zero,0 #$t0=i=0

allocamento_elementi: #ciclo di allocamento array
slt $t2,$t0,$s1 #$t2=1 iff i<n; $t2=0 iff i>=n
beq $t2,$zero,fine_allocamento_elementi #salta a fine_allocamento_elementi se $t2=0, cioè se i>=100
sll $t1,$t0,2 #$t1=4*i
add $t1,$t1,$s0 #$t1address(A[i])
mulou $t3,$s2,$t0 #$t3=m*i
sw $t3,0($t1) #alloca m*i in A[i]

beq $s5,$zero,fine_dettagli_allocamento #salta a fine_dettagli_allocamento se $s5=0

dettagli_allocamento:
ori $v0,$zero,1 #$v0=codice servizio di sistema print_int
addi $a0,$t3,0 #$a0=$t3=m*i
syscall

ori $v0,$zero,4 #$v0=codice servizio di sistema print_string
la $a0,msg1_5 #$a0=address(msg1_5)
syscall

ori $v0,$zero,1 #$v0=codice servizio di sistema print_int
addi $a0,$t1,0 #$a0=$t1=address(A[i])
syscall

ori $v0,$zero,4 #$v0=codice servizio di sistema print_string
la $a0,msg1_6 #$a0=address(msg1_6)
syscall

fine_dettagli_allocamento:
nop #nessuna operazione
addi $t0,$t0,1 #i++
j allocamento_elementi #salto incondizionato a allocamento_elementi

fine_allocamento_elementi:
nop

report_allocamento_array:
ori $v0,$zero,4 #$v0=codice servizio di sistema print_string
la $a0,msg2_1 #$a0=address(msg2_1)
syscall

ori $v0,$zero,1 #$v0=codice servizio di sistema print_int
addi $a0,$s1,0 #$a0=$s1=n
syscall

ori $v0,$zero,4 #$v0=codice servizio di sistema print_string
la $a0,msg2_2 #$a0=address(msg2_2)
syscall

ori $v0,$zero,1 #$v0=codice servizio di sistema print_int
addi $a0,$s2,0 #$a0=$s1=m
syscall

ori $v0,$zero,4 #$v0=codice servizio di sistema print_string
la $a0,msg2_3 #$a0=address(msg2_3)
syscall

ori $v0,$zero,1 #$v0=codice servizio di sistema print_int
lw $t4,0($t1) #$t4=A[n-1]
addi $a0,$t4,0 #$a0=$t4=A[n-1]
syscall

ori $v0,$zero,4 #$v0=codice servizio di sistema print_string
la $a0,msg2_4 #$a0=address(msg2_4)
syscall


addi $t0,$zero,0 #$t0=i=0
addi $s4,$zero,0 #$s4=somma=0

while:
slt $t2,$t0,$s1 #$t2=1 iff i<n; $t2=0 iff i>=n
beq $t2,$zero,fine_while #salta a fine_while se i>=n
sll $t1,$t0,2 #$t1=4*i
add $t1,$t1,$s0 #$t1=address(A[i])
lw $t3,0($t1) #$t3=A[i]

inizio_if:
slt $t2,$t3,$s3 #$t2=1 iff A[i]<t; $t2=0 iff A[i]>=t
beq $t2,$zero,fine_if #salta a fine_if se A[i]>=t
add $s4,$s4,$t3 #$s4=somma=somma+A[i]

fine_if:
nop #nessuna operazione
addi $t0,$t0,1 #i++
j while #salto incondizionato a while

fine_while:
nop #nessuna operazione

report_finale:
ori $v0,$zero,4 #$v0=codice servizio di sistema print_string
la $a0,msg3_1 #$a0=address(msg3_1)
syscall

ori $v0,$zero,1 #$v0=codice servizio di sistema print_int
addi $a0,$s1,0 #$a0=$s1=n
syscall

ori $v0,$zero,4 #$v0=codice servizio di sistema print_string
la $a0,msg3_2 #$a0=address(msg3_2)
syscall

ori $v0,$zero,1 #$v0=codice servizio di sistema print_int
addi $a0,$s2,0 #$a0=$s2=m
syscall

ori $v0,$zero,4 #$v0=codice servizio di sistema print_string
la $a0,msg3_3 #$a0=address(msg3_3)
syscall

ori $v0,$zero,1 #$v0=codice servizio di sistema print_int
addi $a0,$s3,0 #$a0=$s3=t
syscall

ori $v0,$zero,4 #$v0=codice servizio di sistema print_string
la $a0,msg3_4 #$a0=address(msg3_4)
syscall

ori $v0,$zero,1 #$v0=codice servizio di sistema print_int
addi $a0,$s4,0 #$a0=$s4=somma
syscall

ori $v0,$zero,4 #$v0=codice servizio di sistema print_string
la $a0,msg3_5 #$a0=address(msg3_5)
syscall

fine_programma:
ori $v0,$zero,10 #$v0=codice servizio di sistema exit
syscall
