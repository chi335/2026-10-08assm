### 문제 (Question)
1. Which instruction pushes all of the 32-bit general-purpose registers on the stack?
(어떤 명령어가 스택에 모든 32비트 범용 레지스터를 푸시(push)합니까?)

---

### 풀이 (Explanation)
x86 아키텍처(Assembly)에서는 레지스터들의 현재 상태를 보존하기 위해 여러 범용 레지스터의 값을 한 번에 스택에 저장하는 전용 명령어를 제공합니다.

1. **16비트 환경**: `PUSHA` (Push All) 명령어를 사용하여 16비트 범용 레지스터(AX, CX, DX, BX, SP, BP, SI, DI)를 스택에 푸시합니다.
2. **32비트 환경**: `PUSHAD` (Push All Doublewords) 명령어를 사용하여 32비트 범용 레지스터(EAX, ECX, EDX, EBX, ESP, EBP, ESI, EDI) 전체를 스택에 푸시합니다.

*(참고: 반대로 스택에서 모든 32비트 레지스터 값을 다시 꺼내어 복원하는 명령어는 `POPAD`입니다.)*

---

### 답 (Answer)
**`PUSHAD`**

---

### 문제 (Question)
2. Which instruction pushes the 32-bit EFLAGS register on the stack?
(2. 어떤 명령어가 32비트 EFLAGS 레지스터를 스택에 푸시(push)합니까?)

---

### 풀이 (Explanation)
x86 아키텍처에서는 시스템의 상태나 연산 결과의 상태를 나타내는 플래그(Flags) 레지스터를 스택에 저장하는 명령어를 제공합니다.

1. **16비트 환경**: `PUSHF` (Push Flags) 명령어를 사용하여 16비트 FLAGS 레지스터를 스택에 푸시합니다.
2. **32비트 환경**: `PUSHFD` (Push Flags Doubleword) 명령어를 사용하여 32비트 EFLAGS 레지스터를 스택에 푸시합니다.

*(참고: 반대로 스택에서 값을 꺼내 32비트 EFLAGS 레지스터로 복원하는 명령어는 `POPFD`입니다.)*

---

### 답 (Answer)
**`PUSHFD`**

---


### 문제 (Question)
3. Which instruction pops the stack into the EFLAGS register?
(3. 어떤 명령어가 스택의 값을 꺼내어(pop) EFLAGS 레지스터에 저장합니까?)

---

### 풀이 (Explanation)
스택에 저장해 두었던 플래그 레지스터의 상태를 다시 꺼내어 레지스터로 복원(pop)할 때 사용하는 명령어입니다.

1. **16비트 환경**: `POPF` (Pop Flags) 명령어를 사용하여 스택의 값을 16비트 FLAGS 레지스터로 팝합니다.
2. **32비트 환경**: `POPFD` (Pop Flags Doubleword) 명령어를 사용하여 스택의 값을 32비트 EFLAGS 레지스터로 팝합니다.

*(참고: 반대로 32비트 EFLAGS 레지스터의 값을 스택에 저장(push)하는 명령어는 `PUSHFD`입니다.)*

---

### 답 (Answer)
**`POPFD`**

---

### 문제 (Question)
4. Challenge: Another assembler (called NASM) permits the PUSH instruction to list multiple specific registers. Why might this approach be better than the PUSHAD instruction in MASM? Here is a NASM example:
PUSH EAX EBX ECX
(4. 도전 과제: NASM이라는 다른 어셈블러는 PUSH 명령어 하나로 지정한 여러 레지스터를 목록으로 작성할 수 있게 허용합니다. MASM의 PUSHAD 명령어보다 이 방식이 더 좋은 이유는 무엇일까요? 다음은 NASM 예시입니다: PUSH EAX EBX ECX)

---

### 풀이 (Explanation)
MASM의 `PUSHAD` 명령어는 무조건 8개의 모든 범용 레지스터(32바이트)를 스택에 푸시합니다. 반면, NASM처럼 필요한 레지스터만 지정하여 푸시하는 방식은 다음과 같은 명확한 장점이 있습니다.

