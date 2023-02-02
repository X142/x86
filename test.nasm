bits 64
default rel

global _start

%define COUNT 1_000_000_000

section .text
align 4096
_start:
    mov rcx, COUNT
    loop:
        sub rcx, 1
        jne loop

exit:
    xor edi,edi
    mov eax,231
    syscall

section .data
align 4096
data:
    DQ 0

section .bss
; align 2*0x1_000_000
align 4096
bssdata:
    resb 8
