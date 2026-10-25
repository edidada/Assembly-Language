; =====================================================================
; CI smoke test for the GitHub Actions build matrix.
;
; This is a tiny, self-contained 16-bit DOS (MASM small-model) program
; that proves the whole toolchain works end-to-end on a runner:
;
;   1. JWasm assembles this file into a runnable DOS .EXE (jwasm -mz)
;   2. DOSBox runs the .EXE
;   3. The program writes a marker file (C:\CI_OK.TXT) and exits
;   4. The CI checks the marker file exists -> "compile AND run" passed
;
; It does not depend on any video/keyboard hardware, so it runs
; headlessly under DOSBox with SDL_VIDEODRIVER=dummy on every OS.
; =====================================================================

assume cs:code, ds:data, ss:stack

data segment
    fname   db  'CI_OK.TXT', 0          ; ASCIZ file name written to C:
    msg     db  'ASSEMBLY_CI_RUN_OK', 13, 10
    mlen    equ $ - msg                 ; length of the message bytes
data ends

stack segment stack
    db 256 dup (?)                      ; default stack for the .EXE
stack ends

code segment
start:
    ; --- set DS to our data segment ---
    mov ax, data
    mov ds, ax

    ; --- INT 21h / 3Ch : create file "CI_OK.TXT" ---
    mov ah, 3ch
    mov cx, 0                           ; normal attribute
    lea dx, fname
    int 21h
    mov bx, ax                          ; save file handle

    ; --- INT 21h / 40h : write the marker string ---
    mov ah, 40h
    mov cx, mlen
    lea dx, msg
    int 21h

    ; --- INT 21h / 3Eh : close the file ---
    mov ah, 3eh
    int 21h

    ; --- INT 21h / 4Ch : terminate with return code 0 ---
    mov ax, 4c00h
    int 21h
code ends

end start
