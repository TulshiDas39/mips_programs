.text

main:

	la $a0, i    #$a0 = address of i
	la $a1, A    #$a1 = address of A
	la $a2, B    #	$a2 = address of B
	
	add $s1 , $a1,$zero  # $s1 = $a1+0
	add $s2 , $a2,$zero # $s1 = $a1+0

	li $t0, 0    #$t0 = 0
	sw $t0, ($a0) # i = $t0
	
#for loop 
begin: bge $t0,5, end    # loop will execute 5 times
	mul $t3, $t0, 4     # $t3 = 4*$t0
	add $a1, $a1, $t3   # $a1= $a1 + $t3
	add $a2, $a2, $t3   # $a2= $a2 + $t3
	lw $t2, ($a2)       # $t2 = B[i]
	subi $t2, $t2 ,1    # $t2 = $t2 - 1
	sw  $t2, ($a1)      # A[i] = $t2
	addi  $t0, $t0, 1   # $t0 = $t0 + 1
	sw  $t0, ($a0)      # i = $t0
	move $a1, $s1		# $a1 = $s1
	move $a2, $s2		# $a2 = $s2
	
	j begin
end:
	addi  $t0, $t0, -1   # $t0 = $t0 - 1
	sw  $t0, ($a0)       # i = $t0
	
# while loop
while: bltz $t0, exit
	mul $t3, $t0, 4     # $t3 = 4*$t0
	add $a1, $a1, $t3   # $a1= $a1 + $t3
	add $a2, $a2, $t3   # $a2= $a2 + $t3
	lw $t1, ($a1)       # $t1 = A[i]
	lw $t2, ($a2)       # $t2 = B[i]	
	addu $t4, $t1,$t2   # $t4 = A[i] + B[i]
	mul $t4, $t4,2      # $t4 = $t4*2
	sw $t4, ($a1)       # A[i] = $t4
	addi  $t0, $t0, -1  # $t0 = $t0 - 1
	sw  $t0, ($a0)      # i = $t0
	move $a1, $s1		# $a1 = $s1
	move $a2, $s2		# $a2 = $s2
	
	j while

#exit program	
exit:
	li $v0, 10
	syscall

.data
A:	.space 20
B:	.word  1,2,4,8,16
i:   .space 4
