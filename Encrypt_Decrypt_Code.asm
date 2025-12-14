INCLUDE Irvine32.inc

mWriteLn MACRO text             ; Macro to write string and new line
    mov edx, OFFSET text
    call WriteString
    call Crlf
ENDM

mWrite MACRO text               ; Macro to write string without new line
    mov edx, OFFSET text
    call WriteString
ENDM

mReadInt MACRO minVal, maxVal               ; Macro to read and validate integer input with error message
    LOCAL i_Loop, Valid, s_Error
i_Loop:
    call ReadInt
                                ; ReadInt returns number in EAX; overflow handling kept but ReadInt may not set OF
    jo s_Error
    cmp eax, minVal
    jl s_Error
    cmp eax, maxVal
    jg s_Error
    jmp Valid
s_Error:
    mov edx, OFFSET errorMsg
    call WriteString
    call Crlf
    jmp i_Loop
Valid:
ENDM

.data
    menuTitle BYTE "===== CIPHER ENCRYPTION/DECRYPTION PROGRAM =====", 0
    menuOpt1 BYTE "1. Caesar Cipher", 0
    menuOpt2 BYTE "2. Reverse String Cipher", 0
    menuOpt3 BYTE "3. Bit Rotation Cipher (ROL/ROR)", 0
    menuOpt4 BYTE "4. Exit", 0
    menuPrompt BYTE "Enter your choice (1-4): ", 0

    operationOpt1 BYTE "1. Encrypt", 0
    operationOpt2 BYTE "2. Decrypt", 0
    operationPrompt BYTE "Enter operation (1-2): ", 0

    inputPrompt BYTE "Enter text (max 100 chars): ", 0
    shiftPrompt BYTE "Enter shift value (1-25): ", 0
    rotationPrompt BYTE "Enter rotation count (1-7): ", 0
    resultMsg BYTE "Result: ", 0
    errorMsg BYTE "Invalid input! Please enter a valid number.", 0

    continueMsg BYTE "Do you want to perform another operation?", 0
    continueOpt1 BYTE "1. Yes (Return to Main Menu)", 0
    continueOpt2 BYTE "2. No (Exit Program)", 0
    continuePrompt BYTE "Enter your choice (1-2): ", 0
    exitMsg BYTE "Thank you for using the Cipher Program! Goodbye!", 0

    inputBuffer BYTE 101 DUP(0)
    outputBuffer BYTE 101 DUP(0)
    choice DWORD ?
    operation DWORD ?
    shiftValue DWORD ?
    continueChoice DWORD ?

.code
main PROC
MainLoop:
    call Clrscr                     ; Display menu using macros
    mWriteLn menuTitle
    call Crlf
    mWriteLn menuOpt1
    mWriteLn menuOpt2
    mWriteLn menuOpt3
    mWriteLn menuOpt4
    mWrite menuPrompt

    mReadInt 1, 4               ; Get choice with validation (1-4)
    mov choice, eax

    cmp choice, 1                   ; Processing of choice
    je CaesarCipher
    cmp choice, 2
    je ReverseCipher
    cmp choice, 3
    je BitRotationCipher
    cmp choice, 4
    je ExitProgram

    jmp MainLoop

CaesarCipher:
    call CaesarCipherProc
    call AskContinue
    jmp MainLoop

ReverseCipher:
    call ReverseCipherProc
    call AskContinue
    jmp MainLoop

BitRotationCipher:
    call BitRotationCipherProc
    call AskContinue
    jmp MainLoop

ExitProgram:
    call Crlf
    mWriteLn exitMsg
    call Crlf
    exit
main ENDP

;----------------------------------------------------
; Ask Continue Procedure
;----------------------------------------------------
AskContinue PROC
    call Crlf
    call Crlf
    mWriteLn continueMsg
    mWriteLn continueOpt1
    mWriteLn continueOpt2
    mWrite continuePrompt

    mReadInt 1, 2               ;macro that's tajing choice and checking validation
    mov continueChoice, eax

    cmp continueChoice, 2
    je ExitNow

    ret

ExitNow:
    call Crlf
    mWriteLn exitMsg
    call Crlf
    exit
AskContinue ENDP

;----------------------------------------------------
; Caesar Cipher Procedure (clean, fixed)
;----------------------------------------------------
CaesarCipherProc PROC
    push ebx
    push esi
    push edi

    call Crlf                       ; Get operation (1=Encrypt, 2=Decrypt)
    mWriteLn operationOpt1
    mWriteLn operationOpt2
    mWrite operationPrompt
    mReadInt 1, 2
    mov operation, eax

    call Crlf                       ; Get input text
    mWrite inputPrompt
    mov edx, OFFSET inputBuffer
    mov ecx, 100
    call ReadString                 ; returns length in EAX

    mWrite shiftPrompt              ; Get shift value (1..25)
    mReadInt 1, 25
    mov shiftValue, eax              ; store raw shift in memory

    ; If decrypt, compute positive equivalent: shiftValue = (26 - shift) % 26
    cmp operation, 2
    jne EncryptCaesar
    mov eax, 26
    sub eax, shiftValue
    mov shiftValue, eax

        EncryptCaesar:
            mov edi, OFFSET outputBuffer            ; Clear outputBuffer (101 bytes)
            mov ecx, 101
            mov al, 0
            rep stosb                       ;Repeat Store String Byte

    mov esi, OFFSET inputBuffer
    mov edi, OFFSET outputBuffer