1. **실행 속도 및 스택 메모리 절약 (효율성)**
   - `PUSHAD`는 실제로 변경할 필요가 없는 레지스터까지 포함해 8개를 전부 메모리에 쓰므로 **스택 공간을 크게 차지**하고 **실행 시간(클럭 사이클)이 더 걸립니다.**
   - 필요한 레지스터만 선택하여 푸시하면 메모리 접근을 줄여 성능을 최적화할 수 있습니다.

2. **함수 반환값(Return Value) 덮어쓰기 방지**
   - x86 아키텍처에서는 함수의 결과값(반환값)을 주로 `EAX` 레지스터에 저장합니다.
   - 만약 함수 시작 부분에서 `PUSHAD`를 사용하고 끝날 때 `POPAD`를 사용하면, 함수 내부에서 구한 `EAX`의 반환값이 `POPAD`에 의해 **함수 호출 전의 옛날 EAX 값으로 다시 덮어씌워지는 문제**가 발생합니다.
   - 필요한 레지스터만 푸시/팝하면 `EAX`를 제외하고 원하는 레지스터만 보존할 수 있어 안전합니다.

---

### 답 (Answer)
필요한 레지스터만 선택하여 푸시함으로써 **스택 메모리와 실행 시간을 절약(성능 최적화)**할 수 있으며, 함수의 반환값이 들어있는 레지스터(예: EAX)가 복원 과정에서 **이전 값으로 덮어씌워지는 것을 방지**할 수 있기 때문입니다.


---


### 문제 (Question)
5. Challenge: Suppose there were no PUSH instruction. Write a sequence of two other instructions that would accomplish the same as push eax.
(5. 도전 과제: PUSH 명령어가 없다고 가정해 봅시다. push eax와 동일한 동작을 수행하는 다른 두 명령어의 순서를 작성하세요.)

---

### 풀이 (Explanation)
x86 아키텍처에서 스택 메모리는 높은 주소에서 낮은 주소 방향(내림차순)으로 확장됩니다.
따라서 32비트(4바이트) 레지스터인 `EAX`의 값을 스택에 저장하는 `PUSH EAX` 명령어는 내부적으로 다음 두 단계로 동작합니다.

1. **스택 포인터 감소**: 스택의 맨 위를 가리키는 `ESP` 레지스터의 값을 4만큼 뺍니다 (`SUB ESP, 4`).
2. **메모리에 값 복사**: 감소된 `ESP`가 가리키는 메모리 위치(`[ESP]`)에 `EAX` 레지스터의 값을 저장합니다 (`MOV [ESP], EAX`).

이 두 명령어를 순서대로 실행하면 `PUSH EAX`와 완전히 동일한 결과를 만듭니다.

---

### 답 (Answer)
```assembly
SUB ESP, 4
MOV [ESP], EAX
```


---

### 문제 (Question)
6. (True/False): The RET instruction pops the top of the stack into the instruction pointer.
(6. (참/거짓): RET 명령어는 스택의 맨 위 값을 꺼내어(pop) 명령 포인터(Instruction Pointer)에 저장합니다.)

---

### 풀이 (Explanation)
`CALL` 명령어가 실행될 때 함수 호출이 끝난 뒤 돌아올 코드의 주소(복귀 주소, Return Address)가 스택에 먼저 저장(push)됩니다.

이후 함수나 서브루틴의 끝에서 `RET` (Return) 명령어가 실행되면, 스택의 맨 위에 저장되어 있던 복귀 주소를 꺼내어(pop) **명령 포인터 레지스터(32비트 기준 EIP 레지스터)**에 다시 집어넣습니다.

이를 통해 프로그램은 함수가 호출되었던 원래 위치로 성공적으로 돌아가 다음 코드를 이어 실행할 수 있게 됩니다. 따라서 주어진 설명은 **참(True)**입니다.

