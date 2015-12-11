# Name: Fibonacci
# Description: The program computes the nth Fibonacci's number.
#
# Author: Giacomo Marciani <giacomo.marciani@gmail.com>


.data
msg_welcome:.asciiz "Il programma calcola l'n-esimo numero di Fibonacci.\n\n"
msg_input: .asciiz "Inserisci n: "
msg_result: .asciiz "\nRisultato: "

.text
.globl main

### MAIN ###
main:

welcome:
la $a0,msg_welcome #carica indirizzo msg_welcome.
addi $v0,$zero,4 #codice servizio print string.
syscall

user_input:
la $a0,msg_input #carica indirizzo msg_input.
addi $v0,$zero,4 #codice servizio print string.
syscall
addi $v0,$zero,5 #codice servizio read int.
syscall

add $a0,$v0,$zero #pone n in $a0.
jal fibonacci #chiama fibonacci.
nop

result:
add $t0,$v0,$zero #salva il risultato in $t0.
la $a0,msg_result #carica indirizzo msg_result.
addi $v0,$zero,4 #codice servizio print string.
syscall
add $a0,$t0,$zero #pone il contenuto di $t0 in $a0.
addi $v0,$zero,1 #codice servizio print int.
syscall

exit_program:
addi $v0,$zero,10 #codice servizio exit.
syscall
### FINE MAIN ###

### FUNZIONE int fibonacci(int n): $a0=n, $v0=fibonacci(n). ###
fibonacci:
subu $sp,$sp,16 #alloca lo stack frame da 16 byte per fibonacci(n): 1 locazione per $ra, 1 locazione per $a0=n, 1 locazione per fibonacci(n-1), 1 locazione per fibonacci(n-2).
sw $ra, 0($sp) #carica l'indirizzo di ritorno nello stack frame.
sw $a0, 4($sp) #carica l'argomento $a0=n nello stack frame.

beq $a0,$zero,caso_uguale_0 #salta a caso_uguale_0 sse $a0=n=0. Base della ricorsione: fibonacci(0)=0.
nop

addi $t0,$zero,1 #$t0=1, usata come costante.
beq $a0,$t0,caso_uguale_1 #salta a caso_uguale_1 sse $a0=n=1. Base della ricorsione: fibonacci(1)=1.
nop

subu $a0,$a0,1 #$a0=($a0-1)=(n-1), argomento per la chiamata ricorsiva fibonacci(n-1).
jal fibonacci #chiama fibonacci(n-1).

sw $v0,8($sp) #carica $v0=fibonacci(n-1) nello stack frame di fibonacci(n).
lw $a0,4($sp) #$a0=n.
subu $a0,$a0,2 #$a0=($a0-2)=(n-2), argomento per la chiamata ricorsiva fibonacci(n-2).
jal fibonacci #chiama fibonacci(n-2).

sw $v0,12($sp) #carica $v0=fibonacci(n-2) nello stack frame di fibonacci(n).

lw $ra,0($sp) #carica l'indirizzo di ritorno.
lw $t1,8($sp) #$t0=fibonacci(n-1).
lw $t2,12($sp) #t1=fibonacci(n-2).

add $v0,$t1,$t2 #$v0=fibonacci(n)=fibonacci(n-1)+fibonacci(n-2).

addi $sp,$sp,16 #dealloca lo stack frame di fibonacci(n).
jr $ra

caso_uguale_1:
addi $v0,$zero,1 #base della ricorsione: fibonacci(1)=1.
lw $ra,0($sp) #carica l'indirizzo di ritorno.
addi $sp,$sp,16
jr $ra

caso_uguale_0:
addi $v0,$zero,0 #base della ricorsione: fibonacci(0)=0.
lw $ra,0($sp) #carica l'indirizzo di ritorno.
addi $sp,$sp,16 #dealloca lo stack frame di fibonacci(n).
jr $ra
### FINE int fibonacci(int n) ###
