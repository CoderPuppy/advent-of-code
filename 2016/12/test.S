section .data
	format: db "%d %d %d %d", 10, 0
	; format: db "hello world", 10, 0

section .text
	global main
	extern printf

log:
	mov rdi, format
	mov rsi, rbp
	mov rdx, rbx
	mov rcx, r12
	mov r8, r13
	xor rax, rax
	call printf
	ret

main:
	push rbp
	push rbx
	push r12
	push r13

	xor rbp, rbp
	xor rbx, rbx
	xor r12, r12
	xor r13, r13

	mov r12, 1
	call log

	; cpy 1 a
	mov rbp, 1
	; cpy 1 b
	mov rbx, 1
	; cpy 26 d
	mov r13, 26
	; jnz c 2
	cmp r12, 0
	jne j1
	; jnz 1 5
	jmp j2
j1:
	; cpy 7 c
	mov r12, 7
j3:
	; inc d
	inc r13
	; dec c
	dec r12
	; jnz c -2
	cmp r12, 0
	jne j3
j2:
j5:
	; cpy a c
	mov r12, rbp
j4:
	; inc a
	inc rbp
	; dec b
	dec rbx
	; jnz b -2
	cmp rbx, 0
	jne j4
	; cpy c b
	mov rbx, r12
	; dec d
	dec r13
	; jnz d -6
	cmp r13, 0
	jne j5
	; cpy 19 c
	mov r12, 19
j7:
	; cpy 14 d
	mov r13, 14
j6:
	; inc a
	inc rbp
	; dec d
	dec r13
	; jnz d -2
	cmp r13, 0
	jne j6
	; dec c
	dec r12
	; jnz c -5
	cmp r12, 0
	jne j7

	call log

	pop r13
	pop r12
	pop rbx
	pop rbp
	ret
