.section .data
.align 2



.global	selectorUp
selectorUp:
	push	{lr}
	ldr	r0, =selectorPosition
	ldr	r2, [r0, #4]

	ldr	r1,=#492 
	cmp	r2, r1
	strne	r1, [r0, #4]
	
	pop	{pc}

.global	selectorDown
selectorDown:
	push	{lr}
	ldr	r0, =selectorPosition
	ldr	r2, [r0, #4]

	ldr	r1,=#492 
	add	r1, #140
	cmp	r2, r1
	strne	r1, [r0, #4]

	pop	{pc}

.global	drawMenu
drawMenu:
	push		{r4-r8,lr}
	@draw menu
	ldr		r4, =menu

	ldr		r0, =windowPosition
	ldr		r5, [r0]

	ldr		r0, =windowPosition
	ldr		r6, [r0,#4]

	mov		r7, #704
	mov		r8, #704
	push		{r4-r8}
	bl		drawPic
	pop		{r4-r8,pc}



.global	drawPauseMenu
drawPauseMenu:
	push		{r4-r8,lr}
	@draw menu
	ldr		r4, =pause

	ldr		r5, =#717
	ldr		r6, =#297
	mov		r7, #390
	mov		r8, #390
	push		{r4-r8}
	bl		drawPicRemovingWhite
	pop		{r4-r8,pc}

.global	drawSelectorUp
drawSelectorUp:
	push		{r4-r8,lr}
	@draw menu
	ldr		r4, =selector2Up
	ldr		r5, =#747
	ldr		r6, =#487
	mov		r7, #327
	mov		r8, #44
	push		{r4-r8}
	bl		drawPicRemovingWhite
	pop		{r4-r8,pc}


.global	drawSelectorDown
drawSelectorDown:
	push		{r4-r8,lr}
	@draw menu
	ldr		r4, =selector2Down

	ldr		r5, =#809
	ldr		r6, =#575
	mov		r7, #205
	mov		r8, #44
	push		{r4-r8}
	bl		drawPicRemovingWhite
	pop		{r4-r8,pc}
.global drawBlackBox
drawBlackBox:
	push		{r4-r8,lr}
	@draw menu
	ldr		r4, =blackBox

	ldr		r0, =windowPosition
	ldr		r5, [r0]

	ldr		r0, =windowPosition
	ldr		r6, [r0,#4]

	mov		r7, #704
	mov		r8, #704
	push		{r4-r8}
	bl		drawPic
	pop		{r4-r8,pc}


.global	drawWin
drawWin:
	push		{r4-r8,lr}
	@draw menu
	ldr		r4, =win

	ldr		r0, =windowPosition
	ldr		r5, [r0]

	ldr		r0, =windowPosition
	ldr		r6, [r0,#4]

	mov		r7, #704
	mov		r8, #704
	push		{r4-r8}
	bl		drawPicRemovingWhite
	pop		{r4-r8,pc}




.global	drawLost
drawLost:
	push		{r4-r8,lr}
	@draw menu
	ldr		r4, =lost

	ldr		r0, =windowPosition
	ldr		r5, [r0]

	ldr		r0, =windowPosition
	ldr		r6, [r0,#4]

	mov		r7, #704
	mov		r8, #704
	push		{r4-r8}
	bl		drawPicRemovingWhite  @bug here

	pop		{r4-r8,pc}



printHere:
.asciz		"here here \n"
