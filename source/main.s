
@ Code section
.section .text

.global main
main:
	@ ask for frame buffer information
	ldr 		r0, =frameBufferInfo 	@ frame buffer information structure
	bl		initFbInfo

initialize:
	
	mov		r5, #560
	mov		r6, #140
	ldr		r0, =windowPosition
	stmia		r0, {r5,r6}

	mov		r5, #560
	add		r5, #90
	mov		r6, #492
	ldr		r0, =selectorPosition
	stmia		r0, {r5,r6}

	mov		r5, #867
	mov		r6, #780
	ldr		r0, =paddlePosition
	stmia		r0, {r5,r6}

	
	mov		r5, #904
	mov		r6, #764
	mov		r9, #0
	ldr		r0, =ballPosition
	stmia		r0, {r5,r6}


	mov		r5, #2
	mov		r6, #-2
	ldr		r0, =ballDirection
	stmia		r0, {r5,r6}

	mov		r5, #2
	mov		r6, #-2
	ldr		r0, =initBallDirection
	stmia		r0, {r5,r6}

	mov		r5, #2
	ldr		r0, =ballSpeed
	str		r5, [r0]

	mov		r1, #3
	ldr		r0, =livesNum
	str		r1, [r0]

	mov		r1, #0
	ldr		r0, =scoreNum
	str		r1, [r0]

	mov		r1, #1168
	mov		r2, #300
	ldr		r0, =pack1Position
	stmia		r0, {r1,r2}

	mov		r1, #1168
	mov		r2, #300
	ldr		r0, =initPack1Position
	stmia		r0, {r1,r2}

	mov		r1, #976
	mov		r2, #300
	ldr		r0, =pack2Position
	stmia		r0, {r1,r2}

	mov		r1, #976
	mov		r2, #300
	ldr		r0, =initPack2Position
	stmia		r0, {r1,r2}

	mov		r1, #0
	ldr		r0, =pack1State
	str		r1, [r0]

	mov		r1, #0
	ldr		r0, =pack2State
	str		r1, [r0]

	mov		r1, #1
	ldr		r0, =catchState
	str		r1, [r0]
	
	mov		r1, #0
	ldr		r0, =getState
	str		r1, [r0]

	bl		initController
	ldr		r1,=gBase
	str		r0,[r1]	

	ldr		r1, =restartState
	ldr		r2, [r1]
	cmp		r2, #1
	beq		loop

	cmp		r2, #2
	moveq		r0, #60000
	bleq		delayMicroseconds
	mov		r0, #60000
	bl		delayMicroseconds

	ldr		r0, =printInt
	mov		r1, r2
	bl		printf

	ldr		r0, =printY
	bl		printf

	bl		drawMenu

