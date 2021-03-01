;****************************************************************************************************************************
;Program name: "Quadratic Calculator".  This program calculate if there exist two roots, one root, or no root in a qudratic *
;equation. This program also validate if the user inputs are valid float number and return error message if invalid inputs  *
;are found.  Copyright (C) 2021 Danny Ng.                                                                                   *
;                                                                                                                           *
;This file is part of the software program "Quadratic Calculator".                                                          *
;Quadratic Calculator is free software: you can redistribute it and/or modify it under the terms of the GNU General Public  *
;License version 3 as published by the Free Software Foundation.                                                            *
;Quadratic Calculator is distributed in the hope that it will be useful, but WITHOUT ANY WARRANTY; without even the implied *
;warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU General Public License for more details.     *
;A copy of the GNU General Public License v3 is available here:  <https:;www.gnu.org/licenses/>.                            *
;****************************************************************************************************************************


;========1=========2=========3=========4=========5=========6=========7=========8=========9=========0=========1=========2=========3**
;
;Author information
;  Author name: Danny Ng
;  Author email: dannyng@csu.fullerton.edu
;
;Program information
;  Program name: Quadratic Calculator
;  Programming languages: Three modules in C++ and one module in X86
;  Date program began: 2021-Feb-28
;  Date of last update: 2021-Feb-28
;  Date of reorganization of comments: 2021-Feb-28
;  Files in this program: second_degree.cpp, quadratic.asm, quadLibrary.cpp, isfloat.cpp
;  Status: In testing phase
;
;This file
;   File name: quadratic.asm
;   Language: X86, 64-bit target machine
;   Syntax: Intel
;   Max page width: 132 columns
;   Assemble: nasm -f elf64 -o quadratic.o quadratic.asm


;===== Begin code area ==============================================================================================================


extern printf
extern atof
extern scanf
extern isfloat
extern show_no_root
extern show_one_root
extern show_two_root
global root

segment .data

welcome db "This program will find the roots of any quadratic equation.",10,0
prompt db "Please enter the three floating point coefficients of a quadratic equation in the order a, b, c separated by the end of line character: ",0
stringformat db "%s %s %s",0
error_invalid_input_message db 10,"Invalid input data detected.  You may run this program again.",10,10,0
error_not_quad_message db 10,"This is not a quadratic equation.  You may run this program again.",10,10,0
output_equation db 10,"Thank you.  The equation is %8.6lfx^2 + %8.6lfx + %8.6lf = 0.0",10,10,0
output_return db "One of these roots will be returned to the caller function.",10,0

segment .bss
segment .text

root:

;Prolog  Back up the GPRs
push rbp
mov rbp, rsp
push rbx
push rcx
push rdx
push rdi
push rsi
push r8
push r9
push r10
push r11
push r12
push r13
push r14
push r15
pushf

; display welcome message
mov rax, 0             ; 0 xmm register used
mov rdi, welcome       ; "This program will find the roots of any quadratic equation."
call printf

; reserve 256 bytes of space for potentially long input string
sub rsp, 256

; display a prompt message to ask for 3 float numbers
mov rax, 0
mov rdi, prompt        ;"Please enter the three floating point coefficients of a quadratic equation in the order a, b, c separated by the end of line character: "
call printf

;===== Begin validation of input =====================================================================================;|
;Block to input 3 floats
mov rax, 0
mov rdi, stringformat
mov rsi, rsp
mov rdx, rsp
add rdx, 8
mov rcx, rsp
add rcx, 16
call scanf

;Block to validate the first set of input
mov rdi, rsp
call isfloat
cmp rax, 0
je error_input

;Block to validate the second set of input
mov rdi, rsp
add rdi, 8
call isfloat
cmp rax, 0
je error_input

;Block to validate the third set of input
mov rdi, rsp
add rdi, 16
call isfloat
cmp rax, 0
je error_input

;Convert the first set of string to float
mov rax, 0
mov rdi, rsp
call atof
movsd xmm10, xmm0          ;Save the first number to xmm10

