# 어셈블리 언어 연습문제 풀이 (Chapter 5)

---

## 01번 문제

### 📌 문제 (Question)
**1. Which instruction pushes all of the 32-bit general-purpose registers on the stack?**  
*(어떤 명령어가 스택에 모든 32비트 범용 레지스터를 푸시(push)합니까?)*

---

### 💡 풀이 (Explanation)
x86 아키텍처에서는 레지스터들의 현재 상태를 보존하기 위해 여러 범용 레지스터의 값을 한 번에 스택에 저장하는 전용 명령어를 제공합니다.

1. **16비트 환경**: `PUSHA` (Push All) 명령어를 사용하여 16비트 범용 레지스터(AX, CX, DX, BX, SP, BP, SI, DI)를 스택에 푸시합니다.
2. **32비트 환경**: `PUSHAD` (Push All Doublewords) 명령어를 사용하여 32비트 범용 레지스터(EAX, ECX, EDX, EBX, ESP, EBP, ESI, EDI) 전체를 스택에 푸시합니다.

*(참고: 반대로 스택에서 모든 32비트 레지스터 값을 다시 꺼내어 복원하는 명령어는 `POPAD`입니다.)*

---

### ✅ 답 (Answer)
**`PUSHAD`**

<br>

---

## 02번 문제

### 📌 문제 (Question)
**2. Which instruction pushes the 32-bit EFLAGS register on the stack?**  
*(어떤 명령어가 32비트 EFLAGS 레지스터를 스택에 푸시(push)합니까?)*

---

### 💡 풀이 (Explanation)
x86 아키텍처에서는 시스템의 상태나 연산 결과의 상태를 나타내는 플래그(Flags) 레지스터를 스택에 저장하는 명령어를 제공합니다.

1. **16비트 환경**: `PUSHF` (Push Flags) 명령어를 사용하여 16비트 FLAGS 레지스터를 스택에 푸시합니다.
2. **32비트 환경**: `PUSHFD` (Push Flags Doubleword) 명령어를 사용하여 32비트 EFLAGS 레지스터를 스택에 푸시합니다.

*(참고: 반대로 스택에서 값을 꺼내 32비트 EFLAGS 레지스터로 복원하는 명령어는 `POPFD`입니다.)*

---

### ✅ 답 (Answer)
**`PUSHFD`**

<br>

---

## 03번 문제

### 📌 문제 (Question)
**3. Which instruction pops the stack into the EFLAGS register?**  
*(어떤 명령어가 스택의 값을 꺼내어(pop) EFLAGS 레지스터에 저장합니까?)*

---

### 💡 풀이 (Explanation)
스택에 저장해 두었던 플래그 레지스터의 상태를 다시 꺼내어 레지스터로 복원(pop)할 때 사용하는 명령어입니다.

1. **16비트 환경**: `POPF` (Pop Flags) 명령어를 사용하여 스택의 값을 16비트 FLAGS 레지스터로 팝합니다.
2. **32비트 환경**: `POPFD` (Pop Flags Doubleword) 명령어를 사용하여 스택의 값을 32비트 EFLAGS 레지스터로 팝합니다.

*(참고: 반대로 32비트 EFLAGS 레지스터의 값을 스택에 저장(push)하는 명령어는 `PUSHFD`입니다.)*

---

### ✅ 답 (Answer)
**`POPFD`**

<br>

---

## 04번 문제

### 📌 문제 (Question)
**4. Challenge: Another assembler (called NASM) permits the PUSH instruction to list multiple specific registers. Why might this approach be better than the PUSHAD instruction in MASM? Here is a NASM example:**  
`PUSH EAX EBX ECX`  
*(도전 과제: NASM이라는 다른 어셈블러는 PUSH 명령어 하나로 지정한 여러 레지스터를 목록으로 작성할 수 있게 허용합니다. MASM의 PUSHAD 명령어보다 이 방식이 더 좋은 이유는 무엇일까요?)*

---

### 💡 풀이 (Explanation)
MASM의 `PUSHAD` 명령어는 무조건 8개의 모든 범용 레지스터(32바이트)를 스택에 푸시합니다. 반면, NASM처럼 필요한 레지스터만 지정하여 푸시하는 방식은 다음과 같은 명확한 장점이 있습니다.

1. **실행 속도 및 스택 메모리 절약 (효율성)**
   - `PUSHAD`는 실제로 변경할 필요가 없는 레지스터까지 포함해 8개를 전부 메모리에 쓰므로 **스택 공간을 크게 차지**하고 **실행 시간(클럭 사이클)이 더 걸립니다.**
   - 필요한 레지스터만 선택하여 푸시하면 메모리 접근을 줄여 성능을 최적화할 수 있습니다.

