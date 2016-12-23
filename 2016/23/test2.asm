section .data
	fmt_ext: db "extern %d", 10, 0
	fmt_st: db "st %d %d %d %d", 10, 0

section .text
	global main
	extern printf

log_st:
	mov rdi, fmt_st
	mov rsi, rbp
	mov rdx, rbx
	mov rcx, r12
	mov r8, r13
	xor rax, rax
	call printf
	ret

ext:
	call log_st
	mov rdi, fmt_ext
	mov rsi, r14
	xor rax, rax
	call printf
	jmp end

main:
	push rbp
	push rbx
	push r12
	push r13
	push r14
	
	mov rbp, 5040
	mov rbx, 1
	mov r12, 2
	mov r13, 0
	
	call log_st
	
	jmp i17

	; cpy a b
i0:
	mov rbx, rbp
	; dec b
i1:
	dec rbx
	; cpy a d
i2:
	mov r13, rbp
	; cpy 0 a
i3:
	mov rbp, 0
	; cpy b c
i4:
	mov r12, rbx
	; inc a
i5:
	inc rbp
	; dec c
i6:
	dec r12
	; jnz c -2
i7:
	cmp r12, 0
	jne i5
	; dec d
i8:
	dec r13
	; jnz d -5
i9:
	cmp r13, 0
	jne i4
	; dec b
i10:
	dec rbx
	; cpy b c
i11:
	mov r12, rbx
	; cpy c d
i12:
	mov r13, r12
	; dec d
i13:
	dec r13
	; inc c
i14:
	inc r12
	; jnz d -2
i15:
	cmp r13, 0
	jne i13
	; tgl c
i16:
	mov r14, 16
	jmp ext
	; cpy -16 c
i17:
	mov r12, -16
	; cpy 1 c
i18:
	mov r12, 1
	; cpy 85 c
i19:
	mov r12, 85
	; cpy 91 d
i20:
	mov r13, 91
	; inc a
i21:
	inc rbp
	; dec d
i22:
	dec r13
	; jnz d -2
i23:
	cmp r13, 0
	jne i21
	; dec c
i24:
	dec r12
	; jnz c -5
i25:
	cmp r12, 0
	jne i20
	
end:
	call log_st
	pop r14
	pop r13
	pop r12
	pop rbx
	pop rbp
	ret
