# @Name: MaxInArray
# @Description: The program computes (recursively) the maximum in an array A of size 10.
#
# @Author: Giacomo Marciani <giacomo.marciani@gmail.com>


.data
msg_welcome: .asciiz "Il programma determina ricorsivamente l'elemento massimo di un array 10-dimensionale.\n\n"
msg_result: .asciiz "\nElemento maggiore: "
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

addi $a0,$s0,0 #$a0=n.
addi $a1,$s1,0 #$a1=(A+0).

jal max_array
nop

result:
addi $t0,$v1,0 #$t0=$v1=risultato max_array.
la $a0,msg_result #carica l'indirizzo di msg_result.
addi $v0,$zero,4 #codice servizio print string.
syscall

addi $a0,$t0,0 #$a0=$t0=risultato max_array.
addi $v0,$zero,1 #codice servizio print int.
syscall

exit_program:
addi $v0,$zero,10 #codice servizio exit.
syscall
### FINE MAIN ###



### FUNZIONE int max_array(int n, int *A): $a0=n, $a1=(A+0), $v1=max_array(n,A). ###
max_array:
subu $sp,$sp,20 #alloca uno stack frame da 20 byte. 1 locazione per $ra, 1 locazione per $a0=n, 1 locazione per $a1=(A+0), 1 locazione per il risultato di max_array(A+1, n-1), 1 locazione per il risultato di max(A[0],max_array(A+1, n-1)).
sw $ra,0($sp) #carica nello stack frame l'indirizzo di ritorno.
sw $a0,4($sp) #carica nello stack frame n.
sw $a1,8($sp) #carica nello stack frame (A+0).

addi $t2,$zero,1 #$t2=1.
beq $a0,$t2,caso_1_elemento #salta a caso_1_elemento sse n=1. Base della ricorsione: max_array(1,(A+0))=*(A+0).
nop

subu $a0,$a0,1 #$a0=($a0-1)=(n-1), argomento per max_array((n-1),(A+1)).
addi $a1,$a1,4 #$a1=($a1+4)=(A+1), argomento per max_array((n-1),(A+1)).. Nota: ricorda l'indirizzamento al byte.
jal max_array #chiama max_array((n-1),(A+1)).
nop

sw $v1,12($sp) #carica nello stack frame il valore massimo del sottoarray.
lw $t4,8($sp) #$t4=(A+0).
lw $t0,0($t4) #t0=*(A+0), argomento per max(*(A+0),max_array((n-1),(A+1))).
lw $t1,12($sp) #t1=max_array((n-1),(A+1)), argomento per max(*(A+0),max_array((n-1),(A+1))).
jal funzione_max #chiama max(*(A+0),max_array((n-1),(A+1))).
nop

sw $v0,16($sp) #carica nello stack il valore massimo nell'array, calcolato dalla funzione max(n,(A+0)).
lw $ra,0($sp) #carica l'indirizzo di ritorno.
addi $sp,$sp,20 #dealloca lo stack frame.
addi $v1,$v0,0 #$v1=$v0
jr $ra

caso_1_elemento:
lw $t4,8($sp) #$t4=(A+0).
lw $v1,0($t4) #$v1=*(A+0). Base della ricorsione: max_array(1,(A+0))=*(A+0).
lw $ra,0($sp) #carica dallo stack frame l'indirizzo di ritorno.
addi $sp,$sp,20 #dealloca lo stack frame di max_array(n,(A+0)).
jr $ra
### FINE FUNZIONE max_array(n,(A+0)) ###


######################################################################################
######################################################################################
## Progetto: MaxInArray Ricorsivo						    ##
## Linguaggio: Assembler MIPS							    ##
## Data: febbraio 2012								    ##
##									            ##
## Descrizione:	Il programma determina ricorsivamente l'elemento massimo            ##
##              in un'array 10-dimensionale allocato del data segment.		    ##
##										    ##
## Autore: Giacomo Marciani							    ##
##										    ##
## Blog: giacomomarciani.wordpress.com						    ##
## Mail: giacomo.marciani@gmail.com						    ##
######################################################################################
######################################################################################



### FUNZIONE int max(int x, int y): $t0=x, $t1=y, $v0=max(x,y). ###
funzione_max:
subu $sp,$sp,12 #alloca uno stack frame per funzione_max da 12 byte. 1 locazione per $ra, 1 locazione per $t0=x, 1 locazione per $t1=y.
sw $ra,0($sp) #carica nello stack frame l'indirizzo di ritorno.
sw $t0,4($sp) #carica nello stack frame l'argomento $t0=x.
sw $t1,8($sp) #carica nello stack frame l'argomento $t1=y.

slt $t3,$t0,$t1 #$t3=1 iff x<y.
beq $t3,$zero,max_x #salta a max_x sse x>y.

max_y:
addi $v0,$t1,0 #$v0=risultato funzione_max=y.
lw $ra,0($sp) #carica dallo stack frame di funzione_max l'indirizzo di ritorno.
addi $sp,$sp,12 #dealloca lo stack frame di funzione_max.
jr $ra

max_x:
addi $v0,$t0,0 #$v0=risultato funzione_max=x.
lw $ra,0($sp) #carica dallo stack frame di funzione_max l'indirizzo di ritorno.
addi $sp,$sp,12 #dealloca lo stack frame di funzione_max.
jr $ra
### FINE FUNZIONE int max(int x, int y) ###