2. **함수 반환값(Return Value) 덮어쓰기 방지**
   - x86 아키텍처에서는 함수의 결과값(반환값)을 주로 `EAX` 레지스터에 저장합니다.
   - 만약 함수 시작 부분에서 `PUSHAD`를 사용하고 끝날 때 `POPAD`를 사용하면, 함수 내부에서 구한 `EAX`의 반환값이 `POPAD`에 의해 **함수 호출 전의 옛날 EAX 값으로 다시 덮어씌워지는 문제**가 발생합니다.
   - 필요한 레지스터만 푸시/팝하면 `EAX`를 제외하고 원하는 레지스터만 보존할 수 있어 안전합니다.

---

### ✅ 답 (Answer)
필요한 레지스터만 선택하여 푸시함으로써 **스택 메모리와 실행 시간을 절약(성능 최적화)**할 수 있으며, 함수의 반환값이 들어있는 레지스터(예: EAX)가 복원 과정에서 **이전 값으로 덮어씌워지는 것을 방지**할 수 있기 때문입니다.

<br>

---

## 05번 문제

### 📌 문제 (Question)
**5. Challenge: Suppose there were no PUSH instruction. Write a sequence of two other instructions that would accomplish the same as push eax.**  
*(도전 과제: PUSH 명령어가 없다고 가정해 봅시다. push eax와 동일한 동작을 수행하는 다른 두 명령어의 순서를 작성하세요.)*

---

### 💡 풀이 (Explanation)
x86 아키텍처에서 스택 메모리는 높은 주소에서 낮은 주소 방향(내림차순)으로 확장됩니다.
따라서 32비트(4바이트) 레지스터인 `EAX`의 값을 스택에 저장하는 `PUSH EAX` 명령어는 내부적으로 다음 두 단계로 동작합니다.

1. **스택 포인터 감소**: 스택의 맨 위를 가리키는 `ESP` 레지스터의 값을 4만큼 뺍니다 (`SUB ESP, 4`).
2. **메모리에 값 복사**: 감소된 `ESP`가 가리키는 메모리 위치(`[ESP]`)에 `EAX` 레지스터의 값을 저장합니다 (`MOV [ESP], EAX`).

이 두 명령어를 순서대로 실행하면 `PUSH EAX`와 완전히 동일한 결과를 만듭니다.

---

### ✅ 답 (Answer)
```assembly
SUB ESP, 4
MOV [ESP], EAX
```

<br>

---

## 06번 문제

### 📌 문제 (Question)
**6. (True/False): The RET instruction pops the top of the stack into the instruction pointer.**  
*(RET 명령어는 스택의 맨 위 값을 꺼내어(pop) 명령 포인터(Instruction Pointer)에 저장합니다.)*

---

### 💡 풀이 (Explanation)
`CALL` 명령어가 실행될 때 함수 호출이 끝난 뒤 돌아올 코드의 주소(복귀 주소, Return Address)가 스택에 먼저 저장(push)됩니다.

이후 함수나 서브루틴의 끝에서 `RET` (Return) 명령어가 실행되면, 스택의 맨 위에 저장되어 있던 복귀 주소를 꺼내어(pop) **명령 포인터 레지스터(32비트 기준 EIP 레지스터)**에 다시 집어넣습니다.

이를 통해 프로그램은 함수가 호출되었던 원래 위치로 성공적으로 돌아가 다음 코드를 이어 실행할 수 있게 됩니다. 따라서 주어진 설명은 **참(True)**입니다.

---

### ✅ 답 (Answer)
**True (참)**

<br>

---

## 07번 문제

### 📌 문제 (Question)
**7. (True/False): Nested procedure calls are not permitted by the Microsoft assembler unless the NESTED operator is used in the procedure definition.**  
*(중첩된 프로시저 호출(Nested procedure calls)은 프로시저 정의에 NESTED 연산자가 사용되지 않는 한 마이크로소프트 어셈블러(MASM)에서 허용되지 않습니다.)*

---

### 💡 풀이 (Explanation)
어셈블리 언어에서 프로시저(함수) 호출은 스택(Stack) 메모리 구조를 기반으로 작동합니다. 함수가 호출될 때 돌아올 주소(복귀 주소)가 스택에 저장(push)되고, 반환될 때 스택에서 꺼내오는(pop) 방식이기 때문에 별도의 특별한 연산자 없이도 **프로시저 내에서 다른 프로시저를 호출하는 중첩 호출이 기본적으로 허용**됩니다.

MASM에서는 `NESTED`라는 연산자를 지정하지 않더라도 제약 없이 자유롭게 중첩 프로시저 호출을 작성할 수 있습니다. 따라서 주어진 설명은 **거짓(False)**입니다.

---

### ✅ 답 (Answer)
**False (거짓)**

<br>

---

## 08번 문제

### 📌 문제 (Question)
**8. (True/False): In protected mode, each procedure call uses a minimum of 4 bytes of stack space.**  
*(보호 모드(Protected Mode)에서 각 프로시저 호출은 최소 4바이트의 스택 공간을 사용합니다.)*

---

### 💡 풀이 (Explanation)
x86 아키텍처의 32비트 보호 모드(Protected Mode)에서는 주소 체계가 32비트(4바이트) 기반으로 동작합니다.

