	.file	"cuMin.cpp"
	.intel_syntax noprefix
# GNU C++ (Ubuntu/Linaro 4.7.3-2ubuntu4) version 4.7.3 (x86_64-linux-gnu)
#	compiled by GNU C version 4.7.3, GMP version 5.0.5, MPFR version 3.1.1-p2, MPC version 1.0.1
# GGC heuristics: --param ggc-min-expand=100 --param ggc-min-heapsize=131072
# options passed:  -I /usr/local/cuda/include -imultilib .
# -imultiarch x86_64-linux-gnu -D_GNU_SOURCE cuMin.cpp -masm=intel
# -mtune=generic -march=x86-64 -auxbase-strip cuMin.S -Wall -Wextra
# -fverbose-asm -fstack-protector
# options enabled:  -fasynchronous-unwind-tables -fauto-inc-dec
# -fbranch-count-reg -fcommon -fdebug-types-section
# -fdelete-null-pointer-checks -fdwarf2-cfi-asm -fearly-inlining
# -feliminate-unused-debug-types -fexceptions -ffunction-cse -fgcse-lm
# -fgnu-runtime -fident -finline-atomics -fira-share-save-slots
# -fira-share-spill-slots -fivopts -fkeep-static-consts
# -fleading-underscore -fmath-errno -fmerge-debug-strings
# -fmove-loop-invariants -fpeephole -fprefetch-loop-arrays
# -freg-struct-return -fsched-critical-path-heuristic
# -fsched-dep-count-heuristic -fsched-group-heuristic -fsched-interblock
# -fsched-last-insn-heuristic -fsched-rank-heuristic -fsched-spec
# -fsched-spec-insn-heuristic -fsched-stalled-insns-dep -fshow-column
# -fsigned-zeros -fsplit-ivs-in-unroller -fstack-protector
# -fstrict-volatile-bitfields -ftrapping-math -ftree-coalesce-vars
# -ftree-cselim -ftree-forwprop -ftree-loop-if-convert -ftree-loop-im
# -ftree-loop-ivcanon -ftree-loop-optimize -ftree-parallelize-loops=
# -ftree-phiprop -ftree-pta -ftree-reassoc -ftree-scev-cprop
# -ftree-slp-vectorize -ftree-vect-loop-version -funit-at-a-time
# -funwind-tables -fvect-cost-model -fverbose-asm -fzero-initialized-in-bss
# -m128bit-long-double -m64 -m80387 -maccumulate-outgoing-args
# -malign-stringops -mfancy-math-387 -mfp-ret-in-387 -mglibc -mieee-fp
# -mmmx -mno-sse4 -mpush-args -mred-zone -msse -msse2 -mtls-direct-seg-refs

	.globl	moduleName
	.section	.rodata
.LC0:
	.string	"cuMin.ptx"
	.data
	.align 8
	.type	moduleName, @object
	.size	moduleName, 8
moduleName:
	.quad	.LC0
	.globl	kernelName
	.section	.rodata
.LC1:
	.string	"kernelMain"
	.data
	.align 8
	.type	kernelName, @object
	.size	kernelName, 8
kernelName:
	.quad	.LC1
	.text
	.type	_ZL13filledMemSizej, @function
_ZL13filledMemSizej:
.LFB402:
	.cfi_startproc
	push	rbp	#
	.cfi_def_cfa_offset 16
	.cfi_offset 6, -16
	mov	eax, edi	# size, size
	test	eax, 1023	# size,
	mov	rbp, rsp	#,
	.cfi_def_cfa_register 6
	je	.L2	#,
	and	eax, -1024	# D.11252,
	add	eax, 1024	# size,
.L2:
	pop	rbp	#
	.cfi_def_cfa 7, 8
	ret
	.cfi_endproc
.LFE402:
	.size	_ZL13filledMemSizej, .-_ZL13filledMemSizej
	.section	.rodata.str1.1,"aMS",@progbits,1
.LC2:
	.string	"cannot acquire device 0"
.LC3:
	.string	"cannot create context"
.LC4:
	.string	"cannot load module: %d\n"
.LC5:
	.string	"cannot acquire kernel handle"
	.text
	.globl	_Z5cuMinPii
	.type	_Z5cuMinPii, @function
_Z5cuMinPii:
.LFB403:
	.cfi_startproc
	push	rbp	#
	.cfi_def_cfa_offset 16
	.cfi_offset 6, -16
	mov	rbp, rsp	#,
	.cfi_def_cfa_register 6
	push	r15	#
	push	r14	#
	push	r13	#
	.cfi_offset 15, -24
	.cfi_offset 14, -32
	.cfi_offset 13, -40
	mov	r13, rdi	# T, T
	xor	edi, edi	#
	push	r12	#
	push	rbx	#
	.cfi_offset 12, -48
	.cfi_offset 3, -56
	mov	ebx, esi	# n, n
	sub	rsp, 88	#,
	call	cuInit	#
	lea	rdi, [rbp-92]	#,
	xor	esi, esi	#
	call	cuDeviceGet	#
	test	eax, eax	# res
	jne	.L14	#,
	mov	edx, DWORD PTR [rbp-92]	#, cuDevice
	lea	rdi, [rbp-88]	#,
	xor	esi, esi	#
	call	cuCtxCreate_v2	#
	test	eax, eax	# res
	jne	.L15	#,
	mov	rsi, QWORD PTR moduleName[rip]	#, moduleName
	lea	rdi, [rbp-80]	#,
	mov	QWORD PTR [rbp-80], 0	# cuModule,
	call	cuModuleLoad	#
	test	eax, eax	# res
	jne	.L16	#,
	mov	rdx, QWORD PTR kernelName[rip]	#, kernelName
	mov	rsi, QWORD PTR [rbp-80]	#, cuModule
	lea	rdi, [rbp-72]	#,
	call	cuModuleGetFunction	#
	test	eax, eax	# res
	jne	.L17	#,
	movsx	rcx, ebx	# n, n
	xor	edx, edx	#
	mov	rdi, r13	#, T
	sal	rcx, 2	# D.11228,
	mov	rsi, rcx	#, D.11228
	mov	QWORD PTR [rbp-104], rcx	#,
	call	cuMemHostRegister	#
	mov	edi, ebx	#, n
	call	_ZL13filledMemSizej	#
	mov	r15d, eax	# D.11230, inputSize
	mov	r12d, eax	# inputSize,
	shr	r15d, 10	# D.11230,
	mov	edi, r15d	#, D.11230
	call	_ZL13filledMemSizej	#
	lea	rdi, [rbp-64]	#,
	mov	esi, r12d	# inputSize, inputSize
	mov	r14d, eax	# outputSize,
	sal	rsi, 2	# tmp97,
	call	cuMemAlloc_v2	#
	lea	rdi, [rbp-56]	#,
	mov	esi, r14d	# outputSize, outputSize
	sal	rsi, 2	# tmp100,
	call	cuMemAlloc_v2	#
	mov	rcx, QWORD PTR [rbp-104]	#,
	mov	rdi, QWORD PTR [rbp-64]	#, inputD
	mov	rsi, r13	#, T
	mov	rdx, rcx	#, D.11228
	call	cuMemcpyHtoD_v2	#
	mov	rdx, QWORD PTR [rbp-56]	#, outputD
	mov	rsi, QWORD PTR [rbp-64]	#, inputD
	mov	r9d, ebx	#, n
	mov	rdi, QWORD PTR [rbp-72]	#, helloWorld
	mov	r8d, r14d	#, outputSize
	mov	ecx, r12d	#, inputSize
	mov	DWORD PTR [rsp], r15d	#, D.11230
	call	_ZL12universalMinP9CUfunc_styyjjjj	#
	mov	rdi, QWORD PTR [rbp-64]	#, inputD
	mov	ebx, eax	# D.11245,
	call	cuMemFree_v2	#
	mov	rdi, QWORD PTR [rbp-56]	#, outputD
	call	cuMemFree_v2	#
	mov	rdi, QWORD PTR [rbp-88]	#, cuContext
	call	cuCtxDestroy_v2	#
	add	rsp, 88	#,
	mov	eax, ebx	#, D.11245
	pop	rbx	#
	pop	r12	#
	pop	r13	#
	pop	r14	#
	pop	r15	#
	pop	rbp	#
	.cfi_remember_state
	.cfi_def_cfa 7, 8
	ret
.L14:
	.cfi_restore_state
	mov	edi, OFFSET FLAT:.LC2	#,
	call	puts	#
	mov	edi, 1	#,
	call	exit	#
.L17:
	mov	edi, OFFSET FLAT:.LC5	#,
	call	puts	#
	mov	edi, 1	#,
	call	exit	#
.L16:
	mov	esi, eax	#, res
	mov	edi, OFFSET FLAT:.LC4	#,
	xor	eax, eax	#
	call	printf	#
	mov	edi, 1	#,
	call	exit	#
