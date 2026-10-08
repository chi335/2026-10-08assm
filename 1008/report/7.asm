.386
.model flat, stdcall
option casemap:none

INCLUDELIB kernel32.lib

; Win32 API 및 구조체 정의
STD_OUTPUT_HANDLE EQU -11

COORD STRUCT
    X WORD ?
    Y WORD ?
COORD ENDS

SMALL_RECT STRUCT
    Left   WORD ?
    Top    WORD ?
    Right  WORD ?
    Bottom WORD ?
SMALL_RECT ENDS

CONSOLE_SCREEN_BUFFER_INFO STRUCT
    dwSize              COORD <>
    dwCursorPosition    COORD <>
    wAttributes         WORD ?
    srWindow            SMALL_RECT <>
    dwMaximumWindowSize COORD <>
CONSOLE_SCREEN_BUFFER_INFO ENDS

GetStdHandle PROTO stdcall :DWORD
SetConsoleCursorPosition PROTO stdcall :DWORD, :DWORD
GetConsoleScreenBufferInfo PROTO stdcall :DWORD, :PTR CONSOLE_SCREEN_BUFFER_INFO
WriteConsoleA PROTO stdcall :DWORD, :PTR BYTE, :DWORD, :PTR DWORD, :DWORD
GetTickCount  PROTO stdcall
Sleep         PROTO stdcall :DWORD
ExitProcess   PROTO stdcall :DWORD

.data
seed          DWORD 12345678h
hStdOut       DWORD 0
bytesWritten  DWORD 0

maxX          DWORD 80             ; 기본 가로 크기 (열)
maxY          DWORD 25             ; 기본 세로 크기 (행)

dispChar      BYTE 'A'             ; 출력할 단일 문자

csbi          CONSOLE_SCREEN_BUFFER_INFO <>

.code

; -------------------------------------------------------------
; Random32: 난수 생성 내부 함수
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
; RandomRange: 0 ~ (EAX - 1) 범위 난수 생성
; -------------------------------------------------------------
RandomRange PROC
    push ebx
    push ecx
    push edx

    mov ecx, eax                   ; ECX = N
    cmp ecx, 0
    jbe ZeroReturn
    call Random32
    xor edx, edx
    div ecx                        ; EDX = 난수 % N
    mov eax, edx
    jmp Done

ZeroReturn:
    xor eax, eax

Done:
    pop edx
    pop ecx
    pop ebx
    ret
RandomRange ENDP

; -------------------------------------------------------------
; SetCursorPos: 커서 위치 이동 서브루틴
; -------------------------------------------------------------
SetCursorPos PROC x:WORD, y:WORD
    LOCAL pos:DWORD
    mov ax, y
    shl eax, 16
    mov ax, x
    mov pos, eax
    INVOKE SetConsoleCursorPosition, hStdOut, pos
    ret
SetCursorPos ENDP

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

    ; 3. 현재 콘솔 창의 가로/세로 최대 크기 구하기 (GetMaxXY 역할)
    INVOKE GetConsoleScreenBufferInfo, hStdOut, ADDR csbi
    movzx eax, csbi.srWindow.Right
    sub ax, csbi.srWindow.Left
    inc eax
    mov maxX, eax                  ; maxX = 화면 가로 너비 (컬럼 수)

    movzx eax, csbi.srWindow.Bottom
    sub ax, csbi.srWindow.Top
    inc eax
    mov maxY, eax                  ; maxY = 화면 세로 높이 (줄 수)

    ; 4. 100회 루프 실행
    mov ecx, 100

DisplayLoop:
    push ecx                       ; 루프 카운터 보존

    ; 무작위 X 좌표 구하기 (0 ~ maxX-1)
    mov eax, maxX
    call RandomRange
    mov ebx, eax                   ; EBX = X 좌표

    ; 무작위 Y 좌표 구하기 (0 ~ maxY-1)
    mov eax, maxY
    call RandomRange               ; EAX = Y 좌표

    ; 커서를 무작위 좌표 (X, Y)로 이동
    INVOKE SetCursorPos, bx, ax

    ; 문자 'A' 출력
    INVOKE WriteConsoleA, hStdOut, OFFSET dispChar, 1, ADDR bytesWritten, 0

    ; 100ms (0.1초) 지연
    INVOKE Sleep, 100

    pop ecx                        ; 루프 카운터 복원
    dec ecx
    jnz DisplayLoop

    ; 100회 출력 완료 후 맨 아래 줄로 커서 이동 후 종료
    mov ax, WORD PTR [maxY]
    dec ax
    INVOKE SetCursorPos, 0, ax
    INVOKE ExitProcess, 0
main ENDP
END main