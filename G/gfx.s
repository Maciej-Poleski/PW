	.file	"gfx.cpp"
	.intel_syntax noprefix
	.text
	.type	_Z10calc_sobelPiS_i._omp_fn.1, @function
_Z10calc_sobelPiS_i._omp_fn.1:
.LFB26:
	.cfi_startproc
	push	r14
	.cfi_def_cfa_offset 16
	.cfi_offset 14, -16
	push	r13
	.cfi_def_cfa_offset 24
	.cfi_offset 13, -24
	push	r12
	.cfi_def_cfa_offset 32
	.cfi_offset 12, -32
	push	rbp
	.cfi_def_cfa_offset 40
	.cfi_offset 6, -40
	push	rbx
	.cfi_def_cfa_offset 48
	.cfi_offset 3, -48
	mov	rbx, rdi
	call	omp_get_num_threads
	mov	ebp, eax
	call	omp_get_thread_num
	mov	esi, eax
	mov	eax, DWORD PTR [rbx+16]
	sub	eax, 2
	cdq
	idiv	ebp
	cmp	esi, edx
	jl	.L2
.L7:
	imul	esi, eax
	add	edx, esi
	lea	r10d, [rdx+rax]
	cmp	edx, r10d
	jge	.L1
	inc	edx
.L5:
	lea	r9d, [rdx+1]
	lea	r12d, [rdx-1]
	mov	ecx, 1
.L6:
	mov	edi, DWORD PTR [rbx+16]
	lea	eax, [rdi-1]
	cmp	ecx, eax
	jl	.L4
	cmp	r10d, r9d
	mov	edx, r9d
	jge	.L5
	jmp	.L1
.L4:
	mov	esi, edx
	lea	r8d, [rcx+1]
	mov	rax, QWORD PTR [rbx]
	imul	esi, edi
	mov	r11, QWORD PTR [rbx+8]
	lea	r14d, [rcx-1+rsi]
	lea	ebp, [rcx+rsi]
	add	esi, r8d
	movsx	r13, esi
	movsx	r14, r14d
	movsx	rbp, ebp
	mov	esi, DWORD PTR [rax+r14*4]
	sub	esi, DWORD PTR [rax+r13*4]
	mov	r13d, r12d
	imul	r13d, edi
	imul	edi, r9d
	add	r13d, ecx
	movsx	r13, r13d
	add	ecx, edi
	add	esi, DWORD PTR [rax+r13*4]
	movsx	rcx, ecx
	sub	esi, DWORD PTR [rax+rcx*4]
	mov	ecx, r8d
	mov	DWORD PTR [r11+rbp*4], esi
	jmp	.L6
.L2:
	inc	eax
	xor	edx, edx
	jmp	.L7
.L1:
	pop	rbx
	.cfi_def_cfa_offset 40
	pop	rbp
	.cfi_def_cfa_offset 32
	pop	r12
	.cfi_def_cfa_offset 24
	pop	r13
	.cfi_def_cfa_offset 16
	pop	r14
	.cfi_def_cfa_offset 8
	ret
	.cfi_endproc
.LFE26:
	.size	_Z10calc_sobelPiS_i._omp_fn.1, .-_Z10calc_sobelPiS_i._omp_fn.1
	.type	_Z10calc_sobelPiS_i._omp_fn.0, @function
_Z10calc_sobelPiS_i._omp_fn.0:
.LFB25:
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
	jl	.L11
.L15:
	imul	esi, eax
	add	edx, esi
	lea	r8d, [rdx+rax]
	cmp	edx, r8d
	jge	.L10
	mov	rax, QWORD PTR [rbx]
	movsx	rcx, edx
	lea	r10, [rax+rcx*4]
	xor	ecx, ecx
