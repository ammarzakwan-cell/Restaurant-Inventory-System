.data
	#LogIn
	promptName:		.asciiz "Please Enter Staff Username: "
	promptPass:		.asciiz "Please Enter Staff Password: "
	errorPass:		.asciiz "Password Not Match \n"
	errorUser:		.asciiz "User Not Match \n"
	
	#Option
	optionLists: 	.asciiz "\nChoose option\n\n1) Display Items\n2) Update Add\n3) Update Sub\n4) Sign Out\n\n"
	
	#Space
	space:	.asciiz "\n"
	
	#Warning Items below 10
	errorApple: 	.asciiz "THE APPLE IS BELOW 10. PLEASE UPDATE NOW!!!\n"
	errorOrange: 	.asciiz "THE ORANGE IS BELOW 10. PLEASE UPDATE NOW!!!\n"
	errorPineapple: .asciiz "THE PINEAPPLE IS BELOW 10. PLEASE UPDATE NOW!!!\n"
	errorKiwi: 	.asciiz "THE KIWI IS BELOW 10. PLEASE UPDATE NOW!!!\n"
	errorDurian: 	.asciiz "THE DURIAN IS BELOW 10. PLEASE UPDATE NOW!!!\n"
	
	#Validation
	user1:	.asciiz "staff\n"
	pass1:	.asciiz "abc123\n"
	
	#Input
	user: .space 80
	pass: .space 80
	
	#Item
	apple: 		.word 15
	orange: 	.word 14
	pineapple: 	.word 2
	kiwi:		.word 6
	durian:		.word 23
	
	msg3:	.asciiz "\nApple: "
	msg4: 	.asciiz "\nOrange: "
	msg5:	.asciiz "\nPineapple: "
	msg6: 	.asciiz "\nKiwi: "
	msg7:	.asciiz "\nDurian: "
	msg1: 	.asciiz "\nEnter the number to add apples: "
	msg2: 	.asciiz "Enter the number to add oranges: "
	msg8: 	.asciiz "Enter the number to add pineapple: "
	msg9: 	.asciiz "Enter the number to add kiwi: "
	msg10: 	.asciiz "Enter the number to add durian: "
	msg11: 	.asciiz "\nEnter the number to sub apples: "
	msg12: 	.asciiz "Enter the number to sub oranges: "
	msg13: 	.asciiz "Enter the number to sub pineapple: "
	msg14: 	.asciiz "Enter the number to sub kiwi: "
	msg15: 	.asciiz "Enter the number to sub durian: "

.text

#----------------------------------------------------------------------------------------------

 	login:
  	#compare input with the databse
 	la $s2, user1
 	la $s3, user
    	move $t2,$s3
    	jal getstr
    	
    	# string compare loop (just like strcmp)
	cmploop:
    	lb $t2,($s2) # get next char from str1
    	lb $t3,($s3) # get next char from str2
    	bne $t2,$t3,cmpne # are they different? if yes, fly

    	beq $t2,$zero,passwordCheck # at EOS? yes, (strings equal)

    	addi $s2,$s2,1 # get next char
    	addi $s3,$s3,1 # get next char
    	j cmploop          

	# strings are _not_ equal -- print message
	cmpne:
    	la      $a0,errorUser
    	li      $v0,4
    	syscall
    	j login
    	
    	getstr:
 	#prompt username
 	li $v0,4
	la $a0, promptName
 	syscall
 	
 	# read in the string
    	move    $a0,$t2
    	li      $a1,79
    	li      $v0,8
    	syscall

    	jr $ra

#----------------------------------------------------------------------------------------------

	passwordCheck:
 	#compare input with the databse
 	la $s2, pass1
 	la $s3, pass
    	move $t2,$s3
    	jal getstrpass
    	
    	# string compare loop (just like strcmp)
	cmplooppass:
    	lb $t2,($s2) # get next char from str1
    	lb $t3,($s3) # get next char from str2
    	bne $t2,$t3,cmpnepass # are they different? if yes, fly

    	beq $t2,$zero,checkWarning # at EOS? yes, (strings equal)

    	addi $s2,$s2,1 # get next char
    	addi $s3,$s3,1 # get next char
    	j cmplooppass          

	# strings are _not_ equal -- print message
	cmpnepass:
    	la      $a0,errorPass
    	li      $v0,4
    	syscall
    	j passwordCheck
    	
    	getstrpass:
 	#prompt username
 	li $v0,4
	la $a0, promptPass
 	syscall
 	
 	# read in the string
    	move    $a0,$t2
    	li      $a1,79
    	li      $v0,8
    	syscall

    	jr $ra
	