ProcessCaesarLoop:
    mov al, [esi]
    cmp al, 0
    je CaesarDone

    cmp al, 'A'                 ; Check uppercase A..Z
    jb CheckLowerCase
    cmp al, 'Z'
    ja CheckLowerCase

    mov bl, al                          ; Uppercase processing: AL contains letter 'A'..'Z'
    sub bl, 'A'            ; H - A = 72 - 65 = 7
    movzx eax, bl          ; eax = letter index
    mov ebx, shiftValue
    add eax, ebx           ; eax = index + shift
    mov edx, 0 
    mov ecx, 26
    div ecx                ; quotient in eax, remainder in edx
    mov al, dl             ; remainder 0..25
    add al, 'A'
    mov [edi], al
    jmp AdvancePointers

CheckLowerCase:
    cmp al, 'a'         ; Lowercase a..z ?
    jb NotLetter
    cmp al, 'z'
    ja NotLetter

    mov bl, al             ; Lowercase processing
    sub bl, 'a'            ; bl = 0..25
    movzx eax, bl
    mov ebx, shiftValue
    add eax, ebx
    mov edx, 0
    mov ecx, 26
    div ecx
    mov al, dl
    add al, 'a'
    mov [edi], al
    jmp AdvancePointers

NotLetter:
    mov [edi], al          ; copy non-letter as is

AdvancePointers:
    inc esi
    inc edi
    jmp ProcessCaesarLoop

CaesarDone:
    mov byte ptr [edi], 0

    call Crlf               ; Display result
    call Crlf
    mWrite resultMsg
    mov edx, OFFSET outputBuffer
    call WriteString
    call Crlf

    pop edi
    pop esi
    pop ebx
    ret
CaesarCipherProc ENDP

;----------------------------------------------------
; Reverse String Cipher Procedure
;----------------------------------------------------
ReverseCipherProc PROC
    push ebx
    push esi
    push edi

    call Crlf
    mWrite inputPrompt
    mov edx, OFFSET inputBuffer
    mov ecx, 100
    call ReadString
    mov ebx, eax          ; length in EBX

    mov edi, OFFSET outputBuffer            ; Clear outputBuffer
    mov ecx, 101
    mov al, 0
    rep stosb

    mov esi, OFFSET inputBuffer
    mov edi, OFFSET outputBuffer
    add esi, ebx
    dec esi               ; point to last character

ReverseLoop:
    cmp ebx, 0
    je ReverseDone

    mov al, [esi]
    mov [edi], al
    dec esi
    inc edi
    dec ebx
    jmp ReverseLoop

ReverseDone:
    mov byte ptr [edi], 0

    call Crlf
    call Crlf
    mWrite resultMsg
    mov edx, OFFSET outputBuffer
    call WriteString
    call Crlf

    pop edi
    pop esi
    pop ebx
    ret
ReverseCipherProc ENDP

;----------------------------------------------------
; Bit Rotation Cipher Procedure
;----------------------------------------------------
BitRotationCipherProc PROC
    push esi
    push edi

    call Crlf
    mWriteLn operationOpt1
    mWriteLn operationOpt2
    mWrite operationPrompt
    mReadInt 1, 2
    mov operation, eax

    call Crlf
    mWrite inputPrompt
    mov edx, OFFSET inputBuffer
    mov ecx, 100
    call ReadString

    mWrite rotationPrompt
    mReadInt 1, 7
    mov shiftValue, eax

    mov edi, OFFSET outputBuffer            ; Clear outputBuffer
    mov ecx, 101
    mov al, 0
    rep stosb

    mov esi, OFFSET inputBuffer
    mov edi, OFFSET outputBuffer

ProcessBitLoop:
    mov al, [esi]
    cmp al, 0
    je BitDone

    mov cl, byte ptr shiftValue
    cmp operation, 1                ; Check operation: 1=Encrypt(ROL), 2=Decrypt(ROR)
    je DoROL

DoROR:
    ror al, cl
    jmp StoreBit

DoROL:
    rol al, cl

StoreBit:
    mov [edi], al
    inc esi
    inc edi
    jmp ProcessBitLoop

BitDone:
    mov byte ptr [edi], 0

    call Crlf
    call Crlf
    mWrite resultMsg
    mov edx, OFFSET outputBuffer
    call WriteString
    call Crlf

    pop edi
    pop esi
    ret
BitRotationCipherProc ENDP

END main
