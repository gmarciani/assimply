# @Name: Factorial
# @Description: The program computes the factorial of N.
#
# @Author: Giacomo Marciani <giacomo.marciani@gmail.com>


.data
msg_welcome: .asciiz "Il programma calcola il fattoriale di n.\n\n"
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

add $a0,$v0,$zero #$a0=n.
jal fattoriale #chiama fattoriale(n).
nop
add $t0,$v0,$zero #$t0=$v0=fattoriale(n).

result:
la $a0,msg_result #carica indirizzo msg_result.
addi $v0,$zero,4 #codice servizio print string.
syscall
add $a0,$t0,$zero #$a0=$t0=fattoriale(n).
addi $v0,$zero,1 #codice servizio print int.
syscall

exit_program:
addi $v0,$zero,10 #codice servizio exit.
syscall
### FINE MAIN ###


### FUNZIONE int fattoriale(int n): $a0=n, $v0=fattoriale(n). ###
fattoriale:
subu $sp,$sp,12 #alloca stack frame da 12 byte per fattoriale(n): 1 locazione per $ra, 1 locazione byte per $a0, 1 locazione per fattoriale(n-1).
sw $ra, 0($sp) #carica l'indirizzo di ritorno nello stack frame di fattoriale(n).
sw $a0, 4($sp) #carica l'argomento di nello stack frame di fattoriale(n).

beq $a0,$zero,caso_uguale_0 #salta a caso_uguale_0 sse n=0. Base della ricorsione: fattoriale(0)=1.
nop

subu $a0,$a0,1 #$a0=($a0-1)=(n-1) per la chiamata ricorsiva fattoriale(n-1).
jal fattoriale #chiama fattoriale(n-1).
nop

sw $v0,8($sp) #carica $v0=fattoriale(n-1) nello stack frame di fattoriale(n).
lw $ra,0($sp) #carica il registro di ritorno.
lw $t0,4($sp) #carica n.
lw $t1,8($sp) #carica fattoriale(n-1).
addi $sp,$sp,12 #dealloca lo stack frame di fattoriale(n).

mul $v0,$t0,$t1 #$v0=fattoriale(n)=n*fattoriale(n-1).
jr $ra

caso_uguale_0:
addi $v0,$zero,1 #base della ricorsione: fattoriale(0)=1.
lw $ra,0($sp) #carica il registro di ritorno.
addi $sp,$sp,12 #dealloca lo stack frame di fattoriale(0).
jr $ra
### FINE FUNZIONE int fattoriale(int n) ###
