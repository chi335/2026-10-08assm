.386
.model flat, stdcall
option casemap:none

STD_OUTPUT_HANDLE EQU -11

GetStdHandle PROTO stdcall :DWORD
WriteConsoleA PROTO stdcall :DWORD, :PTR BYTE, :DWORD, :PTR DWORD, :DWORD
ExitProcess PROTO stdcall :DWORD

.data
start DWORD 1

; 문제 조건: chars는 BYTE 타입, links는 DWORD 타입
chars BYTE 'H', 'A', 'C', 'E', 'B', 'D', 'F', 'G'
links DWORD 0, 4, 5, 6, 2, 3, 7, 0

ARRAY_SIZE EQU 8

; 결과를 저장할 target 배열 (줄바꿈 포함)
target BYTE ARRAY_SIZE DUP(0), 0Dh, 0Ah
bytesWritten DWORD 0
hStdOut DWORD 0

.code
main PROC
    INVOKE GetStdHandle, STD_OUTPUT_HANDLE
    mov hStdOut, eax

    mov esi, start                  ; ESI = 시작 인덱스 (1)
    mov edi, OFFSET target          ; EDI = 저장할 target 배열의 주소
    mov ecx, ARRAY_SIZE             ; ECX = 루프 횟수 (8)

L1:
    ; 1. chars[esi] 문자를 읽어 target[edi]에 복사
    mov al, chars[esi]
    mov [edi], al
    inc edi

    ; 2. links 배열을 통해 다음 인덱스로 이동 (DWORD이므로 *4)
    mov esi, links[esi * 4]

    loop L1

    ; 3. 콘솔 화면 출력
    INVOKE WriteConsoleA, hStdOut, OFFSET target, ARRAY_SIZE + 2, ADDR bytesWritten, 0
    INVOKE ExitProcess, 0
main ENDP
END main