`CALL` 명령어가 실행되어 프로시저를 호출할 때, 다음 실행할 코드의 위치인 복귀 주소(32비트 `EIP` 레지스터 값)를 스택에 저장(push)합니다. 32비트는 **4바이트**에 해당하므로, 프로시저를 호출할 때마다 복귀 주소를 저장하기 위해 최소 4바이트의 스택 공간이 사용됩니다. 따라서 주어진 설명은 **참(True)**입니다.

---

### ✅ 답 (Answer)
**True (참)**

<br>

---

## 09번 문제

### 📌 문제 (Question)
**9. (True/False): The ESI and EDI registers cannot be used when passing 32-bit parameters to procedures.**  
*(ESI와 EDI 레지스터는 프로시저에 32비트 매개변수를 전달할 때 사용할 수 없습니다.)*

---

### 💡 풀이 (Explanation)
x86 어셈블리 언어에서 `ESI`(Extended Source Index)와 `EDI`(Extended Destination Index)는 모두 32비트 범용 레지스터(General-Purpose Register)입니다.

프로시저(함수)에 매개변수를 전달할 때 스택을 사용하는 방식 외에도 레지스터에 직접 값을 담아 전달할 수 있는데, 이때 `ESI`와 `EDI` 레지스터 역시 32비트 정수나 메모리 주소(포인터)를 매개변수로 전달하는 데 자유롭게 사용될 수 있습니다. 따라서 주어진 설명은 **거짓(False)**입니다.

---

### ✅ 답 (Answer)
**False (거짓)**

<br>

---

## 10번 문제

### 📌 문제 (Question)
**10. (True/False): The ArraySum procedure (Section 5.2.5) receives a pointer to any array of doublewords.**  
*(ArraySum 프로시저(Section 5.2.5)는 더블워드(doublewords) 배열에 대한 포인터를 전달받습니다.)*

---

### 💡 풀이 (Explanation)
Kip Irvine 교재의 `ArraySum` 프로시저는 32비트(더블워드, DWORD) 배열의 모든 요소의 합을 구하는 서브루틴입니다.

이 프로시저를 호출할 때는 다음과 같이 레지스터를 설정하여 인수를 전달합니다.
- `ESI`: 배열의 시작 메모리 주소(**더블워드 배열을 가리키는 포인터**)
- `ECX`: 배열 요소의 개수

프로시저 내부에서 `ESI`가 가리키는 값을 읽고(`[ESI]`), 다음 더블워드 요소로 이동하기 위해 `ESI`의 주소 값을 4바이트씩 증가시키며 동작합니다. 따라서 주어진 설명은 **참(True)**입니다.

---

### ✅ 답 (Answer)
**True (참)**

<br>

---

## 11번 문제

### 📌 문제 (Question)
**11. (True/False): The USES operator lets you name all registers that are modified within a procedure.**  
*(USES 연산자를 사용하면 프로시저 내에서 수정되는 모든 레지스터의 이름을 지정할 수 있습니다.)*

---

### 💡 풀이 (Explanation)
MASM에서 `PROC` 지시어 뒤에 `USES` 연산자를 사용하면 프로시저 내부에서 값이 변경(수정)되는 레지스터들의 목록을 지정할 수 있습니다.

`USES` 연산자에 레지스터들을 등록해 두면 어셈블러가 프로시저 시작 지점에 해당 레지스터들을 **자동으로 스택에 백업(PUSH)**하고, 프로시저가 끝날 때(`RET` 직전) **원래 값으로 복원(POP)**해 주는 코드를 자동으로 생성합니다.

이를 통해 프로시저 내에서 레지스터를 자유롭게 수정하더라도 호출한 이전 상태를 안전하게 유지할 수 있습니다. 따라서 주어진 설명은 **참(True)**입니다.

---

### ✅ 답 (Answer)
**True (참)**

<br>

---

## 12번 문제

### 📌 문제 (Question)
**12. (True/False): The USES operator only generates PUSH instructions, so you must code POP instructions yourself.**  
*(USES 연산자는 PUSH 명령어만 생성하므로, POP 명령어는 직접 코딩해야 합니다.)*

---

### 💡 풀이 (Explanation)
MASM의 `USES` 연산자는 지정된 레지스터들을 보호하기 위해 프로시저 시작 부분에 `PUSH` 명령어를 자동으로 생성할 뿐만 아니라, 프로시저가 종료(`RET`)되기 직전에 역순으로 값을 복원하는 **`POP` 명령어까지 자동으로 생성**해 줍니다.

따라서 개발자가 직접 `POP` 명령어를 작성할 필요가 없습니다. 만약 직접 `POP`을 작성하면 레지스터 값이 엉키거나 스택 상태가 깨져 오류가 발생할 수 있습니다. 따라서 주어진 설명은 **거짓(False)**입니다.

---

### ✅ 답 (Answer)
**False (거짓)**

