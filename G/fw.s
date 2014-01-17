	.file	"fw.cpp"
	.intel_syntax noprefix
	.text
	.type	_Z2fwPiiS_PS_i._omp_fn.0, @function
_Z2fwPiiS_PS_i._omp_fn.0:
.LFB22:
	.cfi_startproc
	push	r12
	.cfi_def_cfa_offset 16
	.cfi_offset 12, -16
	push	rbp
	.cfi_def_cfa_offset 24
	.cfi_offset 6, -24
	push	rbx
	.cfi_def_cfa_offset 32
	.cfi_offset 3, -32
	mov	r12d, DWORD PTR [rdi+8]
	mov	rbx, rdi
	call	omp_get_num_threads
	mov	ebp, eax
	call	omp_get_thread_num
	mov	esi, eax
	mov	eax, r12d
	cdq
	idiv	ebp
	cmp	esi, edx
	jl	.L2
.L9:
	imul	esi, eax
	add	edx, esi
	lea	edi, [rdx+rax]
	cmp	edx, edi
	jge	.L1
.L5:
	xor	ecx, ecx
.L7:
	mov	eax, DWORD PTR [rbx+8]
	cmp	ecx, eax
	jl	.L4
	inc	edx
	cmp	edx, edi
	jne	.L5
	jmp	.L1
.L4:
	mov	r9d, DWORD PTR [rbx+12]
	mov	r8d, edx
	mov	rsi, QWORD PTR [rbx]
	imul	r8d, eax
	imul	eax, r9d
	add	r9d, r8d
	add	r8d, ecx
	movsx	r9, r9d
	movsx	r8, r8d
	add	eax, ecx
	cdqe
	mov	eax, DWORD PTR [rsi+rax*4]
	add	eax, DWORD PTR [rsi+r9*4]
	lea	rsi, [rsi+r8*4]
	cmp	eax, DWORD PTR [rsi]
	jl	.L6
.L8:
	inc	ecx
	jmp	.L7
.L6:
	mov	DWORD PTR [rsi], eax
	jmp	.L8
.L2:
	inc	eax
	xor	edx, edx
	jmp	.L9
.L1:
	pop	rbx
	.cfi_def_cfa_offset 24
	pop	rbp
	.cfi_def_cfa_offset 16
	pop	r12
	.cfi_def_cfa_offset 8
	ret
	.cfi_endproc
.LFE22:
	.size	_Z2fwPiiS_PS_i._omp_fn.0, .-_Z2fwPiiS_PS_i._omp_fn.0
	.type	_Z2fwPiiS_PS_i._omp_fn.1, @function
_Z2fwPiiS_PS_i._omp_fn.1:
.LFB23:
	.cfi_startproc
	push	r15
	.cfi_def_cfa_offset 16
	.cfi_offset 15, -16
	push	r14
	.cfi_def_cfa_offset 24
	.cfi_offset 14, -24
	push	r13
	.cfi_def_cfa_offset 32
	.cfi_offset 13, -32
	push	r12
	.cfi_def_cfa_offset 40
	.cfi_offset 12, -40
	xor	r12d, r12d
	push	rbp
	.cfi_def_cfa_offset 48
	.cfi_offset 6, -48
	push	rbx
	.cfi_def_cfa_offset 56
	.cfi_offset 3, -56
	mov	rbx, rdi
	sub	rsp, 56
	.cfi_def_cfa_offset 112
	mov	ebp, DWORD PTR [rdi+32]
	call	GOMP_barrier
	mov	eax, DWORD PTR [rbx+28]
	lea	r14, [rsp+40]
	lea	r13, [rsp+32]
	xor	edi, edi
	mov	ecx, 1
	mov	edx, 1
	mov	r9, r14
	mov	r8, r13
	movsx	rsi, eax
	mov	DWORD PTR [rsp], eax
	call	GOMP_loop_guided_start
	test	al, al
	je	.L13
	mov	QWORD PTR [rsp+16], r14
	mov	QWORD PTR [rsp+24], r13
.L17:
	mov	r11, QWORD PTR [rsp+32]
	mov	eax, DWORD PTR [rsp+40]
	mov	rdx, QWORD PTR [rbx+8]
	mov	DWORD PTR [rsp+4], eax
	movsx	rax, r11d
	lea	r15d, [r11+1]
	lea	rcx, [rdx+rax*4]
	mov	rdx, QWORD PTR [rbx+16]
	mov	QWORD PTR [rsp+8], rcx
	lea	r14, [rdx+rax*8]
	xor	edx, edx
.L16:
	mov	rax, QWORD PTR [rsp+8]
	mov	r10, QWORD PTR [r14+rdx*8]
	xor	edi, edi
	mov	r12d, DWORD PTR [rax+rdx*4]
.L19:
	cmp	r12d, edi
	jg	.L14
	lea	r12d, [r15+rdx]
	inc	rdx
	lea	eax, [r11+rdx]
	cmp	eax, DWORD PTR [rsp+4]
	jl	.L16
	mov	rsi, QWORD PTR [rsp+16]
	mov	rdi, QWORD PTR [rsp+24]
	call	GOMP_loop_guided_next
	test	al, al
	jne	.L17
	jmp	.L13