#----------------------------------------------------------------------------------------------
	
	checkWarning:
	
	#Space
	li $v0,4
	la $a0,space
	syscall
	
	#load data
	lw $t2, apple
	lw $t3, orange
	lw $t6, pineapple
	lw $t7, kiwi
	lw $t9, durian

	li $t4,10 #load data 10 to register t4
	
	slt $t5,$t2,$t4 #set t5=1 if t2<t4 ie apple<10
	beq $t5,$zero,lessOrange #if t5=0, apple is not less than 10, then goto lessOrange
	li $v0,4 #this executes if apple<10 and load parameter for display message to register v0
	la $a0,errorApple #address of the array where message is stored into register a0
	syscall #print the message "the apple is below 10"
	
	
	lessOrange:
	slt $t5,$t3,$t4
	beq $t5,$zero,lessPineapple
	li $v0,4 
	la $a0,errorOrange 
	syscall 
	
	lessPineapple:
	slt $t5,$t6,$t4
	beq $t5,$zero,lessKiwi
	li $v0,4 
	la $a0,errorPineapple 
	syscall 
	
	lessKiwi:
	slt $t5,$t7,$t4
	beq $t5,$zero,lessDurian
	li $v0,4
	la $a0,errorKiwi
	syscall
	
	lessDurian:
	slt $t5,$t9,$t4
	beq $t5,$zero,chooseOptions
	li $v0,4
	la $a0,errorDurian
	syscall
				
#----------------------------------------------------------------------------------------------	
	
	chooseOptions:
	
	#display options
	li $v0,4
	la $a0,optionLists
	syscall
	
	# user's input of choices
	li $v0, 5
	syscall
	
	# move result of ueer input
	move $t0, $v0
	
	beq $t0, 1, displayItems
	beq $t0, 2, updateAdd
	beq $t0, 3, updateSub
	beq $t0, 4, login
	
#----------------------------------------------------------------------------------------------	
	
	displayItems:
	
	#display apple
	li $v0,4
	la $a0,msg3
	syscall

	li $v0,1
	lw $a0, apple
	syscall

	#display orange
	li $v0,4
	la $a0,msg4
	syscall

	li $v0,1
	lw $a0, orange
	syscall
	
	#display pineapple
	li $v0,4
	la $a0,msg5
	syscall

	li $v0,1
	lw $a0, pineapple
	syscall

	#display kiwi
	li $v0,4
	la $a0,msg6
	syscall

	li $v0,1
	lw $a0, kiwi
	syscall
	
	#display durian
	li $v0,4
	la $a0,msg7
	syscall

	li $v0,1
	lw $a0, durian
	syscall
	
	j chooseOptions