<br>

---

## 13번 문제

### 📌 문제 (Question)
**13. (True/False): The register list in the USES directive must use commas to separate the register names.**  
*(USES 지시어의 레지스터 목록은 레지스터 이름들을 구분하기 위해 쉼표(comma)를 사용해야 합니다.)*

---

### 💡 풀이 (Explanation)
MASM의 `USES` 지시어를 사용할 때 레지스터 목록은 쉼표(`,`)가 아닌 **공백(space)이나 탭(tab)**으로 구분합니다.

예를 들어 `MySub PROC USES eax ebx ecx`와 같이 레지스터 이름 사이에 공백을 두어 작성해야 하며, 쉼표를 사용하면 문법 오류(Syntax Error)가 발생합니다. 따라서 주어진 설명은 **거짓(False)**입니다.

---

### ✅ 답 (Answer)
**False (거짓)**

<br>

---

## 14번 문제

### 📌 문제 (Question)
**14. Which statement(s) in the ArraySum procedure (Section 5.2.5) would have to be modified so it could accumulate an array of 16-bit words? Create such a version of ArraySum and test it.**  
*(ArraySum 프로시저(Section 5.2.5)가 16비트 워드(WORD) 배열의 합을 계산하도록 하려면 어떤 명령어들을 수정해야 합니까? 이러한 버전의 ArraySum을 작성하세요.)*

---

### 💡 풀이 (Explanation)
기존의 32비트(DWORD)용 `ArraySum`을 16비트(WORD)용으로 수정하려면 다음 **두 가지 명령어**를 변경해야 합니다.

1. **누적 연산 부분 (`ADD EAX, [ESI]` $\rightarrow$ `ADD AX, [ESI]`)**:
   - 32비트 레지스터 `EAX` 대신 16비트 레지스터 `AX`를 사용하여 메모리에서 16비트(WORD) 단위로 값을 읽어와 더하도록 변경합니다.
2. **포인터 증가 부분 (`ADD ESI, 4` $\rightarrow$ `ADD ESI, 2`)**:
   - DWORD는 4바이트이지만 WORD는 **2바이트**이므로, 배열의 다음 요소로 이동하려면 `ESI`를 4가 아닌 **2**만큼 증가시켜야 합니다. (또는 `ADD ESI, TYPE WORD` 사용 가능)

---

### ✅ 답 (Answer)
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

<br>

---

## 15번 문제

### 📌 문제 (Question)
**15. What will be the final value in EAX after these instructions execute?**  
```assembly
push 5
push 6
pop  eax
pop  eax
```
*(다음 명령어들이 실행된 후 EAX의 최종 값은 무엇입니까?)*

---

### 💡 풀이 (Explanation)
스택(Stack)은 나중에 들어간 데이터가 먼저 나오는 **LIFO(Last-In, First-Out, 후입선출)** 구조로 동작합니다.

1. `push 5`: 스택에 5를 넣습니다. (스택: `[5]`)
2. `push 6`: 스택에 6을 넣습니다. (스택: `[5, 6]` $\rightarrow$ 맨 위: 6)
3. `pop eax`: 스택의 맨 위에 있는 6을 꺼내어 EAX에 저장합니다. (`EAX = 6`)
4. `pop eax`: 스택에 남아있는 5를 꺼내어 EAX에 덮어씁니다. (`EAX = 5`)

따라서 두 번째 `pop` 명령어에 의해 5가 EAX 레지스터에 최종적으로 저장됩니다.

---

### ✅ 답 (Answer)
**`5` (또는 `00000005h`)**

<br>

---

## 16번 문제

### 📌 문제 (Question)
**16. Which statement is true about what will happen when the example code runs?**  
*(예제 코드가 실행될 때 발생하는 상황으로 올바른 설명은 무엇입니까?)*

```assembly
 1: main PROC
 2:   push 10
 3:   push 20
 4:   call Ex2Sub
 5:   pop  eax
 6:   INVOKE ExitProcess,0
 7: main ENDP
 8:
 9: Ex2Sub PROC
10:   pop eax
11:   ret
12: Ex2Sub ENDP
```

- **a.** EAX will equal 10 on line 6
- **b.** The program will halt with a runtime error on Line 10
- **c.** EAX will equal 20 on line 6
- **d.** The program will halt with a runtime error on Line 11

---

### 💡 풀이 (Explanation)
1. Line 4의 `call Ex2Sub` 명령어가 실행될 때, 프로시저 종료 후 돌아올 **복귀 주소(Return Address)**가 스택에 자동으로 `PUSH`됩니다.
2. `Ex2Sub` 내부의 Line 10 `pop eax`는 사용자가 넣은 데이터(`20`)가 아니라, 스택 맨 위에 있던 **복귀 주소**를 꺼내어 `EAX`에 저장합니다.
3. 그 결과 Line 11의 `ret` 명령어가 실행될 때, 스택에는 복귀 주소가 아닌 매개변수로 넣었던 `20`이 맨 위에 남아있게 됩니다.
4. `ret`은 이 `20`을 복귀 주소로 착각하고 메모리 주소 `20`으로 점프를 시도하다가 올바르지 않은 메모리 접근(Access Violation)으로 인해 **Line 11에서 런타임 오류**를 발생시키고 프로그램이 멈추게 됩니다.