drawSelector:
	@snes listener
	ldr		r1, =gBase
	ldr		r0,[r1]

	bl              Read_SNES		@ call Read_SNES
	ldr		r1, =0xffff

	ldr		r2, =button
	str		r0,[r2]

	@change position

	ldr		r1, =button
	ldr		r0,[r1]
	bl		button_pressed
	cmp		r0, #6
	bleq		selectorUp
	bleq		drawMenu

	ldr		r1, =button
	ldr		r0,[r1]
	bl		button_pressed
	cmp		r0, #7	
	bleq		selectorDown
	bleq		drawMenu

	@draw
	ldr		r0, =selectorPosition
	ldr		r5, [r0]
	ldr		r6, [r0,#4]


	ldr		r4, =selector
	mov		r7, #527
	mov		r8, #64

	push		{r4-r8}	
	bl		drawPicRemovingWhite

	mov		r0, #10000
	bl		delayMicroseconds


menuLoop:
	
	ldr		r1, =button
	ldr		r0,[r1]
	bl		button_pressed

	cmp		r0, #5
	bne		drawSelector

	ldr		r0, =selectorPosition
	ldr		r5, [r0, #4]
	ldr		r6, =#492
	cmp		r5, r6
	bne		quitGame
loop:
	mov 		r7, #0
	ldr		r10, =currentState

	ldr		r1, =restartState
	ldr		r2, [r1]
	cmp		r2, #0
	blne		resetBrick
	ldr		r1, =restartState
	mov		r2, #0
	str		r2, [r1]
//	ldreq		r10, =initialState


drawMap:
	ldrb		r8,[r10],#1

	mov		r0, r7

	cmp		r8, #0
	bleq		drawFloor

	cmp		r8, #1
	bleq		drawBlue1

	cmp		r8, #2
	bleq		drawBlue2

	cmp		r8, #3
	bleq		drawGreen1

	cmp		r8, #4
	bleq		drawGreen2

	cmp		r8, #5
	bleq		drawPurple1

	cmp		r8, #6
	bleq		drawPurple2

	cmp		r8, #9
	bleq		drawWall

	add		r7, #1

	cmp		r7, #484
	blt		drawMap

	bl		drawScoreAndLives


SNES_loop:
	ldr		r1, =gBase
	ldr		r0,[r1]

	bl              Read_SNES		@ call Read_SNES

	ldr		r2, =button
	str		r0,[r2]


testPause:
	ldr		r1, =pauseState
	ldr		r0, [r1]
	cmp		r0, #1
	bne		pauseNotOn


	mov		r0, #60000
	bl		delayMicroseconds
	mov		r0, #60000
	bl		delayMicroseconds
	mov		r0, #60000
	bl		delayMicroseconds

	bl		drawPauseMenu
	ldr		r1, =pauseSelectorState
	ldr		r2, [r1]
	cmp		r2, #1
	bleq		drawSelectorUp
	blne		drawSelectorDown

	ldr		r1, =gBase
	ldr		r0, [r1]

	bl		Read_SNES
	bl		button_pressed

	cmp		r0, #6
	ldreq		r1, =pauseSelectorState
	moveq		r2, #1
	streq		r2, [r1]
	
	cmp		r0, #7
	ldreq		r1, =pauseSelectorState
	moveq		r2, #2
	streq		r2, [r1]

	cmp		r0, #5
	bne		checkNext
	ldr		r1, =pauseSelectorState
	ldr		r2, [r1]
	cmp		r2, #1
//	ldr		r1, =restartState

//	bne		backToMenu
	moveq		r2, #1
	movne		r2, #2
	ldr		r1, =restartState
	str		r2, [r1]
	ldr		r0, =printInt
	mov		r1, r2
	bl		printf
	b		endPause
/*
backToMenu:
	mov		r2, #2
	str		r2, [r1]
	b		endPause
*/
checkNext:
	cmp		r0, #9
	bne		testPause

	mov		r0, #60000
	bl		delayMicroseconds
	mov		r0, #60000
	bl		delayMicroseconds
	mov		r0, #60000
	bl		delayMicroseconds
endPause:
	ldr		r1, =pauseSelectorState
	mov		r2, #1
	str		r2, [r1]

	ldr		r1, =pauseState
	mov		r2, #0
	str		r2, [r1]

	ldr		r1, =restartState
	ldr		r2, [r1]
	cmp		r2, #0
	bne		initialize

	b		loop

pauseNotOn:
	ldr		r1, =button
	ldr		r0, [r1]

	bl		button_pressed

	cmp		r0, #9
	moveq		r2, #1
	ldreq		r1, =pauseState
	streq		r2, [r1]

clearB:
	ldr		r0, =ballPosition
	ldmia		r0, {r0,r1}
	bl		calculateCell

	mov		r8, r0
	ldr		r1, =currentState
	ldrb		r2, [r1, r0]
	cmp		r2, #0	
	bleq		drawFloor

	mov		r0, r8
	add		r0, #1
	ldr		r1, =currentState
	ldrb		r2, [r1, r0]
	cmp		r2, #0	
	bleq		drawFloor

	mov		r0, r8
	add		r0, #22
	ldr		r1, =currentState
	ldrb		r2, [r1, r0]
	cmp		r2, #0	
	bleq		drawFloor

	mov		r0, r8
	add		r0, #23
	ldr		r1, =currentState
	ldrb		r2, [r1, r0]
	cmp		r2, #0	
	bleq		drawFloor



clearPaddle:
	ldr		r1, =paddlePosition
	ldmia		r1, {r0,r1}
	bl		calculateCell

	mov		r8, r0
	bl		drawFloor
	
	mov		r0, r8
	add		r0, #1
	bl		drawFloor

	mov		r0, r8
	add		r0, #2
	bl		drawFloor

	mov		r0, r8
	add		r0, #3
	
	ldr		r1, =currentState
	ldrb		r2, [r1, r0]
	cmp		r2, #0	
	bleq		drawFloor


	bl		drawPack

	

drawPaddle:	
	ldr		r1, =paddlePosition
	ldmia		r1, {r5,r6}

	ldr		r1, =button
	ldr		r0,[r1]
	bl		button_pressed
	cmp		r0, #1
	addeq		r5, #3	

	ldr		r1, =button
	ldr		r0,[r1]
	bl		button_pressed
	cmp		r0, #3
	addeq		r5, #6	

	@calculate if paddle touch the wall on the right
	ldr		r0, =windowPosition
	ldr		r1, [r0]
	add		r1, #672
	sub		r1, #90
	cmp		r5, r1
	movgt		r5, r1

	ldr		r1, =button
	ldr		r0,[r1]
	bl		button_pressed
	cmp		r0, #2
	addeq		r5, #-3

	ldr		r1, =button
	ldr		r0,[r1]
	bl		button_pressed                                                     
	cmp		r0, #4
	addeq		r5, #-6	

	@calculate if paddle touch the wall on the left
	ldr		r0, =windowPosition
	ldr		r1, [r0]
	add		r1, #32
	cmp		r5, r1
	movlt		r5, r1	

	ldr		r1, =paddlePosition
	str		r5,[r1]
	
	ldr		r4, =paddle

	mov		r7, #90
	mov		r8, #23
	push		{r4-r8}
	bl		drawPicRemovingWhite

checkBallCollision:
	ldr		r1, =catchState
	ldr		r0, [r1]
	cmp		r0, #1
	beq		ballWithPaddle
	bl		changeBallDirection
		

checkLives:
	bl		drawScoreAndLives

	ldr		r1, =paddlePosition
	ldmia		r1, {r3,r4}

	ldr		r1, =ballPosition
	ldmia		r1, {r5,r6}

	add		r4, #16
	cmp		r4, r6
	bgt		drawB			

changeBallAndLives:
	ldr		r1, =livesNum
	ldr		r0, [r1]
	sub		r0, #1
	str		r0, [r1]

	ldr		r1, =catchState
	mov		r0, #1
	str		r0, [r1]
	bl		clearLives
	bl		resetSpeed

/*
	ldr		r1, =initBallDirection
	ldmia		r1, {r5,r6}

	ldr		r0, =ballDirection
	stmia		r0, {r5,r6}
*/
	

ballWithPaddle:
	ldr		r1, =paddlePosition
	ldmia		r1, {r5,r6}

	@ move ball to the middle of paddle
	add		r5, #37
	sub		r6, #12

	ldr		r1, =ballPosition
	stmia		r1, {r5,r6}
	
	@ reset the direction for the ball after catch 
	ldr		r1, =initBallDirection
	ldmia		r1, {r5,r6}

	ldr		r0, =ballDirection
	stmia		r0, {r5,r6}

	ldr		r1, =button
	ldr		r0,[r1]
	bl		button_pressed
	cmp		r0, #8
	
	ldreq		r1, =catchState
	moveq		r0, #0
	streq		r0, [r1]
	

drawB:
	bl		drawScoreNum
	bl		drawLivesNum
	
	ldr		r1, =livesNum
	ldr		r0, [r1]	
	cmp		r0, #0
	ble		loseFlag
	
	ldr		r1, =scoreNum
	ldr		r0, [r1]
	cmp		r0, #30
	bge		winFlag
	
	ldr		r4, =smallBall
	mov		r7, #16

	ldr		r0, =ballPosition
	ldmia		r0, {r5,r6}

	ldr		r0, =ballDirection
	ldmia		r0, {r1,r2}

	ldr		r0, =ballSpeed
	ldr		r3, [r0]

	mul		r1, r3
	mul		r2, r3
	add		r5, r1
	add		r6, r2
	ldr		r0, =ballPosition
	stmia		r0, {r5,r6}

	push		{r4,r5,r6,r7}
	bl		DrawBall

delay:
	mov		r0, #20000
	bl		delayMicroseconds
	

updateBrick:

	addr		.req	r4
	offset		.req	r8

	ldr		r1, =ballPosition
	ldmia		r1, {r5,r6}

	@calculate using the middle of the ball
	add		r5, #8
	add		r6, #8
	
	bl		resetBrickState
	
	ldr		r0, =printNewLine
	bl		printf
	
	@bottom
checkBottom:
	mov		r0, r5
	mov		r1, r6
	sub		r1, #8
	bl		calculateCell

	mov		offset, r0

	
	ldr		r0, =brickState
	ldr		r1, [r0, offset]
	cmp		r1, #0
	bne		checkLeft
	
	ldr		r0, =printIntBot
	mov		r1, offset
	bl		printf
	
	ldr		addr, =currentState
	ldrb		r2,[addr,offset]
	mov		r1, offset
	mov		r3, #0

	bl		checkBrick
	cmp		r0, #1
	beq		endUpdateBrick
	
	@Left
checkLeft:
	mov		r0, r5
	add		r0, #8
	mov		r1, r6
	bl		calculateCell

	mov		offset, r0

	ldr		r0, =brickState
	ldr		r1, [r0, offset]
	cmp		r1, #0
	bne		checkRight
	
	ldr		r0, =printIntLeft
	mov		r1, offset
	bl		printf
	
	ldr		addr, =currentState
	ldrb		r2,[addr,offset]
	mov		r1, offset
	mov		r3, #1

	bl		checkBrick
	cmp		r0, #1
	beq		endUpdateBrick
	
	@Right
checkRight:
	mov		r0, r5
	sub		r0, #8
	mov		r1, r6
	bl		calculateCell

	mov		offset, r0
	
	
	ldr		r0, =brickState
	ldr		r1, [r0, offset]
	cmp		r1, #0
	bne		checkTop
	
	ldr		r0, =printIntRight
	mov		r1, offset
	bl		printf
	
	ldr		addr, =currentState
	ldrb		r2,[addr,offset]
	mov		r1, offset
	mov		r3, #1

	bl		checkBrick
	cmp		r0, #1
	beq		endUpdateBrick
	
	@ceilling
checkTop:
	mov		r0, r5
	mov		r1, r6
	add		r1, #8
	bl		calculateCell

	mov		offset, r0
	
	ldr		r0, =brickState
	ldr		r1, [r0, offset]
	cmp		r1, #0
	bne		endUpdateBrick
	
	ldr		r0, =printIntTop
	mov		r1, offset
	bl		printf
	
	ldr		addr, =currentState
	ldrb		r2,[addr,offset]
	mov		r1, offset
	mov		r3, #0

	bl		checkBrick
	

/*
	@brick bottom
	mov		r0, r5
	mov		r1, r6
	sub		r1, #8
	bl		calculateCell

	mov		offset, r0
	ldr		addr, =currentState
	ldrb		r2,[addr,offset]

	mov		r1, offset
	mov		r3, #0

	mov		r0, #5
	cmp		r2, #5
	bleq		changeBrick

	mov		r0, #6
	cmp		r2, #6
	bleq		changeBrick
	
	mov		r1, offset
	mov		r0, #3
	cmp		r2, #3
	bleq		changeBrick

	mov		r0, #4
	cmp		r2, #4
	bleq		changeBrick

	mov		r1, offset
	mov		r0, #1
	cmp		r2, #1
	bleq		changeBrick

	mov		r0, #2
	cmp		r2, #2
	bleq		changeBrick

	@brick left
	mov		r0, r5
	add		r0, #8
	mov		r1, r6
	bl		calculateCell

	mov		offset, r0
	ldr		addr, =currentState
	ldrb		r2,[addr,offset]

	mov		r1, offset
	mov		r3, #1

	mov		r0, #5
	cmp		r2, #5
	bleq		changeBrick

	mov		r0, #6
	cmp		r2, #6
	bleq		changeBrick
	
	mov		r1, offset
	mov		r0, #3
	cmp		r2, #3
	bleq		changeBrick

	mov		r0, #4
	cmp		r2, #4
	bleq		changeBrick

	mov		r1, offset
	mov		r0, #1
	cmp		r2, #1
	bleq		changeBrick

	mov		r0, #2
	cmp		r2, #2
	bleq		changeBrick

	@brick right
	mov		r0, r5
	sub		r0, #8
	mov		r1, r6
	bl		calculateCell

	mov		offset, r0
	ldr		addr, =currentState
	ldrb		r2,[addr,offset]

	mov		r1, offset
	mov		r3, #1

	mov		r0, #5
	cmp		r2, #5
	bleq		changeBrick

	mov		r0, #6
	cmp		r2, #6
	bleq		changeBrick
	
	mov		r1, offset
	mov		r0, #3
	cmp		r2, #3
	bleq		changeBrick

	mov		r0, #4
	cmp		r2, #4
	bleq		changeBrick

	mov		r1, offset
	mov		r0, #1
	cmp		r2, #1
	bleq		changeBrick

	mov		r0, #2
	cmp		r2, #2
	bleq		changeBrick

	@brick ceil
	mov		r0, r5
	mov		r1, r6
	add		r1, #8
	bl		calculateCell

	mov		offset, r0
	ldr		addr, =currentState
	ldrb		r2,[addr,offset]

	mov		r1, offset
	mov		r3, #0

	mov		r0, #5
	cmp		r2, #5
	bleq		changeBrick

	mov		r0, #6
	cmp		r2, #6
	bleq		changeBrick
	
	mov		r1, offset
	mov		r0, #3
	cmp		r2, #3
	bleq		changeBrick

	mov		r0, #4
	cmp		r2, #4
	bleq		changeBrick

	mov		r1, offset
	mov		r0, #1
	cmp		r2, #1
	bleq		changeBrick

	mov		r0, #2
	cmp		r2, #2
	bleq		changeBrick

*/

endUpdateBrick:
	ldr		r1, =loopState
	ldr		r0, [r1]
	cmp		r0, #1
	bne		SNES_loop

	.unreq		addr
	.unreq		offset


winFlag:
	bl		drawWin
	mov		r0, #60000
	bl		delayMicroseconds
	mov		r0, #60000
	bl		delayMicroseconds
	mov		r0, #60000
	bl		delayMicroseconds
	mov		r0, #60000
	bl		delayMicroseconds
	mov		r0, #60000
	bl		delayMicroseconds

	ldr		r1, =gBase
	ldr		r0,[r1]
	bl              Read_SNES
	ldr		r3, =#0xffff
	cmp		r0, r3
	beq		winFlag
	ldr		r1, =restartState
	mov		r2, #2
	str		r2, [r1]
	b		endPause

loseFlag:
	bl		drawLost
	mov		r0, #60000
	bl		delayMicroseconds
	mov		r0, #60000
	bl		delayMicroseconds
	mov		r0, #60000
	bl		delayMicroseconds
	mov		r0, #60000
	bl		delayMicroseconds
	mov		r0, #60000
	bl		delayMicroseconds

	ldr		r1, =gBase
	ldr		r0,[r1]
	bl              Read_SNES
	ldr		r3, =#0xffff
	cmp		r0, r3
	beq		loseFlag
	ldr		r1, =restartState
	mov		r2, #2
	str		r2, [r1]
	b		endPause




quitGame:
	bl		drawBlackBox
	@ stop
	haltLoop$:
		b	haltLoop$

@argument:r0 = x, r1 = y
@return value:r0 = cell number
.globl	calculateCell
calculateCell:
	push		{lr}
	mov		r3, #32
	sub		r2, r0, #560
	udiv		r2, r2, r3
	sub		r1, r1, #140
	udiv		r1, r1, r3
	mov		r3, #22
	mul		r0, r1, r3
	add		r0, r2
	pop		{pc}

resetSpeed:
	push		{lr}
	mov		r0, #2
	ldr		r1, =ballSpeed
	str		r0, [r1]
	pop		{pc}


@ Data section
.section .data

.globl frameBufferInfo
frameBufferInfo:
	.int	0		@ frame buffer pointer
	.int	0		@ screen width
	.int	0		@ screen height

printY:
.asciz          "You have pressed Y\n"   

printh:
.asciz          "program halt\n"

printInt:
.asciz		"%d\n"

printIntLeft:
.asciz		"Left: %d\n"

printIntBot:
.asciz		"Bot: %d\n"

printIntRight:
.asciz		"Right: %d\n"

printIntTop:
.asciz		"Top: %d\n"

printNewLine:
.asciz		"\n\n" 

.align 4
.globl loopState
loopState: 
	.int	0

.globl ballPosition
ballPosition:

ballX:
	.int	0

ballY:
	.int	0

.globl ballDirection
ballDirection:
dX:
	.int	0
dY:
	.int	0

.globl ballSpeed
ballSpeed:
	.int	0

.globl	initBallDirection
initBallDirection:
iDX:
	.int	0
iDY:
	.int	0

.globl paddlePosition
paddlePosition:

paddleX:
	.int	0

paddleY:
	.int	0



.globl	gBase
gBase:
	.int	0

.globl	button
button:
	.int	0

.globl scoreWindowPosition
scoreWindowPosition:
sWX:
	.int	0
sWY:
	.int	0

.globl	windowPosition
windowPosition:
windowX:
	.int	0
windowY:
	.int	0

.globl	selectorPosition
selectorPosition:
selectorX:
	.int	0
selectorY:
	.int	0

.globl	livesNum
livesNum:
	.int	0

.globl	scoreNum
scoreNum:
	.int	0

.globl	initPack1Position
initPack1Position:
iPack1X:
	.int	0
iPack1Y:
	.int	0

.globl	pack1Position
pack1Position:
pack1X:
	.int	0
pack1Y:
	.int	0

.globl	initPack2Position
initPack2Position:
iPack2X:
	.int	0
iPack2Y:
	.int	0

.globl	pack2Position
pack2Position:
pack2X:
	.int	0
pack2Y:
	.int	0

.globl	pack3Position
pack3Position:
pack3X:
	.int	0
pack3Y:
	.int	0

.globl	pack1State
pack1State:
	.int	0

.globl	pack2State
pack2State:
	.int	0

.globl	pack3State
pack3State:
	.int	0

.globl	catchState
catchState:
	.int	0

.global pauseState
pauseState:
	.int	0

.global pauseSelectorState
pauseSelectorState:
	.int	1

.global restartState
restartState:
	.int	0
	
.global getState
getState:
	.int	0
	
.global brickBreakState
brickBreakState:
	.int	0