.L15:
	mov	edi, OFFSET FLAT:.LC3	#,
	call	puts	#
	mov	edi, 1	#,
	call	exit	#
	.cfi_endproc
.LFE403:
	.size	_Z5cuMinPii, .-_Z5cuMinPii
	.section	.rodata.str1.1
.LC6:
	.string	"cuMin.cpp"
.LC7:
	.string	"inputSize%1024==0"
	.text
	.type	_ZL12universalMinP9CUfunc_styyjjjj, @function
_ZL12universalMinP9CUfunc_styyjjjj:
.LFB404:
	.cfi_startproc
	push	rbp	#
	.cfi_def_cfa_offset 16
	.cfi_offset 6, -16
	mov	rbp, rsp	#,
	.cfi_def_cfa_register 6
	push	r15	#
	push	r14	#
	push	r13	#
	push	r12	#
	.cfi_offset 15, -24
	.cfi_offset 14, -32
	.cfi_offset 13, -40
	.cfi_offset 12, -48
	mov	r12, rsi	# input, input
	push	rbx	#
	.cfi_offset 3, -56
	mov	rbx, rdx	# output, output
	sub	rsp, 152	#,
	cmp	r9d, ecx	# inputInitialized,
	mov	QWORD PTR [rbp-128], rdi	# %sfp, kernel
	setb	r13b	#, D.11143
	cmp	DWORD PTR [rbp+16], r8d	# outputInitialized, outputSize
	mov	DWORD PTR [rbp-116], ecx	# %sfp, inputSize
	mov	DWORD PTR [rbp-120], r8d	# %sfp, outputSize
	setb	r15b	#, D.11144
	jb	.L31	#,
	test	r13b, r13b	# D.11143
	jne	.L31	#,
.L19:
	mov	eax, DWORD PTR [rbp-116]	#, %sfp
	test	eax, eax	#
	je	.L25	#,
	test	DWORD PTR [rbp-116], 1023	# %sfp,
	lea	rax, [rbp-96]	#,
	lea	r13, [rbp-80]	# tmp190,
	mov	QWORD PTR [rbp-96], r12	# inputForKernel, input
	mov	QWORD PTR [rbp-80], rbx	# outputForKernel, output
	mov	QWORD PTR [rbp-64], rax	# args,
	mov	QWORD PTR [rbp-56], r13	# args, tmp190
	jne	.L26	#,
	mov	r15d, DWORD PTR [rbp-116]	# inputSize, %sfp
	mov	r14d, 64	# ivtmp.113,
	jmp	.L27	#
.L28:
	lea	rax, [r12+rax*4]	# tmp177,
	mov	QWORD PTR [rbp-56], r13	# args, tmp190
	mov	QWORD PTR [rbp-96], rax	# inputForKernel, tmp177
	mov	eax, r14d	# ivtmp.113, ivtmp.113
	add	r14d, 64	# ivtmp.113,
	lea	rax, [rbx+rax*4]	# tmp180,
	mov	QWORD PTR [rbp-80], rax	# outputForKernel, tmp180
	lea	rax, [rbp-96]	#,
	mov	QWORD PTR [rbp-64], rax	# args,
.L27:
	mov	eax, r15d	# tmp183, inputSize
	lea	rsi, [rbp-100]	#,
	lea	rdi, [rbp-104]	#,
	shr	eax, 10	# tmp183,
	mov	DWORD PTR [rbp-100], 64	# D.10799,
	sub	r15d, 65536	# inputSize,
	mov	DWORD PTR [rbp-104], eax	# D.10798, tmp183
	call	_ZSt3minIjERKT_S2_S2_	#
	mov	rdi, QWORD PTR [rbp-128]	#, %sfp
	mov	esi, DWORD PTR [rax]	# gridSize, *D.11196_55
	lea	rax, [rbp-64]	#,
	mov	r9d, 1	#,
	mov	r8d, 1024	#,
	mov	ecx, 1	#,
	mov	edx, 1	#,
	mov	QWORD PTR [rsp+32], 0	#,
	mov	QWORD PTR [rsp+24], rax	#,
	mov	QWORD PTR [rsp+16], 0	#,
	mov	DWORD PTR [rsp+8], 0	#,
	mov	DWORD PTR [rsp], 1	#,
	call	cuLaunchKernel	#
	call	cuCtxSynchronize	#
	mov	eax, r14d	# inputBegin, ivtmp.113
	sal	eax, 10	#,
	cmp	DWORD PTR [rbp-116], eax	# %sfp, inputBegin
	ja	.L28	#,
	cmp	DWORD PTR [rbp-116], 1024	# %sfp,
	je	.L47	#,
.L25:
	mov	edi, DWORD PTR [rbp-120]	# tmp188, %sfp
	shr	edi, 10	# tmp188,
	call	_ZL13filledMemSizej	#
	mov	r9d, DWORD PTR [rbp-120]	#, %sfp
	mov	r8d, eax	# D.11201,
	mov	eax, DWORD PTR [rbp-116]	#, %sfp
	mov	rdi, QWORD PTR [rbp-128]	#, %sfp
	mov	rdx, r12	#, input
	mov	rsi, rbx	#, output
	mov	DWORD PTR [rsp], eax	#,
	mov	ecx, r9d	#,
	call	_ZL12universalMinP9CUfunc_styyjjjj	#
.L29:
	add	rsp, 152	#,
	pop	rbx	#
	pop	r12	#
	pop	r13	#
	pop	r14	#
	pop	r15	#
	pop	rbp	#
	.cfi_remember_state
	.cfi_def_cfa 7, 8
	ret
.L31:
	.cfi_restore_state
	mov	eax, DWORD PTR [rbp-120]	#, %sfp
	sub	eax, DWORD PTR [rbp+16]	#, outputInitialized
	lea	rsi, [rbp-80]	#,
	lea	rdi, [rbp-96]	#,
	mov	DWORD PTR [rbp-144], r9d	#,
	mov	DWORD PTR [rbp-132], eax	# %sfp,
	mov	DWORD PTR [rbp-80], eax	# D.10785,
	mov	eax, DWORD PTR [rbp-116]	#, %sfp
	sub	eax, r9d	#, inputInitialized
	mov	DWORD PTR [rbp-136], eax	# %sfp,
	mov	DWORD PTR [rbp-96], eax	# D.10784,
	call	_ZSt3maxIjERKT_S2_S2_	#
	mov	edx, DWORD PTR [rax]	# fillSize, *D.11150_14
	lea	rdi, [rbp-80]	#,
	lea	r14, [0+rdx*4]	# D.11152,
	mov	rsi, r14	#, D.11152
	call	cuMemAllocHost_v2	#
	mov	rdi, QWORD PTR [rbp-80]	# fill, fill
	mov	r9d, DWORD PTR [rbp-144]	#,
	lea	rsi, [rdi+r14]	# tmp158,
	mov	rax, rdi	# i, fill
	cmp	rdi, rsi	# fill, tmp158
	jae	.L21	#,
.L40:
	mov	DWORD PTR [rax], 2147483647	# MEM[base: i_129, offset: 0B],
	mov	rdi, QWORD PTR [rbp-80]	# fill, fill
	add	rax, 4	# i,
	lea	rsi, [rdi+r14]	# tmp159,
	cmp	rax, rsi	# i, tmp159
	jb	.L40	#,
.L21:
	test	r13b, r13b	# D.11143
	jne	.L48	#,
.L23:
	test	r15b, r15b	# D.11144
	jne	.L49	#,
.L24:
	.p2align 4,,5
	call	cuMemFreeHost	#
	.p2align 4,,5
	jmp	.L19	#
.L47:
	mov	edx, 4	#,
	mov	rsi, rbx	#, output
	mov	rdi, r13	#, tmp190
	call	cuMemcpyDtoH_v2	#
	mov	eax, DWORD PTR [rbp-80]	# D.11199, result
	jmp	.L29	#
.L48:
	mov	edx, DWORD PTR [rbp-136]	# D.11149, %sfp
	lea	rax, [r12+r9*4]	# tmp164,
	mov	rsi, rdi	#, fill
	mov	rdi, rax	#, tmp164
	sal	rdx, 2	# tmp161,
	call	cuMemcpyHtoD_v2	#
	mov	rdi, QWORD PTR [rbp-80]	# fill, fill
	jmp	.L23	#
.L49:
	mov	r15d, DWORD PTR [rbp+16]	# outputInitialized, outputInitialized
	mov	edx, DWORD PTR [rbp-132]	# D.11148, %sfp
	mov	rsi, rdi	#, fill
	lea	rax, [rbx+r15*4]	# tmp170,
	sal	rdx, 2	# tmp166,
	mov	rdi, rax	#, tmp170
	call	cuMemcpyHtoD_v2	#
	mov	rdi, QWORD PTR [rbp-80]	# fill, fill
	jmp	.L24	#
