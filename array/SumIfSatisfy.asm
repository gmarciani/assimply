# @Name: SumIfSatisfies
# @Description: The program computes the sum of elements A[i][j], where A[][] is a 5x5 array.
# These elements must satisfy the following statement:
# A[i][j]=T(A[(i*2)mod(n)][j/2]), where T(m) is defined as follow:
# T(m)=1, for m<=2;
# T(m)=T(m-1)+T(m-3), otherwise.
#
# @Author: Giacomo Marciani <giacomo.marciani@gmai.com>


.data
msg_welcome: .asciiz "Il programma calcola la somma degli elementi A[i][j] di un array bidimensionale nxn=5x5, che soddisfano la seguente relazione: A[i][j]=T(A[(i*2)mod(n)][j/2]), dove T(m) è una funzione doppiamente ricorsiva definita come segue: T(m)=1 per m<=2; T(m)=T(m-1)+T(m-3) altrimenti.\n\n"
msg_result: .asciiz "\nRisultato: "

A: .word  1,2,3,4,5,2,4,6,8,10,3,6,9,12,15,4,8,12,16,20,5,10,15,20,25 #A[5][5].

.text
.globl main



### MAIN ###
main:

welcome:
la $a0,msg_welcome #carica l'indirizzo di msg_welcome.
addi $v0,$zero,4 #codice servizio print string.
syscall

chiamata_a_S:
addi $a0,$s1,0 #$a0=(A+0).
addi $a1,$s0,0 #$a1=n.
jal S
nop

result:
addi $t0,$v0,0 #$t0=$v0=risultato di S.
la $a0,msg_result #carica l'indirizzo di msg_result.
addi $v0,$zero,4 #codice servizio print string.
syscall

addi $a0,$t0,0 #$a0=$t0=risultato di S.
addi $v0,$zero,1 #codice servizio print int.
syscall

exit_program:
addi $v0,$zero,10 #codice servizio exit.
syscall
### FINE MAIN ###



### FUNZIONE int S(int *A): somma degli elementi A[i][j] di un array bidimensionale nxn=5x5, che soddisfano la seguente relazione: A[i][j]=T(A[(i*2)mod(n)][j/2]). $v0=S(int *A). ###
S:

#$s1=i.
#$s2=j.
#t4=n*4*i. (utilizzato anche per la costruzione dell'indice i'=(i*2)mod(n).
#$t5=4*j. (utilizzato anche per la costruzione dell'indice j'=j/2.
#$t6: registro temporaneo da utilizzare per la costruzione degli indirizzi di memoria.
#$t7: registro temporaneo per elemento A[i][j].

subu $sp,$sp,16 #alloca uno stack frame di S(int *A) da 16 byte. 1 locazione per $ra, 1 locazione per $a0=(A+0), 1 locazione per $a1=n, 1 locazione per T(A[(i*2)mod(n)][j/2]).
sw $ra,0($sp) #carica l'indirizzo di ritorno in fondo allo stack frame.
sw $a0,4($sp) #carica $a0=(A+0) nello stack frame.
sw $a1,8($sp) #carica $a1=n nello stack frame.

addi $s1,$zero,0 #$s1=i=0.
addi $s2,$zero,0 #$s2=j=0.

ciclo_for_righe:
slt $t1,$s1,$a1 #$t1=1 iff $s1=i<$a1=n, quindi $t1=1 sse i<n.
beq $t1,$zero,exit_ciclo_for_righe #salta alla fine del ciclo for righe sse $t1=0, quindi sse i=>n.
sll $t4,$s1,2 #$t4=4*$s1, quindi $t4=4*i.
mul $t4,$a1,$t4 #$t4=$a1*$t4, quindi $t4=n*4*i. $t4 funge quindi da indice di scorrimento delle righe.
add $t4,$t4,$a0 #$t4=$t4+$a0, quindi $t4=(A+0)+(n*4*). $t4 funge dunque da indice di base delle righe.

ciclo_for_colonne:
slt $t1,$s2,$a1 #$t1=1 iff $s2=j<$a1=n, quindi $t1=1 sse j<n.
beq $t1,$zero,exit_ciclo_for_colonne #salta alla fine del ciclo for colonne sse $t1=0, quindi sse j=>n.
sll $t5,$s2,2 #$t5=4*$s2, quindi $t5=4*j. $t5 funge quindi da indice di scorrimento delle colonne della i-esima riga il cui indice di base è $t4.
add $t6,$t4,$t5 #$t6=$t4+$t5, cioè $t6=(indice di base della i-esima riga)+(indice di scorrimento delle colonne).
lw $t7,0($t6) #$t7=A[i][j], cioè l'elemento della i-esima riga j-esima colonna.

