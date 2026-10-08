.386
.model flat, stdcall
option casemap:none

INCLUDELIB kernel32.lib

; Win32 API 선언
STD_OUTPUT_HANDLE EQU -11

GetStdHandle PROTO stdcall :DWORD
WriteConsoleA PROTO stdcall :DWORD, :PTR BYTE, :DWORD, :PTR DWORD, :DWORD
ExitProcess PROTO stdcall :DWORD

.data
counter          DWORD 0            ; 재귀 호출 횟수 카운터
hStdOut          DWORD 0
bytesWritten     DWORD 0

msgPrefix        BYTE "Recursive Call Counter Value: ", 0
outBuffer        BYTE 16 DUP(0)
crlfStr          BYTE 0Dh, 0Ah, 0

.code

; -------------------------------------------------------------
; RecursiveProc: LOOP 명령어로 횟수를 제어하는 재귀 서브루틴
; 입력: ECX = 남은 재귀 호출 횟수
; -------------------------------------------------------------
RecursiveProc PROC
    ; 1. 실행 횟수 확인을 위해 카운터 1 증가
    inc counter

    ; 2. LOOP 명령어 사용:
    ;    ECX를 1 감소시키고, ECX != 0 이면 지정된 라벨(Recurse)로 점프.
    ;    ECX == 0 이 되면 점프하지 않고 아래로 내려가 ret으로 탈출.
    loop Recurse
    ret                             ; 재귀 탈출 조건 (ECX가 0이 되었을 때)

Recurse:
    call RecursiveProc              ; 자기 자신을 재귀 호출
    ret
RecursiveProc ENDP

; -------------------------------------------------------------
; IntToString: 정수를 문자열로 변환 서브루틴
; -------------------------------------------------------------
IntToString PROC val:SDWORD, pOut:PTR BYTE
    pushad
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
    popad
    ret
IntToString ENDP

; -------------------------------------------------------------
; PrintString: null로 끝나는 문자열 출력 서브루틴
; -------------------------------------------------------------
PrintString PROC pStr:PTR BYTE
    pushad
    mov esi, pStr
    xor ecx, ecx
CountLoop:
    cmp BYTE PTR [esi + ecx], 0
    je PrintNow
    inc ecx
    jmp CountLoop

PrintNow:
    INVOKE WriteConsoleA, hStdOut, pStr, ecx, ADDR bytesWritten, 0
    popad
    ret
PrintString ENDP

; -------------------------------------------------------------
; 메인 절차 (Main Procedure)
; -------------------------------------------------------------
main PROC
    ; 1. 콘솔 출력 핸들 구하기
    INVOKE GetStdHandle, STD_OUTPUT_HANDLE
    mov hStdOut, eax

    ; 2. 재귀 호출을 실행할 횟수를 ECX에 지정 (예: 10회)
    mov ecx, 10

    ; 3. 재귀 서브루틴 최초 호출
    call RecursiveProc

    ; 4. 최종 누적된 counter 값 출력 (검증용)
    INVOKE PrintString, OFFSET msgPrefix
    INVOKE IntToString, counter, OFFSET outBuffer
    INVOKE PrintString, OFFSET outBuffer
    INVOKE PrintString, OFFSET crlfStr

    ; 5. 종료
    INVOKE ExitProcess, 0
main ENDP
END main