.L26:
	mov	ecx, OFFSET FLAT:_ZZL12universalMinP9CUfunc_styyjjjjE19__PRETTY_FUNCTION__	#,
	mov	edx, 137	#,
	mov	esi, OFFSET FLAT:.LC6	#,
	mov	edi, OFFSET FLAT:.LC7	#,
	call	__assert_fail	#
	.cfi_endproc
.LFE404:
	.size	_ZL12universalMinP9CUfunc_styyjjjj, .-_ZL12universalMinP9CUfunc_styyjjjj
	.section	.rodata
.LC8:
	.string	"kernelPrepare"
	.text
	.type	_ZL6bigMinP9CUfunc_stP8CUmod_stPii, @function
_ZL6bigMinP9CUfunc_stP8CUmod_stPii:
.LFB405:
	.cfi_startproc
	.cfi_personality 0x3,__gxx_personality_v0
	.cfi_lsda 0x3,.LLSDA405
	push	rbp	#
	.cfi_def_cfa_offset 16
	.cfi_offset 6, -16
	mov	rbp, rsp	#,
	.cfi_def_cfa_register 6
	sub	rsp, 176	#,
	mov	QWORD PTR [rbp-104], rdi	# hw, hw
	mov	QWORD PTR [rbp-112], rsi	# cuModule, cuModule
	mov	QWORD PTR [rbp-120], rdx	# T, T
	mov	DWORD PTR [rbp-124], ecx	# n, n
	mov	rcx, QWORD PTR [rbp-112]	# tmp94, cuModule
	lea	rax, [rbp-64]	# tmp95,
	mov	edx, OFFSET FLAT:.LC8	#,
	mov	rsi, rcx	#, tmp94
	mov	rdi, rax	#, tmp95
.LEHB0:
	call	cuModuleGetFunction	#
	mov	eax, DWORD PTR [rbp-124]	# tmp96, n
	lea	edx, [rax+65535]	# tmp98,
	test	eax, eax	# tmp97
	cmovs	eax, edx	# tmp98,, tmp97
	sar	eax, 16	# tmp99,
	mov	edx, eax	# D.11107, tmp99
	mov	eax, DWORD PTR [rbp-124]	# n.65, n
	and	eax, 65535	# D.11109,
	test	eax, eax	# D.11109
	setne	al	#, D.11110
	movzx	eax, al	# D.11111, D.11110
	add	eax, edx	# D.11112, D.11107
	mov	DWORD PTR [rbp-92], eax	# count, D.11112
	mov	eax, DWORD PTR [rbp-124]	# n.66, n
	mov	edx, 0	# tmp101,
	div	DWORD PTR [rbp-92]	# count
	mov	ecx, eax	# D.11114, tmp100
	mov	eax, DWORD PTR [rbp-124]	# n.67, n
	mov	edx, 0	# tmp102,
	div	DWORD PTR [rbp-92]	# count
	mov	eax, edx	# D.11116, tmp102
	test	eax, eax	# D.11116
	setne	al	#, D.11117
	movzx	eax, al	# D.11118, D.11117
	add	eax, ecx	# tmp104, D.11114
	mov	DWORD PTR [rbp-88], eax	# threadPool, tmp104
	mov	eax, DWORD PTR [rbp-88]	# tmp105, threadPool
	mov	edx, eax	# D.11119, tmp105
	shr	edx, 10	# D.11119,
	mov	eax, DWORD PTR [rbp-88]	# tmp106, threadPool
	and	eax, 1023	# D.11120,
	test	eax, eax	# D.11120
	setne	al	#, D.11121
	movzx	eax, al	# D.11122, D.11121
	add	eax, edx	# tmp107, D.11119
	mov	DWORD PTR [rbp-84], eax	# gridSize, tmp107
	mov	eax, DWORD PTR [rbp-124]	# tmp108, n
	cdqe
	lea	rdx, [0+rax*4]	# D.11124,
	lea	rax, [rbp-56]	# tmp109,
	mov	rsi, rdx	#, D.11124
	mov	rdi, rax	#, tmp109
	call	cuMemAlloc_v2	#
	mov	eax, DWORD PTR [rbp-84]	# tmp110, gridSize
	sal	eax, 10	# D.11125,
	mov	eax, eax	# D.11126, D.11125
	lea	rdx, [0+rax*4]	# D.11127,
	lea	rax, [rbp-48]	# tmp111,
	mov	rsi, rdx	#, D.11127
	mov	rdi, rax	#, tmp111
	call	cuMemAlloc_v2	#
	lea	rax, [rbp-40]	# tmp112,
	mov	esi, 8	#,
	mov	rdi, rax	#, tmp112
	call	cuMemAlloc_v2	#
	mov	eax, DWORD PTR [rbp-92]	# count.68, count
	mov	DWORD PTR [rbp-80], eax	# data, count.68
	mov	eax, DWORD PTR [rbp-124]	# tmp113, n
	mov	DWORD PTR [rbp-76], eax	# data, tmp113
	mov	rax, QWORD PTR [rbp-40]	# arg.69, arg
	lea	rcx, [rbp-80]	# tmp114,
	mov	edx, 8	#,
	mov	rsi, rcx	#, tmp114
	mov	rdi, rax	#, arg.69
	call	cuMemcpyHtoD_v2	#
	mov	eax, DWORD PTR [rbp-124]	# tmp115, n
	cdqe
	lea	rdx, [0+rax*4]	# D.11131,
	mov	rax, QWORD PTR [rbp-56]	# inputOnDevice.70, inputOnDevice
	mov	rcx, QWORD PTR [rbp-120]	# tmp116, T
	mov	rsi, rcx	#, tmp116
	mov	rdi, rax	#, inputOnDevice.70
	call	cuMemcpyHtoD_v2	#
	lea	rax, [rbp-56]	# tmp117,
	mov	QWORD PTR [rbp-32], rax	# args, tmp117
	lea	rax, [rbp-48]	# tmp118,
	mov	QWORD PTR [rbp-24], rax	# args, tmp118
	lea	rax, [rbp-40]	# tmp119,
	mov	QWORD PTR [rbp-16], rax	# args, tmp119
	mov	rax, QWORD PTR [rbp-64]	# helloWorld.71, helloWorld
	mov	esi, DWORD PTR [rbp-84]	# tmp120, gridSize
	mov	QWORD PTR [rsp+32], 0	#,
	lea	rdx, [rbp-32]	# tmp121,
	mov	QWORD PTR [rsp+24], rdx	#, tmp121
	mov	QWORD PTR [rsp+16], 0	#,
	mov	DWORD PTR [rsp+8], 0	#,
	mov	DWORD PTR [rsp], 1	#,
	mov	r9d, 1	#,
	mov	r8d, 1024	#,
	mov	ecx, 1	#,
	mov	edx, 1	#,
	mov	rdi, rax	#, helloWorld.71
	call	cuLaunchKernel	#
	call	cuCtxSynchronize	#
	mov	rax, QWORD PTR [rbp-56]	# inputOnDevice.72, inputOnDevice
	mov	rdi, rax	#, inputOnDevice.72
	call	cuMemFree_v2	#
	mov	rax, QWORD PTR [rbp-40]	# arg.73, arg
	mov	rdi, rax	#, arg.73
	call	cuMemFree_v2	#
	mov	edx, DWORD PTR [rbp-88]	# threadPool.74, threadPool
	mov	rcx, QWORD PTR [rbp-48]	# outputOnDevice.75, outputOnDevice
	mov	rax, QWORD PTR [rbp-104]	# tmp122, hw
	mov	rsi, rcx	#, outputOnDevice.75
	mov	rdi, rax	#, tmp122
	call	_ZL14smallMinDeviceP9CUfunc_styi	#
.LEHE0:
	jmp	.L54	#
.L53:
	mov	rdi, rax	#, D.11311
.LEHB1:
	call	_Unwind_Resume	#
.LEHE1:
.L54:
	leave
	.cfi_def_cfa 7, 8
	ret
	.cfi_endproc
.LFE405:
	.globl	__gxx_personality_v0
	.section	.gcc_except_table,"a",@progbits
.LLSDA405:
	.byte	0xff
	.byte	0xff
	.byte	0x1
	.uleb128 .LLSDACSE405-.LLSDACSB405
.LLSDACSB405:
	.uleb128 .LEHB0-.LFB405
	.uleb128 .LEHE0-.LEHB0
	.uleb128 .L53-.LFB405
	.uleb128 0
	.uleb128 .LEHB1-.LFB405
	.uleb128 .LEHE1-.LEHB1
	.uleb128 0
	.uleb128 0
.LLSDACSE405:
	.text
	.size	_ZL6bigMinP9CUfunc_stP8CUmod_stPii, .-_ZL6bigMinP9CUfunc_stP8CUmod_stPii
	.section	.rodata
