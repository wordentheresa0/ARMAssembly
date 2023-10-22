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
	.asciz "\nSummary: \n"
	.align 2
char_ct:
	.asciz "\t%d characters\n"
	.align 2
word_ct:
	.asciz "\t%d words\n"
	.align 2
line_ct:
	.asciz "\t%d lines\n"
	
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

	ldr	r0, word_ctP
	ldr	r1, [r4, #_wordct]
	bl	printf

	ldr	r0, line_ctP
	ldr	r1, [r4, #_linect]
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
	sub	sp, sp, #20
	@ [fp, #-8] is dp
	@ [fp, #-12] is buff
	@ [fp, #-16] is i
	@ [fp, #-20] is char
	@ [fp, #-24] is in_word

	str	r0, [fp, #-8]
	push	{r4, r5, r6, r7, r8}
	ldr	r4, [fp, #-8]

	ldr	r5, [r4, #_inchar]	@ r5 is inchar
	ldr	r6, [r4, #_outchar]	@ r6 is outchar
	ldr	r7, [r4, #_charct]	@ r7 is charct
	ldr	r8, [fp, #-16]		@ r8 is i (index)

	mov	r8, #0			@ i = 0
	str	r8, [fp, #-16]
	
	ldr	r1, [fp, #-24]		@ in_word = 0
	mov	r1, #0
	str	r1, [fp, #-24]

	ldr	r0, [r4, #_linect]	@ ++linect
	add	r0, r0, #1
	str	r0, [r4, #_linect]
	
	b	guard

body:
	str	r7, [r4, #_charct]	@ ++charct
	add	r7, r7, #1
	str	r7, [r4, #_charct]


	@ IF STATEMENT 1
	ldr	r0, [fp, #-20]		@ if byte == inchar
	ldr	r1, [r4, #_inchar]
	cmp	r0, r1
	bne	if2

	ldr	r0, buffP
	ldr	r1, [fp, #-16]
	ldr	r2, [r4, #_outchar]
	bl	put_byte

if2:
	@ IF STATEMENT 2
	ldr	r0, [fp, #-20]		@ if byte == ' ' && in_word == 1
	cmp	r0, #' '
	bne	if3
	ldr	r0, [fp, #-24]
	cmp	r0, #1
	bne	if3

	ldr	r1, [fp, #-24]		@ in_word = 0
	mov	r1, #0
	str	r1, [fp, #-24]

if3:
	@ IF STATEMENT 3
	ldr	r0, [fp, #-20]		@ if byte > 65 || byte < 123
	cmp	r0, #64			@ (ascii character)
	bgt	if4
	cmp	r0, #123
	bgt	else1

if4:
	@@@@ WORDCT NOT WORKING @@@@
	@ IF STATEMENT 4
	ldr	r0, [fp, #-24]		@ if in_word == 0
	cmp	r0, #0
	bne	else1

	ldr	r1, [r4, #_wordct]	@ ++wordct
	add	r1, r1, #1
	str	r1, [r4, #_wordct]

	ldr	r2, [fp, #-24]		@ in_word = 1
	mov	r2, #1
	str	r2, [fp, #-24]

else1:
	ldr	r8, [fp, #-16]		@ ++i
	add	r8, r8, #1
	str	r8, [fp, #-16]
	
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

	str	r7, [r4, #_charct]	@ store value of r7 into charct

	ldr	r0, buffP		@ return buff
	pop	{r4, r5, r6, r7, r8}
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
/*
	ldr	r0, resultsP
	ldr	r1, [r4, #_inchar]
	ldr	r2, [r4, #_outchar]
	bl	printf

	ldr	r0, buff_stringP
	ldr	r1, buffP
	bl	printf
*/

	mov	r1, #0
	str	r1, [r4, #_charct]
	str	r1, [r4, #_wordct]
	str	r1, [r4, #_linect]
	
	b	guard_main

body_main:
	@ BODY
	ldr	r0, [fp, #-8]
	ldr	r1, buffP
	bl	translate

	ldr	r0, buff_stringP
	ldr	r1, buffP
	bl	printf

	@ GUARD
guard_main:	
	ldr	r0, promptP
	bl	printf
	ldr	r0, buffP
	mov	r1, #100
	bl	get_line

	cmp	r0, #1
	bge	body_main


	
	@ END OF LOOP
	
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
word_ctP:
	.word word_ct
line_ctP:
	.word line_ct

/* string variables */
	.data
	.align 2
buff:
	.skip 100
