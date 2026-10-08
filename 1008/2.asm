.386
.model flat, stdcall
.stack 4096

ExitProcess PROTO, dwExitCode:DWORD

.data
    theSum DWORD  ?       ; 합계를 저장할 변수

.code
main PROC
    mov eax, 10000h       ; 첫 번째 인자
    mov ebx, 20000h       ; 두 번째 인자
    mov ecx, 30000h       ; 세 번째 인자
    
    call Sumof            ; Sumof 함수 호출 (내부에서 덧셈 수행)
    
    mov theSum, eax       ; EAX에 담긴 최종 합계를 theSum 변수에 저장

    INVOKE ExitProcess, 0
main ENDP

;----------------------------------------------------
; Sumof 함수 정의
; 수신: EAX, EBX, ECX
; 반환: EAX = 세 수의 합
;----------------------------------------------------
Sumof PROC
    add eax, ebx          ; EAX = EAX + EBX (10000h + 20000h)
    add eax, ecx          ; EAX = EAX + ECX (결과 + 30000h)
    ret                   ; 메인 함수로 리턴 (EAX에 합계 유지)
Sumof ENDP

END main