.LC9:
	.string	"pad > 0"
.LC10:
	.string	"cannot run kernel"
	.text
	.type	_ZL14smallMinDeviceP9CUfunc_styi, @function
_ZL14smallMinDeviceP9CUfunc_styi:
.LFB406:
	.cfi_startproc
	.cfi_personality 0x3,__gxx_personality_v0
	.cfi_lsda 0x3,.LLSDA406
	push	rbp	#
	.cfi_def_cfa_offset 16
	.cfi_offset 6, -16
	mov	rbp, rsp	#,
	.cfi_def_cfa_register 6
	push	rbx	#
	sub	rsp, 184	#,
	.cfi_offset 3, -24
	mov	QWORD PTR [rbp-120], rdi	# helloWorld, helloWorld
	mov	QWORD PTR [rbp-128], rsi	# inputOnDevice, inputOnDevice
	mov	DWORD PTR [rbp-132], edx	# n, n
	mov	DWORD PTR [rbp-104], 1024	# blockSize,
	mov	eax, DWORD PTR [rbp-132]	# n.34, n
	mov	edx, eax	# D.11020, n.34
	shr	edx, 10	# D.11020,
	mov	eax, DWORD PTR [rbp-132]	# n.35, n
	and	eax, 1023	# D.11022,
	test	eax, eax	# D.11022
	setne	al	#, D.11023
	movzx	eax, al	# D.11024, D.11023
	add	eax, edx	# gridSize.36, D.11020
	mov	DWORD PTR [rbp-100], eax	# gridSize, gridSize.36
	lea	rdx, [rbp-104]	# tmp125,
	lea	rax, [rbp-100]	# tmp126,
	mov	rsi, rdx	#, tmp125
	mov	rdi, rax	#, tmp126
	call	_ZSt3maxIjERKT_S2_S2_	#
	mov	eax, DWORD PTR [rax]	# D.11027, *D.11026_10
	mov	eax, eax	# D.11028, D.11027
	lea	rdx, [0+rax*4]	# D.11029,
	lea	rax, [rbp-80]	# tmp127,
	mov	rsi, rdx	#, D.11029
	mov	rdi, rax	#, tmp127
.LEHB2:
	call	cuMemAlloc_v2	#
.LEHE2:
	mov	eax, DWORD PTR [rbp-100]	# gridSize.37, gridSize
	mov	edx, eax	# D.11031, gridSize.37
	sal	edx, 10	# D.11031,
	mov	eax, DWORD PTR [rbp-132]	# n.38, n
	mov	ecx, edx	#, D.11031
	sub	ecx, eax	#, n.38
	mov	eax, ecx	# D.11033,
	mov	DWORD PTR [rbp-96], eax	# pad, pad.39
	mov	eax, DWORD PTR [rbp-100]	# gridSize.40, gridSize
	mov	edx, 1024	# tmp128,
	mov	ecx, edx	#, tmp128
	sub	ecx, eax	#, gridSize.40
	mov	eax, ecx	# D.11036,
	mov	DWORD PTR [rbp-92], eax	# gridPad, gridPad.41
	lea	rdx, [rbp-92]	# tmp129,
	lea	rax, [rbp-96]	# tmp130,
	mov	rsi, rdx	#, tmp129
	mov	rdi, rax	#, tmp130
	call	_ZSt3maxIiERKT_S2_S2_	#
	mov	eax, DWORD PTR [rax]	# D.11039, *D.11038_22
	cdqe
	lea	rdx, [0+rax*4]	# D.11041,
	lea	rax, [rbp-72]	# tmp131,
	mov	rsi, rdx	#, D.11041
	mov	rdi, rax	#, tmp131
.LEHB3:
	call	cuMemAllocHost_v2	#
	mov	rax, QWORD PTR [rbp-72]	# tmp132, d
	mov	QWORD PTR [rbp-56], rax	# i, tmp132
	jmp	.L56	#
.L57:
	mov	rax, QWORD PTR [rbp-56]	# tmp133, i
	mov	DWORD PTR [rax], 2147483647	# *i_1,
	add	QWORD PTR [rbp-56], 4	# i,
.L56:
	mov	rbx, QWORD PTR [rbp-72]	# d.43, d
	lea	rdx, [rbp-92]	# tmp134,
	lea	rax, [rbp-96]	# tmp135,
	mov	rsi, rdx	#, tmp134
	mov	rdi, rax	#, tmp135
	call	_ZSt3maxIiERKT_S2_S2_	#
	mov	eax, DWORD PTR [rax]	# D.11048, *D.11047_28
	cdqe
	sal	rax, 2	# D.11050,
	add	rax, rbx	# D.11051, d.43
	cmp	rax, QWORD PTR [rbp-56]	# D.11051, i
	seta	al	#, retval.42
	test	al, al	# retval.42
	jne	.L57	#,
	mov	eax, DWORD PTR [rbp-96]	# pad.44, pad
	test	eax, eax	# pad.44
	je	.L58	#,
	mov	eax, DWORD PTR [rbp-96]	# pad.45, pad
	test	eax, eax	# pad.45
	jg	.L59	#,
	mov	ecx, OFFSET FLAT:_ZZL14smallMinDeviceP9CUfunc_styiE19__PRETTY_FUNCTION__	#,
	mov	edx, 214	#,
	mov	esi, OFFSET FLAT:.LC6	#,
	mov	edi, OFFSET FLAT:.LC9	#,
	call	__assert_fail	#
.L59:
	mov	eax, DWORD PTR [rbp-96]	# pad.46, pad
	cdqe
	lea	rdx, [0+rax*4]	# D.11061,
	mov	rax, QWORD PTR [rbp-72]	# d.47, d
	mov	ecx, DWORD PTR [rbp-132]	# tmp136, n
	movsx	rcx, ecx	# D.11063, tmp136
	lea	rsi, [0+rcx*4]	# D.11064,
	mov	rcx, QWORD PTR [rbp-128]	# inputOnDevice.48, inputOnDevice
	add	rcx, rsi	# D.11066, D.11064
	mov	rsi, rax	#, d.47
	mov	rdi, rcx	#, D.11066
	call	cuMemcpyHtoD_v2	#
.L58:
	mov	eax, DWORD PTR [rbp-92]	# gridPad.49, gridPad
	test	eax, eax	# gridPad.49
	jle	.L60	#,
	mov	eax, DWORD PTR [rbp-92]	# gridPad.50, gridPad
	cdqe
	lea	rdx, [0+rax*4]	# D.11073,
	mov	rax, QWORD PTR [rbp-72]	# d.51, d
	mov	ecx, DWORD PTR [rbp-100]	# gridSize.52, gridSize
	mov	ecx, ecx	# D.11076, gridSize.52
	lea	rsi, [0+rcx*4]	# D.11077,
	mov	rcx, QWORD PTR [rbp-80]	# outputOnDevice.53, outputOnDevice
	add	rcx, rsi	# D.11079, D.11077
	mov	rsi, rax	#, d.51
	mov	rdi, rcx	#, D.11079
	call	cuMemcpyHtoD_v2	#
.L60:
	mov	rax, QWORD PTR [rbp-72]	# d.54, d
	mov	rdi, rax	#, d.54
	call	cuMemFreeHost	#
.LEHE3:
	lea	rax, [rbp-128]	# tmp137,
	mov	QWORD PTR [rbp-48], rax	# args, tmp137
	lea	rax, [rbp-80]	# tmp138,
	mov	QWORD PTR [rbp-40], rax	# args, tmp138
	mov	esi, DWORD PTR [rbp-100]	# gridSize.55, gridSize
	mov	rax, QWORD PTR [rbp-120]	# tmp139, helloWorld
	mov	QWORD PTR [rsp+32], 0	#,
	lea	rdx, [rbp-48]	# tmp140,
	mov	QWORD PTR [rsp+24], rdx	#, tmp140
	mov	QWORD PTR [rsp+16], 0	#,
	mov	DWORD PTR [rsp+8], 0	#,
	mov	DWORD PTR [rsp], 1	#,
	mov	r9d, 1	#,
	mov	r8d, 1024	#,
	mov	ecx, 1	#,
	mov	edx, 1	#,
	mov	rdi, rax	#, tmp139
.LEHB4:
	call	cuLaunchKernel	#
	mov	DWORD PTR [rbp-88], eax	# res, D.11102
	cmp	DWORD PTR [rbp-88], 0	# res,
	je	.L61	#,
	mov	edi, OFFSET FLAT:.LC10	#,
	call	puts	#
	mov	edi, 1	#,
	call	exit	#
