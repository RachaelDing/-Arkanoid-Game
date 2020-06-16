.section .text
.align 4


.global	drawPack
drawPack:
	push		{lr}
	mov		r0, #1
	bl		checkPackPosition
	ldr		r1, =pack1State
	ldr		r0, [r1]
	cmp		r0, #1	
	bleq		pack1On

	mov		r0, #2
	bl		checkPackPosition
	ldr		r1, =pack2State
	ldr		r0, [r1]
	cmp		r0, #1	
	bleq		pack2On
	pop		{pc}

.global checkValuePack
checkValuePack:

	@check pack 1
	push	{r5, lr}

	mov	r5, r0
	ldr	r0, =pack1Position
	ldmia	r0, {r0,r1}
	bl	calculateCell
	
	cmp	r5, r0	
	ldreq	r0, =pack1State
	moveq	r1, #1
	streq	r1, [r0]

	@check pack 2
	ldr	r0, =pack2Position
	ldmia	r0, {r0,r1}
	bl	calculateCell
	
	cmp	r5, r0	
	ldreq	r0, =pack2State
	moveq	r1, #1
	streq	r1, [r0]

	@check pack 3
	ldr	r0, =pack3Position
	ldmia	r0, {r0,r1}
	bl	calculateCell
	
	cmp	r5, r0	
	ldreq	r0, =pack3State
	moveq	r1, #1
	streq	r1, [r0]

	pop	{r5, pc}

@input: r0 = #1 or #2(means pack1 or pack2)
.global	checkPackPosition
checkPackPosition:
	push	{lr,r4-r9}
	mov	r9, r0

	cmp	r9, #1
	ldreq	r4, =pack1Position
	ldrne	r4, =pack2Position
	ldmia	r4,{r5,r6}

	@middle of the pack
	add	r5, #32

	ldr	r1, =paddlePosition
	ldmia	r1,{r7,r8}

	@get pack bottom position
	add	r6, #32
	sub	r6, #2
	
	@ 812 is the y position of last row position
	cmp	r6, #812
	bgt	removePack
	
checkPackLeft:
	cmp	r5, r7
	blt	checkPackEnd	

checkPackRight:
	add	r7, #90
	cmp	r5, r7
	bgt	checkPackEnd

checkPackBottom:
	@deviation
	add	r3, r6, #3

	cmp	r6, r8
	blt	checkPackEnd

	cmp	r6, r3
	bgt	checkPackEnd

@speed down the ball when get pack1
@catch the ball when get pack2
valueEffect:
	cmp	r9, #1
	ldreq	r2, =ballSpeed
	ldrne	r2, =getState
	mov	r1, #1
	movne	r1, #3
	str	r1, [r2]

removePack:
	@stop	pack
	cmp	r9, #1
	ldreq	r2, =pack1State
	ldrne	r2, =pack2State
	mov	r1, #0
	str	r1, [r2]
	
	@clear	pack	
	@r4 = offset of the value pack
	cmp	r9, #1
	ldreq	r4, =pack1Position
	ldrne	r4, =pack2Position
	ldmia	r4, {r0, r1}

	bl	calculateCell	
	mov	r4, r0
	bl	drawFloor
	
	mov	r0, r4
	add	r0, #1
	bl	drawFloor

	mov	r0, r4
	add	r0, #22
	bl	drawFloor

	mov	r0, r4
	add	r0, #23
	bl	drawFloor

	@move	pack to initial position
	cmp	r9, #1
	ldreq	r4, =pack1Position
	ldreq	r3, =initPack1Position 
	ldrne	r4, =pack2Position
	ldrne	r3, =initPack2Position
	ldmia	r3,{r0,r1}
	stmia	r4,{r0,r1}
	

checkPackEnd:	
	pop	{pc,r4-r9}


pack1On:
	push		{r4-r8,lr}
	@clear pack1
	ldr		r0, =pack1Position
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

	@get pack1's position
	ldr		r4, =packData1
	ldr		r0, =pack1Position
	ldmia		r0, {r5,r6}

	@move downwards
	add		r6, #1
	str		r6, [r0, #4]

	@draw pack
	mov		r7, #64
	mov		r8, #32
	push		{r4-r8}
	bl		drawPicRemovingWhite
	pop		{r4-r8,pc}
	
pack2On:
	push		{r4-r8,lr}
	@clear pack2
	ldr		r0, =pack2Position
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

	@get pack2's position
	ldr		r4, =packData2
	ldr		r0, =pack2Position
	ldmia		r0, {r5,r6}

	@move downwards
	add		r6, #1
	str		r6, [r0, #4]

	@draw pack
	mov		r7, #64
	mov		r8, #32
	push		{r4-r8}
	bl		drawPicRemovingWhite	

	pop		{r4-r8,pc}	

	
