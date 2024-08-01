# Simple Memory Allocation in Assembly

This project demonstrates how to `allocate` and `free` memory in assembly using the C runtime's malloc and free
functions. It also includes basic logging for each step to help understand the process.

## Table of Contents

[Overview](#overview)
[Code Explanation](#code-explanation)
[Debugging Steps](#debugging-steps)
[How to Run](#how-to-run)
[References](#references)

## Overview

In this example, we allocate 256 bytes of memory, store a value in the allocated memory, and then free the memory.
Throughout the process, we use `printf` to log each step, ensuring that the allocation and deallocation are working as
expected.

## Code Explanation

Here's a breakdown of the code:

```asm
section .data
    alloc_msg db "Allocating memory...", 10, 0
    free_msg db "Freeing memory...", 10, 0
    done_msg db "Done.", 10, 0
    free_error_msg db "Error: Freeing memory failed or crashed.", 10, 0

section .text
    global main
    extern printf, malloc, free, getchar

main:
    push rbp
    mov rbp, rsp

    ; Log: Allocating memory
    lea rcx, [rel alloc_msg]
    call printf

    ; Allocate memory
    mov rcx, 256   ; Size in bytes
    call malloc
    test rax, rax
    jz alloc_error ; Jump if allocation failed

    ; Log: Memory allocated successfully
    lea rcx, [rel done_msg]
    call printf

    ; Log: Freeing memory
    lea rcx, [rel free_msg]
    call printf

    ; Free the allocated memory
    mov rcx, rax
    call free

    ; Log: Done (after freeing memory)
    lea rcx, [rel done_msg]
    call printf

    ; Wait for user input before exiting
    call getchar

    ; Clean up and exit
    leave
    ret

alloc_error:
    ; Log: Allocation failed
    lea rcx, [rel free_error_msg]
    call printf

    leave
    ret
```

## Key Points:

- **Memory Allocation:** Memory is allocated using the `malloc` function, with the size specified in `rcx`.
- **Memory Freeing:** The allocated memory is freed using the `free` function.
- **Logging:** Throughout the program, messages are printed to indicate the progress of the allocation and deallocation.
- **Error Handling:** The program checks if malloc or free fails and handles errors by printing appropriate messages.

## Debugging Steps

Here are the debugging steps followed to ensure the program worked correctly:

1. Initial Setup:
    - Verified that the basic structure of the program was correct, with proper stack management (`rbp` and `rsp`
      setup).
    - Added logging to track the progress of the program.
2. Identifying Issues:
    - Initially, the program crashed before completing, so the issue was isolated by checking the `free` function call.
    - Commented out `free` to see if the crash was related to memory deallocation.
3. Step-by-Step Debugging:
    - Simplified the code by focusing only on the allocation and logging.
    - Introduced a dummy free function to test if the issue was with the free call.
4. Final Fix:
    - Correctly handled the `free` call and ensured that the stack was properly managed throughout the program.
    - Added a `getchar` call to prevent the program from closing immediately, helping to confirm the program's behavior.

## How to Run
### Requirements
- **NASM:** The Netwide Assembler, for assembling the assembly code.
- **GCC:** The GNU Compiler Collection, for linking the object file with the C runtime.

### Steps
1. Assemble the Code:
   ```shell
    nasm -f win64 EX.asm -o EX.o
   ```
2. Link the Object File:
   ```shell
    gcc -m64 -o EX EX.o -lkernel32 -lmsvcrt
   ```
3. Run the Program:
   ```shell
    ./EX.exe
   ```
   
## References
- [C Runtime: malloc and free](https://en.cppreference.com/w/c/memory/malloc)
- [C Runtime: free](https://en.cppreference.com/w/c/memory/free)
