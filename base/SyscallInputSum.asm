# @Name: SyscallInputSum
# @Description: The program sums two integers, prompted by the user, the displays the result.
#
# @Author: Giacomo Marciani <giacomo.marciani@gmail.com>

.text
.globl main

main:
	la $t0, value

	li $v0, 5          # loads the syscall 'read_int' in register $v0
	syscall            # executes the syscall 'read_int'
	sw $v0, 0($t0)     # stores the integer returned by the syscall. $t0=a

	li $v0, 5          # loads the syscall 'read_int' in register $v0
	syscall            # executes the syscall 'read_int'
	sw $v0, 4($t0)     # stores the integer returned by the syscall. $t0=b

	lw $t1, 0($t0)     # $t1=a
	lw $t2, 4($t0)     # $t2=b
	add $t3, $t1, $t2  # $t3=c=a+b
	sw $t3, 8($t0)     # $t0=c

	li $v0, 4          # loads the syscall 'print_string' in register $v0
	la $a0, msgSum     # 'print_string' with argument msgSum
	syscall            # executes the syscall 'print_string'

	li $v0, 1          # loads the syscall 'print_int' in register $v0
	move $a0, $t3      # 'print_int' with argument $t3
	syscall            # executes the syscall 'print_int'

	li  $v0, 10        # loads the syscall 'program_exit' in register $v0
	syscall	           # executes the syscall 'program_exit'

	.data
value:	.word 0, 0, 0
msgSum:	.asciiz "The sum is "
