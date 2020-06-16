.section .text
.align 4
.global changeBrick
changeBrick:
	push	{r4-r7, lr}
	addr	.req	r4
	offset	.req	r5
	stateNum .req	r6
	brickState .req	r7

	mov	offset, r1
	mov	brickState, r0
	
	cmp	r3, #0
	bleq	changeDirectionY
	blne	changeDirectionX

	ldr	addr, =currentState

	cmp	brickState, #5
	bleq	brickToFloor
	
	cmp	brickState, #3
	bleq	greenToPurple

	cmp	brickState, #1
	bleq	blueToGreen

	sub	brickState, #1
	sub	offset, #1

	cmp	brickState, #5
	bleq	brickToFloor

	cmp	brickState, #3
	bleq	greenToPurple

	cmp	brickState, #1
	bleq	blueToGreen


	pop	{r4-r7, pc}

changeDirectionX:
	push	{lr, r5-r8}
	ldr	r1, =ballDirection
	ldmia	r1, {r7,r8}

	mov	r0, #-1
	mul	r7, r0
	str	r7, [r1]
	
	ldr	r1, =ballPosition
	ldmia	r1, {r5,r6}

	mov		r3, #4
	mul		r7, r3
	add		r5, r7
	stmia		r1, {r5,r6}	
	
	pop	{pc, r5-r8}

changeDirectionY:
	push	{lr, r5-r8}
	ldr	r1, =ballDirection
	ldmia	r1, {r7,r8}

	mov	r0, #-1
	mul	r8, r0
	str	r8, [r1, #4]

	ldr	r1, =ballPosition
	ldmia	r1, {r5,r6}	

	mov		r3, #4
	mul		r8, r3
	add		r6, r8
	stmia		r1, {r5,r6}
	
	pop	{pc, r5-r8}

.global brickToFloor
brickToFloor:
	push	{r4-r6, lr}

	mov	stateNum, #0
	strb	stateNum,[addr,offset]

	mov	r0, offset
	bleq	drawFloor


	add	offset, #1
	strb	stateNum,[addr,offset]
	
	mov	r0, offset
	bleq	drawFloor

	@check value pack only when brick is removed
packCheck:
	sub	offset, #1
	mov	r0, offset
	bl	checkValuePack

bl	clearScore

addScore:
	ldr	r1, = scoreNum
	ldr	r0, [r1]
	add	r0, #1
	str	r0, [r1]
	pop	{r4-r6, pc}
	
.global	greenToPurple
greenToPurple:
	push	{r4-r6, lr}
	mov	stateNum, #5
	strb	stateNum,[addr,offset]

	mov	r0, offset
	bleq	drawPurple1

	add	offset, #1
	mov	stateNum, #6
	strb	stateNum, [addr,offset]
	
	mov	r0, offset
	bleq	drawPurple2
	pop	{r4-r6, pc}

.global	blueToGreen
blueToGreen:
	push	{r4-r6, lr}
	mov	stateNum, #3
	strb	stateNum,[addr,offset]

	mov	r0, offset
	bleq	drawGreen1


	add	offset, #1
	mov	stateNum, #4
	strb	stateNum, [addr,offset]
	
	mov	r0, offset
	bleq	drawGreen2

	pop	{r4-r6, pc}	
	.unreq	addr
	.unreq	offset
	.unreq	stateNum

.global checkBrick
checkBrick:
	push		{r4-r8,r10, lr}
	mov		r10, #0

//	ldr		r4, =brickBreakState
	ldr		r4, =brickState
	mov		r5, #1
	
	mov		r6, r1
	mov		r7, r2

	mov		r0, #5
	cmp		r2, #5
	bleq		changeBrick
	cmp		r7, #5
	streq		r5, [r4, r6]
	

	mov		r0, #6
	cmp		r2, #6
	bleq		changeBrick
	cmp		r7, #6
	streq		r5, [r4, r6]
	
	mov		r0, #3
	cmp		r2, #3
	bleq		changeBrick
	cmp		r7, #3
	streq		r5, [r4, r6]


	mov		r0, #4
	cmp		r2, #4
	bleq		changeBrick
	cmp		r7, #4
	streq		r5, [r4, r6]
	
	
	mov		r0, #1
	cmp		r2, #1
	bleq		changeBrick
	cmp		r7, #1
	streq		r5, [r4, r6]
	
	
	mov		r0, #2
	cmp		r2, #2
	bleq		changeBrick
	cmp		r7, #2
	streq		r5, [r4, r6]

	addeq		r10, #1
	
	mov		r0, r10
	pop		{r4-r8,r10, pc}



.global resetBrick
resetBrick:
	push	{r4, r5, lr}
	initAdd	.req	r1
	currAdd	.req	r2
	offset	.req	r4
	cellNum	.req	r5

	mov	offset, #0
	ldr	initAdd, =initialState
	ldr	currAdd, =currentState

resetLoop:
	ldrb	cellNum, [initAdd], #1
	strb	cellNum, [currAdd], #1
	add	offset, #1
	cmp	offset, #484
	blt	resetLoop
	pop	{r4, r5, pc}
	
	
.global resetBrickState
resetBrickState:
	push	{r4, r5, lr}
	initAdd	.req	r1
	offset	.req	r4
	cellNum	.req	r5

	mov	offset, #0
	ldr	initAdd, =brickState

	mov	cellNum, #0
resetBrickLoop:
	strb	cellNum, [initAdd], #1
	add	offset, #1
	cmp	offset, #484
	blt	resetBrickLoop
	pop	{r4, r5, pc}
	
	
	
.section .data
printInt:
.asciz		"              Hit: %d\n"

printNewLine:
.asciz		"\n\n" 
