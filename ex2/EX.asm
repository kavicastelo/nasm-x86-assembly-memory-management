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

    ; Test with dummy free or actual free
    ; mov rcx, rax
    ; call dummy_free

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
