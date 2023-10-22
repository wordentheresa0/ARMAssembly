/* example of using a global struct
   requires hdlib */

	.data
/* global variables */
	.align 2
buff:				@ global char* variable
	.asciz "Hello"
	.align 2
buffa:				@buff charr array
	.skip 5

	.align 2
dat:				@ global variable dat of type  struct transdat
	.word	0		@ member inchar of type int
	.word	0		@ member outchar of type int
	.word	0		@ member charct of type int
	.word	0		@ member wordct of type int
	.word	0		@ member linect of type int
	_inchar = 0		@ _inchar is offset for member inchar
	_outchar = 4		@ _outchar is offset for member outchar
	_charct = 8		@ _charct is offset for member charct
	_wordct = 12		@ _wordct is offset for member wordct 
	_linect = 16		@ _linect is offest for member linect

/* function print_summary */
	.text
print_summary:
	push	{fp, lr}
	add	fp, sp, #4
	sub	sp, sp, #8	@one local variable
	@ [fp, #-8] is dp, pointer to variable of type struct transdat

	str	r0, [fp, #-8]

	push	{r4}
	ldr	r4, [fp, #-8]

	ldr	r0, print_statementP
	ldr	r1, [r4, #_charct]
	ldr	r2, [r4, #_wordct]
	ldr	r3, [r4, #_linect]
	bl	printf
	
	
/* function translate */
	.text
translate:
	push	{fp, lr}
	add	fp, sp, #4
	sub	sp, sp, #8	@two local variables
	@ [fp, #-8] is dp, pointer to variable of type struct transdat
	@ [fp, #-12] is a non-constant/non-empty string

	str	r0, [fp, #-8]
	push	{r4}
	ldr	r4, [fp, #-8]

	ldr	r0, buffaP
	mov	r1, #0
	mov	r2, #'*'
	bl	put_byte

	ldr	r0, [fp, #-12]
	pop	{r4}
	sub	sp, fp, #4
	pop	{fp, pc}
	
	
/*function get_description */
	.text
get_description:
	push	{fp, lr}
	add	fp, sp, #4
	sub	sp, sp, #8	@two local variables
	@ [fp, #-8] is dp, pointer to variable of type struct transdat
	@ [fp, #-12] is a string representing an input line

	str	r0, [fp, #-8]

	push	{r4}
	ldr	r4, [fp, #-8]

	ldr	r0, [fp, #-12]		@get first char
	mov	r1, #0
	bl	get_byte

	ldr	r1, [r4, #_inchar]
	mov	r1, r0
	str	r1, [r4, #_inchar]

	ldr	r0, [fp, #-12]		@get second char
	mov	r1, #2
	bl	get_byte
	
	ldr	r1, [r4, #_outchar]
	mov	r1, r0
	str	r1, [r4, #_outchar]
	
	mov	r0, #1
	pop	{r4}
	sub	sp, fp, #4
	pop	{fp, pc}
	
	
	

/* function mod
      1 arg - pointer to a variable of type  struct try
      state change - add 1 to arg1->val and assign 'X' to arg1->str[1]
      return - integer, value of arg1->val */
	.text
mod:
	push	{fp, lr}		@ setup stack frame
	add	fp, sp, #4
	sub	sp, sp, #8		@ one local variable
	@ [fp, #-8] holds dp, pointer to variable of type  struct try
	@ r4 holds copy of the pointer dp

	str	r0, [fp, #-8]		@ initialize argument dp
	
	push	{r4}			@ save and initialize r4
	ldr	r4, [fp, #-8]

	ldr	r1, [r4, #_inchar]
	add	r1, r1, #100
	str	r1, [r4, #_inchar]

	ldr	r1, [r4, #_outchar]
	add	r1, r1, #100
	str	r1, [r4, #_outchar]

	ldr	r1, [r4, #_charct]
	add	r1, r1, #100
	str	r1, [r4, #_charct]

	ldr	r1, [r4, #_wordct]
	add	r1, r1, #100
	str	r1, [r4, #_wordct]

	ldr	r1, [r4, #_linect]
	add	r1, r1, #100
	str	r1, [r4, #_linect]

	ldr	r0, [r4, #_inchar]	@ return dp->inchar
	pop	{r4}			@ restore value of r4
	sub	sp, fp, #4		@ tear down stack frame
	pop	{fp, pc}

/* format strings */
	.section .rodata
	.align 2
return:					@ format string for return value
	.asciz "mod(dp) returned %d\n"
	.align 2
dump1:					@ format string for dat members
	.asciz "dat holds {%d, %d, %d}\n"
	.align 2
dump2:
	.asciz "dat also holds {%d, %d}\n"
	.align 2
print_statement:
	.asciz "Character count: %d, Word count: %d, Line count: %d.\n"
	.align 2
prompt:
	.asciz "Enter two characters separated by a space: "
	.align 2
print_res:
	.asciz "%d \n%d\n"

/* function main */
	.text
	.global main
	.align 4
main:	
	push	{fp, lr}		@ setup stack frame
	add	fp, sp, #4
	sub	sp, sp, #8		@ two local variables
	@ [fp, #-8] holds dp, pointer to variable of type  struct try
	@ [fp, #-12] holds ret, return value from mod()
	@ r4 holds copy of the pointer dp
	

	push	{r4}			@ save and initialize r4
	ldr	r4, datP		@ assign address of dat to r4

	str	r4, [fp, #-8]		@ initialize local variable dp

	mov	r1, #0			@ store 0 in dp->val
	str	r1, [r4, #_inchar]

	mov	r1, #0			@store 0 in dp->outchar
	str	r1, [r4, #_outchar]

	mov	r1, #0			@store 0 in dp->charct
	str	r1, [r4, #_charct]

	mov	r1, #0			@store 0 in dp->wordct
	str	r1, [r4, #_wordct]

	mov	r1, #0			@store 0 in dp->linect
	str	r1, [r4, #_linect]

	ldr	r0, dump1P		@print dump1
	ldr	r1, [r4, #_inchar]
	ldr	r2, [r4, #_outchar]
	ldr	r3, [r4, #_charct]
	bl	printf

	ldr	r0, dump2P		@print dump2
	ldr	r1, [r4, #_wordct]
	ldr	r2, [r4, #_linect]
	bl	printf


	ldr	r0, [fp, #-8]		@ call mod(dp)
	bl	mod
	str	r0, [fp, #-12]		@ store return value in ret

	ldr	r0, returnP		@ print labelled return value
	ldr	r1, [fp, #-12]
	bl	printf

	ldr	r0, dump1P
	ldr	r1, [r4, #_inchar]
	ldr	r2, [r4, #_outchar]
	ldr	r3, [r4, #_charct]
	bl	printf

	ldr	r0, dump2P
	ldr	r1, [r4, #_wordct]
	ldr	r2, [r4, #_linect]
	bl	printf

	ldr	r0, promptP		
	bl	printf
	ldr	r0, buffaP
	mov	r1, #5
	bl	get_line

	ldr	r0, [fp, #-8]		@ call get_description
	ldr	r1, buffaP
	bl	get_description
	
	ldr	r0, print_resP		@call print statement
	ldr	r1, [r4, #_inchar]
	ldr	r2, [r4, #_outchar]
	bl	printf

	ldr	r0, [fp, #-8]		@ call translate
	ldr	r1, buffaP
	bl	translate

	ldr	r0, buffaP
	bl	puts

	ldr	r0, [fp, #-8]
	bl	print_summary

	mov	r0, #0			@ return 0
	pop	{r4}			@ restore value of r4
	sub	sp, fp, #4		@ tear down stack frame
	pop	{fp, pc}

/* pointer variables */

	.align 2
buffP:	.word buff
datP:	.word dat
returnP:
	.word return
dump1P:	.word dump1
dump2P:	.word dump2
print_statementP:
	.word print_statement
buffaP:
	.word buffa
promptP:
	.word prompt
print_resP:
	.word print_res