---

### 답 (Answer)
True (참)

---

### 문제 (Question)
7. (True/False): Nested procedure calls are not permitted by the Microsoft assembler unless the NESTED operator is used in the procedure definition.
(7. (참/거짓): 중첩된 프로시저 호출(Nested procedure calls)은 프로시저 정의에 NESTED 연산자가 사용되지 않는 한 마이크로소프트 어셈블러(MASM)에서 허용되지 않습니다.)

---

### 풀이 (Explanation)
어셈블리 언어에서 프로시저(함수) 호출은 스택(Stack) 메모리 구조를 기반으로 작동합니다. 함수가 호출될 때 돌아올 주소(복귀 주소)가 스택에 저장(push)되고, 반환될 때 스택에서 꺼내오는(pop) 방식이기 때문에 별도의 특별한 연산자 없이도 **프로시저 내에서 다른 프로시저를 호출하는 중첩 호출이 기본적으로 허용**됩니다.

MASM에서는 `NESTED`라는 연산자를 지정하지 않더라도 제약 없이 자유롭게 중첩 프로시저 호출을 작성할 수 있습니다. 따라서 주어진 설명은 **거짓(False)**입니다.

---

### 답 (Answer)
False (거짓)

---

### 문제 (Question)
8. (True/False): In protected mode, each procedure call uses a minimum of 4 bytes of stack space.
(8. (참/거짓): 보호 모드(Protected Mode)에서 각 프로시저 호출은 최소 4바이트의 스택 공간을 사용합니다.)

---

### 풀이 (Explanation)
x86 아키텍처의 32비트 보호 모드(Protected Mode)에서는 주소 체계가 32비트(4바이트) 기반으로 동작합니다.

`CALL` 명령어가 실행되어 프로시저를 호출할 때, 다음 실행할 코드의 위치인 복귀 주소(32비트 `EIP` 레지스터 값)를 스택에 저장(push)합니다. 32비트는 **4바이트**에 해당하므로, 프로시저를 호출할 때마다 복귀 주소를 저장하기 위해 최소 4바이트의 스택 공간이 사용됩니다. 따라서 주어진 설명은 **참(True)**입니다.

---

### 답 (Answer)
True (참)

---

### 문제 (Question)
9. (True/False): The ESI and EDI registers cannot be used when passing 32-bit parameters to procedures.
(9. (참/거짓): ESI와 EDI 레지스터는 프로시저에 32비트 매개변수를 전달할 때 사용할 수 없습니다.)

---

### 풀이 (Explanation)
x86 어셈블리 언어에서 `ESI`(Extended Source Index)와 `EDI`(Extended Destination Index)는 모두 32비트 범용 레지스터(General-Purpose Register)입니다.

프로시저(함수)에 매개변수를 전달할 때 스택을 사용하는 방식 외에도 레지스터에 직접 값을 담아 전달할 수 있는데, 이때 `ESI`와 `EDI` 레지스터 역시 32비트 정수나 메모리 주소(포인터)를 매개변수로 전달하는 데 자유롭게 사용될 수 있습니다. 따라서 주어진 설명은 **거짓(False)**입니다.

---

### 답 (Answer)
False (거짓)

---

### 문제 (Question)
10. (True/False): The ArraySum procedure (Section 5.2.5) receives a pointer to any array of doublewords.
(10. (참/거짓): ArraySum 프로시저(Section 5.2.5)는 더블워드(doublewords) 배열에 대한 포인터를 전달받습니다.)

---

### 풀이 (Explanation)
Kip Irvine 교재의 `ArraySum` 프로시저는 32비트(더블워드, DWORD) 배열의 모든 요소의 합을 구하는 서브루틴입니다.

이 프로시저를 호출할 때는 다음과 같이 레지스터를 설정하여 인수를 전달합니다.
- `ESI`: 배열의 시작 메모리 주소(**더블워드 배열을 가리키는 포인터**)
- `ECX`: 배열 요소의 개수

