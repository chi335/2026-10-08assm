.386
.model flat, stdcall
.stack 4096

; 윈도우 표준 종료 함수 선언
ExitProcess PROTO, dwExitCode:DWORD

.data
    ; 필요한 데이터가 있다면 여기에 작성합니다.

.code
main PROC
    ; 1. 세 개의 32비트 정수 설정
    mov eax, 100     ; 첫 번째 정수
    mov ebx, 200     ; 두 번째 정수
    mov ecx, 300     ; 세 번째 정수

    ; 2. sumof 함수 호출
    call sumof       
    ; (이 시점에서 EAX에는 600이 들어있게 됩니다.)

    ; 3. 프로그램 정상 종료 (윈도우 API 호출)
    INVOKE ExitProcess, 0
main ENDP

;----------------------------------------------------
; sumof 프로시저 (함수)
; 수신: EAX, EBX, ECX (세 개의 정수)
; 반환: EAX = 세 수의 합
;----------------------------------------------------
sumof PROC
    add eax, ebx     ; EAX = EAX + EBX
    add eax, ecx     ; EAX = EAX + ECX
    ret              ; 메인 함수로 리턴
sumof ENDP

END main