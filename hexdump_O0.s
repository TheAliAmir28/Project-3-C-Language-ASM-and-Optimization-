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
	pushq	%rbp
	.seh_pushreg	%rbp
	movq	%rsp, %rbp
	.seh_setframe	%rbp, 0
	subq	$80, %rsp
	.seh_stackalloc	80
	.seh_endprologue
	movl	%ecx, 16(%rbp)
	movq	%rdx, 24(%rbp)
	call	__main
	movl	$0, -4(%rbp)
	cmpl	$2, 16(%rbp)
	je	.L2
	movq	24(%rbp), %rax
	movq	(%rax), %rax
	movq	%rax, %rdx
	leaq	.LC0(%rip), %rax
	movq	%rax, %rcx
	call	printf
	movl	$1, %eax
	jmp	.L15
.L2:
	movq	24(%rbp), %rax
	addq	$8, %rax
	movq	(%rax), %rax
	leaq	.LC1(%rip), %rdx
	movq	%rax, %rcx
	call	fopen
	movq	%rax, -16(%rbp)
	cmpq	$0, -16(%rbp)
	jne	.L5
	leaq	.LC2(%rip), %rax
	movq	%rax, %rcx
	call	puts
	movl	$1, %eax
	jmp	.L15
.L14:
	movl	-4(%rbp), %eax
	movl	%eax, %edx
	leaq	.LC3(%rip), %rax
	movq	%rax, %rcx
	call	printf
	movl	$0, -8(%rbp)
	jmp	.L6
.L7:
	movl	-8(%rbp), %eax
	cltq
	movzbl	-48(%rbp,%rax), %eax
	movzbl	%al, %eax
	movl	%eax, %edx
	leaq	.LC4(%rip), %rax
	movq	%rax, %rcx
	call	printf
	addl	$1, -8(%rbp)
.L6:
	movq	-24(%rbp), %rax
	cmpl	%eax, -8(%rbp)
	jl	.L7
	movq	-24(%rbp), %rax
	movl	%eax, -8(%rbp)
	jmp	.L8
.L9:
	leaq	.LC5(%rip), %rax
	movq	%rax, %rcx
	call	printf
	addl	$1, -8(%rbp)
.L8:
	cmpl	$15, -8(%rbp)
	jle	.L9
	movl	$124, %ecx
	call	putchar
	movl	$0, -8(%rbp)
	jmp	.L10
.L13:
	movl	-8(%rbp), %eax
	cltq
	movzbl	-48(%rbp,%rax), %eax
	movzbl	%al, %eax
	movl	%eax, %ecx
	movq	__imp_isprint(%rip), %rax
	call	*%rax
	testl	%eax, %eax
	je	.L11
	movl	-8(%rbp), %eax
	cltq
	movzbl	-48(%rbp,%rax), %eax
	movzbl	%al, %eax
	movl	%eax, %ecx
	call	putchar
	jmp	.L12
.L11:
	movl	$46, %ecx
	call	putchar
.L12:
	addl	$1, -8(%rbp)
.L10:
	movq	-24(%rbp), %rax
	cmpl	%eax, -8(%rbp)
	jl	.L13
	leaq	.LC6(%rip), %rax
	movq	%rax, %rcx
	call	puts
	movq	-24(%rbp), %rax
	movl	%eax, %edx
	movl	-4(%rbp), %eax
	addl	%edx, %eax
	movl	%eax, -4(%rbp)
.L5:
	movq	-16(%rbp), %rdx
	leaq	-48(%rbp), %rax
	movq	%rdx, %r9
	movl	$16, %r8d
	movl	$1, %edx
	movq	%rax, %rcx
	call	fread
	movq	%rax, -24(%rbp)
	cmpq	$0, -24(%rbp)
	jne	.L14
	movq	-16(%rbp), %rax
	movq	%rax, %rcx
	call	fclose
	movl	$0, %eax
.L15:
	addq	$80, %rsp
	popq	%rbp
	ret
	.seh_endproc
	.def	__main;	.scl	2;	.type	32;	.endef
	.ident	"GCC: (Rev2, Built by MSYS2 project) 14.2.0"
	.def	printf;	.scl	2;	.type	32;	.endef
	.def	fopen;	.scl	2;	.type	32;	.endef
	.def	puts;	.scl	2;	.type	32;	.endef
	.def	putchar;	.scl	2;	.type	32;	.endef
	.def	fread;	.scl	2;	.type	32;	.endef
	.def	fclose;	.scl	2;	.type	32;	.endef
