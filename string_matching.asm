.text
main:

	la $s0, result
	
# take input of string of 255 char
	li $v0, 8           # $v0=8
	la $a0, string      # $a0= address of string
	li $a1, 255         # $a1 = 255
	syscall
	
	li $t0 ,'m'    #$t0 = 'm'


	li $t1, 0        #  $t1 =0
	move $t2, $a0    # $t2 = $a0, $a0= address of string
	lb $t3 ,($t2)    # $t3 = string[0]
	
#searching start here	
search: beqz $t3, finish  # if $t3 == 0 goto label finish
	beq $t3, $t0 found   # if $t3 == 'm' goto label found
	addi $t1, $t1, 1     # $t1= $t1+ 1   
	add $t2, $t2, 1      # $t2 = $t2 + 1
	lb $t3 ,($t2)        # $t3 = string[0]
	j search
# print the found message and address
found:  sw $t2 ,($s0)  # result = $t2
	li $v0, 4		   # $v0=0
	la $a0, message1  # $a0 = address of label message
	syscall       
	li $v0, 1         # $v0 = 1
	lw $a0, ($s0)     # $a0 = result
	syscall         
	li $v0, 4         # $v0 = 4
	la $a0, newln     # $a0 = address of newln label
	syscall           # print the message of address found
	j exit            # goto exit
	
# prin the not found message
finish:
	li $v0, 4
	la $a0, message2
	syscall

# exit the program	
exit:
	li $v0, 10
	syscall


.data
string:  .space  256
i:       .word   0
result:  .word   0
newln:   .asciiz "\n"
message1: .asciiz  "First match at address  "
message2: .asciiz  "No match found\n"