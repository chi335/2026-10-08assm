.386
.model flat, stdcall
option casemap:none

INCLUDELIB kernel32.lib

; Win32 API 선언
STD_OUTPUT_HANDLE EQU -11

GetStdHandle PROTO stdcall :DWORD
WriteConsoleA PROTO stdcall :DWORD, :PTR BYTE, :DWORD, :PTR DWORD, :DWORD
GetTickCount  PROTO stdcall
ExitProcess   PROTO stdcall :DWORD

.data
seed         DWORD 12345678h
hStdOut      DWORD 0
bytesWritten DWORD 0

outBuffer    BYTE 32 DUP(0)
spaceStr     BYTE " ", 0
crlfStr      BYTE 0Dh, 0Ah, 0

.code

; -------------------------------------------------------------
; Random32: 0 ~ 2^32-1 범위의 난수를 생성하는 내부 함수
; -------------------------------------------------------------
Random32 PROC
    mov eax, seed
    imul eax, 343FDh
    add eax, 269EC3h
    mov seed, eax
    shr eax, 16
    and eax, 07FFFh
    ret
Random32 ENDP

; -------------------------------------------------------------
; BetterRandomRange: M ~ (N - 1) 범위의 난수를 생성
; 입력: EBX = M (하한값, lower bound)
;       EAX = N (상한값, upper bound)
; 출력: EAX = M ~ (N - 1) 사이의 난수
; -------------------------------------------------------------
BetterRandomRange PROC
    push ebx
    push ecx
    push edx

    ; 1. 범위의 크기(Range Size) 계산: ECX = N - M
    mov ecx, eax
    sub ecx, ebx                   ; ECX = N - M

    ; 2. 0 ~ (N - M - 1) 범위의 난수 생성
    push ebx
    call Random32                  ; EAX에 난수 생성
    xor edx, edx
    div ecx                        ; EDX = EAX % ECX (0 ~ Range-1)
    pop ebx

    ; 3. 하한값 M을 더해서 [M, N-1] 범위로 이동
    add edx, ebx
    mov eax, edx                   ; 최종 결과를 EAX에 저장

    pop edx
    pop ecx
    pop ebx
    ret
BetterRandomRange ENDP

; -------------------------------------------------------------
; IntToString: 정수를 문자열로 변환 (음수 지원)
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
; PrintString: null로 끝나는 문자열 출력
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

    ; 2. 타임스탬프를 이용해 난수 시드(Seed) 초기화
    INVOKE GetTickCount
    mov seed, eax

    ; 3. 50회 루프 설정
    mov ecx, 50

TestLoop:
    push ecx                       ; 루프 카운터 보존

    ; 문제 예시 조건 설정
    mov ebx, -300                  ; Lower bound (M)
    mov eax, 100                   ; Upper bound (N)
    call BetterRandomRange         ; EAX에 -300 ~ 99 사이 난수 생성됨

    ; 결과 변환 및 출력
    INVOKE IntToString, eax, OFFSET outBuffer
    INVOKE PrintString, OFFSET outBuffer
    INVOKE PrintString, OFFSET spaceStr   ; 공백 출력

    pop ecx                        ; 루프 카운터 복원
    dec ecx
    jnz TestLoop

    ; 줄바꿈 후 종료
    INVOKE PrintString, OFFSET crlfStr
    INVOKE ExitProcess, 0
main ENDP
END main