.L61:
	lea	rax, [rbp-64]	# tmp141,
	mov	esi, 4	#,
	mov	rdi, rax	#, tmp141
	call	cuMemAllocHost_v2	#
	call	cuCtxSynchronize	#
	mov	eax, DWORD PTR [rbp-100]	# gridSize.56, gridSize
	cmp	eax, 1	# gridSize.56,
	jne	.L62	#,
	mov	rcx, QWORD PTR [rbp-80]	# outputOnDevice.57, outputOnDevice
	mov	rax, QWORD PTR [rbp-64]	# result.58, result
	mov	edx, 4	#,
	mov	rsi, rcx	#, outputOnDevice.57
	mov	rdi, rax	#, result.58
	call	cuMemcpyDtoH_v2	#
.LEHE4:
	jmp	.L63	#
.L62:
	lea	rax, [rbp-80]	# tmp142,
	mov	QWORD PTR [rbp-32], rax	# args, tmp142
	lea	rax, [rbp-128]	# tmp143,
	mov	QWORD PTR [rbp-24], rax	# args, tmp143
	mov	rax, QWORD PTR [rbp-120]	# tmp144, helloWorld
	mov	QWORD PTR [rsp+32], 0	#,
	lea	rdx, [rbp-32]	# tmp145,
	mov	QWORD PTR [rsp+24], rdx	#, tmp145
	mov	QWORD PTR [rsp+16], 0	#,
	mov	DWORD PTR [rsp+8], 0	#,
	mov	DWORD PTR [rsp], 1	#,
	mov	r9d, 1	#,
	mov	r8d, 1024	#,
	mov	ecx, 1	#,
	mov	edx, 1	#,
	mov	esi, 1	#,
	mov	rdi, rax	#, tmp144
.LEHB5:
	call	cuLaunchKernel	#
	mov	DWORD PTR [rbp-88], eax	# res, D.11103
	cmp	DWORD PTR [rbp-88], 0	# res,
	je	.L64	#,
	mov	edi, OFFSET FLAT:.LC10	#,
	call	puts	#
	mov	edi, 1	#,
	call	exit	#
.L64:
	call	cuCtxSynchronize	#
	mov	rcx, QWORD PTR [rbp-128]	# inputOnDevice.59, inputOnDevice
	mov	rax, QWORD PTR [rbp-64]	# result.60, result
	mov	edx, 4	#,
	mov	rsi, rcx	#, inputOnDevice.59
	mov	rdi, rax	#, result.60
	call	cuMemcpyDtoH_v2	#
.LEHE5:
.L63:
	mov	rax, QWORD PTR [rbp-64]	# result.61, result
	mov	eax, DWORD PTR [rax]	# tmp146, *result.61_67
	mov	DWORD PTR [rbp-84], eax	# r, tmp146
	mov	rax, QWORD PTR [rbp-128]	# inputOnDevice.62, inputOnDevice
	mov	rdi, rax	#, inputOnDevice.62
.LEHB6:
	call	cuMemFree_v2	#
	mov	rax, QWORD PTR [rbp-80]	# outputOnDevice.63, outputOnDevice
	mov	rdi, rax	#, outputOnDevice.63
	call	cuMemFree_v2	#
	mov	rax, QWORD PTR [rbp-64]	# result.64, result
	mov	rdi, rax	#, result.64
	call	cuMemFreeHost	#
.LEHE6:
	mov	eax, DWORD PTR [rbp-84]	# D.11099, r
	jmp	.L72	#
.L70:
	jmp	.L67	#
.L71:
	jmp	.L67	#
.L69:
.L67:
	mov	rdi, rax	#, D.11313
.LEHB7:
	call	_Unwind_Resume	#
.LEHE7:
.L72:
	add	rsp, 184	#,
	pop	rbx	#
	pop	rbp	#
	.cfi_def_cfa 7, 8
	ret
	.cfi_endproc
.LFE406:
	.section	.gcc_except_table
.LLSDA406:
	.byte	0xff
	.byte	0xff
	.byte	0x1
	.uleb128 .LLSDACSE406-.LLSDACSB406
.LLSDACSB406:
	.uleb128 .LEHB2-.LFB406
	.uleb128 .LEHE2-.LEHB2
	.uleb128 .L69-.LFB406
	.uleb128 0
	.uleb128 .LEHB3-.LFB406
	.uleb128 .LEHE3-.LEHB3
	.uleb128 .L70-.LFB406
	.uleb128 0
	.uleb128 .LEHB4-.LFB406
	.uleb128 .LEHE4-.LEHB4
	.uleb128 .L69-.LFB406
	.uleb128 0
	.uleb128 .LEHB5-.LFB406
	.uleb128 .LEHE5-.LEHB5
	.uleb128 .L71-.LFB406
	.uleb128 0
	.uleb128 .LEHB6-.LFB406
	.uleb128 .LEHE6-.LEHB6
	.uleb128 .L69-.LFB406
	.uleb128 0
	.uleb128 .LEHB7-.LFB406
	.uleb128 .LEHE7-.LEHB7
	.uleb128 0
	.uleb128 0
.LLSDACSE406:
	.text
	.size	_ZL14smallMinDeviceP9CUfunc_styi, .-_ZL14smallMinDeviceP9CUfunc_styi
	.type	_ZL8smallMinP9CUfunc_stPii, @function
_ZL8smallMinP9CUfunc_stPii:
.LFB407:
	.cfi_startproc
	.cfi_personality 0x3,__gxx_personality_v0
	.cfi_lsda 0x3,.LLSDA407
	push	rbp	#
	.cfi_def_cfa_offset 16
	.cfi_offset 6, -16
	mov	rbp, rsp	#,
	.cfi_def_cfa_register 6
	push	rbx	#
	sub	rsp, 184	#,
	.cfi_offset 3, -24
	mov	QWORD PTR [rbp-120], rdi	# helloWorld, helloWorld
	mov	QWORD PTR [rbp-128], rsi	# T, T
	mov	DWORD PTR [rbp-132], edx	# n, n
	mov	DWORD PTR [rbp-112], 1024	# blockSize,
	mov	eax, DWORD PTR [rbp-132]	# n.1, n
	mov	edx, eax	# D.10912, n.1
	shr	edx, 10	# D.10912,
	mov	eax, DWORD PTR [rbp-132]	# n.2, n
	and	eax, 1023	# D.10914,
	test	eax, eax	# D.10914
	setne	al	#, D.10915
	movzx	eax, al	# D.10916, D.10915
	add	eax, edx	# gridSize.3, D.10912
	mov	DWORD PTR [rbp-108], eax	# gridSize, gridSize.3
	mov	eax, DWORD PTR [rbp-108]	# gridSize.4, gridSize
	sal	eax, 10	# D.10919,
	mov	eax, eax	# D.10920, D.10919
	lea	rdx, [0+rax*4]	# D.10921,
	lea	rax, [rbp-88]	# tmp132,
	mov	rsi, rdx	#, D.10921
	mov	rdi, rax	#, tmp132
.LEHB8:
	call	cuMemAlloc_v2	#
	lea	rdx, [rbp-112]	# tmp133,
	lea	rax, [rbp-108]	# tmp134,
	mov	rsi, rdx	#, tmp133
	mov	rdi, rax	#, tmp134
	call	_ZSt3maxIjERKT_S2_S2_	#
	mov	eax, DWORD PTR [rax]	# D.10923, *D.10922_14
	mov	eax, eax	# D.10924, D.10923
	lea	rdx, [0+rax*4]	# D.10925,
	lea	rax, [rbp-80]	# tmp135,
	mov	rsi, rdx	#, D.10925
	mov	rdi, rax	#, tmp135
	call	cuMemAlloc_v2	#
.LEHE8:
	mov	eax, DWORD PTR [rbp-108]	# gridSize.5, gridSize
	mov	edx, eax	# D.10927, gridSize.5
	sal	edx, 10	# D.10927,
	mov	eax, DWORD PTR [rbp-132]	# n.6, n
	mov	ecx, edx	#, D.10927
	sub	ecx, eax	#, n.6
	mov	eax, ecx	# D.10929,
	mov	DWORD PTR [rbp-104], eax	# pad, pad.7
	mov	eax, DWORD PTR [rbp-108]	# gridSize.8, gridSize
	mov	edx, 1024	# tmp136,
	mov	ecx, edx	#, tmp136
	sub	ecx, eax	#, gridSize.8
	mov	eax, ecx	# D.10932,
	mov	DWORD PTR [rbp-100], eax	# gridPad, gridPad.9
	lea	rdx, [rbp-100]	# tmp137,
	lea	rax, [rbp-104]	# tmp138,
	mov	rsi, rdx	#, tmp137
	mov	rdi, rax	#, tmp138
	call	_ZSt3maxIiERKT_S2_S2_	#
	mov	eax, DWORD PTR [rax]	# D.10935, *D.10934_26
	cdqe
	lea	rdx, [0+rax*4]	# D.10937,
	lea	rax, [rbp-72]	# tmp139,
	mov	rsi, rdx	#, D.10937
	mov	rdi, rax	#, tmp139