.L14:
	mov	DWORD PTR [r10+rcx*4], 0
	mov	r9d, DWORD PTR [rbx+8]
	lea	esi, [rdx+rcx]
	inc	rcx
	lea	edi, [r9-1]
	imul	edi, r9d
	add	edi, esi
	movsx	rdi, edi
	mov	DWORD PTR [rax+rdi*4], 0
	mov	edi, DWORD PTR [rbx+8]
	imul	edi, esi
	movsx	rdi, edi
	mov	DWORD PTR [rax+rdi*4], 0
	mov	edi, DWORD PTR [rbx+8]
	imul	esi, edi
	lea	esi, [rdi-1+rsi]
	movsx	rsi, esi
	mov	DWORD PTR [rax+rsi*4], 0
	lea	esi, [rdx+rcx]
	cmp	esi, r8d
	jl	.L14
	jmp	.L10
.L11:
	inc	eax
	xor	edx, edx
	jmp	.L15
.L10:
	pop	rbx
	.cfi_def_cfa_offset 24
	pop	rbp
	.cfi_def_cfa_offset 16
	pop	r12
	.cfi_def_cfa_offset 8
	ret
	.cfi_endproc
.LFE25:
	.size	_Z10calc_sobelPiS_i._omp_fn.0, .-_Z10calc_sobelPiS_i._omp_fn.0
	.type	_Z9calc_blurPiS_i._omp_fn.3, @function
_Z9calc_blurPiS_i._omp_fn.3:
.LFB28:
	.cfi_startproc
	push	r14
	.cfi_def_cfa_offset 16
	.cfi_offset 14, -16
	push	r13
	.cfi_def_cfa_offset 24
	.cfi_offset 13, -24
	push	r12
	.cfi_def_cfa_offset 32
	.cfi_offset 12, -32
	push	rbp
	.cfi_def_cfa_offset 40
	.cfi_offset 6, -40
	push	rbx
	.cfi_def_cfa_offset 48
	.cfi_offset 3, -48
	mov	rbx, rdi
	call	omp_get_num_threads
	mov	ebp, eax
	call	omp_get_thread_num
	mov	esi, eax
	mov	eax, DWORD PTR [rbx+16]
	sub	eax, 2
	cdq
	idiv	ebp
	cmp	esi, edx
	jl	.L18
.L23:
	imul	esi, eax
	add	esi, edx
	lea	r11d, [rsi+rax]
	cmp	esi, r11d
	jge	.L17
	inc	esi
	mov	r9d, 4
.L21:
	lea	r10d, [rsi+1]
	lea	r12d, [rsi-1]
	mov	ecx, 1
.L22:
	mov	edi, DWORD PTR [rbx+16]
	lea	eax, [rdi-1]
	cmp	ecx, eax
	jl	.L20
	cmp	r11d, r10d
	mov	esi, r10d
	jge	.L21
	jmp	.L17
.L20:
	mov	eax, esi
	lea	r8d, [rcx+1]
	mov	rdx, QWORD PTR [rbx]
	imul	eax, edi
	lea	r14d, [rcx-1+rax]
	lea	ebp, [rcx+rax]
	add	eax, r8d
	movsx	r13, eax
	movsx	r14, r14d
	movsx	rbp, ebp
	mov	eax, DWORD PTR [rdx+r14*4]
	add	eax, DWORD PTR [rdx+r13*4]
	mov	r13d, r12d
	imul	r13d, edi
	imul	edi, r10d
	add	r13d, ecx
	movsx	r13, r13d
	add	ecx, edi
	mov	rdi, QWORD PTR [rbx+8]
	add	eax, DWORD PTR [rdx+r13*4]
	movsx	rcx, ecx
	add	eax, DWORD PTR [rdx+rcx*4]
	mov	ecx, r8d
	cdq
	idiv	r9d
	mov	DWORD PTR [rdi+rbp*4], eax
	jmp	.L22
.L18:
	inc	eax
	xor	edx, edx
	jmp	.L23
.L17:
	pop	rbx
	.cfi_def_cfa_offset 40
	pop	rbp
	.cfi_def_cfa_offset 32
	pop	r12
	.cfi_def_cfa_offset 24
	pop	r13
	.cfi_def_cfa_offset 16
	pop	r14
	.cfi_def_cfa_offset 8
	ret
	.cfi_endproc
.LFE28:
	.size	_Z9calc_blurPiS_i._omp_fn.3, .-_Z9calc_blurPiS_i._omp_fn.3
	.type	_Z9calc_blurPiS_i._omp_fn.2, @function
