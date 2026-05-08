	.file	"hexdump.c"
	.text
	.section .rdata,"dr"
.LC0:
	.ascii "Usage: %s <filename>\12\0"
.LC1:
	.ascii "rb\0"
.LC2:
	.ascii "Error: could not open file.\0"
.LC3:
	.ascii "%08x \0"
.LC4:
	.ascii "%02x \0"
.LC5:
	.ascii "   \0"
.LC6:
	.ascii "|\0"
	.section	.text.startup,"x"
	.p2align 4
	.globl	main
	.def	main;	.scl	2;	.type	32;	.endef
	.seh_proc	main
main:
	pushq	%r15
	.seh_pushreg	%r15
	pushq	%r14
	.seh_pushreg	%r14
	pushq	%r13
	.seh_pushreg	%r13
	pushq	%r12
	.seh_pushreg	%r12
	pushq	%rbp
	.seh_pushreg	%rbp
	pushq	%rdi
	.seh_pushreg	%rdi
	pushq	%rsi
	.seh_pushreg	%rsi
	pushq	%rbx
	.seh_pushreg	%rbx
	subq	$72, %rsp
	.seh_stackalloc	72
	.seh_endprologue
	movl	%ecx, %esi
	movq	%rdx, %rbx
	call	__main
	cmpl	$2, %esi
	je	.L2
	movq	(%rbx), %rdx
	leaq	.LC0(%rip), %rcx
	call	printf
.L3:
	movl	$1, %eax
.L1:
	addq	$72, %rsp
	popq	%rbx
	popq	%rsi
	popq	%rdi
	popq	%rbp
	popq	%r12
	popq	%r13
	popq	%r14
	popq	%r15
	ret
.L2:
	movq	8(%rbx), %rcx
	leaq	.LC1(%rip), %rdx
	leaq	48(%rsp), %rsi
	leaq	.LC5(%rip), %r13
	call	fopen
	xorl	%edx, %edx
	movq	__imp_isprint(%rip), %r14
	movq	%rax, 40(%rsp)
	movl	%edx, 36(%rsp)
	testq	%rax, %rax
	je	.L27
	.p2align 4
	.p2align 3
.L4:
	movq	40(%rsp), %r9
	movl	$16, %r8d
	movl	$1, %edx
	movq	%rsi, %rcx
	call	fread
	movq	%rax, %rbx
	testq	%rax, %rax
	je	.L28
	movl	36(%rsp), %edx
	leaq	.LC3(%rip), %rcx
	movl	%ebx, %edi
	call	printf
	testl	%ebx, %ebx
	jle	.L6
	leal	-1(%rbx), %eax
	movq	%rsi, %r15
	leaq	.LC4(%rip), %rbp
	leaq	49(%rsp,%rax), %r12
	.p2align 4
	.p2align 3
.L7:
	movzbl	(%r15), %edx
	movq	%rbp, %rcx
	addq	$1, %r15
	call	printf
	cmpq	%r12, %r15
	jne	.L7
	cmpl	$16, %ebx
	je	.L29
.L6:
	movl	%ebx, %ebp
	.p2align 4
	.p2align 3
.L9:
	movq	%r13, %rcx
	addl	$1, %ebp
	call	printf
	cmpl	$16, %ebp
	jne	.L9
	movl	$124, %ecx
	call	putchar
	testl	%ebx, %ebx
	jle	.L13
.L12:
	xorl	%ebp, %ebp
	jmp	.L16
	.p2align 4,,10
	.p2align 3
.L30:
	movl	%r12d, %ecx
	addq	$1, %rbp
	call	putchar
	cmpl	%ebp, %edi
	jle	.L13
.L16:
	movzbl	(%rsi,%rbp), %r12d
	movl	%r12d, %ecx
	call	*%r14
	testl	%eax, %eax
	jne	.L30
	movl	$46, %ecx
	addq	$1, %rbp
	call	putchar
	cmpl	%ebp, %edi
	jg	.L16
.L13:
	leaq	.LC6(%rip), %rcx
	call	puts
	addl	%ebx, 36(%rsp)
	jmp	.L4
.L29:
	movl	$124, %ecx
	call	putchar
	jmp	.L12
.L28:
	movq	40(%rsp), %rcx
	call	fclose
	xorl	%eax, %eax
	jmp	.L1
.L27:
	leaq	.LC2(%rip), %rcx
	call	puts
	jmp	.L3
	.seh_endproc
	.def	__main;	.scl	2;	.type	32;	.endef
	.ident	"GCC: (Rev2, Built by MSYS2 project) 14.2.0"
	.def	printf;	.scl	2;	.type	32;	.endef
	.def	fopen;	.scl	2;	.type	32;	.endef
	.def	fread;	.scl	2;	.type	32;	.endef
	.def	putchar;	.scl	2;	.type	32;	.endef
	.def	puts;	.scl	2;	.type	32;	.endef
	.def	fclose;	.scl	2;	.type	32;	.endef
