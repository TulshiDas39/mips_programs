.text
main:
	li $v0,4
	la $a0, welcomeMessage
	syscall

   ## jal printBoard
   
	li $v0,4
	la $a0, randomInitializerMassage
	syscall

	li $v0,4
	la $a0, randomNumber1InputMessage
	syscall
	
	li $v0,5
	syscall
	
	move $a0, $v0
	li  $v0, 1
	syscall

.data
m_w:   .space 4           #int m_w
m_z:   .space 4           #int m_z   
myScore:   .word  0       #int myScore=0
yourScore:  .word  0      #int yourScore=0

welcomeMessage:  .asciiz  "Welcome to Dots and Boxes!\nVersion 1.0\nImplemented by: \n1.Uddip Acharjee\n2.Obaidur Rahman\n3.Hasnuzzaman Hasan\n4.Tulshi Chandra Das\n\n"
randomInitializerMassage:	.asciiz   "\nEnter two positive numbers to initialize the random number generator.\n"
randomNumber1InputMessage:	 .asciiz  "Number 1: "