_Z9calc_blurPiS_i._omp_fn.2:
.LFB27:
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
	jl	.L26
.L30:
	imul	esi, eax
	add	edx, esi
	lea	r8d, [rdx+rax]
	cmp	edx, r8d
	jge	.L25
	mov	rax, QWORD PTR [rbx]
	movsx	rcx, edx
	lea	r10, [rax+rcx*4]
	xor	ecx, ecx
.L29:
	mov	DWORD PTR [r10+rcx*4], 0
	mov	r9d, DWORD PTR [rbx+8]
	lea	esi, [rdx+rcx]
	inc	rcx
	lea	edi, [r9-1]
	imul	edi, r9d
	add	edi, esi
	movsx	rdi, edi
	mov	DWORD PTR [rax+rdi*4], 0
	mov	edi, DWORD PTR [rbx+8]
	imul	edi, esi
	movsx	rdi, edi
	mov	DWORD PTR [rax+rdi*4], 0
	mov	edi, DWORD PTR [rbx+8]
	imul	esi, edi
	lea	esi, [rdi-1+rsi]
	movsx	rsi, esi
	mov	DWORD PTR [rax+rsi*4], 0
	lea	esi, [rdx+rcx]
	cmp	esi, r8d
	jl	.L29
	jmp	.L25
.L26:
	inc	eax
	xor	edx, edx
	jmp	.L30
.L25:
	pop	rbx
	.cfi_def_cfa_offset 24
	pop	rbp
	.cfi_def_cfa_offset 16
	pop	r12
	.cfi_def_cfa_offset 8
	ret
	.cfi_endproc
.LFE27:
	.size	_Z9calc_blurPiS_i._omp_fn.2, .-_Z9calc_blurPiS_i._omp_fn.2
	.globl	_Z10calc_sobelPiS_i
	.type	_Z10calc_sobelPiS_i, @function
_Z10calc_sobelPiS_i:
.LFB21:
	.cfi_startproc
	push	rbx
	.cfi_def_cfa_offset 16
	.cfi_offset 3, -16
	mov	rbx, rdi
	mov	edi, OFFSET FLAT:_Z10calc_sobelPiS_i._omp_fn.0
	sub	rsp, 48
	.cfi_def_cfa_offset 64
	mov	QWORD PTR [rsp+8], rsi
	lea	rsi, [rsp+8]
	mov	DWORD PTR [rsp+16], edx
	xor	edx, edx
	call	GOMP_parallel_start
	lea	rdi, [rsp+8]
	call	_Z10calc_sobelPiS_i._omp_fn.0
	call	GOMP_parallel_end
	mov	rax, QWORD PTR [rsp+8]
	lea	rsi, [rsp+24]
	xor	edx, edx
	mov	edi, OFFSET FLAT:_Z10calc_sobelPiS_i._omp_fn.1
	mov	QWORD PTR [rsp+24], rbx
	mov	QWORD PTR [rsp+32], rax
	mov	eax, DWORD PTR [rsp+16]
	mov	DWORD PTR [rsp+40], eax
	call	GOMP_parallel_start
	lea	rdi, [rsp+24]
	call	_Z10calc_sobelPiS_i._omp_fn.1
	call	GOMP_parallel_end
	add	rsp, 48
	.cfi_def_cfa_offset 16
	pop	rbx
	.cfi_def_cfa_offset 8
	ret
	.cfi_endproc
.LFE21:
	.size	_Z10calc_sobelPiS_i, .-_Z10calc_sobelPiS_i
	.globl	_Z9calc_blurPiS_i
	.type	_Z9calc_blurPiS_i, @function
