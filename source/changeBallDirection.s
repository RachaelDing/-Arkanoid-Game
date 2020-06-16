.section .text
.align 4

.global	changeBallDirection
changeBallDirection:
	push		{lr, r4-r10}
	
	ldr		r1, =ballPosition
	ldmia		r1, {r5,r6}

	
	ldr		r1, =ballDirection
	ldmia		r1, {r7,r8}
	
	@left wall
	ldr		r0, =windowPosition
	ldr		r2, [r0]
	add		r2, #32
	cmp		r5, r2
	blle		changeBallX
	sub		r0, r2, r5
	blle		putBallOnSurface
	blle		drawAllWall
	


	@right wall
	ldr		r0, =windowPosition
	ldr		r2, [r0]
	add		r2, #672
	sub		r2, #16
	cmp		r5, r2
	blge		changeBallX
	sub		r0, r5, r2
	blge		putBallOnSurface
	blge		drawAllWall
	

	@upper wall
	ldr		r0, =windowPosition
	ldr		r2, [r0,#4]
	add		r2, #32
	cmp		r6, r2
	blle		changeBallY
	sub		r0, r2, r6
	blle		putBallOnSurface
	blle		drawAllWall
	


	@paddleM
	ldr		r1, =paddlePosition
	ldmia		r1, {r3,r4}
	
	@r3 = paddleMLeft, r4 = paddleMUp, r9 =paddleMRight
	add		r3, #16
	add		r4, #2
	add		r9, r3, #58

	ldr		r1, =ballPosition
	ldmia		r1, {r5,r6}
	
	@r5 = X value for the middle of the ball, r6 = Y value for the bottom of the ball 
	add		r5, #8
	add		r6, #16

	ldr		r1, =ballDirection
	ldmia		r1, {r7,r8}

paddleMCheck:
	@paddleMLeft
	cmp		r5, r3
	bge		paddleMRight
	b 		paddleLCheck

paddleMRight:
	cmp		r5, r9
	ble		paddleMUp
	b		paddleLCheck

paddleMUp:
	@deviation
	add		r3, r4, #8

	cmp		r6, r4	
	blt		paddleLCheck

	cmp		r6, r3
	bge		paddleLCheck

ballOnPaddleM:
	@change direction
	ldr		r1, =ballDirection
	mov		r3, #-1
	mul		r8, r3
	str		r8, [r1, #4]

	mov		r0, #0
	mov		r2, #1
	mov		r3, #-1
	cmp		r7, r0
	strlt		r3, [r1]
	strge		r2, [r1]

	@put ball on the surface of paddle
	sub		r3, r6, r4
	ldr		r1, =ballDirection
	ldmia		r1, {r7,r8}
	mul		r7, r7,r3
	mul		r8, r8,r3
	
	ldr		r1, =ballPosition
	ldmia		r1, {r5,r6}
	add		r5, r5, r7
	add		r6, r6, r8
	stmia		r1, {r5,r6}
	
	ldr		r0, =getState
	ldr		r1, =catchState
	ldr		r2, [r0]
	cmp		r2, #0
	movgt		r3, #1
	strgt		r3, [r1]
	subgt		r2, #1
	strgt		r2, [r0]
	b		paddleCheckEnd


	
	
	
 // This version does work (newest)
paddleLCheck:
	ldr		r1, =paddlePosition
	ldmia		r1, {r3,r4}

	@r3 = paddleLLeft, r4 = paddleLUp, r9 =paddleLRight
	add		r9, r3, #16

	@r5 = X value for the middle of the ball, r6 = Y value for the bottom of the ball
	ldr		r1, =ballPosition
	ldmia		r1, {r5,r6}

	add		r5, #8
	add		r6, #16
	
	ldr		r1, =ballDirection
	ldmia		r1, {r7,r8}

paddleLLeft:
	@ set the paddle left larger
//	sub		r0, r3, #2
	cmp		r5, r3
	bge		paddleLRight
	b 		paddleLSide

paddleLRight:
	cmp		r5, r9
	blt		paddleLUp
	b		paddleRCheck

paddleLUp:
	@deviation
	add		r3, r4, #8

	cmp		r6, r4	
	blt		paddleRCheck

	cmp		r6, r3
	bge		paddleRCheck
	
	b		ballOnPaddleL
paddleLSide:
	add		r0, r6, #8
	add		r1, r5, #8
	cmp		r0, #812
	bge		paddleRCheck
	cmp		r0, #780
	ble		paddleRCheck
	cmp		r1, r3
	bge		ballOnPaddleL

paddleRCheck:
	ldr		r1, =paddlePosition
	ldmia		r1, {r3,r4}

	@r3 = paddleRLeft, r4 = paddleRUp, r9 =paddleRRight
	add		r3, #74
	add		r9, r3, #16

	@r5 = X value for the middle of the ball, r6 = Y value for the bottom of the ball
	ldr		r1, =ballPosition
	ldmia		r1, {r5,r6}

	add		r5, #8
	add		r6, #16
	
	ldr		r1, =ballDirection
	ldmia		r1, {r7,r8}

paddleRLeft:
	cmp		r5, r3
	bgt		paddleRRight
	b 		paddleCheckEnd

paddleRRight:
	@ set the paddle right larger
//	add		r0, r9, #2
	cmp		r5, r9
	ble		paddleRUp
	b		paddleRSide

paddleRUp:
	@deviation
	add		r3, r4, #8

	cmp		r6, r4	
	blt		paddleCheckEnd

	cmp		r6, r3
	bge		paddleCheckEnd
	
	b		ballOnPaddleR
	
paddleRSide:
	add		r0, r6, #8
	sub		r1, r5, #8
	cmp		r0, #812
	bge		paddleCheckEnd
	cmp		r0, #780
	ble		paddleCheckEnd
	cmp		r1, r9
	ble		ballOnPaddleR
	b		paddleCheckEnd



ballOnPaddleL:
	@change direction
// This is 45 degress	
//	mov		r0, #0
//	mov		r2, #2
//	mov		r3, #-2

// This is 60 degrees
//	mov		r0, #0
//	mov		r2, #1
// 	mov		r3, #-1
	
	
	ldr		r1, =ballDirection
	mov		r3, #-1
	mul		r8, r3
	str		r8, [r1, #4]
	
	mov		r0, #0
	mov		r2, #-2
//	mov		r3, #-2
//	cmp		r7, r0
//	strlt		r3, [r1]
//	strge		r2, [r1]				
	str		r2, [r1]

	@put ball on the surface of paddle
	sub		r3, r6, r4
	ldr		r1, =ballDirection
	ldmia		r1, {r7,r8}
	mul		r7, r7,r3
	mul		r8, r8,r3
	
	ldr		r1, =ballPosition
	ldmia		r1, {r5,r6}
	add		r5, r5, r7
	add		r6, r6, r8
	stmia		r1, {r5,r6}
	
	ldr		r0, =getState
	ldr		r1, =catchState
	ldr		r2, [r0]
	cmp		r2, #0
	movgt		r3, #1
	strgt		r3, [r1]
	subgt		r2, #1
	strgt		r2, [r0]
	b		paddleCheckEnd
	
ballOnPaddleR:
	@change direction
// This is 45 degress	
//	mov		r0, #0
//	mov		r2, #2
//	mov		r3, #-2

// This is 60 degrees
//	mov		r0, #0
//	mov		r2, #1
// 	mov		r3, #-1
	
	
	ldr		r1, =ballDirection
	cmp		r8, #0
	mov		r3, #-1
	mul		r8, r3
	str		r8, [r1, #4]
	
	mov		r0, #0
	mov		r2, #2
//	mov		r3, #2
//	cmp		r7, r0
//	strlt		r3, [r1]
//	strge		r2, [r1]
	str		r2, [r1]

	@put ball on the surface of paddle
	sub		r3, r6, r4
	ldr		r1, =ballDirection
	ldmia		r1, {r7,r8}
	mul		r7, r7,r3
	mul		r8, r8,r3
	
	ldr		r1, =ballPosition
	ldmia		r1, {r5,r6}
	add		r5, r5, r7
	add		r6, r6, r8
	stmia		r1, {r5,r6}
	
	ldr		r0, =getState
	ldr		r1, =catchState
	ldr		r2, [r0]
	cmp		r2, #0
	movgt		r3, #1
	strgt		r3, [r1]
	subgt		r2, #1
	strgt		r2, [r0]


paddleCheckEnd:

	pop		{pc, r4-r10}

changeBallX:
	push		{lr, r5-r8}

	
	ldr		r0, =ballPosition
	ldmia		r0, {r5,r6}

	
	ldr		r1, =ballDirection
	ldmia		r1, {r7,r8}

	mov		r3, #-1
	mul		r7, r3
	str		r7, [r1]


	pop		{pc, r5-r8}

changeBallY:
	push		{lr, r5-r8}

	ldr		r0, =ballPosition
	ldmia		r0, {r5,r6}

	
	ldr		r1, =ballDirection
	ldmia		r1, {r7,r8}

	mov		r3, #-1
	mul		r8, r3
	str		r8, [r1,#4]


	pop		{pc, r5-r8}	


putBallOnSurface:
	push		{r5-r8, lr}
	

	ldr		r1, =ballDirection
	ldmia		r1, {r7,r8}
	mul		r7, r7,r0
	mul		r8, r8,r0

	ldr		r1, =ballPosition
	ldmia		r1, {r5, r6}
	add		r5, r5, r7
	add		r6, r6, r8
	stmia		r1, {r5,r6}

	
	pop		{r5-r8, pc}