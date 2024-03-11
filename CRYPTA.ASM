;<GITHUB>: khmelnitskiianton
;README: 
;1)In first case my hash was simple, that you can choose password to enter
;2)In second i have checking for only buffer overflow flag 
;  but user have access to stack before overflowing segment!
;  And in it while entering situated address of return from function <enter_pwd>
;  That user can change to jmp to <success>!
;----------------------------------------------------------------------------
.model tiny
.286
.code
org 100h
locals @@
;--------------------------------DEFINE--------------------------------------
CH_END_STR      equ 0024h    ; end char of string '$'
CH_END_PWD      equ 0000h    ; end of pwd NULL
CH_CR           equ 0dh      ; CR - carriage return - control code
CH_LF           equ 0ah      ; LF - line feed       - control code
CH_HT           equ 09h      ; HT - horizontal tab  - control code
SC_ENTER        equ 01ch     ; Scan code of ENTER in kybd
;--------------------------------START---------------------------------------
Start:
        ;Welcome User to write password
        mov dx, offset invitation
        mov ah, 09h
        int 21h ;DOS Fn 21h 09h
        ;------------------------------
        ;Scanning password
        mov si, offset user_buff  ;si - dynamic address of buff
        call enter_pwd
        ;------------------------------
        mov si, offset user_buff  ;set si to start
        call my_hash                    ;counting input hash
        cmp ax, true_hash              ; compare
        jne fail_case
        ;------------------------------
        ;Success
success_case:
        mov dx, offset luck_msg
        mov ah, 09h
        int 21h ;DOS Fn 21h 09h
        jmp end_case
        ;Fail
fail_case:
        mov dx, offset fail_msg
        mov ah, 09h
        int 21h ;DOS Fn 21h 09h
end_case:
        ;End
        mov ax, 4c00h ;DOS Fn 21h 4ch
        int 21h
;------------------------------FUNCTIONS-------------------------------------
;ENTER_PWD
;Function for entering password(for hack special)
;In: si - address of buffer
;Change: buffer
;Locals: 0
;Ret: cx - amount input
enter_pwd proc
        nop
        ;in action
        push bp
        mov bp, sp
        xor cx, cx              ;counter of symbols
@@do_while:
        mov ah, 07h
        int 21h         ;Dos Fn 21h 07h no echo, no check
        cmp al, CH_CR  ;check for ENTER == CR
        je @@end_while
        mov [si], al    ;put everything in var in the end
        inc si       
        je fail_case        ;HIDDEN 300IQ CHECK FOR OVERFLOWING SI
        inc cx
        jmp @@do_while
@@end_while:
        ;close action
        mov sp, bp 
        pop bp
        ret
enter_pwd endp
;----------------------------------------------------------------------------
;MY_HASH
;Hash function for user input
;IN: cx - size of input, si - address of buffer
;Locals: 0
;Ret: ax - hash of user
my_hash proc
        nop
        ;in action
        push bp
        mov bp, sp
        ;cx - amount
        xor ax,ax
@@for_start:    
        ;hashing
        ;summ of askii codes
        mov bx, [si]
        xor bh, bh
        add ax, bx
        inc si
        loop @@for_start
        nop
        ;close action
        mov sp, bp 
        pop bp
        ret
my_hash endp
;------------------------------CONSTANTS-------------------------------------
invitation db 'Hello boy! Im your crypto wallet. Please enter your password in console:', CH_CR, CH_LF, CH_HT, CH_HT, CH_END_STR 
luck_msg   db 'Success!', CH_CR, CH_LF, CH_END_STR 
fail_msg   db 'Fail!', CH_CR, CH_LF, CH_END_STR 
true_hash  dw  202d   
user_buff  db 0
;----------------------------------------------------------------------------
end     Start