---

### ✅ 답 (Answer)
**d. The program will halt with a runtime error on Line 11**

<br>

---

## 17번 문제

### 📌 문제 (Question)
**17. Which statement is true about what will happen when the example code runs?**  
*(예제 코드가 실행될 때 발생하는 상황으로 올바른 설명은 무엇입니까?)*

```assembly
 1: main PROC
 2:   mov  eax,30
 3:   push eax
 4:   push 40
 5:   call Ex3Sub
 6:   INVOKE ExitProcess,0
 7: main ENDP
 8:
 9: Ex3Sub PROC
10:   pusha
11:   mov eax,80
12:   popa
13:   ret
14: Ex3Sub ENDP
```

- **a.** EAX will equal 40 on line 6
- **b.** The program will halt with a runtime error on Line 6
- **c.** EAX will equal 30 on line 6
- **d.** The program will halt with a runtime error on Line 13

---

### 💡 풀이 (Explanation)
1. Line 2에서 `EAX`에 값 `30`이 저장됩니다.
2. `Ex3Sub` 프로시저가 호출된 후, Line 10의 `pusha` 명령어에 의해 `EAX`를 포함한 모든 범용 레지스터의 값이 스택에 백업됩니다. (이때 백업되는 `EAX` 값은 `30`)
3. Line 11에서 `EAX`를 `80`으로 수정하지만, 바로 다음 Line 12의 `popa` 명령어에 의해 스택에 백업되었던 원래의 레지스터 값들이 모두 복원됩니다. 따라서 `EAX`는 다시 `30`으로 돌아옵니다.
4. `pusha`와 `popa`가 쌍을 이루어 스택의 상태도 원상복구되었으므로 Line 13의 `ret` 명령어가 정상 작동하여 메인 함수로 돌아옵니다.
5. 메인 함수로 돌아온 Line 6 시점에서 `EAX`의 값은 복원된 값인 **30**입니다.

---

### ✅ 답 (Answer)
**c. EAX will equal 30 on line 6**

<br>

---

## 18번 문제

### 📌 문제 (Question)
**18. Which statement is true about what will happen when the example code runs?**  
*(예제 코드가 실행될 때 발생하는 상황으로 올바른 설명은 무엇입니까?)*

```assembly
 1: main PROC
 2:   mov eax,40
 3:   push offset Here
 4:   jmp  Ex4Sub
 5: Here:
 6:   mov eax,30
 7:   INVOKE ExitProcess,0
 8: main ENDP
 9:
10: Ex4Sub PROC
11:   ret
12: Ex4Sub ENDP
```

- **a.** EAX will equal 30 on line 7
- **b.** The program will halt with a runtime error on Line 4
- **c.** EAX will equal 30 on line 6
- **d.** The program will halt with a runtime error on Line 11

---

### 💡 풀이 (Explanation)
1. Line 3의 `push offset Here` 명령어는 라벨 `Here`(Line 5)의 메모리 주소를 수동으로 스택에 백업합니다.
2. Line 4의 `jmp Ex4Sub` 명령어를 통해 `Ex4Sub` 프로시저로 이동합니다. (`call`과 달리 `jmp`는 복귀 주소를 자동으로 넣지 않지만, 이미 스택에 `Here` 주소를 넣어둔 상태입니다.)
3. Line 11의 `ret` 명령어가 실행될 때, 스택의 맨 위에 있던 `Here` 라벨의 주소를 복귀 주소로 꺼내어 Line 5 (`Here:`)로 점프하여 돌아옵니다.
4. Line 6의 `mov eax, 30` 명령어가 실행되어 `EAX` 레지스터의 값이 `30`으로 변경됩니다.
5. 따라서 다음 문장인 Line 7이 실행되는 시점에서 `EAX`의 값은 **30**이 됩니다.

---

### ✅ 답 (Answer)
**a. EAX will equal 30 on line 7**

---

## 19번 문제

### 📌 문제 (Question)
**19. Which statement is true about what will happen when the example code runs?**  
*(다음 예제 코드가 실행될 때 발생하는 상황으로 올바른 설명은 무엇입니까?)*

```assembly
 1: main PROC
 2:   mov edx,0
 3:   mov eax,40
 4:   push eax
 5:   call Ex5Sub
 6:   INVOKE ExitProcess,0
 7: main ENDP
 8:
 9: Ex5Sub PROC
10:   pop  eax
11:   pop  edx
12:   push eax
13:   ret
14: Ex5Sub ENDP
```

- **a.** EDX will equal 40 on line 6
- **b.** The program will halt with a runtime error on Line 13
- **c.** EDX will equal 0 on line 6
- **d.** The program will halt with a runtime error on Line 11

