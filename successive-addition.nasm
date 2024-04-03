section .data
    prompt1 db "Enter the first number: ", 0
    prompt2 db "Enter the second number: ", 0
    result_msg db "The result is: ", 0

section .bss
    num1 resb 10 ; reserve space for the first number
    num2 resb 10 ; reserve space for the second number
    result resb 10 ; reserve space for the result

section .text
    global _start

_start:
    ; Prompting user to input the first number
    mov eax, 4
    mov ebx, 1
    mov ecx, prompt1
    mov edx, 23 ; length of the prompt message
    int 0x80 ; invoking system call to write

    ; Reading the first number
    mov eax, 3
    mov ebx, 0
    mov ecx, num1
    mov edx, 10 ; reading up to 10 characters
    int 0x80 ; invoking system call to read

    ; Converting string to integer (first number)
    call atoi

    ; Storing the first number in register
    mov ebx, eax

    ; Prompting user to input the second number
    mov eax, 4
    mov ebx, 1
    mov ecx, prompt2
    mov edx, 24 ; length of the prompt message
    int 0x80 ; invoking system call to write

    ; Reading the second number
    mov eax, 3
    mov ebx, 0
    mov ecx, num2
    mov edx, 10 ; reading up to 10 characters
    int 0x80 ; invoking system call to read

    ; Converting string to integer (second number)
    call atoi

    ; Multiplcation using successive addition method
    mov eax, 0 ; clear eax for result accumulation
    mov ecx, ebx ; move the second number to ecx
    mov ebx, eax ; clear ebx for loop counter

multiply_loop:
    add eax, ebx ; add the first number to the result
    inc ebx ; increment loop counter
    loop multiply_loop ; repeat until ecx (second number) becomes zero

    ; Converting result to string
    call itoa

    ; Printing the result
    mov eax, 4
    mov ebx, 1
    mov ecx, result_msg
    mov edx, 15 ; length of the result message
    int 0x80 ; invoking system call to write

    mov eax, 4
    mov ebx, 1
    mov ecx, result
    call strlen
    add eax, ecx ; total length of result including null terminator
    mov edx, eax
    sub edx, 1 ; exclude null terminator from length
    mov eax, 4
    mov ebx, 1
    mov ecx, result
    int 0x80 ; invoking system call to write

exit:
    ; Exit the program
    mov eax, 1
    xor ebx, ebx
    int 0x80

; atoi: Convert ASCII string to integer
; Input: ecx - pointer to string
; Output: eax - integer value
atoi:
    xor eax, eax
atoi_loop:
    movzx edx, byte [ecx] ; Load next byte from string
    test dl, dl ; Check for null terminator
    jz atoi_done
    sub dl, '0' ; Convert ASCII to integer
    imul eax, eax, 10 ; Multiply current value by 10
    add eax, edx ; Add the digit
    inc ecx ; Move to next character
    jmp atoi_loop
atoi_done:
    ret

; itoa: Convert integer to ASCII string
; Input: eax - integer value
; Output: result - ASCII string
itoa:
    mov ebx, 10 ; Base 10
    mov edi, result ; Destination pointer
    xor ecx, ecx ; Clear counter
itoa_loop:
    xor edx, edx ; Clear edx for division
    div ebx ; Divide eax by 10, remainder in edx
    add dl, '0' ; Convert remainder to ASCII
    mov [edi+ecx], dl ; Store ASCII character
    inc ecx ; Increment counter
    test eax, eax ; Check if quotient is zero
    jnz itoa_loop ; If not zero, continue loop
    mov byte [edi+ecx], 0 ; Null-terminate string
    ret

; strlen: Calculate string length
; Input: ecx - pointer to string
; Output: eax - length of string
strlen:
    xor eax, eax ; Clear eax for length calculation
strlen_loop:
    cmp byte [ecx + eax], 0 ; Check for null terminator
    je strlen_done
    inc eax ; Increment length
    jmp strlen_loop
strlen_done:
    ret