프로시저 내부에서 `ESI`가 가리키는 값을 읽고(`[ESI]`), 다음 더블워드 요소로 이동하기 위해 `ESI`의 주소 값을 4바이트씩 증가시키며 동작합니다. 따라서 주어진 설명은 **참(True)**입니다.

---

### 답 (Answer)
True (참)

---

### 문제 (Question)
11. (True/False): The USES operator lets you name all registers that are modified within a procedure.
(11. (참/거짓): USES 연산자를 사용하면 프로시저 내에서 수정되는 모든 레지스터의 이름을 지정할 수 있습니다.)

---

### 풀이 (Explanation)
MASM에서 `PROC` 지시어 뒤에 `USES` 연산자를 사용하면 프로시저 내부에서 값이 변경(수정)되는 레지스터들의 목록을 지정할 수 있습니다.

`USES` 연산자에 레지스터들을 등록해 두면 어셈블러가 프로시저 시작 지점에 해당 레지스터들을 **자동으로 스택에 백업(PUSH)**하고, 프로시저가 끝날 때(`RET` 직전) **원래 값으로 복원(POP)**해 주는 코드를 자동으로 생성합니다.

이를 통해 프로시저 내에서 레지스터를 자유롭게 수정하더라도 호출한 이전 상태를 안전하게 유지할 수 있습니다. 따라서 주어진 설명은 **참(True)**입니다.

---

### 답 (Answer)
True (참)

---

### 문제 (Question)
12. (True/False): The USES operator only generates PUSH instructions, so you must code POP instructions yourself.
(12. (참/거짓): USES 연산자는 PUSH 명령어만 생성하므로, POP 명령어는 직접 코딩해야 합니다.)

---

### 풀이 (Explanation)
MASM의 `USES` 연산자는 지정된 레지스터들을 보호하기 위해 프로시저 시작 부분에 `PUSH` 명령어를 자동으로 생성할 뿐만 아니라, 프로시저가 종료(`RET`)되기 직전에 역순으로 값을 복원하는 **`POP` 명령어까지 자동으로 생성**해 줍니다.

따라서 개발자가 직접 `POP` 명령어를 작성할 필요가 없습니다. 만약 직접 `POP`을 작성하면 레지스터 값이 엉키거나 스택 상태가 깨져 오류가 발생할 수 있습니다. 따라서 주어진 설명은 **거짓(False)**입니다.

---

### 답 (Answer)
False (거짓)


---

### 문제 (Question)
13. (True/False): The register list in the USES directive must use commas to separate the register names.
(13. (참/거짓): USES 지시어의 레지스터 목록은 레지스터 이름들을 구분하기 위해 쉼표(comma)를 사용해야 합니다.)

---

### 풀이 (Explanation)
MASM의 `USES` 지시어를 사용할 때 레지스터 목록은 쉼표(`,`)가 아닌 **공백(space)이나 탭(tab)**으로 구분합니다.

예를 들어 `MySub PROC USES eax ebx ecx`와 같이 레지스터 이름 사이에 공백을 두어 작성해야 하며, 쉼표를 사용하면 문법 오류(Syntax Error)가 발생합니다. 따라서 주어진 설명은 **거짓(False)**입니다.

---

### 답 (Answer)
False (거짓)

---

### 문제 (Question)
14. Which statement(s) in the ArraySum procedure (Section 5.2.5) would have to be modified so it could accumulate an array of 16-bit words? Create such a version of ArraySum and test it.
(14. ArraySum 프로시저(Section 5.2.5)가 16비트 워드(WORD) 배열의 합을 계산하도록 하려면 어떤 명령어들을 수정해야 합니까? 이러한 버전의 ArraySum을 작성하세요.)

---

### 풀이 (Explanation)
기존의 32비트(DWORD)용 `ArraySum`을 16비트(WORD)용으로 수정하려면 다음 **두 가지 명령어**를 변경해야 합니다.

