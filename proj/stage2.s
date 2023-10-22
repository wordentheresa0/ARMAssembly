/* string constants */
	.section	.rodata
	.align 2
prompt:
	.asciz "Enter up to 100 characters: "
	.align 2
results:
	.asciz "%c, %c\n"
	.align 2
buff_string:
	.asciz "%s\n"
	.align 2
summary:	
	.asciz "Summary: \n"
	.align 2
char_ct:
	.asciz "\t%d characters\n"
	
	.data
/* global variables */
	.align 2
dat:
	.word 0
	.word 0
	.word 0
	.word 0
	.word 0
	_inchar = 0
	_outchar = 4
	_charct = 8
	_wordct = 12
	_linect = 16

	.text
/* print_summary function */
print_summary:
	push	{fp, lr}
	add	fp, sp, #4
	sub	sp, sp, #8

	str	r0, [fp, #-8]
	push	{r4}
	ldr	r4, [fp, #-8]

	ldr	r0, summaryP
	bl	printf

	ldr	r0, char_ctP
	ldr	r1, [r4, #_charct]
	bl	printf

	mov	r0, #0
	pop	{r4}
	sub	sp, fp, #4
	pop	{fp, pc}

	
	.text
/* translate function*/	
translate:
	push	{fp, lr}
	add	fp, sp, #4
	sub	sp, sp, #16
	@ [fp, #-8] is dp
	@ [fp, #-12] is buff
	@ [fp, #-16] is i
	@ [fp, #-20] is char

	str	r0, [fp, #-8]
	push	{r4}
	ldr	r4, [fp, #-8]
/*
	ldr	r0, buffP		@ calling put_byte(buff, 0, '*')
	mov	r1, #0
	mov	r2, #'*'
	bl	put_byte
*/
	ldr	r1, [fp, #-16]		@ i = 0
	mov	r1, #0
	str	r1, [fp, #-16]
	
	b	guard

body:
	ldr	r1, [r4, #_charct]	@ ++charct
	add	r1, r1, #1
	str	r1, [r4, #_charct]

	@ IF STATEMENT
	ldr	r0, [fp, #-20]
	ldr	r1, [r4, #_inchar]
	cmp	r0, r1
	bne	else1

	ldr	r0, buffP
	ldr	r1, [fp, #-16]
	ldr	r2, [r4, #_outchar]
	bl	put_byte
/*
	ldr	r2, [fp, #-16]		@ ++i
	add	r2, r2, #1
	str	r2, [fp, #-16]
*/
	
else1:	
	
	ldr	r2, [fp, #-16]		@ ++i
	add	r2, r2, #1
	str	r2, [fp, #-16]

guard:
	@ WHILE LOOP
	
	ldr	r0, buffP		@ get_byte(buff, i)
	ldr	r1, [fp, #-16]
	bl	get_byte

	ldr	r3, [fp, #-20]
	mov	r3, r0
	str	r3, [fp, #-20]		@ c = get_byte(buff, i)
	
	ldr	r0, [fp, #-20]
	mov	r1, #10
	cmp	r0, r1
	bne	body

	
	
	ldr	r0, buffP		@ return buff
	pop	{r4}
	sub	sp, fp, #4
	pop	{fp, pc}
	
	.text
/* get_description function */
get_description:	
	push	{fp, lr}
	add	fp, sp, #4
	sub	sp, sp, #16
	@ [fp, #-8] is dp
	@ [fp, #-12] is buff
	@ [fp, #-16] is char1
	@ [fp, #-20] is char2

	str	r0, [fp, #-8]
	push	{r4}
	ldr	r4, [fp, #-8]

	ldr	r0, buffP		@ getting 1st char
	mov	r1, #0
	bl	get_byte

	ldr	r1, [r4, #_inchar]	@ putting 1st char into inchar
	mov	r1, r0
	str 	r1, [r4, #_inchar]

	ldr	r0, buffP		@ getting 3rd char
	mov	r1, #2
	bl	get_byte

	ldr	r1, [r4, #_outchar]	@ putting 3rd char into outchar
	mov	r1, r0
	str	r1, [r4, #_outchar]


	ldr	r0, buffP		@ getting 2nd char
	mov	r1, #1
	bl	get_byte
	ldr	r1, [fp, #-16]		@ putting 2nd char into char1
	mov	r1, r0
	str	r1, [fp, #-16]

	ldr	r0, buffP		@ getting 4th char
	mov	r1, #3
	bl	get_byte
	ldr	r1, [fp, #-20]		@ putting 4th char into char2
	mov	r1, r0
	str	r1, [fp, #-20]
/*
	ldr	r0, [fp, #-16]		@ if statement
	cmp	r0, #32
	bne	else
	ldr	r0, [fp, #-20]
	cmp	r0, #10
	bne	else
*/

	ldr	r0, buffP		@ arg1,0 == 0
	mov	r1, #0
	bl	get_byte
	ldr	r1, [fp, #-20]
	mov	r1, r0
	str	r1, [fp, #-20]
	ldr	r1, [fp, #-20]
	cmp	r1, #0
	bne	else

	ldr	r0, buffP		@ arg1,1 == ' '
	mov	r1, #1
	bl	get_byte
	ldr	r1, [fp, #-20]
	mov	r1, r0
	str	r1, [fp, #-20]
	ldr	r1, [fp, #-20]
	cmp	r1, #' '
	bne	else

	ldr	r0, buffP		@ arg1,2 == 0
	mov	r1, #2
	bl	get_byte
	ldr	r1, [fp, #-20]
	mov	r1, r0
	str	r1, [fp, #-20]
	ldr	r1, [fp, #-20]
	cmp	r1, #0
	bne	else

	ldr	r0, buffP		@ arg1,3 == '\n'
	mov	r1, #3
	bl	get_byte
	ldr	r1, [fp, #-20]
	mov	r1, r0
	str	r1, [fp, #-20]
	ldr	r1, [fp, #-20]
	cmp	r1, #10
	bne	else

	ldr	r0, buffP		@ arg1,4 == 0
	mov	r1, #4
	bl	get_byte
	ldr	r1, [fp, #-20]
	mov	r1, r0
	str	r1, [fp, #-20]
	ldr	r1, [fp, #-20]
	cmp	r1, #0
	bne	else
	
	
	mov	r0, #0
	pop	{r4}
	sub	sp, fp, #4
	pop	{fp, pc}

	
else:	
	mov	r0, #1
	pop	{r4}
	sub	sp, fp, #4
	pop	{fp, pc}


/* main program */
	.text
	.align 2
	.global main
main:
	push 	{fp, lr}
	add	fp, sp, #4
	sub	sp, sp, #8

	push	{r4}
	ldr	r4, datP
	str	r4, [fp, #-8]
	mov	r1, #0
	str	r1, [r4, #_inchar]
	str	r1, [r4, #_outchar]
	str	r1, [r4, #_charct]
	str	r1, [r4, #_wordct]
	str	r1, [r4, #_linect]

	ldr	r0, promptP
	bl	printf
	ldr	r0, buffP
	mov	r1, #100
	bl	get_line

	ldr	r0, buffP
	bl	puts
	
	ldr	r0, [fp, #-8]
	ldr	r1, buffP
	bl	get_description

	ldr	r0, resultsP
	ldr	r1, [r4, #_inchar]
	ldr	r2, [r4, #_outchar]
	bl	printf

	ldr	r0, buff_stringP
	ldr	r1, buffP
	bl	printf

	ldr	r0, promptP
	bl	printf
	ldr	r0, buffP
	mov	r1, #100
	bl	get_line

	mov	r1, #0
	str	r1, [r4, #_charct]
	str	r1, [r4, #_wordct]
	str	r1, [r4, #_linect]

	ldr	r0, [fp, #-8]
	ldr	r1, buffP
	bl	translate

	ldr	r0, buff_stringP
	ldr	r1, buffP
	bl	printf

	ldr	r0, [fp, #-8]
	bl	print_summary
	
	
	mov	r0, #0
	pop	{r4}
	sub	sp, fp, #4
	pop	{fp, pc}

/* pointer variables for locations in .rodata and .data sections */
	.align 2
promptP:
	.word prompt
buffP:	.word buff
datP:	.word dat
resultsP:
	.word results
buff_stringP:
	.word buff_string
summaryP:
	.word summary
char_ctP:
	.word char_ct

/* string variables */
	.data
	.align 2
buff:
	.skip 100
