; simple memory allocation program

section .data
    heap_handle dq 0        ; Storage for heap handle
    heap_size equ 1024 * 10 ; Size of heap (10 KB)
    alloc_size equ 256      ; Size of each allocation

    alloc_msg db "Memory allocated at: %p", 10, 0
    free_msg db "Memory freed.", 10, 0
    error_msg db "Heap creation failed.", 10, 0

section .bss
    alloc_ptr resq 1        ; Storage for allocated memory pointer

section .text
    extern printf, HeapCreate, HeapAlloc, HeapFree
    global main

main:
    push rbp
    mov rbp, rsp

    sub rsp, 32             ; Allocate shadow space

    ; Create a heap
    mov rcx, 0              ; No options
    mov rdx, heap_size      ; Initial size of heap
    mov r8, 0               ; Maximum size (0 for default)
    call HeapCreate
    test rax, rax
    jz heap_fail
    mov [rel heap_handle], rax

    ; Allocate memory from the heap
    mov rcx, [rel heap_handle]  ; Heap handle
    mov rdx, 0              ; No flags
    mov r8, alloc_size      ; Size to allocate
    call HeapAlloc
    mov [rel alloc_ptr], rax

    ; Print the allocated memory address
    lea rcx, [rel alloc_msg]
    mov rdx, [rel alloc_ptr]
    call printf

    ; Free the allocated memory
    mov rcx, [rel heap_handle]  ; Heap handle
    mov rdx, 0              ; No flags
    mov r8, [rel alloc_ptr]     ; Memory to free
    call HeapFree

    ; Print success message
    lea rcx, [rel free_msg]
    call printf

    jmp program_end

heap_fail:
    ; Print error message
    lea rcx, [rel error_msg]
    call printf

program_end:
    leave
    ret