1. **누적 연산 부분 (`ADD EAX, [ESI]` $\rightarrow$ `ADD AX, [ESI]`)**:
   - 32비트 레지스터 `EAX` 대신 16비트 레지스터 `AX`를 사용하여 메모리에서 16비트(WORD) 단위로 값을 읽어와 더하도록 변경합니다.
2. **포인터 증가 부분 (`ADD ESI, 4` $\rightarrow$ `ADD ESI, 2`)**:
   - DWORD는 4바이트이지만 WORD는 **2바이트**이므로, 배열의 다음 요소로 이동하려면 `ESI`를 4가 아닌 **2**만큼 증가시켜야 합니다. (또는 `ADD ESI, TYPE WORD` 사용 가능)

---

### 답 (Answer)
```assembly
;-----------------------------------------------------
; ArraySum16
; 16비트 정수(WORD) 배열의 합을 계산합니다.
; 받음: ESI = 배열의 시작 주소
;       ECX = 배열 요소의 개수
; 반환: AX = 배열 요소들의 합
;-----------------------------------------------------
ArraySum16 PROC
    push esi
    push ecx

    mov  ax, 0           ; 합계를 0으로 초기화 (16비트)

L1:
    add  ax, [esi]       ; 16비트 워드 값을 AX에 더함 (수정 1)
    add  esi, 2          ; 다음 워드 요소 위치로 이동 (2바이트 증가) (수정 2)
    loop L1              ; ECX만큼 반복

    pop  ecx
    pop  esi
    ret
ArraySum16 ENDP
```

---

### 문제 (Question)
15. What will be the final value in EAX after these instructions execute?
push 5
push 6
pop  eax
pop  eax
(15. 다음 명령어들이 실행된 후 EAX의 최종 값은 무엇입니까?)

---

### 풀이 (Explanation)
스택(Stack)은 나중에 들어간 데이터가 먼저 나오는 **LIFO(Last-In, First-Out, 후입선출)** 구조로 동작합니다.

1. `push 5`: 스택에 5를 넣습니다. (스택: [5])
2. `push 6`: 스택에 6을 넣습니다. (스택: [5, 6] $\rightarrow$ 맨 위: 6)
3. `pop eax`: 스택의 맨 위에 있는 6을 꺼내어 EAX에 저장합니다. (EAX = 6)
4. `pop eax`: 스택에 남아있는 5를 꺼내어 EAX에 덮어씁니다. (EAX = 5)

따라서 두 번째 `pop` 명령어에 의해 5가 EAX 레지스터에 최종적으로 저장됩니다.

---

### 답 (Answer)
5 (또는 00000005h)

---


### 문제 (Question)
16. Which statement is true about what will happen when the example code runs?
 1: main PROC
 2: push 10
 3: push 20
 4: call Ex2Sub
 5: pop  eax
 6: INVOKE ExitProcess,0
 7: main ENDP
 8:
 9: Ex2Sub PROC
10: pop eax
11: ret
12: Ex2Sub ENDP

a. EAX will equal 10 on line 6
b. The program will halt with a runtime error on Line 10
c. EAX will equal 20 on line 6
d. The program will halt with a runtime error on Line 11
(16. 예제 코드가 실행될 때 발생하는 상황으로 올바른 설명은 무엇입니까?)

---

### 풀이 (Explanation)
1. Line 4의 `call Ex2Sub` 명령어가 실행될 때, 프로시저 종료 후 돌아올 **복귀 주소(Return Address)**가 스택에 자동으로 `PUSH`됩니다.
2. `Ex2Sub` 내부의 Line 10 `pop eax`는 사용자가 넣은 데이터(20)가 아니라, 스택 맨 위에 있던 **복귀 주소**를 꺼내어 `EAX`에 저장합니다.
3. 그 결과 Line 11의 `ret` 명령어가 실행될 때, 스택에는 복귀 주소가 아닌 매개변수로 넣었던 `20`이 맨 위에 남아있게 됩니다.
4. `ret`은 이 `20`을 복귀 주소로 착각하고 메모리 주소 `20`으로 점프를 시도하다가 올바르지 않은 메모리 접근(Access Violation)으로 인해 **Line 11에서 런타임 오류**를 발생시키고 프로그램이 멈추게 됩니다.

