.386
.model flat, stdcall
option casemap:none

; 윈도우 기본 API 함수 선언 (외부 파일 필요 없음)
STD_OUTPUT_HANDLE EQU -11

GetStdHandle PROTO stdcall :DWORD
SetConsoleTextAttribute PROTO stdcall :DWORD, :WORD
WriteConsoleA PROTO stdcall :DWORD, :PTR BYTE, :DWORD, :PTR DWORD, :DWORD
ExitProcess PROTO stdcall :DWORD

.data
myMessage BYTE "Hello, Assembly Language!", 0Dh, 0Ah
msgLen EQU $ - myMessage            ; 문자열 길이 계산

; 4가지 색상 값 (4: 빨강, 2: 초록, 11: 연한 청록, 14: 노랑)
colorList WORD 4, 2, 11, 14
hStdOut DWORD 0
bytesWritten DWORD 0

.code
main PROC
    ; 1. 콘솔 출력 핸들 가져오기
    INVOKE GetStdHandle, STD_OUTPUT_HANDLE
    mov hStdOut, eax

    mov ecx, 4                      ; 루프 횟수 (4회)
    mov esi, OFFSET colorList       ; 색상 배열 시작 주소

L1:
    push ecx                        ; API 호출 시 ECX가 변할 수 있으므로 백업

    ; 2. 텍스트 색상 변경
    movzx eax, WORD PTR [esi]
    INVOKE SetConsoleTextAttribute, hStdOut, ax

    ; 3. 문자열 출력
    INVOKE WriteConsoleA, hStdOut, OFFSET myMessage, msgLen, ADDR bytesWritten, 0

    add esi, 2                      ; WORD 타입이므로 2바이트 증가
    pop ecx                         ; ECX 복원
    loop L1                         ; 루프 진행

    ; 4. 콘솔 색상 기본값(7: 기본 회색)으로 복구
    INVOKE SetConsoleTextAttribute, hStdOut, 7

    INVOKE ExitProcess, 0
main ENDP
END main