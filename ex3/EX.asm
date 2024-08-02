section .data
    ; Pointers and variables for memory management
    free_list dq memory_start    ; Start with all memory free

    ; Logging messages
    alloc_msg db "Allocating memory...", 10, 0
    free_msg db "Freeing memory...", 10, 0
    error_msg db "Error: Allocation failed.", 10, 0
    init_msg db "Initial memory pool setup:", 10, 0
    block_size_msg db "Block size: ", 0
    done_msg db "Done.", 10, 0
    new_head_msg db "New free list head:", 10, 0

section .bss
    buffer resb 256  ; Buffer for testing allocations
    ; Memory pool
    memory_start resb 1024 * 10  ; 10KB memory pool

section .text
    global main
    extern printf, getchar

main:
    push rbp
    mov rbp, rsp
    sub rsp, 32  ; Shadow space for external calls

    ; Initialize memory management (start with entire pool free)
    mov rax, memory_start
    mov qword [rax], 10240 - 8  ; Store size of free block (10KB - size for storing size)
    mov qword [rax + 8], 0      ; Set the next pointer to NULL

    ; Debug: Print initial memory pool setup
    lea rcx, [rel init_msg]
    call printf
    mov rax, memory_start
    call print_hex              ; Print start address of memory pool
    lea rcx, [rel block_size_msg]
    call printf
    mov rax, [rel memory_start]
    call print_hex              ; Print initial block size

    ; Example: Allocate a block of memory
    lea rcx, [rel alloc_msg]
    call printf
    mov rcx, 128   ; Example size of 128 bytes
    call allocate_memory
    test rax, rax
    jz alloc_error  ; Check if allocation failed

    ; Store something in the allocated memory
    mov byte [rax], 42  ; Example: Store the value 42

    ; Free the memory
    lea rcx, [rel free_msg]
    call printf
    mov rdi, rax
    call free_memory

    ; Log: Done
    lea rcx, [rel done_msg]
    call printf

    ; Wait for user input before exiting
    call getchar

    ; Clean up and exit
    leave
    ret

alloc_error:
    ; Log: Allocation failed
    lea rcx, [rel error_msg]
    call printf

    leave
    ret

; Allocate memory using a simple first-fit strategy
; Input: rcx = size of memory requested
; Output: rax = pointer to allocated memory or 0 if failed
allocate_memory:
    push rbp
    mov rbp, rsp

    sub rsp, 32    ; Allocate shadow space for calls

    ; Preserve the requested size in rsi
    mov rsi, rcx

    ; Add space for storing block size
    add rcx, 8

    ; Traverse the free list to find the first block that fits
    mov rbx, [rel free_list]

.find_block:
    test rbx, rbx
    jz alloc_error_alloc   ; No suitable block found

    ; Get the size of the current block
    mov rdx, [rbx]
    cmp rdx, rcx
    jae allocate_here      ; If block size >= requested size, allocate here

    ; Move to the next block
    mov rbx, [rbx + 8]     ; Get the next block in the list
    jmp .find_block

allocate_here:
    ; Check if the block can be split
    sub rdx, rcx
    cmp rdx, 16            ; If leftover size is too small, don't split
    jl exact_fit

    ; Split the block
    mov rdi, rbx           ; Save current block pointer
    add rdi, rcx           ; Move to where the new block starts
    mov [rdi], rdx         ; Set the size of the new block
    mov rdx, [rbx + 8]
    mov [rdi + 8], rdx     ; Update the next pointer

    ; Update the current block
    mov [rbx], rcx         ; Set size to the requested size
    mov [rbx + 8], rdi     ; Point to the new block

    ; Return the allocated block
    add rbx, 8             ; Move to the user part of the block
    mov rax, rbx
    leave
    ret

exact_fit:
    ; Exact fit, remove block from free list
    mov rdx, [rbx + 8]     ; Get the next block pointer
    mov [rel free_list], rdx   ; Update the free list head

    add rbx, 8             ; Move to the user part of the block
    mov rax, rbx
    leave
    ret

alloc_error_alloc:
    xor rax, rax           ; Return 0 on failure
    leave
    ret

; Free memory and add it back to the free list
; Input: rdi = pointer to memory to be freed
free_memory:
    push rbp
    mov rbp, rsp

    sub rsp, 32            ; Allocate shadow space for calls

    ; Debug: Print the address to be freed
    lea rcx, [rel free_msg]
    call printf
    mov rax, rdi
    call print_hex

    ; Move pointer back to include the size field
    sub rdi, 8

    ; Debug: Print the block size being freed
    lea rcx, [rel block_size_msg]
    call printf
    mov rax, [rdi]
    call print_hex

    ; Add block to the beginning of the free list
    mov rdx, [rel free_list]
    mov [rdi + 8], rdx     ; Set the next pointer to the current free list head
    mov [rel free_list], rdi   ; Update the free list head

    ; Debug: Print the new free list head
    lea rcx, [rel new_head_msg]
    call printf
    mov rax, [rel free_list]
    call print_hex

    leave
    ret

; Function to print a hexadecimal value (RAX) as a string
print_hex:
    push rbp
    mov rbp, rsp
    sub rsp, 32

    ; Use the format specifier "%016llX" to print RAX as a 64-bit hex value
    lea rcx, [rel hex_format]
    mov rdx, rax
    call printf

    leave
    ret

section .data
hex_format db "%016llX", 10, 0