#----------------------------------------------------------------------------------------------

	updateAdd:
	#Get input for apples and store in $t0
	li $v0,4
	la $a0,msg1
	syscall

	li $v0,5
	syscall
	move $t0,$v0
	
	#get input for oranges and store in $t1
	li $v0,4
	la $a0,msg2
	syscall

	li $v0,5
	syscall
	move $t1,$v0
	
	#Get input for pineapple and store in $t4
	li $v0,4
	la $a0,msg8
	syscall

	li $v0,5
	syscall
	move $t4,$v0
	
	#get input for kiwi and store in $t5
	li $v0,4
	la $a0,msg9
	syscall

	li $v0,5
	syscall
	move $t5,$v0
	
	#Get input for durian and store in $t4
	li $v0,4
	la $a0,msg10
	syscall

	li $v0,5
	syscall
	move $t8,$v0
	
	#load data
	lw $t2, apple
	lw $t3, orange
	lw $t6, pineapple
	lw $t7, kiwi
	lw $t9, durian

	#add apples input from t0 to t2 and store result in t2
	Add $t2,$t0,$t2
	#save t2 to data apple
	sw $t2, apple
	
	#add orange input from t1 to t3 and store result in t3
	Add $t3,$t1,$t3
	#save t3 to data orange
	sw $t3, orange
	
	#add pineapple input from t4 to t6 and store result in t6
	Add $t6,$t4,$t6
	#save t2 to data pineapple
	sw $t6, pineapple
	
	#add kiwi input from t5 to t7 and store result in t7
	Add $t7,$t5,$t7
	#save t3 to data kiwi
	sw $t7, kiwi
	
	#add durian input from t8 to t9 and store result in t9
	Add $t9,$t8,$t9
	#save t2 to data durian
	sw $t9, durian
	
	#display apple
	li $v0,4
	la $a0,msg3
	syscall

	li $v0,1
	move $a0,$t2
	syscall

	#display orange
	li $v0,4
	la $a0,msg4
	syscall

	li $v0,1
	move $a0,$t3
	syscall
	
	#display pineapple
	li $v0,4
	la $a0,msg5
	syscall

	li $v0,1
	move $a0,$t6
	syscall

	#display kiwi
	li $v0,4
	la $a0,msg6
	syscall

	li $v0,1
	move $a0,$t7
	syscall
	
	#display durian
	li $v0,4
	la $a0,msg7
	syscall

	li $v0,1
	move $a0,$t9
	syscall
	
	j chooseOptions
	
#----------------------------------------------------------------------------------------------	
	
	updateSub:
	#Get input for apples and store in $t0
	li $v0,4
	la $a0,msg11
	syscall

	li $v0,5
	syscall
	move $t0,$v0
	
	#get input for oranges and store in $t1
	li $v0,4
	la $a0,msg12
	syscall

	li $v0,5
	syscall
	move $t1,$v0
	
	#Get input for apples and store in $t2
	li $v0,4
	la $a0,msg13
	syscall

	li $v0,5
	syscall
	move $t4,$v0
	
	#get input for oranges and store in $t3
	li $v0,4
	la $a0,msg14
	syscall

	li $v0,5
	syscall
	move $t5,$v0
	
	#Get input for apples and store in $t4
	li $v0,4
	la $a0,msg15
	syscall

	li $v0,5
	syscall
	move $t8,$v0
	
	
	#load data
	lw $t2, apple
	lw $t3, orange
	lw $t6, pineapple
	lw $t7, kiwi
	lw $t9, durian


	#sub apples input from t0 to t2 and store result in t2
	sub $t2,$t2,$t0
	#save t2 to data apple
	sw $t2, apple
	
	#sub orange input from t1 to t3 and store result in t3
	sub $t3,$t3,$t1
	#save t3 to data orange
	sw $t3, orange
	
	#sub pineapple input from t4 to t6 and store result in t6
	sub $t6,$t6,$t4
	#save t2 to data pineapple
	sw $t6, pineapple
	
	#sub kiwi input from t5 to t7 and store result in t7
	sub $t7,$t7,$t5
	#save t3 to data kiwi
	sw $t7, kiwi
	
	#sub durian input from t8 to t9 and store result in t9
	sub $t9,$t9,$t8
	#save t2 to data durian
	sw $t9, durian
	
	
	#display apple
	li $v0,4
	la $a0,msg3
	syscall

	li $v0,1
	move $a0,$t2
	syscall

	#display orange
	li $v0,4
	la $a0,msg4
	syscall

	li $v0,1
	move $a0,$t3
	syscall
	
	#display pineapple
	li $v0,4
	la $a0,msg5
	syscall

	li $v0,1
	move $a0,$t6
	syscall

	#display kiwi
	li $v0,4
	la $a0,msg6
	syscall

	li $v0,1
	move $a0,$t7
	syscall
	
	#display durian
	li $v0,4
	la $a0,msg7
	syscall

	li $v0,1
	move $a0,$t9
	syscall
	
	j chooseOptions
