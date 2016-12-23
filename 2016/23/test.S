section .data
	format: db "%d: %d %d %d %d", 10, 0
	; format: db "hello world", 10, 0

section .text
	global main
	extern printf

log:
	mov rdi, format
	mov rsi, r14
	mov rdx, rbp
	mov rcx, rbx
	mov r8, r12
	mov r9, r13
	xor rax, rax
	call printf
	ret

main:
	push rbp
	push rbx
	push r12
	push r13
	push r14

	xor r14, r14

	xor rbp, rbp
	xor rbx, rbx
	xor r12, r12
	xor r13, r13

	mov rbp, 7

	mov r14, 0
	call log

	; cpy a b
	mov rbx, rbp
	; dec b
	dec rbx
j4:
	; cpy a d
	mov r13, rbp
	; cpy 0 a
	mov rbp, 0
j2:
	; cpy b c
	mov r12, rbx
j1:
	; inc a
	inc rbp
	; dec c
	dec r12
	; jnz c -2
	cmp r12, 0
	jne j1
	; dec d
	dec r13
	; jnz d -5
	cmp r13, 0
	jne j2
	; dec b
	dec rbx
	; cpy b c
	mov r12, rbx
	; cpy c d
	mov r13, r12
j3:
	; dec d
	dec r13
	; inc c
	inc r12
	; jnz d -2
	cmp r13, 0
	jne j3

	mov r14, 1
	call log

	; tgl c
	; !!!STATIC!!!
	; cpy -16 c
	mov r12, -16
	; jnz 1 c
	; !!!STATIC!!!
	jmp j4
	; cpy 85 c
	mov r12, 85
	; jnz 91 d
	; !!!STATIC!!!
	; d=0
	; inc a
	; inc d
	; jnz d -2
	; inc c
	; jnz c -5

	pop r13
	pop r12
	pop rbx
	pop rbp
	ret
