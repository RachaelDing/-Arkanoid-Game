@ Student Name: Yichen Ding, Qingyue Zhu, Frank Guo
@ Student Number: 30024034, 30022412, 30029381

@ The program is a armv7 program. It can get information from GPIO and let user know which botton in the controler they are pressing
@ The program will ask the user press a botton in the controler
@ the program will terminate after the user press start botton
.section    .text
.global initController

initController:
        gBase   .req   r7			@ set r7 to be gBase
        button  .req   r8			@ set r8 to be button
        i       .req   r9			@ set r9 to be i
        mask    .req   r10			@ set r10 to be mask

	push		{r4-r10,lr}

        bl             getGpioPtr		@ get gpio address

        ldr            r1, =gpioBaseAddress	@ get the address of gpioBaseAddress
        str            r0, [r1]			@ store the address into gpioBaseAddress

        ldr            r0, =gpioBaseAddress	@ load the nase address
        ldr            gBase, [r0]		@ load the gBase in r0
	
	mov            r0, #9			@ set r0 to 9 (pin 9)
	mov	       r1, #1			@ set r1 to 1 (output function)
        bl             Init_GPIO		@ initialize GPIO Latch

	mov	       r0, #10			@ pin 10
	mov	       r1, #0			@ output function to be 0
	bl	       Init_GPIO		@ initialize the GPIO Data

	mov	       r0, #11			@ pin 11
	mov	       r1, #1			@ output function to be 1
	bl	       Init_GPIO		@ initialize the GPIO Lock
        
	ldr            r0, =names		@ load the address of names
        bl             printf			@ call print function
	
	mov		r0, r7

	pop		{r4-r10,pc}

Init_GPIO:					@ closed subroutine that initialize the GPIO
	push	       {r4, r5}			@ push r4 and r5 into stack
	mov	       r5, #10			@ r5 = 10
	udiv	       r2, r0, r5		@ r2 = r0 / r5
	mul	       r4, r2, r5		@ r4 = r2 * r5
	sub	       r4, r0, r4		@ r4 = r0 - r4
	mov	       r5, #3			@ r5 = 3
	mul	       r4, r5			@ r4 = r4* r5

	mov	       r5, #4			@ r5 = 4
	mul	       r2, r5			@ r2 = r2 * r5
	mov	       r5, r2			@ r5 = r2
        ldr            r3, [gBase, r2]		@ load the information in r3
        mov            r2, #7			@ r2 = 7
        lsl            r2, r4			@ logic shift r2, r4 positions
        bic            r3, r2			@ bit clear r3
	mov	       r0, r1			@ r0 = r1
        lsl            r0, r4			@ logic shift r0, r4 position
        orr            r3, r0 			@ orr r3 and r0
        str            r3, [gBase, r5]		@ store r3 into gBase

	pop	       {r4, r5}			@ pop r4 and r5 
        mov            pc, lr			@ return

print_button:					@ print the ask for button message
        ldr            r0, =pressButton		@ load address
        bl             printf			@ call print fucntion

        mov            r0,#0xffff		@ set r0 to be 0xffff
        lsl            r0,#2			@ r0 * 4
        bl             delayMicroseconds	@ call delay function


read_data:
        bl             Read_SNES		@ call Read_SNES
	mov	       button, r0		@ set the return value to button 


.global button_pressed
button_pressed:					@ check the button message
	push		{r4-r10,lr}
	mov		button, r0
       
	mov		r10, #0
	ldr		r1, =#0xfeff
	cmp		button, r1
	moveq		r10, #1
	mov		r0, r10

	ldr		r1, =#0xfdff
	cmp		button, r1
	moveq		r10, #2
	mov		r0, r10

	ldr		r1, =#0xfe7f
	cmp		button, r1
	moveq		r10, #3
	mov		r0, r10

	ldr		r1, =#0xfd7f
	cmp		button, r1
	moveq		r10, #4
	mov		r0, r10

	ldr		r1, =#0xff7f
	cmp		button, r1
	moveq		r10, #5
	mov		r0, r10

	@ UP
	ldr		r1, =#0xf7ff
	cmp		button, r1
	moveq		r10, #6
	mov		r0, r10

	@ DOwn
	ldr		r1, =#0xfbff
	cmp		button, r1
	moveq		r10, #7
	mov		r0, r10

	@ B
	ldr		r1, =#0x7fff
	cmp		button, r1
	moveq		r10, #8
	mov		r0, r10
	
	@ Start
	ldr		r1, =#0xefff
	cmp		button, r1
	moveq		r10, #9
	mov		r0, r10

	pop		{r4-r10,pc}




stop:   b              stop			@ the loop terminate the program

