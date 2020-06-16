
@ Code section
.section .text

.global drawFloor
drawFloor:
	push		{r4,r5,r6,r7,r8,lr}
	mov		r1, #22
	udiv		r6, r0, r1

	mul		r5, r6, r1
	sub		r5, r0,	r5
	
	ldr		r4, =floor
	mov		r7, #32
	mov		r8, #32

	lsl		r6, #5
	lsl		r5, #5

	ldr		r0, =windowPosition
	ldr		r1, [r0]
	add		r5, r1

	ldr		r0, =windowPosition
	ldr		r1, [r0,#4]
	add		r6, r1

	push		{r4-r8}
	bl		drawPic

	pop		{r4,r5,r6,r7,r8,pc}


.global drawWall
drawWall:
	push		{r4,r5,r6,r7,r8,lr}
	mov		r1, #22
	udiv		r6, r0, r1

	mul		r5, r6, r1
	sub		r5, r0,	r5
	
	ldr		r4, =wall
	mov		r7, #32
	mov		r8, #32

	lsl		r6, #5
	lsl		r5, #5

	ldr		r0, =windowPosition
	ldr		r1, [r0]
	add		r5, r1

	ldr		r0, =windowPosition
	ldr		r1, [r0,#4]
	add		r6, r1

	push		{r4-r8}
	bl		drawPic

	pop		{r4,r5,r6,r7,r8,pc}

.global drawBlue1
drawBlue1:
	push		{r4,r5,r6,r7,r8,lr}
	mov		r1, #22
	udiv		r6, r0, r1

	mul		r5, r6, r1
	sub		r5, r0,	r5
	
	mov		r7, #32
	mov		r8, #32

	lsl		r6, #5
	lsl		r5, #5

	ldr		r0, =windowPosition
	ldr		r1, [r0]
	add		r5, r1

	ldr		r0, =windowPosition
	ldr		r1, [r0,#4]
	add		r6, r1

	ldr		r4, =blue1
	push		{r4-r8}
	bl		drawPic

	pop		{r4,r5,r6,r7,r8,pc}


.global drawBlue2
drawBlue2:
	push		{r4,r5,r6,r7,r8,lr}
	mov		r1, #22
	udiv		r6, r0, r1

	mul		r5, r6, r1
	sub		r5, r0,	r5
	
	mov		r7, #32
	mov		r8, #32

	lsl		r6, #5
	lsl		r5, #5

	ldr		r0, =windowPosition
	ldr		r1, [r0]
	add		r5, r1

	ldr		r0, =windowPosition
	ldr		r1, [r0,#4]
	add		r6, r1

	ldr		r4, =blue2
	push		{r4-r8}
	bl		drawPic

	pop		{r4,r5,r6,r7,r8,pc}

.global drawGreen1
drawGreen1:
	push		{r4,r5,r6,r7,r8,lr}
	mov		r1, #22
	udiv		r6, r0, r1

	mul		r5, r6, r1
	sub		r5, r0,	r5
	
	ldr		r4, =green1
	mov		r7, #32
	mov		r8, #32

	lsl		r6, #5
	lsl		r5, #5

	ldr		r0, =windowPosition
	ldr		r1, [r0]
	add		r5, r1

	ldr		r0, =windowPosition
	ldr		r1, [r0,#4]
	add		r6, r1

	push		{r4-r8}
	bl		drawPic

	pop		{r4,r5,r6,r7,r8,pc}

.global drawGreen2
drawGreen2:
	push		{r4,r5,r6,r7,r8,lr}
	mov		r1, #22
	udiv		r6, r0, r1

	mul		r5, r6, r1
	sub		r5, r0,	r5
	
	ldr		r4, =green2
	mov		r7, #32
	mov		r8, #32

	lsl		r6, #5
	lsl		r5, #5

	ldr		r0, =windowPosition
	ldr		r1, [r0]
	add		r5, r1

	ldr		r0, =windowPosition
	ldr		r1, [r0,#4]
	add		r6, r1

	push		{r4-r8}
	bl		drawPic

	pop		{r4,r5,r6,r7,r8,pc}

.global drawPurple1
drawPurple1:
	push		{r4,r5,r6,r7,r8,lr}
	mov		r1, #22
	udiv		r6, r0, r1

	mul		r5, r6, r1
	sub		r5, r0,	r5
	
	ldr		r4, =purple1
	mov		r7, #32
	mov		r8, #32

	lsl		r6, #5
	lsl		r5, #5

	ldr		r0, =windowPosition
	ldr		r1, [r0]
	add		r5, r1

	ldr		r0, =windowPosition
	ldr		r1, [r0,#4]
	add		r6, r1

	push		{r4-r8}
	bl		drawPic

	pop		{r4,r5,r6,r7,r8,pc}

.global drawPurple2
drawPurple2:
	push		{r4,r5,r6,r7,r8,lr}
	mov		r1, #22
	udiv		r6, r0, r1

	mul		r5, r6, r1
	sub		r5, r0,	r5
	
	ldr		r4, =purple2
	mov		r7, #32
	mov		r8, #32

	lsl		r6, #5
	lsl		r5, #5

	ldr		r0, =windowPosition
	ldr		r1, [r0]
	add		r5, r1

	ldr		r0, =windowPosition
	ldr		r1, [r0,#4]
	add		r6, r1

	push		{r4-r8}
	bl		drawPic

	pop		{r4,r5,r6,r7,r8,pc}

.global drawPic
drawPic:
	addr		.req	r4
	oX		.req 	r5
	oY		.req	r6
	width		.req	r7
	height		.req	r8
	cX		.req	r9
	cY		.req	r10
	
	pop		{r4,r5,r6,r7,r8}
	push		{r4,r5,r6,r7,r8,r9,r10,lr}
	
	mov		cX, #0
	mov		cY, #0

drawLoop:	
	cmp		cY, width
	blt		drawRow
	pop		{r4,r5,r6,r7,r8,r9,r10,pc}

drawRow:
	add		r0, oX, cX
	add		r1, oY, cY
	ldr		r2, [addr],#4
	
	bl		DrawPixel

	add		cX, #1

	cmp		cX, height
	blt		drawRow
	
	mov		cX, #0
	add		cY, #1
	b		drawLoop


.global DrawBall			
DrawBall:
	addr		.req	r4
	oX		.req 	r5
	oY		.req	r6
	radian		.req	r7

	cX		.req	r9
	cY		.req	r10
	
	pop		{r4,r5,r6,r7}
	push		{r4,r5,r6,r7,r9,r10,lr}	

	mov		cX, #0
	mov		cY, #0

drawBLoop:	
	cmp		cY, width
	blt		drawBRow
	pop		{r4,r5,r6,r7,r9,r10,pc}

drawBRow:
	add		r0, oX, cX
	add		r1, oY, cY
	ldr		r2, [addr],#4

	ldr		r3, =#0xffffffff
	cmp		r2, r3
	bllt		DrawPixel

	add		cX, #1

	cmp		cX, width
	blt		drawBRow
	
	mov		cX, #0
	add		cY, #1
	b		drawBLoop
	
.global drawPicRemovingWhite			
drawPicRemovingWhite:
	addr		.req	r4
	oX		.req 	r5
	oY		.req	r6
	width 		.req	r7
	height		.req	r8

	cX		.req	r9
	cY		.req	r10
	
	pop		{r4-r8}
	push		{r4- r10,lr}	

	mov		cX, #0
	mov		cY, #0



drawP2Loop:	
	cmp		cY, height

	blt		drawP2Row

	pop		{r4-r10, pc}

drawP2Row:
	add		r0, oX, cX
	add		r1, oY, cY
	ldr		r2, [addr],#4

	ldr		r3, =#0xffffffff
	cmp		r2, r3
	blne		DrawPixel

	add		cX, #1

	cmp		cX, width
	blt		drawP2Row
	
	mov		cX, #0
	add		cY, #1
	b		drawP2Loop	

.global drawAllWall
drawAllWall:
	push		{lr, r4-r8}
	ldr		r4, =currentState
	mov		r5, #0
	
drawAllWallLoop:
	ldrb		r6,[r4],#1

	mov		r0, r5

	cmp		r6, #9
	bleq		drawWall

	add		r5, #1
	cmp		r5, #484
	blt		drawAllWallLoop
	pop		{pc, r4-r8}
	



@ Draw Pixel
@  r0 - x
@  r1 - y
@  r2 - colour	

DrawPixel:
	push		{r4, r5}

	offset		.req	r4

	ldr		r5, =frameBufferInfo	

	@ offset = (y * width) + x
	
	ldr		r3, [r5, #4]		@ r3 = width
	mul		r1, r3
	add		offset,	r0, r1
	
	@ offset *= 4 (32 bits per pixel/8 = 4 bytes per pixel)
	lsl		offset, #2

	@ store the colour (word) at frame buffer pointer + offset
	ldr		r0, [r5]		@ r0 = frame buffer pointer
	str		r2, [r0, offset]

	pop		{r4, r5}
	bx		lr


@ Data section
.section .data

.align

printY:
.asciz          "You have pressed asdfghjklwqertyuiop\n"   
