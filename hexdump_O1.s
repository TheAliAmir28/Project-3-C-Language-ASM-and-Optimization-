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
	.text
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
	subq	$56, %rsp
	.seh_stackalloc	56
	.seh_endprologue
	movl	%ecx, %esi
	movq	%rdx, %rbx
	call	__main
	cmpl	$2, %esi
	je	.L2
	movq	(%rbx), %rdx
	leaq	.LC0(%rip), %rcx
	call	printf
	movl	$1, %eax
.L1:
	addq	$56, %rsp
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
	call	fopen
	movq	%rax, %r14
	movl	$0, %r13d
	movq	__imp_isprint(%rip), %r12
	leaq	.LC5(%rip), %rbp
	testq	%rax, %rax
	jne	.L4
	leaq	.LC2(%rip), %rcx
	call	puts
	movl	$1, %eax
	jmp	.L1
.L10:
	movl	$46, %ecx
	call	putchar
.L11:
	addq	$1, %rbx
	cmpq	%rbx, %r15
	je	.L9
.L12:
	movzbl	(%rbx), %esi
	movl	%esi, %ecx
	call	*%r12
	testl	%eax, %eax
	je	.L10
	movl	%esi, %ecx
	call	putchar
	jmp	.L11
.L9:
	leaq	.LC6(%rip), %rcx
	call	puts
	addl	%edi, %r13d
.L4:
	leaq	32(%rsp), %rcx
	movq	%r14, %r9
	movl	$16, %r8d
	movl	$1, %edx
	call	fread
	movq	%rax, %rdi
	testq	%rax, %rax
	je	.L20
	movl	%r13d, %edx
	leaq	.LC3(%rip), %rcx
	call	printf
	testl	%edi, %edi
	jle	.L5
	leaq	32(%rsp), %rbx
	leal	-1(%rdi), %eax
	leaq	33(%rsp,%rax), %r15
	leaq	.LC4(%rip), %rsi
.L6:
	movzbl	(%rbx), %edx
	movq	%rsi, %rcx
	call	printf
	addq	$1, %rbx
	cmpq	%r15, %rbx
	jne	.L6
	cmpl	$15, %edi
	jg	.L7
.L5:
	movl	%edi, %ebx
.L8:
	movq	%rbp, %rcx
	call	printf
	addl	$1, %ebx
	cmpl	$16, %ebx
	jne	.L8
	movl	$124, %ecx
	call	putchar
	testl	%edi, %edi
	jle	.L9
.L14:
	leaq	32(%rsp), %rbx
	leal	-1(%rdi), %eax
	leaq	33(%rsp,%rax), %r15
	jmp	.L12
.L20:
	movq	%r14, %rcx
	call	fclose
	movl	$0, %eax
	jmp	.L1
.L7:
	movl	$124, %ecx
	call	putchar
	jmp	.L14
	.seh_endproc
	.def	__main;	.scl	2;	.type	32;	.endef
	.ident	"GCC: (Rev2, Built by MSYS2 project) 14.2.0"
	.def	printf;	.scl	2;	.type	32;	.endef
	.def	fopen;	.scl	2;	.type	32;	.endef
	.def	puts;	.scl	2;	.type	32;	.endef
	.def	putchar;	.scl	2;	.type	32;	.endef
	.def	fread;	.scl	2;	.type	32;	.endef
	.def	fclose;	.scl	2;	.type	32;	.endef