.global Read_SNES
Read_SNES:					@ subroutine that read the snes and return the code
        push	       {r4-r10, lr}	@ push r4, r5, r7, r8, r8, lr to stack 
	mov	       r7, r0
	mov	       r5, #0
	mov	       r6, #0
main_loop:					@ main loop for the subroutine
        mov            r8, #0			@ r8 = 0
        mov            r4, #0			@ r4 = 0

        mov            r1, #1			@ parameter = 1
        bl             Write_Clock		@ call Write_Clock 

        mov            r1, #1			@ parameter = 1
        bl             Write_Latch		@ call Write_Latch
 
        mov            r0, #12			@ delay for 12 us
        bl             delayMicroseconds

       mov            r1, #0			@ parameter = 0
       bl             Write_Latch		@ call write_latch

        mov            r9, #0			@ r9 = 0
	mov	       r10, #0


pulse_loop:       				@ pulse_loop read through the 16 bits
        mov            r0, #6			@ delay 6 us
        bl             delayMicroseconds

       mov            r1, #0			@ parameter = 0
       bl             Write_Clock         	@ falling edge
 
        mov            r0, #6			@ delay 6us
        bl             delayMicroseconds

       mov            r0, #1			@ parameter = 1
        bl             Read_Data		@ read the bit in Data
	mov	       r4, r0			@ r4 = r0

       lsl            r8, #1			@ logic shift r8
        cmp            r4, #1			@ compare r4 (the bit that been read) and 1
        beq            addOne			@ if equal branch to addOne


clockRising:
        mov            r1, #1			@ clock rising edge
        bl             Write_Clock	

       add            r9, #1			@ r9 ++

loop_test:					@ test the loop should end or not
        cmp            r9, #16			@ compare r9 and 16
        blt            pulse_loop		@ if less than, loop back to pulse_loop

        mov            r0, r8			@ r0 = r8 (set return value)
        pop            {r4-r10, pc}	@ pop r4, r5, r7, r8, r9, pc from stack

addOne:						@ add 1 to button code
        add            r8, #1			@ add 1 to r8
        b              clockRising		@ branch to clockRising

Write_Clock:       				@ write to clock
        push           {r4-r10,lr}			@ push r7 and lr to stack
        mov            r0, #11			@ r0 = 11
        mov            r3, #1			@ r3 = 1
        lsl            r3, r0			@ r3 = r0
        teq            r1, #0			@ test equal r1 and 0
        streq          r3, [r7, #40]		@ if equal store r3 to address of 40
        strne          r3, [r7, #28]		@ if not equal store r3 to address of 28
        pop            {r4-r10,pc}			@ pop r7 and pc from stack


Write_Latch:       				@ write to latch
        push           {r7,lr}			@ push r7 and lr to stack
        mov            r0, #9			@ r0 = 9
        mov            r3, #1			@ r3 = 1
        lsl            r3, r0			@ logic shift r3
        teq            r1, #0			@ compare r1 and 0
        streq          r3, [gBase, #40]		@ store r3 in different position
        strne          r3, [gBase, #28]              
        pop            {r7,pc}			@ pop r7 and pc from stack
   

Read_Data:       				@ read data 
        push           {r7,lr}			@ push r7 and lr to stack
        ldr            r1, [gBase, #52]		@ load r1 to address
        mov            r3, #10    		@ r3 = 10
        lsl            r0, r3			@ logic shift r0
        and            r1, r0			@ and r1 and r3
        teq            r1, #0			@ compare r1 and 0
        moveq          r0, #0			@ if equal return 0
        movne          r0, #1			@ if not equal return 1
        pop            {r7,pc}			@ pop r7 and pc from stack
     


@ Data section
.section .data

names:
.asciz          "Creator names: Yichen Ding, Qingyue Zhu, Frank Guo\n"

pressButton:
.asciz          "PLease press a button\n"     

pressedB:
.asciz          "You have pressed B\n"

pressedY:
.asciz          "You have pressed Y\n"   

pressedSelect:
.asciz          "You have pressed Select\n"

pressedStart:
.asciz          "You have pressed Start\n"

pressedUP:
.asciz          "You have pressed UP\n"

pressedDOWN:
.asciz          "You have pressed DOWN\n"

pressedLEFT:
.asciz          "You have pressed LEFT\n"

pressedRIGHT:
.asciz          "You have pressed RIGHT\n"

pressedA:
.asciz          "You have pressed A\n"

pressedX:
.asciz          "You have pressed X\n"

pressedLeft:
.asciz          "You have pressed Left\n"

pressedRight:
.asciz          "You have pressed Right\n"


terminating:
.asciz		"The program is terminating...\n"


.align 2

.global gpioBaseAddress
gpioBaseAddress:
        .int      0   