따라서 정답은 **d**입니다.

---

### 답 (Answer)
d. The program will halt with a runtime error on Line 11

---

### 문제 (Question)
17. Which statement is true about what will happen when the example code runs?
 1: main PROC
 2: mov  eax,30
 3: push eax
 4: push 40
 5: call Ex3Sub
 6: INVOKE ExitProcess,0
 7: main ENDP
 8:
 9: Ex3Sub PROC
10: pusha
11: mov eax,80
12: popa
13: ret
14: Ex3Sub ENDP

a. EAX will equal 40 on line 6
b. The program will halt with a runtime error on Line 6
c. EAX will equal 30 on line 6 
d. The program will halt with a runtime error on Line 13
(17. 예제 코드가 실행될 때 발생하는 상황으로 올바른 설명은 무엇입니까?)

---

### 풀이 (Explanation)
1. Line 2에서 `EAX`에 값 `30`이 저장됩니다.
2. `Ex3Sub` 프로시저가 호출된 후, Line 10의 `pusha` 명령어에 의해 `EAX`를 포함한 모든 범용 레지스터의 값이 스택에 백업됩니다. (이때 백업되는 `EAX` 값은 `30`)
3. Line 11에서 `EAX`를 `80`으로 수정하지만, 바로 다음 Line 12의 `popa` 명령어에 의해 스택에 백업되었던 원래의 레지스터 값들이 모두 복원됩니다. 따라서 `EAX`는 다시 `30`으로 돌아옵니다.
4. `pusha`와 `popa`가 쌍을 이루어 스택의 상태도 원상복구되었으므로 Line 13의 `ret` 명령어가 정상 작동하여 메인 함수로 돌아옵니다.
5. 메인 함수로 돌아온 Line 6 시점에서 `EAX`의 값은 복원된 값인 **30**입니다.

따라서 정답은 **c**입니다.

---

### 답 (Answer)
c. EAX will equal 30 on line 6

---

### 문제 (Question)
18. Which statement is true about what will happen when the example code runs?
 1: main PROC
 2: mov eax,40
 3: push offset Here
 4: jmp  Ex4Sub
 5: Here:
 6: mov eax,30
 7: INVOKE ExitProcess,0
 8: main ENDP
 9:
10: Ex4Sub PROC
11: ret
12: Ex4Sub ENDP

a. EAX will equal 30 on line 7
b. The program will halt with a runtime error on Line 4
c. EAX will equal 30 on line 6 
d. The program will halt with a runtime error on Line 11
(18. 예제 코드가 실행될 때 발생하는 상황으로 올바른 설명은 무엇입니까?)

---

### 풀이 (Explanation)
1. Line 3의 `push offset Here` 명령어는 라벨 `Here`(Line 5)의 메모리 주소를 수동으로 스택에 백업합니다.
2. Line 4의 `jmp Ex4Sub` 명령어를 통해 `Ex4Sub` 프로시저로 이동합니다. (`call`과 달리 `jmp`는 복귀 주소를 자동으로 넣지 않지만, 이미 스택에 `Here` 주소를 넣어둔 상태입니다.)
3. Line 11의 `ret` 명령어가 실행될 때, 스택의 맨 위에 있던 `Here` 라벨의 주소를 복귀 주소로 꺼내어 Line 5 (`Here:`)로 점프하여 돌아옵니다.
4. Line 6의 `mov eax, 30` 명령어가 실행되어 `EAX` 레지스터의 값이 `30`으로 변경됩니다.
5. 따라서 다음 문장인 Line 7이 실행되는 시점에서 `EAX`의 값은 **30**이 됩니다.

따라서 정답은 **a**입니다.

---

### 답 (Answer)
a. EAX will equal 30 on line 7