.LEHB9:
	call	cuMemAllocHost_v2	#
	mov	rax, QWORD PTR [rbp-72]	# tmp140, d
	mov	QWORD PTR [rbp-56], rax	# i, tmp140
	jmp	.L74	#
.L75:
	mov	rax, QWORD PTR [rbp-56]	# tmp141, i
	mov	DWORD PTR [rax], 2147483647	# *i_1,
	add	QWORD PTR [rbp-56], 4	# i,
.L74:
	mov	rbx, QWORD PTR [rbp-72]	# d.11, d
	lea	rdx, [rbp-100]	# tmp142,
	lea	rax, [rbp-104]	# tmp143,
	mov	rsi, rdx	#, tmp142
	mov	rdi, rax	#, tmp143
	call	_ZSt3maxIiERKT_S2_S2_	#
	mov	eax, DWORD PTR [rax]	# D.10944, *D.10943_32
	cdqe
	sal	rax, 2	# D.10946,
	add	rax, rbx	# D.10947, d.11
	cmp	rax, QWORD PTR [rbp-56]	# D.10947, i
	seta	al	#, retval.10
	test	al, al	# retval.10
	jne	.L75	#,
	mov	eax, DWORD PTR [rbp-104]	# pad.12, pad
	test	eax, eax	# pad.12
	je	.L76	#,
	mov	eax, DWORD PTR [rbp-104]	# pad.13, pad
	test	eax, eax	# pad.13
	jg	.L77	#,
	mov	ecx, OFFSET FLAT:_ZZL8smallMinP9CUfunc_stPiiE19__PRETTY_FUNCTION__	#,
	mov	edx, 288	#,
	mov	esi, OFFSET FLAT:.LC6	#,
	mov	edi, OFFSET FLAT:.LC9	#,
	call	__assert_fail	#
.L77:
	mov	eax, DWORD PTR [rbp-104]	# pad.14, pad
	cdqe
	lea	rdx, [0+rax*4]	# D.10957,
	mov	rax, QWORD PTR [rbp-72]	# d.15, d
	mov	ecx, DWORD PTR [rbp-132]	# tmp144, n
	movsx	rcx, ecx	# D.10959, tmp144
	lea	rsi, [0+rcx*4]	# D.10960,
	mov	rcx, QWORD PTR [rbp-88]	# inputOnDevice.16, inputOnDevice
	add	rcx, rsi	# D.10962, D.10960
	mov	rsi, rax	#, d.15
	mov	rdi, rcx	#, D.10962
	call	cuMemcpyHtoD_v2	#
.L76:
	mov	eax, DWORD PTR [rbp-100]	# gridPad.17, gridPad
	test	eax, eax	# gridPad.17
	jle	.L78	#,
	mov	eax, DWORD PTR [rbp-100]	# gridPad.18, gridPad
	cdqe
	lea	rdx, [0+rax*4]	# D.10969,
	mov	rax, QWORD PTR [rbp-72]	# d.19, d
	mov	ecx, DWORD PTR [rbp-108]	# gridSize.20, gridSize
	mov	ecx, ecx	# D.10972, gridSize.20
	lea	rsi, [0+rcx*4]	# D.10973,
	mov	rcx, QWORD PTR [rbp-80]	# outputOnDevice.21, outputOnDevice
	add	rcx, rsi	# D.10975, D.10973
	mov	rsi, rax	#, d.19
	mov	rdi, rcx	#, D.10975
	call	cuMemcpyHtoD_v2	#
.L78:
	mov	rax, QWORD PTR [rbp-72]	# d.22, d
	mov	rdi, rax	#, d.22
	call	cuMemFreeHost	#
.LEHE9:
	mov	eax, DWORD PTR [rbp-132]	# tmp145, n
	cdqe
	lea	rdx, [0+rax*4]	# D.10979,
	mov	rax, QWORD PTR [rbp-88]	# inputOnDevice.23, inputOnDevice
	mov	rcx, QWORD PTR [rbp-128]	# tmp146, T
	mov	rsi, rcx	#, tmp146
	mov	rdi, rax	#, inputOnDevice.23
.LEHB10:
	call	cuMemcpyHtoD_v2	#
	mov	rax, QWORD PTR [rbp-128]	# tmp147, T
	mov	rdi, rax	#, tmp147
	call	cuMemHostUnregister	#
	lea	rax, [rbp-88]	# tmp148,
	mov	QWORD PTR [rbp-48], rax	# args, tmp148
	lea	rax, [rbp-80]	# tmp149,
	mov	QWORD PTR [rbp-40], rax	# args, tmp149
	mov	esi, DWORD PTR [rbp-108]	# gridSize.24, gridSize
	mov	rax, QWORD PTR [rbp-120]	# tmp150, helloWorld
	mov	QWORD PTR [rsp+32], 0	#,
	lea	rdx, [rbp-48]	# tmp151,
	mov	QWORD PTR [rsp+24], rdx	#, tmp151
	mov	QWORD PTR [rsp+16], 0	#,
	mov	DWORD PTR [rsp+8], 0	#,
	mov	DWORD PTR [rsp], 1	#,
	mov	r9d, 1	#,
	mov	r8d, 1024	#,
	mov	ecx, 1	#,
	mov	edx, 1	#,
	mov	rdi, rax	#, tmp150
	call	cuLaunchKernel	#
	mov	DWORD PTR [rbp-96], eax	# res, D.11001
	cmp	DWORD PTR [rbp-96], 0	# res,
	je	.L79	#,
	mov	edi, OFFSET FLAT:.LC10	#,
	call	puts	#
	mov	edi, 1	#,
	call	exit	#
.L79:
	lea	rax, [rbp-64]	# tmp152,
	mov	esi, 4	#,
	mov	rdi, rax	#, tmp152
	call	cuMemAllocHost_v2	#
	call	cuCtxSynchronize	#
	mov	eax, DWORD PTR [rbp-108]	# gridSize.25, gridSize
	cmp	eax, 1	# gridSize.25,
	jne	.L80	#,
	mov	rcx, QWORD PTR [rbp-80]	# outputOnDevice.26, outputOnDevice
	mov	rax, QWORD PTR [rbp-64]	# result.27, result
	mov	edx, 4	#,
	mov	rsi, rcx	#, outputOnDevice.26
	mov	rdi, rax	#, result.27
	call	cuMemcpyDtoH_v2	#
.LEHE10:
	jmp	.L81	#
.L80:
	lea	rax, [rbp-80]	# tmp153,
	mov	QWORD PTR [rbp-32], rax	# args, tmp153
	lea	rax, [rbp-88]	# tmp154,
	mov	QWORD PTR [rbp-24], rax	# args, tmp154
	mov	rax, QWORD PTR [rbp-120]	# tmp155, helloWorld
	mov	QWORD PTR [rsp+32], 0	#,
	lea	rdx, [rbp-32]	# tmp156,
	mov	QWORD PTR [rsp+24], rdx	#, tmp156
	mov	QWORD PTR [rsp+16], 0	#,
	mov	DWORD PTR [rsp+8], 0	#,
	mov	DWORD PTR [rsp], 1	#,
	mov	r9d, 1	#,
	mov	r8d, 1024	#,
	mov	ecx, 1	#,
	mov	edx, 1	#,
	mov	esi, 1	#,
	mov	rdi, rax	#, tmp155
.LEHB11:
	call	cuLaunchKernel	#
	mov	DWORD PTR [rbp-96], eax	# res, D.11002
	cmp	DWORD PTR [rbp-96], 0	# res,
	je	.L82	#,
	mov	edi, OFFSET FLAT:.LC10	#,
	call	puts	#
	mov	edi, 1	#,
	call	exit	#
.L82:
	call	cuCtxSynchronize	#
	mov	rcx, QWORD PTR [rbp-88]	# inputOnDevice.28, inputOnDevice
	mov	rax, QWORD PTR [rbp-64]	# result.29, result
	mov	edx, 4	#,
	mov	rsi, rcx	#, inputOnDevice.28
	mov	rdi, rax	#, result.29
	call	cuMemcpyDtoH_v2	#
.LEHE11:
.L81:
	mov	rax, QWORD PTR [rbp-64]	# result.30, result
	mov	eax, DWORD PTR [rax]	# tmp157, *result.30_75
	mov	DWORD PTR [rbp-92], eax	# r, tmp157
	mov	rax, QWORD PTR [rbp-88]	# inputOnDevice.31, inputOnDevice
	mov	rdi, rax	#, inputOnDevice.31
