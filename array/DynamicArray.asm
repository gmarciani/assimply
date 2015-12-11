# @Name: DynamicArray
# @Description: The program allocates (iteratively) a NxN array, as defined by the user.
#
# @Author: Giacomo Marciani <giacomo.marciani@gmail.com>


.data
msg_welcome: .asciiz "Il programma carica nel data segment un array bidimensionale nxn impostato dall'utente attraverso un ciclo iterativo."
msg_input: .asciiz "Inserisci n: "
msg_input_riga_0: .asciiz "\n\nInserisci i "
msg_input_riga_1: .asciiz " elementi della riga "
msg_input_riga_2: .asciiz ": "

primo_elemento_array: .word 0 #funge da segnalibro nella memoria, per costruire gli indirizzi di base dell'array bidimensionale.

.text
.globl main

### MAIN ###
main:

welcome:
la $a0,msg_welcome #carica l'indirizzo di msg_welcome.
addi $v0,$zero,4 #codice servizio print string.
syscall

user_input_n:
la $a0,msg_input #carica l'indirizzo di msg_input.
addi $v0,$zero,4 #codice servizio print string.
syscall
addi $v0,$zero,5 #codice servizio read int.
syscall
addi $s0,$v0,0 #$s0=n.
### FINE MAIN ###



### INPUT ARRAY ###
user_input_array:
la $s1,primo_elemento_array #$s1=indice di base dell'array, punta a A[0][0].
addi $s2,$s1,0 #$s2=indice di base della i-esima riga, punta a A[i][0].
addi $t0,$zero,0 #$t0=i=0.

ciclo_for_user_input_righe_array:
addi $t1,$zero,0 #$t1=j=0.
slt $t4,$t0,$s0 #$t4=1 iff $t0=i<$s0=n, cioè $t4=1 sse i<n.
beq $t4,$zero,exit_ciclo_for_user_input_righe_array #salta alla fine del ciclo righe se $t4=0, cioè sse i=>n.
sll $t2,$t0,2 #$t2=4*$t0, cioè $t2=4*i, quindi $t2=indice scorrimento righe array.

la $a0,msg_input_riga_0 #carica l'indirizzo di msg_input_riga_0.
addi $v0,$zero,4 #codice servizio print string.
syscall
addi $a0,$s0,0 #$a0=n.
addi $v0,$zero,1 #codice servizio print int.
syscall
la $a0,msg_input_riga_1 #carica l'indirizzo di msg_input_riga_1.
addi $v0,$zero,4 #codice servizio print string.
syscall
addi $a0,$t0,0 #$a0=i.
addi $v0,$zero,1 #codice servizio print int.
syscall
la $a0,msg_input_riga_2 #carica l'indirizzo di msg_input_riga_2.
addi $v0,$zero,4 #codice servizio print string.
syscall

ciclo_for_user_input_colonne_array:
slt $t4,$t1,$s0 #$t4=1 iff $t1=j<$s0=n, cioè $t4=1 sse j<n.
beq $t4,$zero,exit_ciclo_for_user_input_colonne_array #salta alla fine del ciclo colonne della riga i-esima se $t4=0, cioè se j=>n.
sll $t3,$t1,2 #$t3=4*$t1, cioè $t3=4*j, quindi $t3=indice scorrimento colonne array.
add $t5,$s2,$t3 #$t5=indirizzo della j-esima colonna, nella i-esima riga.
addi $v0,$zero,5 #codice servizio read int.
syscall
sw $v0,0($t5) #pone x in A[i][j].

addi $t1,$t1,1 #$t1+1, cioè j++.
j ciclo_for_user_input_colonne_array

exit_ciclo_for_user_input_colonne_array:
nop
addi $t0,$t0,1 #$t0+1, cioè i++.
add $s2,$s2,$t3 #$s2=$s2+$t3, cioè $s2indica l'ultimo elemento della i-esima riga.
addi $s2,$s2,4  #$s2=$s2+4, cioè $s2 indica il primo elemento della (i+1)-esima riga.
j ciclo_for_user_input_righe_array

exit_ciclo_for_user_input_righe_array:
nop
### FINE INPUT ARRAY ###
