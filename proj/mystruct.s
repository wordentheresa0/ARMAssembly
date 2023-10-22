/* example of using a global struct
   requires hdlib */

	.data
/* global variables */
	.align 2
buff:				@ global char* variable
	.asciz "Hello"

	.align 2
dat:				@ global variable dat of type  struct try
	.word	0		@ member val of type int
	.word	0		@ member str of type char *
	_val = 0		@ _val is offset for member val
	_str = 4		@ _str is offset for member str


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

	ldr	r1, [r4, #_val]		@ add 1 to dp->val
	add	r1, r1, #1
	str	r1, [r4, #_val]

	ldr	r0, [r4, #_str]		@ call put_byte(dp->str, 1, 'X')
	mov	r1, #1
	mov	r2, #'X'
	bl	put_byte

	ldr	r0, [r4, #_val]		@ return dp->val
	pop	{r4}			@ restore value of r4
	sub	sp, fp, #4		@ tear down stack frame
	pop	{fp, pc}

/* format strings */
	.section .rodata
	.align 2
return:					@ format string for return value
	.asciz "mod(dp) returned %d\n"
	.align 2
dump:					@ format string for dat members
	.asciz "dat holds {%d, \"%s\"}\n"

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
	mov	r1, #10			@ store 10 in dp->val
	str	r1, [r4, #_val]
	ldr	r1, buffP		@ store address buff in dp->str
	str	r1, [r4, #_str]

	ldr	r0, dumpP		@ print labelled members of *dp
	ldr	r1, [r4, #_val]
	ldr	r2, [r4, #_str]
	bl	printf

	ldr	r0, [fp, #-8]		@ call mod(dp)
	bl	mod
	str	r0, [fp, #-12]		@ store return value in ret

	ldr	r0, returnP		@ print labelled return value
	ldr	r1, [fp, #-12]
	bl	printf

	ldr	r0, dumpP		@ print labelled members of *dp
	ldr	r1, [r4, #_val]
	ldr	r2, [r4, #_str]
	bl	printf

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
dumpP:	.word dump
	
