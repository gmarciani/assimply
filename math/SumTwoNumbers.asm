# Name: SumTwoNumbers
# Description: The program computes the sum of two numbers stored in registers.
#
# Author: Giacomo Marciani <giacomo.marciani@gmail.com>


.text
.globl  main

main:
	ori $8, $0, 0xA # loads "10" into register 8
	ori $9, $0, 0xC # loads "12" into register 9
	add $10,$8, $9  # adds registers 8 and 9, then puts the result in register 10
