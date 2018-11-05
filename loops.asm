.text
main:

	li $t0, 0    #$t0 = 0
	la $a0, i    #$a0 = address of i
	sw $t0, ($a0) # i = $t0
	
	la $a1, Z       #a1 = address of Z
	lw $t1, ($a1)   # $t1 = z
	
# for loop from i= 0 to i =21

begin: bgt $t0, 21, end  # if z>21 go to end
	addi  $t0, $t0,3    # $t0 = $t0 + 3
	sw  $t0, ($a0)      # i = $t0
	addi  $t1, $t1,1    # $t1 = $t1 + 1
	sw $t1, ($a1)       # z = z+1
	j begin
end:

# do while loop
do: 
	addi  $t1, $t1,1    # $t1 = $t1 + 1
	sw $t1, ($a1)       # z = $t1
     blt $t1, 100, do    # while(z<100)

# while loop
while: blez $t0, break
	subi  $t0, $t0,1    # $t0 = $t0 -1
	sw  $t0, ($a0)      # i = $t0
	subi  $t1, $t1,1    # $t1 = $t1 - 1
	sw $t1, ($a1)       # z = z-1
     j while
break:
		
	li $v0,10
	syscall 
	
.data

i:	 .space 4
Z:	 .word  4