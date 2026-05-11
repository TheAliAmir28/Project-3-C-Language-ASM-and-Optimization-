# GCC Optimization Analysis: hexdump.c
**Author:** Ali Amir  
**Course:** CMSC 313: Computer Organization and Assembly Language


---

## What This Program Does

`hexdump.c` reads a binary file and prints its contents three columns at a time: the byte
offset into the file, sixteen bytes in hex, and the ASCII characters those bytes represent.
Any byte that isn't printable gets shown as a period.

I compiled the same source file three times using `-O0`, `-O1`, and `-O3`, then used
the `-S` flag to dump the assembly each time. The goal was to see what the compiler
actually changes under the hood at each level.

---

## 1. Where Variables Live: Stack vs. Registers

This was the most obvious difference between `-O0` and the other two levels.

At `-O0`, the compiler stores almost everything on the stack. If you look at the assembly,
you'll see a lot of memory addresses like `-4(%rbp)`, `-8(%rbp)`, `-48(%rbp)`. Each one
is a variable from the C code sitting in RAM. Every time the program needs to read or
update a variable, it has to do a memory access:

```asm
; -O0: variables live in stack memory
subq   $80, %rsp           ; reserve 80 bytes on the stack
movl   $0, -4(%rbp)        ; offset = 0
movl   -8(%rbp), %eax      ; load loop counter i from memory
movq   -24(%rbp), %rax     ; load bytesRead from memory
```

At `-O1` and `-O3`, most of those variables get moved into CPU registers instead. Registers
are storage built directly into the processor — there's no memory access involved at all.
You can see this in how the function starts:

```asm
; -O1/-O3: variables kept in registers
movl   %ecx, %esi      ; argc stored in %esi
movq   %rax, %r14      ; file pointer stored in %r14
movl   $0, %r13d       ; offset stored in %r13d
```

Also notice that `-O0` uses `%rbp` as a frame pointer, meaning it always keeps track of
the base of the stack frame. `-O1` and `-O3` drop it entirely — they don't need it once
variables are in registers.

Why does this matter? Registers are faster. A memory load takes multiple cycles; a register
read takes one. When the main loop runs once per 16 bytes of file input, shaving off
redundant memory accesses adds up.

---

## 2. Moving Repeated Work Outside the Loop

Inside the main loop, the program calls `isprint()` on every byte to decide whether to
print it or show a period. `isprint` is an external library function, so the CPU has to
look up its address in memory before it can call it. At `-O0`, that lookup happens on
every single pass through the loop:

```asm
; -O0: address looked up every iteration
movq   __imp_isprint(%rip), %rax
call   *%rax
```

At `-O1` and `-O3`, the compiler notices that the address of `isprint` never changes inside
the loop, so it loads it once before the loop starts and keeps it in a register:

```asm
; -O1: loaded once, reused every time
movq   __imp_isprint(%rip), %r12
...
call   *%r12
```

The same thing happens with the `"   "` padding string. At `-O0`, the assembly computes
the address of that string literal every time it's needed. At `-O1` and `-O3`, the address
gets pre-loaded into a register before the loop and reused from there.

This is called **loop-invariant code motion** — pulling work out of a loop if the result
doesn't change between iterations. It's one of the first things an optimizing compiler
does.

---

## 3. How the Loop Is Structured

At `-O0`, the loop structure maps almost directly to what was written in C. The body runs,
then `fread` is called at the bottom, and a conditional jump decides whether to loop again:

```asm
; -O0: check happens at the bottom
.L14:
    ; ... print hex bytes, print ASCII ...
.L5:
    call   fread
    cmpq   $0, -24(%rbp)
    jne    .L14            ; jump back up if bytes were read
```

At `-O1` and `-O3`, the compiler reorganizes this. The `fread` call moves to the top so
the check happens before the body runs. This is cleaner for the branch predictor — the
CPU hardware that tries to guess which way a branch will go. A predictable loop condition
means fewer wasted cycles from mispredictions.

At `-O3`, the compiler also duplicates the `putchar('|')` call into two places in the code.
This avoids a conditional check that would otherwise add an extra branch every iteration
on full 16-byte rows. It's a small trade: a few extra lines of assembly in exchange for
one fewer decision to make at runtime.

---

## 4. A Shorter Way to Write Zero (O3 only)

At `-O3`, you'll notice this in a couple places:

```asm
xorl   %edx, %edx    ; set edx to 0
xorl   %eax, %eax    ; set eax to 0 (return value)
```

At `-O0` and `-O1`, the same thing is written as:

```asm
movl   $0, %eax
```

XOR-ing a register with itself always produces zero. Modern x86-64 processors have a
special fast path for this exact instruction — they can zero the register without even
waiting for the previous value to be ready, which helps with out-of-order execution.
It's also one byte shorter than loading the constant zero. GCC only applies this at `-O3`
where it's looking for every small gain it can find.

---

## 5. Aligning Loops in Memory (O3 only)

The `-O3` assembly has directives that don't appear in the other two:

```asm
    .p2align 4
    .p2align 3
.L7:
    movzbl  (%r15), %edx
    ...
```

`.p2align 4` tells the assembler to align the next instruction to a 16-byte boundary,
padding with NOPs if needed. CPUs fetch instructions in chunks from the cache — usually
16 or 32 bytes at a time. If a loop starts in the middle of one of those chunks, the
processor might need two fetches just to get the first iteration going.

By aligning the top of each hot loop to a boundary, `-O3` makes sure the entire beginning
of the loop lands in a single fetch. It doesn't change what the program does, it just
helps the CPU run it more smoothly.

---

## 6. A Special Section for Startup Code (O3 only)

Near the top of the `-O3` assembly file, you'll see:

```asm
.section  .text.startup,"x"
```

The other two levels just use `.text` for everything. This directive tells the linker to
place `main` in a separate section reserved for code that only runs once at startup.

The linker can then keep this one-time setup code away from the inner loop code, which
means the frequently-run parts of the program stay grouped together in the instruction
cache. Again, no change to what the program does — just a hint to the hardware about
how to handle the code.

---

## Summary

| What Changed | `-O0` | `-O1` | `-O3` |
|---|:---:|:---:|:---:|
| Variables kept in registers (not stack) | No | Yes | Yes |
| Frame pointer (`%rbp`) removed | No | Yes | Yes |
| `isprint` address loaded once before loop | No | Yes | Yes |
| Padding string address loaded once before loop | No | Yes | Yes |
| Loop structure reorganized | No | Yes | Yes |
| `xorl` used to zero registers | No | No | Yes |
| Loop alignment directives (`.p2align`) | No | No | Yes |
| Startup code placed in `.text.startup` | No | No | Yes |

The biggest jump is from `-O0` to `-O1`. Getting variables off the stack and into registers
cuts out a lot of memory traffic, and hoisting the `isprint` lookup out of the loop removes
a redundant load on every single byte the program processes.

The `-O3` additions are more subtle. Things like loop alignment and the XOR-zero idiom are
micro-architectural tricks that target how the CPU pipeline works. Whether they actually
make this program run noticeably faster is another question — most of the time here is
spent waiting on `fread` and `printf` to do I/O, not on the CPU arithmetic. But the
compiler applies these optimizations anyway because it doesn't know ahead of time what
the bottleneck will be.
