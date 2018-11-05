.data
board: .asciiz "  1 2 3 4\na . . . .\nb . . . .\nc . . . .\nd . . . .\n"
msg1: .asciiz "  Enter coordinate of the first dot: "
msg2: .asciiz "  Enter coordinate of the second dot: "
str: .space 4
row1: .space 4
column1: .space 4
row2: .space 4
column2: .space 4
msg3: .asciiz "Coordinates must be adjacent\n"
msg4: .asciiz "There is already a line there.\n"
space: .byte ' '
underscore: .byte '_'
line: .byte '|'
H: .byte 'H'
C: .byte 'C'

iteration: .word 1
randomValue: .word 1
prev: .word 0
isFirstMove: .word 1

yourScore: .word 0
myScore: .word 0

player1: .asciiz "player 1:\n"
player2: .asciiz "player 2:\n"

p1: .asciiz "\nplayer 1 wins!!\n"
p2: .asciiz "\nplayer 2 wins!!\n"
.text

main:
	
	jal printBoard
	
	jal play
	
	jal printBoard
	
	lw $t0,yourScore
	lw $t1,myScore
	
	bgt $t0,$t1,who
		li $v0,4
		la $a0,p1
		syscall
	j whopass
	who:
		li $v0,4
		la $a0,p2
		syscall
	whopass:
	
	li $v0,10
	syscall
	
printBoard:
	li $t0,0					    #  int i =0
	for1:
		beq $t0,5,endfor1           #   if (i==5)    exit outer for loop
		li $t1,0				    #   int j=0
		for2:
			beq $t1,10,endfor2		# if (j==10)    exit inner for loop
			mul $t3,$t0,10			
			add $t3,$t3,$t1			
			lb $t4,board($t3)		#  board[i][j]
			
			li $v0,11				# print   board[i][j]
			move $a0,$t4
			syscall
			
			addi $t1,$t1,1
			j for2
		endfor2:
		addi $t0,$t0,1
		j for1
	endfor1:
	jr $ra	
########### END OF printBoard  