.L14:
	xor	r8d, r8d
	mov	ecx, -2147483648
.L21:
	cmp	r12d, r8d
	jg	.L18
	cmp	ebp, ecx
	cmovl	ebp, ecx
	inc	rdi
	jmp	.L19
.L18:
	xor	esi, esi
.L22:
	cmp	r12d, esi
	jg	.L20
	inc	r8
	jmp	.L21
.L20:
	mov	r13d, DWORD PTR [r10+rsi*4]
	mov	eax, DWORD PTR [r10+r8*4]
	imul	r13d, DWORD PTR [rbx+24]
	imul	eax, DWORD PTR [rbx+24]
	mov	r9, QWORD PTR [rbx]
	add	r13d, DWORD PTR [r10+r8*4]
	add	eax, DWORD PTR [r10+rdi*4]
	movsx	r13, r13d
	cdqe
	mov	eax, DWORD PTR [r9+rax*4]
	add	eax, DWORD PTR [r9+r13*4]
	mov	r13d, DWORD PTR [r10+rdi*4]
	imul	r13d, DWORD PTR [rbx+24]
	add	r13d, DWORD PTR [r10+rsi*4]
	movsx	r13, r13d
	add	eax, DWORD PTR [r9+r13*4]
	cmp	ecx, eax
	cmovl	ecx, eax
	inc	rsi
	jmp	.L22
.L13:
	cmp	r12d, DWORD PTR [rsp]
	je	.L23
.L24:
	call	GOMP_loop_end_nowait
	add	rsp, 56
	.cfi_remember_state
	.cfi_def_cfa_offset 56
	pop	rbx
	.cfi_def_cfa_offset 48
	pop	rbp
	.cfi_def_cfa_offset 40
	pop	r12
	.cfi_def_cfa_offset 32
	pop	r13
	.cfi_def_cfa_offset 24
	pop	r14
	.cfi_def_cfa_offset 16
	pop	r15
	.cfi_def_cfa_offset 8
	ret
.L23:
	.cfi_restore_state
	mov	DWORD PTR [rbx+32], ebp
	jmp	.L24
	.cfi_endproc
.LFE23:
	.size	_Z2fwPiiS_PS_i._omp_fn.1, .-_Z2fwPiiS_PS_i._omp_fn.1
	.globl	_Z2fwPiiS_PS_i
	.type	_Z2fwPiiS_PS_i, @function
_Z2fwPiiS_PS_i:
.LFB21:
	.cfi_startproc
	push	rbp
	.cfi_def_cfa_offset 16
	.cfi_offset 6, -16
	xor	eax, eax
	mov	rbp, rcx
	push	rbx
	.cfi_def_cfa_offset 24
	.cfi_offset 3, -24
	mov	rbx, rdx
	sub	rsp, 88
	.cfi_def_cfa_offset 112
.L33:
	cmp	eax, esi
	jge	.L36
	mov	DWORD PTR [rsp+32], esi
	lea	rsi, [rsp+24]
	xor	edx, edx
	mov	QWORD PTR [rsp+24], rdi
	mov	edi, OFFSET FLAT:_Z2fwPiiS_PS_i._omp_fn.0
	mov	DWORD PTR [rsp+12], r8d
	mov	DWORD PTR [rsp+36], eax
	call	GOMP_parallel_start
	lea	rdi, [rsp+24]
	call	_Z2fwPiiS_PS_i._omp_fn.0
	call	GOMP_parallel_end
	mov	eax, DWORD PTR [rsp+36]
	mov	rdi, QWORD PTR [rsp+24]
	mov	esi, DWORD PTR [rsp+32]
	mov	r8d, DWORD PTR [rsp+12]
	inc	eax
	jmp	.L33
.L36:
	mov	DWORD PTR [rsp+64], esi
	lea	rsi, [rsp+40]
	mov	QWORD PTR [rsp+40], rdi
	xor	edx, edx
	mov	edi, OFFSET FLAT:_Z2fwPiiS_PS_i._omp_fn.1
	mov	DWORD PTR [rsp+68], r8d
	mov	QWORD PTR [rsp+48], rbx
	mov	QWORD PTR [rsp+56], rbp
	mov	DWORD PTR [rsp+72], -2147483648
	call	GOMP_parallel_start
	lea	rdi, [rsp+40]
	call	_Z2fwPiiS_PS_i._omp_fn.1
	call	GOMP_parallel_end
	mov	eax, DWORD PTR [rsp+72]
	add	rsp, 88
	.cfi_def_cfa_offset 24
	pop	rbx
	.cfi_def_cfa_offset 16
	pop	rbp
	.cfi_def_cfa_offset 8
	ret
	.cfi_endproc
.LFE21:
	.size	_Z2fwPiiS_PS_i, .-_Z2fwPiiS_PS_i
	.ident	"GCC: (Gentoo 4.8.2 p1.3, pie-0.5.8) 4.8.2"
	.section	.note.GNU-stack,"",@progbits