.LEHB12:
	call	cuMemFree_v2	#
	mov	rax, QWORD PTR [rbp-80]	# outputOnDevice.32, outputOnDevice
	mov	rdi, rax	#, outputOnDevice.32
	call	cuMemFree_v2	#
	mov	rax, QWORD PTR [rbp-64]	# result.33, result
	mov	rdi, rax	#, result.33
	call	cuMemFreeHost	#
.LEHE12:
	mov	eax, DWORD PTR [rbp-92]	# D.10998, r
	jmp	.L90	#
.L88:
	jmp	.L85	#
.L89:
	jmp	.L85	#
.L87:
.L85:
	mov	rdi, rax	#, D.11316
.LEHB13:
	call	_Unwind_Resume	#
.LEHE13:
.L90:
	add	rsp, 184	#,
	pop	rbx	#
	pop	rbp	#
	.cfi_def_cfa 7, 8
	ret
	.cfi_endproc
.LFE407:
	.section	.gcc_except_table
.LLSDA407:
	.byte	0xff
	.byte	0xff
	.byte	0x1
	.uleb128 .LLSDACSE407-.LLSDACSB407
.LLSDACSB407:
	.uleb128 .LEHB8-.LFB407
	.uleb128 .LEHE8-.LEHB8
	.uleb128 .L87-.LFB407
	.uleb128 0
	.uleb128 .LEHB9-.LFB407
	.uleb128 .LEHE9-.LEHB9
	.uleb128 .L88-.LFB407
	.uleb128 0
	.uleb128 .LEHB10-.LFB407
	.uleb128 .LEHE10-.LEHB10
	.uleb128 .L87-.LFB407
	.uleb128 0
	.uleb128 .LEHB11-.LFB407
	.uleb128 .LEHE11-.LEHB11
	.uleb128 .L89-.LFB407
	.uleb128 0
	.uleb128 .LEHB12-.LFB407
	.uleb128 .LEHE12-.LEHB12
	.uleb128 .L87-.LFB407
	.uleb128 0
	.uleb128 .LEHB13-.LFB407
	.uleb128 .LEHE13-.LEHB13
	.uleb128 0
	.uleb128 0
.LLSDACSE407:
	.text
	.size	_ZL8smallMinP9CUfunc_stPii, .-_ZL8smallMinP9CUfunc_stPii
	.section	.rodata
.LC11:
	.string	"No errors"
.LC12:
	.string	"Invalid value"
.LC13:
	.string	"Out of memory"
.LC14:
	.string	"Driver not initialized"
.LC15:
	.string	"Driver deinitialized"
	.align 8
.LC16:
	.string	"No CUDA-capable device available"
.LC17:
	.string	"Invalid device"
.LC18:
	.string	"Invalid kernel image"
.LC19:
	.string	"Invalid context"
.LC20:
	.string	"Context already current"
.LC21:
	.string	"Map failed"
.LC22:
	.string	"Unmap failed"
.LC23:
	.string	"Array is mapped"
.LC24:
	.string	"Already mapped"
.LC25:
	.string	"No binary for GPU"
.LC26:
	.string	"Already acquired"
.LC27:
	.string	"Not mapped"
	.align 8
.LC28:
	.string	"Mapped resource not available for access as an array"
	.align 8
.LC29:
	.string	"Mapped resource not available for access as a pointer"
	.align 8
.LC30:
	.string	"Uncorrectable ECC error detected"
	.align 8
.LC31:
	.string	"CUlimit not supported by device"
.LC32:
	.string	"Invalid source"
.LC33:
	.string	"File not found"
	.align 8
.LC34:
	.string	"Link to a shared object failed to resolve"
	.align 8
.LC35:
	.string	"Shared object initialization failed"
.LC36:
	.string	"Invalid handle"
.LC37:
	.string	"Not found"
.LC38:
	.string	"CUDA not ready"
.LC39:
	.string	"Launch failed"
.LC40:
	.string	"Launch exceeded resources"
.LC41:
	.string	"Launch exceeded timeout"
	.align 8
.LC42:
	.string	"Launch with incompatible texturing"
.LC43:
	.string	"Unknown error"
.LC44:
	.string	"Unknown CUDA error value"
	.text
	.globl	_Z17cuda_error_string14cudaError_enum
	.type	_Z17cuda_error_string14cudaError_enum, @function
_Z17cuda_error_string14cudaError_enum:
.LFB408:
	.cfi_startproc
	push	rbp	#
	.cfi_def_cfa_offset 16
	.cfi_offset 6, -16
	mov	rbp, rsp	#,
	.cfi_def_cfa_register 6
	mov	DWORD PTR [rbp-4], edi	# result, result
	mov	eax, DWORD PTR [rbp-4]	# result.0, result
	cmp	eax, 211	# result.0,
	je	.L109	#,
	cmp	eax, 211	# result.0,
	jg	.L126	#,
	cmp	eax, 200	# result.0,
	je	.L100	#,
	cmp	eax, 200	# result.0,
	jg	.L127	#,
	cmp	eax, 3	# result.0,
	je	.L96	#,
	cmp	eax, 3	# result.0,
	jg	.L128	#,
	cmp	eax, 1	# result.0,
	je	.L94	#,
	cmp	eax, 1	# result.0,
	jg	.L95	#,
	test	eax, eax	# result.0
	je	.L93	#,
	jmp	.L92	#
.L128:
	cmp	eax, 100	# result.0,
	je	.L98	#,
	cmp	eax, 101	# result.0,
	je	.L99	#,
	cmp	eax, 4	# result.0,
	je	.L97	#,
	jmp	.L92	#
.L127:
	cmp	eax, 206	# result.0,
	je	.L104	#,
	cmp	eax, 206	# result.0,
	jg	.L129	#,
	cmp	eax, 202	# result.0,
	je	.L102	#,
	cmp	eax, 202	# result.0,
	jl	.L101	#,
	cmp	eax, 205	# result.0,
	je	.L103	#,
	jmp	.L92	#
.L129:
	cmp	eax, 208	# result.0,
	je	.L106	#,
	cmp	eax, 208	# result.0,
	jl	.L105	#,
	cmp	eax, 209	# result.0,
	je	.L107	#,
	cmp	eax, 210	# result.0,
	je	.L108	#,
	jmp	.L92	#
.L126:
	cmp	eax, 303	# result.0,
	je	.L117	#,
	cmp	eax, 303	# result.0,
	jg	.L130	#,
	cmp	eax, 215	# result.0,
	je	.L113	#,
	cmp	eax, 215	# result.0,
	jg	.L131	#,
	cmp	eax, 213	# result.0,
	je	.L111	#,
	cmp	eax, 213	# result.0,
	jg	.L112	#,
	jmp	.L134	#
.L131:
	cmp	eax, 301	# result.0,
	je	.L115	#,
	cmp	eax, 301	# result.0,
	jg	.L116	#,
	cmp	eax, 300	# result.0,
	je	.L114	#,
	jmp	.L92	#
.L130:
	cmp	eax, 700	# result.0,
	je	.L121	#,
	cmp	eax, 700	# result.0,
	jg	.L132	#,
	cmp	eax, 500	# result.0,
	je	.L119	#,
	cmp	eax, 600	# result.0,
	je	.L120	#,
	cmp	eax, 400	# result.0,
	je	.L118	#,
	jmp	.L92	#
.L132:
	cmp	eax, 702	# result.0,
	je	.L123	#,
	cmp	eax, 702	# result.0,
	jl	.L122	#,
	cmp	eax, 703	# result.0,
	je	.L124	#,
	cmp	eax, 999	# result.0,
	je	.L125	#,
	jmp	.L92	#
.L93:
	mov	eax, OFFSET FLAT:.LC11	# D.10909,
	jmp	.L133	#
.L94:
	mov	eax, OFFSET FLAT:.LC12	# D.10909,
	jmp	.L133	#
.L95:
	mov	eax, OFFSET FLAT:.LC13	# D.10909,
	jmp	.L133	#
.L96:
	mov	eax, OFFSET FLAT:.LC14	# D.10909,
	jmp	.L133	#
.L97:
	mov	eax, OFFSET FLAT:.LC15	# D.10909,
	jmp	.L133	#
.L98:
	mov	eax, OFFSET FLAT:.LC16	# D.10909,
	jmp	.L133	#
.L99:
	mov	eax, OFFSET FLAT:.LC17	# D.10909,
	jmp	.L133	#
.L100:
	mov	eax, OFFSET FLAT:.LC18	# D.10909,
	jmp	.L133	#
.L101:
	mov	eax, OFFSET FLAT:.LC19	# D.10909,
	jmp	.L133	#
.L102:
	mov	eax, OFFSET FLAT:.LC20	# D.10909,
	jmp	.L133	#
.L103:
	mov	eax, OFFSET FLAT:.LC21	# D.10909,
	jmp	.L133	#
.L104:
	mov	eax, OFFSET FLAT:.LC22	# D.10909,
	jmp	.L133	#