_Z9calc_blurPiS_i:
.LFB22:
	.cfi_startproc
	push	rbx
	.cfi_def_cfa_offset 16
	.cfi_offset 3, -16
	mov	rbx, rdi
	mov	edi, OFFSET FLAT:_Z9calc_blurPiS_i._omp_fn.2
	sub	rsp, 48
	.cfi_def_cfa_offset 64
	mov	QWORD PTR [rsp+8], rsi
	lea	rsi, [rsp+8]
	mov	DWORD PTR [rsp+16], edx
	xor	edx, edx
	call	GOMP_parallel_start
	lea	rdi, [rsp+8]
	call	_Z9calc_blurPiS_i._omp_fn.2
	call	GOMP_parallel_end
	mov	rax, QWORD PTR [rsp+8]
	lea	rsi, [rsp+24]
	xor	edx, edx
	mov	edi, OFFSET FLAT:_Z9calc_blurPiS_i._omp_fn.3
	mov	QWORD PTR [rsp+24], rbx
	mov	QWORD PTR [rsp+32], rax
	mov	eax, DWORD PTR [rsp+16]
	mov	DWORD PTR [rsp+40], eax
	call	GOMP_parallel_start
	lea	rdi, [rsp+24]
	call	_Z9calc_blurPiS_i._omp_fn.3
	call	GOMP_parallel_end
	add	rsp, 48
	.cfi_def_cfa_offset 16
	pop	rbx
	.cfi_def_cfa_offset 8
	ret
	.cfi_endproc
.LFE22:
	.size	_Z9calc_blurPiS_i, .-_Z9calc_blurPiS_i
	.globl	_Z4hashPii
	.type	_Z4hashPii, @function
_Z4hashPii:
.LFB23:
	.cfi_startproc
	imul	esi, esi
	mov	r8d, 20
	mov	edx, 1234567
	mov	r9d, 7777777
.L37:
	xor	ecx, ecx
.L40:
	cmp	esi, ecx
	jle	.L41
	imul	edx, DWORD PTR [rdi+rcx*4]
	inc	rcx
	lea	eax, [rdx+171713]
	cdq
	idiv	r9d
	jmp	.L40
.L41:
	dec	r8d
	jne	.L37
	mov	eax, edx
	ret
	.cfi_endproc
.LFE23:
	.size	_Z4hashPii, .-_Z4hashPii
	.globl	_Z14process_bitmapPii
	.type	_Z14process_bitmapPii, @function
_Z14process_bitmapPii:
.LFB24:
	.cfi_startproc
	push	r15
	.cfi_def_cfa_offset 16
	.cfi_offset 15, -16
	movabs	r15, 2287828610704211968
	push	r14
	.cfi_def_cfa_offset 24
	.cfi_offset 14, -24
	push	r13
	.cfi_def_cfa_offset 32
	.cfi_offset 13, -32
	or	r13, -1
	push	r12
	.cfi_def_cfa_offset 40
	.cfi_offset 12, -40
	mov	r12, rdi
	mov	rdi, r13
	push	rbp
	.cfi_def_cfa_offset 48
	.cfi_offset 6, -48
	mov	ebp, esi
	imul	ebp, esi
	push	rbx
	.cfi_def_cfa_offset 56
	.cfi_offset 3, -56
	mov	ebx, esi
	movsx	rbp, ebp
	sub	rsp, 24
	.cfi_def_cfa_offset 80
	lea	r14, [0+rbp*4]
	cmp	rbp, r15
	cmovbe	rdi, r14
	call	_Znam
	cmp	rbp, r15
	mov	rdi, r13
	mov	QWORD PTR [rsp+8], rax
	cmovbe	rdi, r14
	call	_Znam
	mov	rsi, QWORD PTR [rsp+8]
	mov	rbp, rax
	mov	edx, ebx
	mov	rdi, r12
	call	_Z10calc_sobelPiS_i
	mov	edx, ebx
	mov	rsi, rbp
	mov	rdi, r12
	call	_Z9calc_blurPiS_i
	mov	edi, 4
	call	__cxa_allocate_exception
	xor	edx, edx
	mov	DWORD PTR [rax], 1
	mov	esi, OFFSET FLAT:_ZTIi
	mov	rdi, rax
	call	__cxa_throw
	.cfi_endproc
.LFE24:
	.size	_Z14process_bitmapPii, .-_Z14process_bitmapPii
	.ident	"GCC: (Gentoo 4.8.2 p1.3, pie-0.5.8) 4.8.2"
	.section	.note.GNU-stack,"",@progbits