;Convert the sceond set of string to float
mov rax, 0
mov rdi, rsp
add rdi, 8
call atof
movsd xmm11, xmm0           ;Save the second number to xmm11

;Convert the third set of string to float
mov rax, 0
mov rdi, rsp
add rdi, 16
call atof
movsd xmm12, xmm0           ;Save the third number to xmm12

;Block to validate the equation
pxor xmm0, xmm0             ;zero xmm0
ucomisd xmm10, xmm0
je error_equation

;Output the equation
mov rax, 3
mov rdi, output_equation
movsd xmm0,xmm10
movsd xmm1,xmm11
movsd xmm2,xmm12
call printf

;calculate b^2-4ac and save it to xmm14
movsd xmm14, xmm11          ; xmm14=b
mulsd xmm14, xmm14          ; xmm14=b^2
mov rax, 2                  ; put int 2 to rax
push rax                    ; push that to rsp
cvtsi2sd xmm9, [rsp]        ; covert to floating point and store in xmm9, now we have a 2 in xmm9
pop rax                     ; release rax
movsd xmm13, xmm10          ; xmm13=a
mulsd xmm13, xmm9           ; xmm13=2a
mulsd xmm13, xmm9           ; xmm13=4a
mulsd xmm13, xmm12          ; xmm13=4ac
subsd xmm14, xmm13          ; xmm14=b^2-4ac

;Block to validate b^2-4ac
;if it is <0, show no root
pxor xmm0, xmm0             ; zero xmm0
ucomisd xmm14, xmm0         ; compare b^2-4ac with 0.0
jb no_root

; calculate x1 and save in xmm15
pxor xmm15, xmm15           ; zero xmm15
subsd xmm15, xmm11          ; xmm15=-b
sqrtsd xmm13, xmm14         ; xmm13=sqrt(b^-4ac)
movsd xmm14, xmm15          ; xmm14=-b
addsd xmm15, xmm13          ; xmm15=-b+sqrt(b^-4ac)
divsd xmm15, xmm9           ; xmm15=(-b+sqrt(b^-4ac))/2
divsd xmm15, xmm10          ; xmm15=(-b+sqrt(b^-4ac))/2c
je one_root                 ; jump to one_root if b^2-4ac = 0.0

; calculate x2 and save in xmm14
subsd xmm14, xmm13          ; xmm14=-b-sqrt(b^-4ac)
divsd xmm14, xmm9           ; xmm14=(-b-sqrt(b^-4ac))/2
divsd xmm14, xmm10          ; xmm15=(-b-sqrt(b^-4ac))/2c

; display two roots
mov rax, 2                  ; using 2 xmm registers
movsd xmm0, xmm15           ; x1
movsd xmm1, xmm14           ; x2
call show_two_root

; display return message
mov rax, 0                  ; using 0 xmm registers
mov rdi, output_return      ; "One of these roots will be returned to the caller function."
call printf
movsd xmm0, xmm15
jmp conclusion


one_root:
; display one root
mov rax, 1                  ; using 1 xmm register
movsd xmm0, xmm15           ; x1
call show_one_root

; display return message
mov rax, 0                  ; using 0 xmm register
mov rdi, output_return      ; "One of these roots will be returned to the caller function."
call printf
movsd xmm0, xmm15           ; x1
jmp conclusion

no_root:
mov rax, 0
call show_no_root
pxor xmm0, xmm0             ;zero xmm0
jmp conclusion

error_input:
mov rax,0
mov rdi,error_invalid_input_message
call printf
pxor xmm0, xmm0             ;zero xmm0
jmp conclusion

error_equation:
mov rax, 0
mov rdi, error_not_quad_message
call printf
pxor xmm0, xmm0             ;zero xmm0

conclusion:
add rsp, 256
;Epilogue: restore data to the values held before this function was called.
popf
pop r15
pop r14
pop r13
pop r12
pop r11
pop r10
pop r9
pop r8
pop rsi
pop rdi
pop rdx
pop rcx
pop rbx
pop rbp               ;Restore the base pointer of the stack frame of the caller.
ret

;========================================================================================