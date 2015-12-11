# @Name: DoublyRecursiveFunction
# @Description: The program computes T(n)=Sum(F(i)), for i in [0,n].
# F(x) is a doubly recursive function, defined as follow:
#    F(x)=1, for x<=1;
#    F(x)=F(x-1)*F(x-2)+1, otherwise.
#
# @Author: Giacomo Marciani <giacomo.marciani@gmail.com>

.data
msg_welcome: .asciiz "Il programma esegue la sommatoria degli n risultati di una funzione doppiamente ricorsiva. \n\n"
msg_input: .asciiz "Inserisci n: "
msg_result: .asciiz "\nRisultato: "

.text
.globl main


### MAIN ###
main:

welcome:
la $a0,msg_welcome #carica l'indirizzo di msg_welcome.
addi $v0,$zero,4 #codice servizio print string.
syscall

user_input:
la $a0,msg_input #carica l'indirizzo di msg_input.
addi $v0,$zero,4 #codice servizio print string.
syscall
addi $v0,$zero,5 #codice servizio read int.
syscall

addi $a0,$v0,0 #$a0=n, argomento di T(n).
jal T #chiama T(n).
nop

result:
addi $t0,$v0,0 #salva il risultato in $t0.
la $a0,msg_result #carica l'indirizzo di msg_result.
addi $v0,$zero,4 #codice servizio print string.
syscall
addi $a0,$t0,0 #pone il contenuto di $t0 in $a0.
addi $v0,$zero,1 #codice servizio print int.
syscall

exit_program:
addi $v0,$zero,10 #codice servizio exit.
syscall
### FINE MAIN ###


### FUNZIONE int T(int n): $a0=n,$v0=T(n). ###
T:
subu $sp,$sp,8 #alloca uno stack frame da 8 byte per T(n). 1 locazione per $ra, 1 locazione per $a0.
sw $ra,0($sp) #carica l'indirizzo di ritorno nello stack frame.
sw $a0,4($sp) #carica l'argomento $a0=n nello stack frame.

addi $v0,$zero,0 #$v0=0.
addi $t0,$zero,0 #$t0=i=0.
addi $t1,$a0,1 #$t1=n+1.

ciclo_for_T:
slt $t2,$t0,$t1 #$t2=1 sse i<(n+1).
beq $t2,$zero,exit_ciclo_for_T #salta alla fine del ciclo, sse $t2=0, cioè sse i=>(n+1).
addi $v1,$zero,0 #$v1=0, cioè resetta il risultato di F(n), perchè dovrà essere ricalcolato.
addi $a1,$t0,0 #$a1=$t0=i, quindi n=i, argomento per la chiamata a F(n).
jal F #chiama F(n).
nop

add $v0,$v0,$v1 #$v0=$v0+$v1. $v1=F(n). Quindi aggiorna la sommatoria S.
addi $t0,$t0,1 #$t0=($t0+1)=(i+1), cioè i++.
j ciclo_for_T

exit_ciclo_for_T:
nop
lw $ra,0($sp) #carica l'indirizzo di ritorno.
addi $sp,$sp,8 #dealloca lo stack frame di T(n).
jr $ra
### FINE FUNZIONE int T(int n) ###


### FUNZIONE int F(int n): $a1=n,$v1=F(n). ###
F:
subu $sp,$sp,16 #alloca lo stack frame da 16 byte per F(n). 1 locazione per $ra, 1 locazione per $a1, 1 locazione per il risultato di F(n-1), 1 locazione per il risultato di F(n-2).
sw $ra,0($sp) #carica l'indirizzo di ritorno nello stack frame.
sw $a1,4($sp) #carica $a1=n nello stack frame.

addi $t4,$zero,1 #$t4=1, usata come costante.
slt $t3,$t4,$a1 #$t3=1 iff $t4=1<$a1=n, cioè $t3=1 sse n=>2.
beq $t3,$zero,caso_minore_uguale_1 #base della ricorsione: F(n<=1)=1.

subu $a1,$a1,1 #$a1=(n-1).
jal F #chiamata ricorsiva a F(n-1).
nop

sw $v1,8($sp) #carico il risultato di F(n-1) nello stack frame di F(n).
lw $a1,4($sp) #$a1=n.
subu $a1,$a1,2 #$a1=($a1-2)=(n-2), argomento per la chiamata ricorsiva F(n-2).
jal F #chiama F(n-2).
nop

sw $v1,12($sp) #carico il risultato di F(n-2) nello stack frame di F(n).
lw $ra,0($sp) #carico l'indirizzo di ritorno.
lw $t5,8($sp) #$t5=F(n-1).
lw $t6,12($sp) #$t6=F(n-2).

mul $v1,$t5,$t6 #$v1=$t5*$t6=F(n-1)*F(n-2).
addi $v1,$v1,1 #$v1=$v1+1=F(n-1)*F(n-2)+1=F(n).

addi $sp,$sp,16 #dealloca lo stack frame di F(n).
jr $ra

caso_minore_uguale_1:
addi $v1,$zero,1 #base della ricorsione: F(n<=1)=1.
lw $ra,0($sp)#carica l'indirizzo di ritorno.
addi $sp,$sp,16 #dealloca lo stack frame di F(n).
jr $ra
### FINE FUNZIONE int T(int n) ###
