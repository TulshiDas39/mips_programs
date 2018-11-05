.text
 main:

	la $a0, A
	la $a1, B

	lw $s0, ($a0)	# $s0 = A
	lw $s1, ($a1)  # $s1 = B

# if A>B goto L1
	bgt $s0, $s1 L1	# if $s0>$s1 goto L1
	la $a0, C           # $a0 = address of C
	lw $s2, ($a0)  	# $s2 = C
	add $t2, $s2, 1 	# $t2 = $s2 + 1
	beq $t2, 7, L1		# if $t2 == 7 goto L1
	
	j L2                # goto L2

# assign the value of z to 1
L1:  la $a0, Z           # $a0 = address of Z
	li $s3, 1           # $s3 = 1
	sw $s3, ($a0) 		# Z=1 
	j L6                # goto L6
	
# if(A < B && C > 5) goto label L4
L2:  blt $s0, $s1, L3    # if $s0<$s1 go to L3
	j L5                # goto L5
L3:  bgt $s2, 5, L4      # if $s2>5 goto L4
	j L5                # go to L5

# z = 2
L4:  la $a0, Z           # $a0 = address of Z
	li $s3, 2           # $s3 = 2
	sw $s3, ($a0)       # z = $s3
	j L6                # goto L6

# z=3
L5:	li $s3, 3           # $s3 = 3
     la $a0, Z           # $a0 = address of Z
	sw $s3, ($a0)       # Z= 3
	


# conditional switch blocks to check the value of z and negate it
L6:		la $a0, Z     # $a0 = address of Z

case1:    beq $s3, 1, setNeg1  # if $s3 == 1 goto setNeg1,here $s3 is the value of z
	     j case2              # goto case2 label
	   
setNeg1:  li $s3, -1           # $s3 = -1
		sw $s3, ($a0)        # z = -1
		j end                # goto end , end is label
case2:    beq $s3 , 2, setNeg2 #if $s3 == 2 goto setNeg2
	     j case3              # if goto case3

setNeg2:  li $s3, -2           # $s3 = -2
		sw $s3, ($a0)        # z= -2
		j end                # goto end

case3:   beq $s3 , 3, setNeg3  # if $s2 == 3 goto setNeg3
	    j end                 # goto j

setNeg3:  li $s3, -3           # $s3 = -3
		sw $s3, ($a0)        # z= -3

end: 
	
	li $v0, 10                
	syscall                   # exit program

.data

A:	.word  10
B:	.word  15
C:	.word  6
Z:	.word  0