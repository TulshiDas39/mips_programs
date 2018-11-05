
.text

main:
	# assign immendiate value to sixt temporary registers

	addi $t0,  $zero, 15		#$t0=15
	addi $t1, $zero, 10		#$t1=10
	addi $t2, $zero, 5		#$t2=5
	addi $t3, $zero, 2		#$t3=2
	addi $t4, $zero, 18		#$t4 = 18
	addi $t5, $zero, -3		#$t5= -3
	
	
	la   $a0, z  		#load the address of variable z
	
	sw $zero, ($a0)          # z=0
	# calculation starts
	
	sub $t6, $t0, $t1   	# $t6 = $t0-$t1
	add $t7, $t2, $t3	#$t7  = $t2 + $t3
	mul $t7, $t7, $t6	#$t7 = $t6 * $t7
	sub $t6, $t4, $t5	#$t6 = $t4-$t5
	add $t7, $t7, $t6       #$t7= $t7 + $t6
	div $t6, $t0, $t2       # $t6 = $t0/$t2
	sub $t7, $t7, $t6       # $t7= $t7- $t6
	
	sw $t7, ($a0)			# z=$t7
					# ultimately, z= ($t0-$t1)*($t2 + $t3)+($t4-$t5)-($t0/$t2)
		
	li $v0,4
	la $a0,result
	syscall
	
	li $v0, 10
	syscall	
	
.data

z:	.space 4
result: .asciiz "Result: "