sll $t4,$s1,2 #$t4=2*$s1, quindi $t4=2*i.
div $t4,$a1 #$t4/$a1, cioè (2*i)/n. Il quoziente è posto nel registro lo, il resto è posto nel registro hi. (anoi interessa il resto della divisione, perchè vogliamo implementare l'operazione modulo). Quindi [hi]=(2*i)mod(n).
mfhi $t4 #$t4=[hi], quindi $t4=i'=(2*i)mod(n).

srl $t5,$s2,1 #$t5=$s2/2, quindi $t5=j'=(j/2).

#IMPORTANTE: costruzione dell'indirizzo di memoria di A[(2*i)mod(n)][(j/2)]==A[i'][j']; lo costruiamo in $t6.$t6=(A+0)+(n*4*i')+(4*j').

sll $t4,$t4,2 #$t4=4*$t4, quindi $t4=4*i'.
mul $t4,$a1,$t4 #$t4=$a1*$t4=(n*4*i').

sll $t5,$t5,2 #$t5=4*$t5, quindi $t5=4*j'.

add $t6,$a0,$t4 #$t6=$a0+$t4, quindi $t6=(A+0)+(n*4*i').
add $t6,$t6,$t5 #$t6=$t6+$t5, quindi $t6=(A+0)+(n*4*i')+(4*j').

lw $t0,0($t6) #$t0=A[(i*2)mod(n)][j/2]. $t0 è quindi l'argomento m di T(m).
jal T #chiama T(m).
nop

beq $t7,$v1,aggiorna_somma #salta a aggiorna somma se è verificata la condizione if(A[i][j]=T(A[(i*2)mod(n)][j/2])).

addi $s2,$s2,1 #$s2=($s2+1), cioè j++.
j ciclo_for_colonne

aggiorna_somma:
add $v0,$v0,$t7 #$v0=($v0+$t7), cioè viene aggiunto alla somma l'elemento $t7 che soddisfa la condizione.
addi $s2,$s2,1 #$s2=($s2+1), cioè j++.
j ciclo_for_colonne

exit_ciclo_for_colonne:
addi $s2,$zero,0 #$s2=j=0.
addi $s1,$s1,1 #$s1++=i++.
j ciclo_for_righe

exit_ciclo_for_righe:
lw $ra,0($sp) #carica l'indirizzo di ritorno.
addi $sp,$sp,16 #dealloca lo stack frame di S(int *A).
jr $ra
###FINE FUNZIONE int S(int *A) ###



### FUNZIONE T(m): T(m)=1 per m<=2; T(m)=T(m-1)+T(m-3) altrimenti. $v1=T(m).###
T:
subu $sp,$sp,16 #alloca lo stack frame da 16 byte. 1 locazione per $ra, 1 locazione per $t0=m, 1 locazione per T(m-1), 1 locazione per T(m-3).
sw $ra,0($sp) #carica l'indirizzo di ritorno in fondo allo stack frame.
sw $t0,4($sp) #carica $t0=(A+0) nello stack frame.

slti $t1,$t0,3 #$t1=1 iff $t0<3, cioè $t1=1 sse m<=2.
bne $t1,$zero,caso_minore_uguale_2 #$t1=0 iff $t0=>3, cioè $t1=0 sse m=>3. base della ricorsione: T(m<=2)=1.

subu $t0,$t0,1 #$t0=(m-1), per la chiamata ricorsiva T(m-1).
jal T #chiama T(m-1).

sw $v1,8($sp) #carica nello stack frame di T(m) il risultato di T(m-1).

lw $t0,4($sp) #$t0=m.
subu $t0,$t0,3 #$t0=(m-3), per la chiamata ricorsiva T(m-3).
jal T #chiama T(m-3).

sw $v1,12($sp) #carica nello stack frame di T(m) il risultato di T(m-3).

lw $ra,0($sp) #carica l'indirizzo di ritorno.
lw $t2,8($sp) #$t2=T(m-1).
lw $t3,12($sp) #$t3=T(m-3).

sub $v1,$t2,$t3 #$v1=T(m)=T(m-1)-T(m-3).

addi $sp,$sp,16 #dealloca lo stack frame di T(m): saliamo quindi a T(m+1).
jr $ra

caso_minore_uguale_2:
addi $v1,$zero,1 #base della ricorsione: T(m<=2)=1.
lw $ra,0($sp) #carica l'indirizzo di ritorno.
addi $sp,$sp,16 #dealloca lo stack frame della chiamata ricorsiva corrente.
jr $ra
### FINE FUNZIONE T(m) ###
