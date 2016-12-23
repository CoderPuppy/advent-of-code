section .data
	format: db "%d %d %d %d", 10, 0

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
	push r14

	xor rbp, rbp
	xor rbx, rbx
	xor r12, r12
	xor r13, r13

	mov r12, 2
	call log

	inc rbp
	nop
	nop
	nop
	dec r12
	nop
	nop
	nop
i1:
	mov r14, i1
	add r14, -2
	cmp r12, 0
	jne r14

	call log

	pop r14
	pop r13
	pop r12
	pop rbx
	pop rbp
	ret
