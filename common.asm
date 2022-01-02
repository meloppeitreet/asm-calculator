; This asm file stores all the common utilities that would normally be provided as a simple function in high level programming languages

; Since there is space here I might as well just talk about the experience :)
; In total, I wrote this for 4 hours and tried debugging and finding problems for 2 hours :"D
; I didn't really refer to the material in asmtutor because I wanted to try on my own (leading to the 4 hours in total)
; I used gdb for finding the problems, and although there may have been easier ways, I got a bit too comfortable with gdb
; So yes, it is kind of a memorable experience haha

;------------------------------
; Ending the Programme
end:

	mov	ebx, 0			;Exit Status in ebx
	mov	eax, 1			;Syscall for Exitting in eax
	int	80h
	ret


;------------------------------
; Printing Strings
;----------------
; Getting the length of strings
slen:
	push	ebx			;preserve whatever value was there first
	mov	ebx, eax		;move address of string into ebx too
.charloop:
	cmp	byte [eax], 0h		;check if the end of the string has reached
	jz	.finlen			;if at the end, proceed to find the difference
        inc     eax                     ;move to the next character
	jmp	.charloop
.finlen:
	sub	eax,ebx			;length is their difference
	pop	ebx			;restore the preserved value of ebx
	ret
;----------------
; Printing the strings
print:

	push	edx			;preserve before storing length of string
	push	ecx			;preserve before storing address of string
	push	ebx			;preserve before storing output channel
	push	eax			;preserve before storing syscall
	call	slen

	mov	edx, eax
	pop	eax			;get the preserved address of the string back
	mov	ecx,eax
	mov	ebx, 1			;print to stdout
	mov	eax, 4			;syscall for printing
	int	80h

	pop	ebx			;get preserved values back
	pop	ecx			;get preserved values back
	pop	edx			;get preserved values back
	ret


;---------------------------------------
; Conversion between ASCII and Integers
;------------------
; ASCII to Integer
atoi:

	push	edx
	push	ebx
	push	ecx
	push	esi
	mov	ecx, 0
	mov	esi, eax
	mov	eax, 0

.multiplyloop:

	xor	ebx, ebx
	mov	bl, [esi+ecx]
	cmp	bl, 48
	jl	.finMloop
	cmp	bl, 57
	jg	.finMloop

	mov	edx, 10
	mul	edx
	sub	bl, 48
	add	eax, ebx
	inc	ecx
	jmp	.multiplyloop

.finMloop:

	pop	esi
	pop	ecx
	pop	ebx
	pop	edx
	ret

;------------
; Integer to ASCII
itoa:

        push    ebx
        push    ecx
        push    edx
        mov     ecx, 0

.divideloop:

	mov	edx, 0
        mov     ebx, 10
        idiv    ebx                             ;idiv also only accepts memory location or registers

        add     edx, 48
        push    edx
        inc     ecx
        cmp     eax, 0
        je      .printDloop
        jmp     .divideloop

.printDloop:

        mov     eax, esp
        call    print
        dec     ecx
	pop	eax
        cmp     ecx,0
	jnz	.printDloop
	call	end