---

### 💡 풀이 (Explanation)
스택의 동작 흐름을 차례대로 추적해 보면 다음과 같습니다.

1. **Line 2~4**: `EDX`에 `0`, `EAX`에 `40`을 넣은 뒤 `PUSH EAX`를 실행하여 스택에 `40`을 보관합니다. *(스택: [40])*
2. **Line 5 (`call Ex5Sub`)**: 프로시저 호출 시 **복귀 주소(Line 6의 주소)**가 스택 상단에 자동으로 추가됩니다. *(스택: [40, 복귀주소])*
3. **Line 10 (`pop eax`)**: 스택 맨 위에 있던 **복귀 주소**를 꺼내어 `EAX`에 저장합니다. *(스택: [40], EAX = 복귀주소)*
4. **Line 11 (`pop edx`)**: 스택에 남아있던 `40`을 꺼내어 `EDX`에 저장합니다. *(스택: 빈 상태, EDX = 40)*
5. **Line 12 (`push eax`)**: 아까 `EAX`에 보관해 두었던 **복귀 주소**를 다시 스택에 푸시합니다. *(스택: [복귀주소])*
6. **Line 13 (`ret`)**: 스택의 복귀 주소를 정상적으로 꺼내어 Line 6으로 안전하게 복귀합니다.
7. **Line 6 시점**: `Ex5Sub` 내부에서 `EDX`에 `40`이 할당되었고 복귀도 정상 처리되었으므로, **Line 6에 도달했을 때 `EDX`의 값은 40**이 됩니다.

따라서 정답은 **a**입니다.

---

### ✅ 답 (Answer)
**a. EDX will equal 40 on line 6**

---


## 20번 문제

### 📌 문제 (Question)
**20. What values will be written to the array when the following code executes?**  
*(다음 코드가 실행될 때 배열(array)에 기록되는 값들은 무엇입니까?)*

```assembly
.data
array DWORD 4 DUP(0)

.code
main PROC
    mov  eax,10
    mov  esi,0
    call proc_1
    add  esi,4
    add  eax,10
    mov  array[esi],eax
    INVOKE ExitProcess,0
main ENDP

proc_1 PROC
    call proc_2
    add  esi,4
    add  eax,10
    mov  array[esi],eax
    ret
proc_1 ENDP

proc_2 PROC
    call proc_3
    add  esi,4
    add  eax,10
    mov  array[esi],eax
    ret
proc_2 ENDP

proc_3 PROC
    mov  array[esi],eax
    ret
proc_3 ENDP
```

---

### 💡 풀이 (Explanation)
중첩 프로시저 호출(Call Stack)에 따라 코드가 실행되는 순서와 레지스터 및 배열의 변화를 추적해보면 다음과 같습니다.

1. **초기 설정 (`main`)**:
   - `EAX = 10`, `ESI = 0`으로 설정 후 `proc_1` 호출
2. **`proc_1` $\rightarrow$ `proc_2` $\rightarrow$ `proc_3` 호출**:
   - 프로시저들이 계속 중첩 호출되어 가장 안쪽인 `proc_3`까지 진입합니다.
3. **`proc_3` 실행**:
   - `mov array[esi], eax`: 현재 `ESI = 0`, `EAX = 10`이므로 **`array[0] = 10`**을 저장합니다.
   - `proc_2`로 복귀(`ret`)
4. **`proc_2` 나머지 실행**:
   - `add esi, 4` $\rightarrow$ `ESI = 4`
   - `add eax, 10` $\rightarrow$ `EAX = 20`
   - `mov array[esi], eax`: **`array[4] = 20`**을 저장합니다.
   - `proc_1`로 복귀(`ret`)
5. **`proc_1` 나머지 실행**:
   - `add esi, 4` $\rightarrow$ `ESI = 8`
   - `add eax, 10` $\rightarrow$ `EAX = 30`
   - `mov array[esi], eax`: **`array[8] = 30`**을 저장합니다.
   - `main`으로 복귀(`ret`)
6. **`main` 나머지 실행**:
   - `add esi, 4` $\rightarrow$ `ESI = 12`
   - `add eax, 10` $\rightarrow$ `EAX = 40`
   - `mov array[esi], eax`: **`array[12] = 40`**을 저장합니다.

---

### ✅ 답 (Answer)
배열 요소 순서대로 **`10, 20, 30, 40`** 이 기록됩니다.

*(또는 16진수로 `0000000Ah, 00000014h, 0000001Eh, 00000028h`)*
---

## 01번 프로그래밍 문제

### 📌 문제 (Question)
**1. Write a sequence of statements that use only PUSH and POP instructions to exchange the values in the EAX and EBX registers (or RAX and RBX in 64-bit mode).**  
*(PUSH와 POP 명령어만을 사용하여 EAX와 EBX 레지스터(또는 64비트 모드의 RAX와 RBX)의 값을 서로 교환(swap)하는 명령어 시퀀스를 작성하세요.)*

