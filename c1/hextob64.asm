section .data
    hex_table db '0123456789ABCDEF'
    base64_table db 'ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789+/'

section .bss
    input resb 64         ; buffer for input
    output resb 88        ; buffer for output
    bin_data resb 48      ; buffer for binary data

section .text
    global _start

_start:
    ; Read hex input from stdin
    mov eax, 3            ; syscall: sys_read
    mov ebx, 0            ; stdin
    mov ecx, input        ; buffer
    mov edx, 64           ; bytes to read
    int 0x80

    ; Convert hex to binary
    xor ecx, ecx          ; index for input
    xor edi, edi          ; index for binary data
convert_hex:
    movzx eax, byte [input + ecx]     ; get first character
    call hex_to_bin
    shl eax, 4                      ; shift high nibble
    movzx ebx, byte [input + ecx + 1] ; get second character
    call hex_to_bin
    or al, bl                      ; combine nibbles into one byte
    mov [bin_data + edi], al      ; store the byte in binary data
    inc edi                        ; move to next byte
    add ecx, 2                     ; move to the next hex pair
    cmp ecx, 64                    ; check for maximum input size
    jb convert_hex

    ; Encode to Base64
    xor ecx, ecx                  ; index for binary data
    xor edx, edx                  ; index for Base64 output
base64_encode:
    ; Gather 3 bytes into eax
    movzx eax, byte [bin_data + ecx] ; get first byte
    inc ecx
    shl eax, 8                     ; shift left
    movzx ebx, byte [bin_data + ecx] ; get second byte
    inc ecx
    shl eax, 8                     ; shift left
    movzx ebx, byte [bin_data + ecx] ; get third byte
    ; Now eax contains 3 bytes in the form of a 24-bit value

    ; Encode to 4 Base64 characters
    mov ebx, 0                     ; reset index for base64 output
base64_loop:
    mov edx, eax                   ; get the 24-bit value
    shr edx, 18                    ; get the first 6 bits
    mov dl, [base64_table + edx]  ; get the Base64 character
    mov [output + ebx], dl        ; store it in output
    inc ebx

    shl eax, 6                     ; shift left to get the next 6 bits
    and eax, 0x3FFFFF              ; clear the lower bits
    cmp ebx, 4                     ; if we have 4 chars
    jb base64_loop                 ; repeat until we get 4 chars

    ; Write output to stdout
    mov eax, 4                     ; syscall: sys_write
    mov ebx, 1                     ; stdout
    mov ecx, output                ; buffer
    mov edx, ebx                   ; number of bytes to write (4)
    int 0x80

    ; Exit
    mov eax, 1                     ; syscall: sys_exit
    xor ebx, ebx                   ; return 0
    int 0x80

hex_to_bin:
    ; Convert hex to binary
    cmp al, '0'
    jb .invalid
    cmp al, '9'
    jbe .digit
    sub al, 'A' - 10
    cmp al, 'F'
    jbe .hex
    sub al, 'a' - 10
    cmp al, 'f'
    jbe .hex
.invalid:
    xor eax, eax
    ret
.digit:
    sub al, '0'
.hex:
    ret
