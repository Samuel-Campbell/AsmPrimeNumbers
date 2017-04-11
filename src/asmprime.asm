section .data
	question db "Enter a Number (must be 2 digits)", 0xa
	lenQuestion equ $ - question	

	numberPrime db "The Number Is Prime", 0xa
	lenNumberPrime equ $ - numberPrime

	numberNotPrime db "The Number Is Not Prime", 0xa 
	lenNumberNotPrime equ $ - numberNotPrime
	
	
	input db "       ", 0
	inputLen equ $ - input

section .bss
	num resb 4		
	prime resb 1
	divident resb 4

section .text
global _start

_start:

;initialize prime to 1
;first divisor should be 2
.init:
	mov eax, 1
	mov [prime], eax
	mov eax, 2
	mov [num], eax	
	
.askForNumber:
	mov eax, 4
	mov ebx, 1
	mov ecx, question
	mov edx, lenQuestion
	int 0x80

.userInput:
	mov eax, 3
	mov ebx, 1	
	mov ecx, input
	mov edx, inputLen
	int 0x80

.atoi:
	lea esi,[input]

	;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
	;CHANGE LENGTH OF INPUT HERE
	;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

	mov ecx, 2
	call string_to_int
	mov [divident], eax	

;Make sure that the divisor is smaller than numerator
.checkDivisor:
	mov eax, [num]
	mov ecx, [divident]

	; if The divisor is greater or equal than
	; the numerator then we exit the program
	cmp eax, ecx	
	jae .isPrime

;Perform division
.division:
	mov dx, 0     
	mov ax, [divident]
	mov bx, [num]
	div bx 
	
	mov ax, 0

	cmp ax, dx
	jne .incrementDivisor 

	mov eax, 0
	mov [prime], eax
	
;Increment the divisor to iterate through every possibilities
.incrementDivisor:
	mov eax, [num]
	inc eax
	mov [num], eax			
	
	jmp .checkDivisor

;Checks if the remainder of a division is 0
.isPrime:
	mov eax, [prime]
	mov ecx, 0
	
	cmp eax, ecx
	je .notPrime

;Found number is prime
.prime:
	mov eax, 4
	mov ebx, 1
	mov ecx, numberPrime
	mov edx, lenNumberPrime
	int 0x80
	
	jmp .exitProgram

;Found number is not prime
.notPrime:
	mov eax, 4
	mov ebx, 1
	mov ecx, numberNotPrime
	mov edx, lenNumberNotPrime
	int 0x80
	
	jmp .exitProgram

.exitProgram:
	mov eax, 1
	int 0x80	

string_to_int:
	xor ebx,ebx    ; clear ebx

.next_digit:
	movzx eax,byte[esi]
	inc esi
	sub al,'0'    ; convert from ASCII to number
	imul ebx,10
	add ebx,eax   ; ebx = ebx*10 + eax
	loop .next_digit  ; while (--ecx)
	mov eax,ebx
	ret

