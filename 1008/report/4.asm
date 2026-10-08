.386
.model flat, stdcall
option casemap:none

INCLUDELIB kernel32.lib

; Win32 API 선언
STD_INPUT_HANDLE  EQU -10
STD_OUTPUT_HANDLE EQU -11

GetStdHandle PROTO stdcall :DWORD
SetConsoleCursorPosition PROTO stdcall :DWORD, :DWORD
FillConsoleOutputCharacterA PROTO stdcall :DWORD, :BYTE, :DWORD, :DWORD, :PTR DWORD
WriteConsoleA PROTO stdcall :DWORD, :PTR BYTE, :DWORD, :PTR DWORD, :DWORD
ReadConsoleA PROTO stdcall :DWORD, :PTR BYTE, :DWORD, :PTR DWORD, :DWORD
ExitProcess PROTO stdcall :DWORD

.data
prompt1          BYTE "Enter the first integer: "
prompt1Len       EQU $ - prompt1

prompt2          BYTE "Enter the second integer: "
prompt2Len       EQU $ - prompt2

resultHeader     BYTE "The sum is: "
resultHeaderLen  EQU $ - resultHeader

crlf             BYTE 0Dh, 0Ah
crlfLen          EQU 2

loopCount        DWORD 3              ; 3회 반복
num1             DWORD 0
num2             DWORD 0
hStdOut          DWORD 0
hStdIn           DWORD 0
bytesWritten     DWORD 0
bytesRead        DWORD 0

inBuffer         BYTE 32 DUP(0)
outBuffer        BYTE 16 DUP(0)

.code

; 커서 위치 이동 서브루틴
SetCursorPos PROC x:WORD, y:WORD
    LOCAL pos:DWORD
    mov ax, y
    shl eax, 16
    mov ax, x
    mov pos, eax
    INVOKE SetConsoleCursorPosition, hStdOut, pos
    ret
SetCursorPos ENDP

; 입력받은 문자열을 정수(int)로 변환
StringToInt PROC pStr:PTR BYTE
    mov esi, pStr
    xor eax, eax
    xor ebx, ebx

    mov cl, [esi]
    cmp cl, '-'
    jne ConvertLoop
    inc ebx
    inc esi

ConvertLoop:
    movzx ecx, BYTE PTR [esi]
    cmp cl, '0'
    jb Done
    cmp cl, '9'
    ja Done

    sub cl, '0'
    imul eax, 10
    add eax, ecx
    inc esi
    jmp ConvertLoop

Done:
    cmp ebx, 1
    jne ExitProc
    neg eax

ExitProc:
    ret
StringToInt ENDP

; 정수를 출력용 문자열로 변환
IntToString PROC val:SDWORD, pOut:PTR BYTE
    mov eax, val
    mov edi, pOut

    cmp eax, 0
    jge Positive
    mov BYTE PTR [edi], '-'
    inc edi
    neg eax

Positive:
    mov ebx, 10
    xor ecx, ecx

PushDigits:
    xor edx, edx
    div ebx
    add dl, '0'
    push dx
    inc ecx
    cmp eax, 0
    jne PushDigits

PopDigits:
    pop dx
    mov [edi], dl
    inc edi
    loop PopDigits

    mov BYTE PTR [edi], 0
    ret
IntToString ENDP

main PROC
    ; 핸들 구하기
    INVOKE GetStdHandle, STD_OUTPUT_HANDLE
    mov hStdOut, eax
    INVOKE GetStdHandle, STD_INPUT_HANDLE
    mov hStdIn, eax

MainLoop:
    ; 1. 매 루프마다 화면 전체 지우기 (80열x25행 = 2000칸)
    INVOKE SetCursorPos, 0, 0
    INVOKE FillConsoleOutputCharacterA, hStdOut, ' ', 2000, 0, ADDR bytesWritten

    ; 2. 첫 번째 정수 입력 (30열, 12행)
    INVOKE SetCursorPos, 30, 12
    INVOKE WriteConsoleA, hStdOut, OFFSET prompt1, prompt1Len, ADDR bytesWritten, 0
    INVOKE ReadConsoleA, hStdIn, OFFSET inBuffer, 32, ADDR bytesRead, 0
    INVOKE StringToInt, OFFSET inBuffer
    mov num1, eax

    ; 3. 두 번째 정수 입력 (30열, 13행)
    INVOKE SetCursorPos, 30, 13
    INVOKE WriteConsoleA, hStdOut, OFFSET prompt2, prompt2Len, ADDR bytesWritten, 0
    INVOKE ReadConsoleA, hStdIn, OFFSET inBuffer, 32, ADDR bytesRead, 0
    INVOKE StringToInt, OFFSET inBuffer
    mov num2, eax

    ; 4. 두 정수의 합 계산
    mov eax, num1
    add eax, num2

    ; 5. 정수를 문자열로 변환
    INVOKE IntToString, eax, OFFSET outBuffer

    ; 6. 결과 출력 (30열, 14행)
    INVOKE SetCursorPos, 30, 14
    INVOKE WriteConsoleA, hStdOut, OFFSET resultHeader, resultHeaderLen, ADDR bytesWritten, 0

    ; 숫자 길이 계산
    mov esi, OFFSET outBuffer
    xor ecx, ecx
CountLen:
    cmp BYTE PTR [esi + ecx], 0
    je PrintNum
    inc ecx
    jmp CountLen

PrintNum:
    ; 숫자 출력
    INVOKE WriteConsoleA, hStdOut, OFFSET outBuffer, ecx, ADDR bytesWritten, 0
    INVOKE WriteConsoleA, hStdOut, OFFSET crlf, crlfLen, ADDR bytesWritten, 0

    ; 7. 다음 루프로 넘어가기 전 Enter 키 대기
    INVOKE ReadConsoleA, hStdIn, OFFSET inBuffer, 32, ADDR bytesRead, 0

    ; 8. 루프 카운트 감소 및 반복 체크
    dec loopCount
    cmp loopCount, 0
    jne MainLoop

    INVOKE ExitProcess, 0
main ENDP
END main