play:
		
	while:
	lw $t0,iteration
	bgt $t0,24,endWhile
	 
	li $t7,2
	div $t0,$t7
	mfhi $t7
	
	beqz $t7,turn
		li $v0,4
		la $a0,player1
		syscall
		j turn_over
	turn:
		li $v0,4
		la $a0,player2
		syscall
	turn_over:
	##  read the first dot
	li $v0,4
	la $a0,msg1
	syscall
	
	li $v0,8
	la $a0,str
	li $a1,4
	syscall
	
	#convert string to row1 and column1
	li $t0,0				
	lb $t0,str($t0)			
	addi $t0,$t0,-96		
	sw $t0,row1				
	
	li $t0,1
	lb $t0,str($t0)
	addi $t0,$t0,-48
	sw $t0,column1
	
	## read the second dot	
	li $v0,4
	la $a0,msg2
	syscall
	
	li $v0,8
	la $a0,str
	li $a1,4
	syscall
	
	#convert string to row2 and column2
	li $t0,0
	lb $t0,str($t0)
	addi $t0,$t0,-96
	sw $t0,row2
	
	li $t0,1
	lb $t0,str($t0)
	addi $t0,$t0,-48
	sw $t0,column2
	
	#####################
	
	lw $t0,row1
	lw $t1,row2
	lw $t2,column1
	lw $t3,column2
	
	bne $t0,$t1,else1
		
		addi $t4,$t3,1
		subi $t5,$t3,1
		
		beq $t2,$t4,col_adjacent
		bne $t2,$t5,else3
		col_adjacent:
			blt $t2,$t3,min
			move $t4,$t3
			j min_found
			min: move $t4,$t2		## ## ##   $t4 = min($t2,$t3)
			min_found:
			
			# if( board[row1][min*2+1]==' ')
			mul $t5,$t0,10			##  $t5 = row1*10    for getting the row number
			
			mul $t9,$t4,2			# $t9=min*2
			addi $t9,$t9,1			# $t9= min*2+1
			
			add $t6,$t5,$t9			#####  $t6= board(row1*10+(min*2+1))
			
			lb $t7,board($t6)		# $t7= board($t6)
			
			lb $t8,space
			bne $t7,$t8,else4		## if( $t7 !=$t8) go to else4
				
				lb $t8,underscore
				sb $t8,board($t6)
				
				##  if( row1!=4)
				beq $t0,4,check_upper_box
					addi $t5,$t0,1
					mul $t5,$t5,10		### $t5=row1+1
					
					mul $t9,$t4,2		# $t9=min*2
					add $t6,$t5,$t9     # address of  board[row+1][min*2]
					
					lb $t7,board($t6)
					lb $t8,line
					
					bne $t7,$t8,check_upper_box
					
					add $t9,$t9,1  		#$t9=min*2+1
					add $t6,$t5,$t9			# address of  board[row+1][min*2+1]
					
					lb $t7,board($t6)
					lb $t8,underscore
					
					bne $t7,$t8,check_upper_box
					
					add $t9,$t9,1
					add $t6,$t5,$t9			# address of  board[row+1][min*2+2]
					
					lb $t7,board($t6)
					lb $t8,line
					
					bne $t7,$t8,check_upper_box
						add $t9,$t9,-1
						add $t6,$t5,$t9			# address of  board[row+1][min*2+1]
						
						####  if(iteration%2==0)
						lw $t8,iteration
						li $t7,2
						div $t8,$t7
						mfhi $t8
						
						bnez $t8,fill_with_C1
							lb $t7,H
							sb $t7,board($t6)
							
							lw $t7,yourScore
							addi $t7,$t7,1
							sw $t7,yourScore
							
							j check_upper_box
						fill_with_C1:
							lb $t7,C
							sb $t7,board($t6)
							
							lw $t7,myScore
							addi $t7,$t7,1
							sw $t7,myScore
						
					
				check_upper_box:
				## if( row1 !=1)
				beq $t0,1,upper_box_checking_finished
					mul $t5,$t0,10
					mul $t9,$t4,2
					add $t6,$t5,$t9
					lb $t7,board($t6)
					lb $t8,line
					
					bne $t7,$t8,upper_box_checking_finished
					addi $t9,$t9,2	
					add $t6,$t5,$t9
					lb $t7,board($t6) 
					lb $t8,line
					
					bne $t7,$t8,upper_box_checking_finished
					addi $t5,$t0,-1
					mul $t5,$t5,10
					mul $t9,$t4,2
					addi $t9,$t9,1
					add $t6,$t5,$t9
					lb $t7,board($t6) 
					lb $t8,space
					
					beq $t7,$t8,upper_box_checking_finished
						mul $t5,$t0,10
						add $t6,$t5,$t9
						
						####  if(iteration%2==0)
						lw $t8,iteration
						li $t7,2
						div $t8,$t7
						mfhi $t8
						
						bnez $t8,fill_with_C2
							lb $t7,H
							sb $t7,board($t6)
							
							lw $t7,yourScore
							addi $t7,$t7,1
							sw $t7,yourScore
							
							j upper_box_checking_finished
						fill_with_C2:
							lb $t7,C
							sb $t7,board($t6)
							
							lw $t7,myScore
							addi $t7,$t7,1
							sw $t7,myScore
						
				upper_box_checking_finished:
				
				####  call  printBoard
				addi $sp,$sp,-4
				sw $ra,4($sp)
				
				jal printBoard
				
				lw $ra,4($sp)
				addi $sp,$sp,4
				
				#####   iteration++  
				lw $t0,iteration
				addi $t0,$t0,1
				sw $t0,iteration
				
				j next
			else4:
				li $v0,4
				la $a0,msg4
				syscall
				j next
		else3:
		li $v0,4
		la $a0,msg3
		syscall
		
		j next
	else1:
		bne $t2,$t3,coor_not_adjacent   ##  if(column1!=column2) goto coor_not_adjacent
		addi $t4,$t1,1
		addi $t5,$t1,-1
		beq $t0,$t4,row_equal
		bne $t0,$t5,coor_not_adjacent
		row_equal:
			bgt $t0,$t1,max
			move $t4,$t1
			j max_found
			max: move $t4,$t0             ###  $t4=max($t0,$t1)
			max_found:
			
			mul $t5,$t4,10      		###  $t5= max*10         
			mul $t9,$t2,2                #  $t9 =$t2*2
			
			add $t6,$t5,$t9             #### address in board element
			
			lb $t7,board($t6)
			lb $t8,line
			
			beq $t7,$t8,line_there
				sb $t8,board($t6)
				
				# if(column1!=4)
				beq $t2,4,check_left_box
					addi $t9,$t9,1
					add $t6,$t5,$t9
					lb $t7,board($t6)
					lb $t8,underscore
					
					bne $t7,$t8,check_left_box
					
					subi $t5,$t4,1
					mul $t5,$t5,10
					add $t6,$t5,$t9
					lb $t7,board($t6)
					lb $t8,space
					
					beq $t7,$t8,check_left_box 
					
					mul $t5,$t4,10
					addi $t9,$t9,1
					add $t6,$t5,$t9
					lb $t7,board($t6)
					lb $t8,line
					
					bne $t7,$t8,check_left_box
						addi $t9,$t9,-1
						add $t6,$t5,$t9
						
						####  if(iteration%2==0)
						lw $t8,iteration
						li $t7,2
						div $t8,$t7
						mfhi $t8
						
						bnez $t8,fill_with_C3
							lb $t7,H
							sb $t7,board($t6)
							
							lw $t7,yourScore
							addi $t7,$t7,1
							sw $t7,yourScore
							
							j check_left_box
						fill_with_C3:
							lb $t7,C
							sb $t7,board($t6)
							
							lw $t7,myScore
							addi $t7,$t7,1
							sw $t7,myScore
				
				check_left_box:
				# if(column1!=1)
				beq $t2,1,checking_left_box_finished
					mul $t5,$t4,10
					mul $t9,$t2,2
					addi $t9,$t9,-1
					add $t6,$t5,$t9
					lb $t7,board($t6)
					lb $t8,underscore
					
					bne $t7,$t8,checking_left_box_finished
					
					addi $t5,$t4,-1
					mul $t5,$t5,10
					add $t6,$t5,$t9
					lb $t7,board($t6)
					lb $t8,space
					
					beq $t7,$t8,checking_left_box_finished
					
					mul $t5,$t4,10
					addi $t9,$t9,-1
					add $t6,$t5,$t9
					lb $t7,board($t6)
					lb $t8,line
					
					bne $t7,$t8,checking_left_box_finished
						addi $t9,$t9,1
						add $t6,$t5,$t9
						
						####  if(iteration%2==0)
						lw $t8,iteration
						li $t7,2
						div $t8,$t7
						mfhi $t8
						
						bnez $t8,fill_with_C4
							lb $t7,H
							sb $t7,board($t6)
							
							lw $t7,yourScore
							addi $t7,$t7,1
							sw $t7,yourScore
							
							j checking_left_box_finished
						fill_with_C4:
							lb $t7,C
							sb $t7,board($t6)
							
							lw $t7,myScore
							addi $t7,$t7,1
							sw $t7,myScore
				    
				checking_left_box_finished:
				
				####  call  printBoard
				addi $sp,$sp,-4
				sw $ra,4($sp)
				
				jal printBoard
				
				lw $ra,4($sp)
				addi $sp,$sp,4
				
				
				#####   iteration++  
				lw $t0,iteration
				addi $t0,$t0,1
				sw $t0,iteration
				
				j next
			line_there:
				li $v0,4
				la $a0,msg4
				syscall
				j next
		coor_not_adjacent:
			li $v0,4
			la $a0,msg3
			syscall
	next:
	j while
	
	endWhile:
	jr $ra
	
	
