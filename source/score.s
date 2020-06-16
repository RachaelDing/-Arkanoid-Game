.global drawScoreAndLives
drawScoreAndLives:
	push	{lr, r4-r8}
	addr	.req	r4
	oX	.req	r5
	oY	.req	r6
	width	.req	r7
	height	.req	r8

	mov	oX, #592
	mov	oY, #172
	mov	width, #640
	mov	height, #64

	ldr	r4, =scoreData
	
	push	{r4-r8}
	bl	drawPicRemovingWhite
		.unreq	addr
		.unreq	oX
		.unreq	oY
		.unreq	width
		.unreq	height

	pop	{pc, r4-r8}

.global	drawScoreNum
drawScoreNum:
	push	{lr, r4-r10}
	addr	.req	r4
	oX	.req	r5
	oY	.req	r6
	width	.req	r7
	height	.req	r8
	num1	.req	r9
	num2	.req	r10

	ldr	r1, =scoreNum
	ldr	r9, [r1]
	
	@calculate num1 and num2	
	mov	r0, #10
	udiv	r1, num1, r0
	mul	r2, r1, r0
	sub	num2, num1, r2
	mov	num1, r1
	
drawNum1:
	mov	oX, #816
	mov	oY, #172
	mov	width, #32
	mov	height, #64

	cmp	num1, #6
	ldreq	r4, =six

	cmp	num1, #5
	ldreq	r4, =five

	cmp	num1, #4
	ldreq	r4, =four

	cmp	num1, #3
	ldreq	r4, =three

	cmp	num1, #2
	ldreq	r4, =two

	cmp	num1, #1
	ldreq	r4, =one

	cmp	num1, #0
	ldreq	r4, =zero
	
	push	{r4-r8}
	bl	drawPicRemovingWhite

drawNum2:
	mov	r5, #848
	mov	r6, #172
	mov	r7, #32
	mov	r8, #64

	cmp	num2, #9
	ldreq	r4, =nine

	cmp	num2, #8
	ldreq	r4, =eight

	cmp	num2, #7
	ldreq	r4, =seven

	cmp	num2, #6
	ldreq	r4, =six

	cmp	num2, #5
	ldreq	r4, =five

	cmp	num2, #4
	ldreq	r4, =four

	cmp	num2, #3
	ldreq	r4, =three

	cmp	num2, #2
	ldreq	r4, =two

	cmp	num2, #1
	ldreq	r4, =one

	cmp	num2, #0
	ldreq	r4, =zero
	
	push	{r4-r8}
	bl	drawPicRemovingWhite

		.unreq	addr
		.unreq	oX
		.unreq	oY
		.unreq	width
		.unreq	height
		.unreq	num1
		.unreq 	num2

	pop	{pc, r4-r10}

.global	drawLivesNum
drawLivesNum:
	push	{lr, r4-r9}
	addr	.req	r4
	oX	.req	r5
	oY	.req	r6
	width	.req	r7
	height	.req	r8
	num	.req	r9

	mov	oX, #1104
	mov	oY, #172
	mov	width, #32
	mov	height, #64

	ldr	r1, =livesNum
	ldr	num, [r1]

	cmp	num, #5
	ldreq	r4, =five

	cmp	num, #4
	ldreq	r4, =four

	cmp	num, #3
	ldreq	r4, =three

	cmp	num, #2
	ldreq	r4, =two

	cmp	num, #1
	ldreq	r4, =one

	cmp	num, #0
	ldreq	r4, =zero

	push	{r4-r8}
	bl	drawPicRemovingWhite

		.unreq	addr
		.unreq	oX
		.unreq	oY
		.unreq	width
		.unreq	height
		.unreq	num

	pop	{pc, r4-r9}

.global clearScore
clearScore:
	push		{lr}
	@ offset of scores
	mov		r0, #30
	bl		drawFloor
	
	mov		r0, #31
	bl		drawFloor

	mov		r0, #52
	bl		drawFloor

	mov		r0, #53
	bl		drawFloor
	pop		{pc}



.global clearLives
clearLives:
	push		{lr}
	mov		r0, #39
	bl		drawFloor
	
	mov		r0, #61
	bl		drawFloor

	pop		{pc}