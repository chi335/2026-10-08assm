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
seed          DWORD 12345678h
hStdOut       DWORD 0
bytesWritten  DWORD 0

stringBuffer  BYTE 100 DUP(0)     ; 랜덤 문자열을 저장할 배열
crlfStr       BYTE 0Dh, 0Ah, 0    ; 줄바꿈 문자열

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
; 입력: EAX = N
; 출력: EAX = 0 ~ N-1
; -------------------------------------------------------------
RandomRange PROC
    push ebx
    push ecx
    push edx

    mov ecx, eax                   ; ECX = N
    call Random32
    xor edx, edx
    div ecx                        ; EDX = 난수 % N
    mov eax, edx

    pop edx
    pop ecx
    pop ebx
    ret
RandomRange ENDP

; -------------------------------------------------------------
; GenerateRandomString: 길이 L 만큼의 랜덤 대문자 문자열 생성
; 입력: EAX = 길이 L
;       ESI = 문자열을 저장할 버퍼의 포인터
; -------------------------------------------------------------
GenerateRandomString PROC
    pushad

    mov ecx, eax                   ; 루프 카운터 ECX = L
    cmp ecx, 0
    jbe Done                       ; 길이가 0 이하이면 종료

GenerateLoop:
    ; 0 ~ 25 사이의 난수 생성 ('A' ~ 'Z' 총 26개)
    mov eax, 26
    call RandomRange               ; EAX = 0 ~ 25

    add al, 'A'                    ; 'A'(65)를 더해 대문자 ASCII 코드 생성
    mov [esi], al                  ; 버퍼에 저장
    inc esi                        ; 다음 문자 위치로 이동

    loop GenerateLoop

    mov BYTE PTR [esi], 0          ; 문자열 끝에 null 문자(0) 추가

Done:
    popad
    ret
GenerateRandomString ENDP

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

    ; 3. 20회 반복 루프 설정
    mov ecx, 20

MainLoop:
    push ecx                       ; 루프 카운터 보존

    ; 랜덤 문자열 생성 조건 설정
    mov eax, 10                    ; 길이 L = 10 (예시)
    mov esi, OFFSET stringBuffer   ; 버퍼 포인터 전달
    call GenerateRandomString      ; 문자열 생성

    ; 화면에 생성된 문자열 출력 및 줄바꿈
    INVOKE PrintString, OFFSET stringBuffer
    INVOKE PrintString, OFFSET crlfStr

    pop ecx                        ; 루프 카운터 복원
    dec ecx
    jnz MainLoop

    INVOKE ExitProcess, 0
main ENDP
END main