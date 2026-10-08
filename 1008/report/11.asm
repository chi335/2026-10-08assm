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
N            EQU 50                  ; 배열 크기 N = 50
byteArray    BYTE N DUP(0)           ; 크기 50인 바이트 배열 (0으로 초기화)

hStdOut      DWORD 0
bytesWritten DWORD 0

msgK2        BYTE "Array state after K = 2:", 0Dh, 0Ah, 0
msgK3        BYTE "Array state after K = 3:", 0Dh, 0Ah, 0
outBuffer    BYTE 16 DUP(0)
crlfStr      BYTE 0Dh, 0Ah, 0
spaceStr     BYTE " ", 0

.code

; -------------------------------------------------------------
; MarkMultiples: N 미만의 K의 배수 위치를 1로 설정
; 입력: ESI = 바이트 배열 포인터
;       ECX = 배열 크기 N
;       EBX = 배수 K
; 규칙: 변경되는 레지스터는 반드시 저장 및 복원해야 함
; -------------------------------------------------------------
MarkMultiples PROC
    pushad                           ; 레지스터 상태 보존 (요구사항)

    cmp ebx, 0
    jbe Done                         ; K <= 0 이면 종료
    cmp ebx, ecx
    jae Done                         ; K >= N 이면 배수가 없으므로 종료

    ; K의 배수 인덱스(K, 2K, 3K...)를 루프
    mov edx, ebx                     ; EDX = K (현재 인덱스 위치)

MarkLoop:
    cmp edx, ecx                     ; Index < N 인지 확인
    jae Done

    mov BYTE PTR [esi + edx], 1      ; 배수 위치의 요소 값을 1로 변경

    add edx, ebx                     ; 다음 K의 배수로 이동 (Index += K)
    jmp MarkLoop

Done:
    popad                            ; 레지스터 상태 복원 (요구사항)
    ret
MarkMultiples ENDP

; -------------------------------------------------------------
; IntToString: 정수를 문자열로 변환 서브루틴
; -------------------------------------------------------------
IntToString PROC val:DWORD, pOut:PTR BYTE
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
; PrintArray: 배열 요소들을 0과 1로 출력하는 서브루틴
; -------------------------------------------------------------
PrintArray PROC
    pushad
    mov esi, OFFSET byteArray
    mov ecx, N

PrintLoop:
    push ecx
    movzx eax, BYTE PTR [esi]
    
    INVOKE IntToString, eax, OFFSET outBuffer
    INVOKE PrintString, OFFSET outBuffer
    INVOKE PrintString, OFFSET spaceStr

    inc esi
    pop ecx
    loop PrintLoop

    INVOKE PrintString, OFFSET crlfStr
    popad
    ret
PrintArray ENDP

; -------------------------------------------------------------
; 메인 절차 (Main Procedure)
; -------------------------------------------------------------
main PROC
    ; 1. 콘솔 출력 핸들 구하기
    INVOKE GetStdHandle, STD_OUTPUT_HANDLE
    mov hStdOut, eax

    ; 2. K = 2 로 첫 번째 서브루틴 호출
    mov esi, OFFSET byteArray
    mov ecx, N
    mov ebx, 2
    call MarkMultiples

    ; K = 2 실행 결과 출력
    INVOKE PrintString, OFFSET msgK2
    call PrintArray

    ; 3. K = 3 으로 두 번째 서브루틴 호출
    mov esi, OFFSET byteArray
    mov ecx, N
    mov ebx, 3
    call MarkMultiples

    ; K = 3 실행 결과 출력
    INVOKE PrintString, OFFSET msgK3
    call PrintArray

    ; 4. 종료
    INVOKE ExitProcess, 0
main ENDP
END main