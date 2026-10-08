.386
.model flat, stdcall
option casemap:none

INCLUDELIB kernel32.lib

; Win32 API 선언
STD_OUTPUT_HANDLE EQU -11

GetStdHandle PROTO stdcall :DWORD
WriteConsoleA PROTO stdcall :DWORD, :PTR BYTE, :DWORD, :PTR DWORD, :DWORD
ExitProcess  PROTO stdcall :DWORD

.data
N            EQU 47                  ; 생성할 피보나치 수의 개수 (N = 47)
fibArray     DWORD N DUP(0)          ; 결과가 저장될 32비트 배열

hStdOut      DWORD 0
bytesWritten DWORD 0

msgHeader    BYTE "Fibonacci Series (N = 47):", 0Dh, 0Ah, 0
outBuffer    BYTE 32 DUP(0)
crlfStr      BYTE 0Dh, 0Ah, 0
spaceStr     BYTE " ", 0

.code

; -------------------------------------------------------------
; GenerateFibonacci: N개의 피보나치 수를 배열에 저장
; 입력: ESI = 피보나치 수열을 저장할 배열의 포인터
;       ECX = 생성할 피보나치 수의 개수 N
; -------------------------------------------------------------
GenerateFibonacci PROC
    pushad

    cmp ecx, 0
    jbe Done                       ; N <= 0 이면 종료

    ; 1. 첫 번째 피보나치 수 F(1) = 1 저장
    mov DWORD PTR [esi], 1
    cmp ecx, 1
    je Done                        ; N == 1 이면 종료

    ; 2. 두 번째 피보나치 수 F(2) = 1 저장
    mov DWORD PTR [esi + 4], 1
    cmp ecx, 2
    je Done                        ; N == 2 면 종료

    ; 3. F(3)부터 F(N)까지 계산하는 루프
    sub ecx, 2                     ; 이미 2개를 채웠으므로 (N-2)번 반복
    mov ebx, 1                     ; F(i-2) = 1
    mov edx, 1                     ; F(i-1) = 1
    add esi, 8                     ; 배열 세 번째 위치(index 2)로 이동

FibLoop:
    mov eax, ebx
    add eax, edx                   ; EAX = F(i-2) + F(i-1)
    mov [esi], eax                 ; 배열에 저장

    mov ebx, edx                   ; F(i-2) = F(i-1)
    mov edx, eax                   ; F(i-1) = F(i)

    add esi, 4                     ; 다음 DWORD 위치로 이동
    loop FibLoop

Done:
    popad
    ret
GenerateFibonacci ENDP

; -------------------------------------------------------------
; UIntToString: 무부호 정수(Unsigned)를 문자열로 변환
; (2,971,215,073 처럼 2^31을 넘는 수를 표현하기 위해 Unsigned 처리)
; -------------------------------------------------------------
UIntToString PROC val:DWORD, pOut:PTR BYTE
    pushad
    mov eax, val
    mov edi, pOut
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
UIntToString ENDP

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

    ; 2. 피보나치 생성 서브루틴 호출
    mov esi, OFFSET fibArray       ; 배열 포인터
    mov ecx, N                     ; N = 47
    call GenerateFibonacci

    ; 3. 콘솔 화면에 결과 출력
    INVOKE PrintString, OFFSET msgHeader

    mov esi, OFFSET fibArray
    mov ecx, N

PrintLoop:
    push ecx
    mov eax, [esi]
    
    INVOKE UIntToString, eax, OFFSET outBuffer
    INVOKE PrintString, OFFSET outBuffer
    INVOKE PrintString, OFFSET spaceStr

    add esi, 4
    pop ecx
    loop PrintLoop

    INVOKE PrintString, OFFSET crlfStr

    ; 4. 종료
    INVOKE ExitProcess, 0
main ENDP
END main