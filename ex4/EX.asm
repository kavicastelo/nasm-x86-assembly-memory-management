; Test with different sizes of arrays to observe how allocation behaves with small vs. large memory blocks.

section .data
    fmt db "Array[%d] = %d", 0x0A, 0x00  ; format string for printing
    hex_format db "%016llX", 10, 0      ; Format strings
    done_msg db "Done.", 10, 0
    error_msg db "Error: Allocation failed.", 10, 0

section .bss
    array resq 1                        ; reserve space for pointer

section .text
    extern malloc, free, printf
    global main

main:
    ; Allocate memory for an array of 10 integers
    mov rdi, 40                         ; 10 integers * 4 bytes (32-bit integers)
    call malloc
    mov [rel array], rax                ; store the allocated memory pointer

    ; Check if allocation was successful
    test rax, rax
    jz allocation_failed

    ; Initialize array elements
    mov rsi, 0                          ; initialize loop counter
    mov rbx, [rel array]                ; load base address of array

init_loop:
    cmp rsi, 10                         ; compare counter with array size
    jge init_done
    mov [rbx + rsi*4], esi              ; store index value at array[rsi]
    inc rsi
    jmp init_loop

init_done:
    ; Print array elements
    mov rsi, 0
    mov rbx, [rel array]

print_loop:
    ; Debug
    mov rax, [rbx + rsi*4]
    call print_hex
    ; Print array element
    cmp rsi, 10
    jge print_done
    mov rcx, fmt                        ; Format string in RCX
    mov rdx, rsi                        ; First argument (index) in RDX
    mov r8, [rbx + rsi*4]               ; Second argument (value) in R8
    mov rax, 0                          ; Clear RAX before calling printf
    call printf
    inc rsi
    jmp print_loop

print_done:
    ; Print done message
    mov rcx, done_msg                   ; Done message in RCX
    call printf

    ; Free the allocated memory
    mov rdi, [rel array]
    call free

    ; Exit the program
    mov rax, 0                          ; return 0
    ret

allocation_failed:
    ; Handle memory allocation failure
    mov rcx, error_msg                  ; Error message in RCX
    call printf
    mov rax, -1
    ret

; Function to print a hexadecimal value (RAX) as a string
print_hex:
    push rbp
    mov rbp, rsp
    sub rsp, 32

    ; Use the format specifier "%016llX" to print RAX as a 64-bit hex value
    mov rcx, hex_format                 ; Format string in RCX
    mov rdx, rax                        ; Value to print in RDX
    call printf

    leave
    ret