---

### 💡 풀이 (Explanation)
스택(Stack)은 **LIFO(Last-In, First-Out, 후입선출)** 구조로 동작하므로, 푸시(PUSH)한 역순으로 팝(POP)된다는 성질을 이용하면 임시 레지스터나 변수 없이 두 레지스터의 값을 손쉽게 교환할 수 있습니다.

1. `push eax`: 스택에 `EAX`의 원래 값($EAX_{orig}$)을 넣습니다. *(스택: [$EAX_{orig}$])*
2. `push ebx`: 스택에 `EBX`의 원래 값($EBX_{orig}$)을 넣습니다. *(스택: [$EAX_{orig}$, $EBX_{orig}$] $\rightarrow$ 맨 위: $EBX_{orig}$)*
3. `pop eax`: 스택 맨 위의 $EBX_{orig}$를 꺼내어 `EAX`에 저장합니다. (이제 `EAX` = 원래 `EBX` 값)
4. `pop ebx`: 스택에 남아있던 $EAX_{orig}$를 꺼내어 `EBX`에 저장합니다. (이제 `EBX` = 원래 `EAX` 값)

---

### ✅ 답 (Answer)

**32비트 모드 (x86)**
```assembly
push eax
push ebx
pop  eax
pop  ebx
```

**64비트 모드 (x64)**
```assembly
push rax
push rbx
pop  rax
pop  rbx
```

---

## 02번 문제

### 📌 문제 (Question)
**2. Suppose you wanted a subroutine to return to an address that was 3 bytes higher in memory than the return address currently on the stack. Write a sequence of instructions that would be inserted just before the subroutine’s RET instruction that accomplish this task.**  
*(서브루틴이 현재 스택에 있는 복귀 주소보다 메모리에서 3바이트 더 높은 주소로 복귀하도록 만들고 싶다고 가정해 봅시다. 서브루틴의 RET 명령어 바로 직전에 삽입하여 이 작업을 수행할 명령어 시퀀스를 작성하세요.)*

---

### 💡 풀이 (Explanation)
서브루틴 내부에서 `RET` 명령어가 실행되기 직전, 스택의 맨 위(`[ESP]`)에는 서브루틴 종료 후 돌아갈 **복귀 주소(Return Address)**가 들어있습니다.

이 복귀 주소 값에 `3`을 더해주면, `RET` 명령어가 실행될 때 기존 복귀 주소보다 3바이트 뒤의 메모리 위치로 복귀하게 됩니다. 이를 구현하는 방법은 크게 두 가지가 있습니다.

1. **방법 1 (스택 메모리 직접 수정 - 가장 간결함)**:
   - 스택 포인터 `ESP`가 가리키는 메모리 위치(`[ESP]`)의 값에 직접 `3`을 더합니다.
2. **방법 2 (레지스터 이용)**:
   - 스택에서 복귀 주소를 `POP`하여 레지스터에 꺼낸 뒤, `3`을 더하고 다시 `PUSH`합니다.

---

### ✅ 답 (Answer)

**방법 1 (추천: 스택 메모리 직접 수정)**
```assembly
add DWORD PTR [esp], 3
ret
```

**방법 2 (POP / PUSH 활용)**
```assembly
pop eax
add eax, 3
push eax
ret
```

*(참고: 64비트 환경일 경우 `esp` 대신 `rsp`, `DWORD` 대신 `QWORD`, `eax` 대신 `rax`를 사용합니다.)*

---

## 03번 문제

### 📌 문제 (Question)
**3. Functions in high-level languages often declare local variables just below the return address on the stack. Write an instruction that you could put at the beginning of an assembly language subroutine that would reserve space for two integer doubleword variables. Then, assign the values 1000h and 2000h to the two local variables.**  
*(고급 언어의 함수는 종종 스택의 복귀 주소 바로 아래에 지역 변수를 선언합니다. 어셈블리 언어 서브루틴의 시작 부분에 배치하여 2개의 정수 더블워드(DWORD) 변수를 위한 공간을 확보하는 명령어를 작성하세요. 그런 다음 두 지역 변수에 1000h와 2000h 값을 할당하세요.)*

---

### 💡 풀이 (Explanation)
x86 아키텍처에서 스택 메모리는 **높은 주소에서 낮은 주소 방향(내림차순)**으로 할당됩니다. 따라서 지역 변수 공간을 확보하려면 스택 포인터(`ESP`)의 값을 줄여주어야 합니다.

1. **공간 확보**: 더블워드(DWORD) 1개는 4바이트이므로, 2개의 더블워드 변수를 위해 **8바이트** 공간을 확보해야 합니다. (`SUB ESP, 8`)
2. **값 할당**: 확보된 공간(`[ESP]` 및 `[ESP + 4]`)에 각각 `1000h`와 `2000h` 값을 할당합니다.

---

### ✅ 답 (Answer)