.L105:
	mov	eax, OFFSET FLAT:.LC23	# D.10909,
	jmp	.L133	#
.L106:
	mov	eax, OFFSET FLAT:.LC24	# D.10909,
	jmp	.L133	#
.L107:
	mov	eax, OFFSET FLAT:.LC25	# D.10909,
	jmp	.L133	#
.L108:
	mov	eax, OFFSET FLAT:.LC26	# D.10909,
	jmp	.L133	#
.L109:
	mov	eax, OFFSET FLAT:.LC27	# D.10909,
	jmp	.L133	#
.L134:
	mov	eax, OFFSET FLAT:.LC28	# D.10909,
	jmp	.L133	#
.L111:
	mov	eax, OFFSET FLAT:.LC29	# D.10909,
	jmp	.L133	#
.L112:
	mov	eax, OFFSET FLAT:.LC30	# D.10909,
	jmp	.L133	#
.L113:
	mov	eax, OFFSET FLAT:.LC31	# D.10909,
	jmp	.L133	#
.L114:
	mov	eax, OFFSET FLAT:.LC32	# D.10909,
	jmp	.L133	#
.L115:
	mov	eax, OFFSET FLAT:.LC33	# D.10909,
	jmp	.L133	#
.L116:
	mov	eax, OFFSET FLAT:.LC34	# D.10909,
	jmp	.L133	#
.L117:
	mov	eax, OFFSET FLAT:.LC35	# D.10909,
	jmp	.L133	#
.L118:
	mov	eax, OFFSET FLAT:.LC36	# D.10909,
	jmp	.L133	#
.L119:
	mov	eax, OFFSET FLAT:.LC37	# D.10909,
	jmp	.L133	#
.L120:
	mov	eax, OFFSET FLAT:.LC38	# D.10909,
	jmp	.L133	#
.L121:
	mov	eax, OFFSET FLAT:.LC39	# D.10909,
	jmp	.L133	#
.L122:
	mov	eax, OFFSET FLAT:.LC40	# D.10909,
	jmp	.L133	#
.L123:
	mov	eax, OFFSET FLAT:.LC41	# D.10909,
	jmp	.L133	#
.L124:
	mov	eax, OFFSET FLAT:.LC42	# D.10909,
	jmp	.L133	#
.L125:
	mov	eax, OFFSET FLAT:.LC43	# D.10909,
	jmp	.L133	#
.L92:
	mov	eax, OFFSET FLAT:.LC44	# D.10909,
.L133:
	pop	rbp	#
	.cfi_def_cfa 7, 8
	ret
	.cfi_endproc
.LFE408:
	.size	_Z17cuda_error_string14cudaError_enum, .-_Z17cuda_error_string14cudaError_enum
	.section	.text._ZSt3maxIjERKT_S2_S2_,"axG",@progbits,_ZSt3maxIjERKT_S2_S2_,comdat
	.weak	_ZSt3maxIjERKT_S2_S2_
	.type	_ZSt3maxIjERKT_S2_S2_, @function
_ZSt3maxIjERKT_S2_S2_:
.LFB409:
	.cfi_startproc
	push	rbp	#
	.cfi_def_cfa_offset 16
	.cfi_offset 6, -16
	mov	rbp, rsp	#,
	.cfi_def_cfa_register 6
	mov	QWORD PTR [rbp-8], rdi	# __a, __a
	mov	QWORD PTR [rbp-16], rsi	# __b, __b
	mov	rax, QWORD PTR [rbp-8]	# tmp63, __a
	mov	edx, DWORD PTR [rax]	# D.11007, *__a_2(D)
	mov	rax, QWORD PTR [rbp-16]	# tmp64, __b
	mov	eax, DWORD PTR [rax]	# D.11008, *__b_4(D)
	cmp	edx, eax	# D.11007, D.11008
	jae	.L136	#,
	mov	rax, QWORD PTR [rbp-16]	# D.11011, __b
	jmp	.L137	#
.L136:
	mov	rax, QWORD PTR [rbp-8]	# D.11011, __a
.L137:
	pop	rbp	#
	.cfi_def_cfa 7, 8
	ret
	.cfi_endproc
.LFE409:
	.size	_ZSt3maxIjERKT_S2_S2_, .-_ZSt3maxIjERKT_S2_S2_
	.section	.text._ZSt3minIjERKT_S2_S2_,"axG",@progbits,_ZSt3minIjERKT_S2_S2_,comdat
	.weak	_ZSt3minIjERKT_S2_S2_
	.type	_ZSt3minIjERKT_S2_S2_, @function
_ZSt3minIjERKT_S2_S2_:
.LFB410:
	.cfi_startproc
	push	rbp	#
	.cfi_def_cfa_offset 16
	.cfi_offset 6, -16
	mov	rbp, rsp	#,
	.cfi_def_cfa_register 6
	mov	QWORD PTR [rbp-8], rdi	# __a, __a
	mov	QWORD PTR [rbp-16], rsi	# __b, __b
	mov	rax, QWORD PTR [rbp-16]	# tmp63, __b
	mov	edx, DWORD PTR [rax]	# D.11208, *__b_2(D)
	mov	rax, QWORD PTR [rbp-8]	# tmp64, __a
	mov	eax, DWORD PTR [rax]	# D.11209, *__a_4(D)
	cmp	edx, eax	# D.11208, D.11209
	jae	.L139	#,
	mov	rax, QWORD PTR [rbp-16]	# D.11212, __b
	jmp	.L140	#
.L139:
	mov	rax, QWORD PTR [rbp-8]	# D.11212, __a
.L140:
	pop	rbp	#
	.cfi_def_cfa 7, 8
	ret
	.cfi_endproc
.LFE410:
	.size	_ZSt3minIjERKT_S2_S2_, .-_ZSt3minIjERKT_S2_S2_
	.section	.text._ZSt3maxIiERKT_S2_S2_,"axG",@progbits,_ZSt3maxIiERKT_S2_S2_,comdat
	.weak	_ZSt3maxIiERKT_S2_S2_
	.type	_ZSt3maxIiERKT_S2_S2_, @function
_ZSt3maxIiERKT_S2_S2_:
.LFB411:
	.cfi_startproc
	push	rbp	#
	.cfi_def_cfa_offset 16
	.cfi_offset 6, -16
	mov	rbp, rsp	#,
	.cfi_def_cfa_register 6
	mov	QWORD PTR [rbp-8], rdi	# __a, __a
	mov	QWORD PTR [rbp-16], rsi	# __b, __b
	mov	rax, QWORD PTR [rbp-8]	# tmp63, __a
	mov	edx, DWORD PTR [rax]	# D.11013, *__a_2(D)
	mov	rax, QWORD PTR [rbp-16]	# tmp64, __b
	mov	eax, DWORD PTR [rax]	# D.11014, *__b_4(D)
	cmp	edx, eax	# D.11013, D.11014
	jge	.L142	#,
	mov	rax, QWORD PTR [rbp-16]	# D.11017, __b
	jmp	.L143	#
.L142:
	mov	rax, QWORD PTR [rbp-8]	# D.11017, __a
.L143:
	pop	rbp	#
	.cfi_def_cfa 7, 8
	ret
	.cfi_endproc
.LFE411:
	.size	_ZSt3maxIiERKT_S2_S2_, .-_ZSt3maxIiERKT_S2_S2_
	.section	.rodata
	.align 32
	.type	_ZZL8smallMinP9CUfunc_stPiiE19__PRETTY_FUNCTION__, @object
	.size	_ZZL8smallMinP9CUfunc_stPiiE19__PRETTY_FUNCTION__, 36
_ZZL8smallMinP9CUfunc_stPiiE19__PRETTY_FUNCTION__:
	.string	"int smallMin(CUfunction, int*, int)"
	.align 32
	.type	_ZZL14smallMinDeviceP9CUfunc_styiE19__PRETTY_FUNCTION__, @object
	.size	_ZZL14smallMinDeviceP9CUfunc_styiE19__PRETTY_FUNCTION__, 49
_ZZL14smallMinDeviceP9CUfunc_styiE19__PRETTY_FUNCTION__:
	.string	"int smallMinDevice(CUfunction, CUdeviceptr, int)"
	.align 32
	.type	_ZZL12universalMinP9CUfunc_styyjjjjE19__PRETTY_FUNCTION__, @object
	.size	_ZZL12universalMinP9CUfunc_styyjjjjE19__PRETTY_FUNCTION__, 111
_ZZL12universalMinP9CUfunc_styyjjjjE19__PRETTY_FUNCTION__:
	.string	"int universalMin(CUfunction, CUdeviceptr, CUdeviceptr, unsigned int, unsigned int, unsigned int, unsigned int)"
	.ident	"GCC: (Ubuntu/Linaro 4.7.3-2ubuntu4) 4.7.3"
	.section	.note.GNU-stack,"",@progbits
