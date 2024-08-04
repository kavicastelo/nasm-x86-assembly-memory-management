section .data
    cmd_line db "C:\Windows\System32\notepad.exe", 0
    create_process_msg db "Creating process...", 13, 10, 0
    process_done_msg db "Process completed with exit code: %d", 13, 10, 0
    error_msg db "Error: Could not create process.", 13, 10, 0
    error_code_msg db "Error Code: %d", 13, 10, 0

section .bss
    sin resb 68                     ; STARTUPINFO structure (size 68 bytes)
    pi resb 24                      ; PROCESS_INFORMATION structure (size 24 bytes)
    exit_code resd 1                ; to store the process exit code

section .text
    extern CreateProcessA, WaitForSingleObject, GetExitCodeProcess, printf, ExitProcess, CloseHandle, GetLastError, getchar
    global main

main:
    sub rsp, 88                     ; Shadow space + 6 args + alignment

    ; Zero out the STARTUPINFO and PROCESS_INFORMATION structures
    lea rdi, [rel sin]
    mov rcx, 68
    xor rax, rax
    rep stosb

    lea rdi, [rel pi]
    mov rcx, 24
    rep stosb

    ; Set the cb member to the size of the structure
    mov dword [rel sin], 68             ; STARTUPINFO.cb = 68

    ; Print message for creating the process
    lea rcx, [rel create_process_msg]
    call printf

    ; Call CreateProcessA
    xor ecx, ecx                    ; lpApplicationName (NULL)
    lea rdx, [rel cmd_line]             ; lpCommandLine
    xor r8, r8                      ; lpProcessAttributes (NULL)
    xor r9, r9                      ; lpThreadAttributes (NULL)

    mov dword [rsp + 32], 1         ; bInheritHandles = TRUE
    mov [rsp + 40], ecx             ; dwCreationFlags = 0
    mov [rsp + 48], ecx             ; lpEnvironment
    mov [rsp + 56], ecx             ; lpCurrentDirectory
    lea rax, [rel sin]
    mov [rsp + 64], rax             ; lpStartupInfo
    lea rax, [rel pi]
    mov [rsp + 72], rax             ; lpProcessInformation
    call CreateProcessA

    ; Check if process creation was successful
    test rax, rax
    jz process_creation_failed

    ; Wait for the process to complete
    mov rcx, [rel pi]                   ; pi.hProcess
    mov rdx, -1                     ; INFINITE timeout
    call WaitForSingleObject

    ; Get the exit code of the process
    mov rcx, [rel pi]                   ; pi.hProcess
    lea rdx, [rel exit_code]            ; lpExitCode
    call GetExitCodeProcess

    ; Print the exit code
    lea rcx, [rel process_done_msg]
    mov edx, [rel exit_code]
    call printf

    ; Close process and thread handles
    mov rcx, [rel pi]                   ; pi.hProcess
    call CloseHandle
    mov rcx, [rel pi + 8]               ; pi.hThread
    call CloseHandle

    call getchar

    ; Exit the program
    xor ecx, ecx
    call ExitProcess

process_creation_failed:
    ; Print error message
    lea rcx, [rel error_msg]
    call printf

    ; Get and print the error code
    call GetLastError
    mov edx, eax
    lea rcx, [rel error_code_msg]
    call printf

    call getchar

    ; Exit with error code
    mov ecx, 1
    call ExitProcess