```assembly
; 1. 2개의 DWORD(8바이트) 지역 변수 공간 확보
sub esp, 8

; 2. 첫 번째 및 두 번째 지역 변수에 값 할당
mov DWORD PTR [esp], 1000h      ; 첫 번째 지역 변수
mov DWORD PTR [esp + 4], 2000h  ; 두 번째 지역 변수
```

*(참고: 프레임 포인터 `EBP`를 사용하는 경우 `mov DWORD PTR [ebp - 4], 1000h`, `mov DWORD PTR [ebp - 8], 2000h` 형태로도 작성할 수 있습니다.)*

---

## 04번 문제

### 📌 문제 (Question)
**4. Write a sequence of statements using indexed addressing that copies an element in a doubleword array to the previous position in the same array.**  
*(인덱스 주소 지정 방식(indexed addressing)을 사용하여 더블워드(DWORD) 배열의 특정 요소를 동일한 배열의 이전 위치로 복사하는 명령어 시퀀스를 작성하세요.)*

---

### 💡 풀이 (Explanation)
더블워드(DWORD) 배열은 요소 1개당 **4바이트**의 크기를 가집니다.

따라서 인덱스 인덱스 레지스터(`ESI`)에 현재 요소의 바이트 오프셋(byte offset)이 들어있다고 할 때, 이전 위치 요소의 바이트 오프셋은 **`ESI - 4`**가 됩니다.

1. **현재 요소 읽기**: `ESI` 오프셋에 위치한 현재 요소의 값을 레지스터(`EAX`)로 가져옵니다. (`MOV EAX, array[ESI]`)
2. **이전 위치에 쓰기**: 읽어온 `EAX` 값을 이전 위치(`ESI - 4`)의 배열 메모리에 저장합니다. (`MOV array[ESI - 4], EAX`)

---

### ✅ 답 (Answer)

**방법 1 (ESI가 바이트 오프셋인 경우 - 추천)**
```assembly
; ESI에는 현재 복사할 요소의 바이트 오프셋이 설정되어 있다고 가정 (예: 2번째 요소 = 4)
mov eax, array[esi]        ; 현재 요소 array[i]를 EAX로 읽어옴
mov array[esi - 4], eax    ; 이전 위치 array[i-1]로 복사
```

**방법 2 (ESI가 요소의 인덱스 번호인 경우)**
```assembly
; ESI에는 현재 요소의 인덱스 번호가 설정되어 있다고 가정 (예: 2번째 요소 = 1)
mov eax, array[esi * 4]        ; 현재 요소 array[i]를 EAX로 읽어옴
mov array[esi * 4 - 4], eax    ; 이전 위치 array[i-1]로 복사
```

---

## 05번 문제

### 📌 문제 (Question)
**5. Write a sequence of statements that display a subroutine’s return address. Be sure that whatever modifications you make to the stack do not prevent the subroutine from returning to its caller.**  
*(서브루틴의 복귀 주소를 출력하는 명령어 시퀀스를 작성하세요. 스택에 가하는 어떠한 변경 사항도 서브루틴이 호출자에게 복귀하는 것을 방지하지 않도록 주의하세요.)*

---

### 💡 풀이 (Explanation)
서브루틴이 호출된 직후, 스택의 맨 위(`[ESP]`)에는 호출한 위치로 돌아가기 위한 **복귀 주소(Return Address)**가 들어있습니다.

스택 구조를 깨뜨리지 않고 안전하게 복귀 주소를 출력하는 방법은 두 가지가 있습니다.

1. **방법 1 (`MOV` 명령어 사용 - 가장 안전함)**:
   - 스택 포인터 `ESP`를 변경하지 않고 `mov eax, [esp]`를 사용하여 스택 맨 위의 복귀 주소를 `EAX` 레지스터로 읽어온 뒤 `WriteHex`로 출력합니다. 스택 상태가 전혀 바뀌지 않으므로 가장 안전합니다.
2. **방법 2 (`POP` / `PUSH` 복원 사용)**:
   - `pop eax`로 복귀 주소를 꺼내어 출력한 뒤, 서브루틴이 끝나기 전에 반드시 `push eax`로 복귀 주소를 스택에 다시 집어넣어 복원합니다.

---

### ✅ 답 (Answer)

**방법 1 (추천: 스택 상태를 건드리지 않고 읽기)**
```assembly
mov eax, [esp]      ; 스택 맨 위(복귀 주소)의 값을 EAX로 복사
call WriteHex       ; Irvine32 라이브러리를 사용하여 16진수로 복귀 주소 출력
call Crlf           ; 줄바꿈
```

**방법 2 (POP으로 꺼낸 후 PUSH로 다시 복원하기)**
```assembly
pop eax             ; 스택에서 복귀 주소를 EAX로 꺼냄
call WriteHex       ; 복귀 주소 출력
call Crlf           ; 줄바꿈
push eax            ; RET 명령어가 정상 작동하도록 복귀 주소를 스택에 다시 복원!
```
