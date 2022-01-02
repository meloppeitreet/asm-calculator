; This is a small project started on 16/9/2021 for learning purposes.

; I saw an addition calculator being made on asmtutor.com,
; so I just wanted to try making a calculator that supported more operators
; before moving on to the other lessons (as a small revision).

; Although it may not be helpful in any sense, it had been a fun 6 hours :)
; Really got me used to trying to follow the flow of the programme (e.g. keeping track of the registers and stack).
; - Melodi Joy Halim


%include 'common.asm'

SECTION .data:
usagemsg	db	'Usage: ./calculator <number> <operator> <number>',0h
argerrormsg	db	'Incorrect number of arguments. Please enter: <number> <operator> <number>',0h
numerrormsg	db	'Argument entered is not a valid number. Please try again.',0h
operrormsg	db	'Operator entered is not a valid operator. Please try again.',0h

SECTION .text:
global	_start


_start:

	pop	ecx			;Get the no. of arguments (first on the stack)
	pop	edx			;Get the name of the programme (to be discarded)
	sub	ecx, 1			;Actual number of arguments (without the programme name)
	mov	edx, 0			;edx will store the final result

	cmp	ecx, 0h			;Check if there are no arguments given
	jz	noargfinish


argcvalidation:

	cmp	ecx, 3			;Check if there are exactly 3 arguments
	je	operation		;Proceed to validating each argument + operating
	mov	eax, argerrormsg
	call	print
	call	end


operation:

	pop	eax			;Get the first number (first argument)
	call	atoi			;Convert the argument to integer
	mov	edx, eax		;Store the first number in edx temporarily

	pop	eax			;Get the operator (second argument)
	xor	ecx, ecx
	mov	cl, [eax]		;Store the ASCII number of the operator in ecx

	pop	eax			;Get the second number (third argument)
	call	atoi			;Convert the argument to integer
	mov	ebx, eax		;Store the second number in edx

	mov	eax, edx		;Move the first number into eax for operation to be done

	cmp	cl, 37			;%
	je	modulo
	cmp	cl, 42			;*
	je	multiply
	cmp	cl, 43			;+
	je	addition
	cmp	cl, 45			;-
	je	subtraction
	cmp	cl, 47			;/
	je	division

	mov	eax, operrormsg		;The operator is not a supported one
	call	print
	jmp	end


modulo:

	mov	edx, 0
	div	ebx			;divide first number (in eax) by second number (in edx)
	mov	eax, ebx		;remainder stored in edx after idiv to be printed (hence moved into eax)
	jmp	finish

multiply:

	mul	ebx			;multiply eax (first number) by edx (second number)
	jmp	finish

addition:

	add	eax, ebx		;add eax (first number) and edx (second number)
	jmp	finish

subtraction:

	sub	eax, ebx		;subtract edx (second number) from eax (first number)
	jmp	finish

division:

	mov	edx, 0
	div	ebx			;divide [eax] by [edx] and quotient is already stored in eax
	jmp	finish

noargfinish:

	mov	ebx, usagemsg
	call	print
	call	end



finish:

	call	itoa
	call	end
