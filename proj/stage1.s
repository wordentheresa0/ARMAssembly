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

	ldr	r0, summaryP
	bl	printf

	mov	r0, #0
	sub	sp, fp, #4
	pop	{fp, pc}

	
	.text
/* translate function*/
translate:
	push	{fp, lr}
	add	fp, sp, #4
	sub	sp, sp, #8

	str	r0, [fp, #-8]
	push	{r4}
	ldr	r4, [fp, #-8]

	ldr	r0, buffP
	mov	r1, #0
	mov	r2, #'*'
	bl	put_byte

	ldr	r0, [fp, #-12]
	pop	{r4}
	sub	sp, fp, #4
	pop	{fp, pc}
	
	.text
/* get_description function */
get_description:	
	push	{fp, lr}
	add	fp, sp, #4
	sub	sp, sp, #8

	str	r0, [fp, #-8]

	push	{r4}
	ldr	r4, [fp, #-8]

	ldr	r0, [fp, #-12]
	mov	r1, #0
	bl	get_byte

	ldr	r1, [r4, #_inchar]
	mov	r1, r0
	str 	r1, [r4, #_inchar]

	ldr	r0, [fp, #-12]
	mov	r1, #2
	bl	get_byte

	ldr	r1, [r4, #_outchar]
	mov	r1, r0
	str	r1, [r4, #_outchar]

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

	ldr	r0, [fp, #-8]
	ldr	r1, buffP
	bl	translate

	ldr	r0, buff_stringP
	ldr	r1, buffP
	bl	printf

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

/* string variables */
	.data
	.align 2
buff:
	.skip 100
