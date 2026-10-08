# 📘 Assembly Programming: Procedures (프로시저)

어셈블리 언어의 프로시저(Subroutine), 스택 동작, 외부 라이브러리 링크 및 Irvine32/Irvine64 라이브러리 사용법 정리 노트입니다.

---

## 📌 목차 (Table of Contents)
1. [Stack Operations (스택 연산)](#1-stack-operations-스택-연산)
2. [Defining and Using Procedures (프로시저 정의 및 사용)](#2-defining-and-using-procedures-프로시저-정의-및-사용)
3. [Linking to an External Library (외부 라이브러리 링크)](#3-linking-to-an-external-library-외부-라이브러리-링크)
4. [The Irvine32 Library (Irvine32 라이브러리)](#4-the-irvine32-library-irvine32-라이브러리)
5. [64-Bit Assembly Programming (64비트 어셈블리)](#5-64-bit-assembly-programming-64비트-어셈블리)

---

## 1. Stack Operations (스택 연산)

- **Runtime Stack (런타임 스택)**
  - 32비트 모드에서 **후입선출(LIFO, Last-In First-Out)** 방식으로 동작하는 메모리 구조입니다.
  - `ESP` (Stack Pointer) 레지스터가 스택의 최상단 주소를 가리킵니다.

- **`PUSH` & `POP` 명령**
  - **`PUSH`**: 데이터를 스택에 저장하며, `ESP` 값이 감소합니다.
  - **`POP`**: 스택의 최상단 데이터를 꺼내어 지정한 레지스터/변수에 저장하고, `ESP` 값이 증가합니다.

---

## 2. Defining and Using Procedures (프로시저 정의 및 사용)

### 2.1 프로시저 정의 (`PROC` & `ENDP`)
어셈블리 언어에서 프로시저는 `PROC` 지시어로 시작하고 `ENDP` 지시어로 종료합니다.

```assembly
SumOf PROC
    add eax, ebx
    add eax, ecx
    ret
SumOf ENDP
```

### 2.2 `CALL`과 `RET` 명령의 동작 원리
- **`CALL` 명령**:
  1. 프로시저 실행 후 돌아올 다음 명령어 주소(Return Address)를 스택에 `PUSH`합니다.
  2. 프로시저의 시작 주소를 `EIP` (Instruction Pointer)에 복사하여 해당 위치로 이동합니다.
- **`RET` 명령**:
  1. 스택에서 리턴 주소를 `POP`하여 `EIP`에 복사합니다.
  2. 호출 직후의 원래 위치로 돌아가 프로그램 실행을 재개합니다.

### 2.3 중첩 프로시저 호출 (Nested Procedure Calls)
- 하나의 프로시저 내부에서 또 다른 프로시저를 호출할 수 있습니다.
- 스택 구조를 활용하므로 호출 순서의 역순으로 복귀 주소가 `POP`되어 안전하게 복귀합니다.

### 2.4 레지스터 인자 전달 및 상태 보존
- **레지스터 전달**: 범용 레지스터(`EAX`, `EBX`, `ECX`, `ESI` 등)에 값을 담아 프로시저에 전달합니다.
- **레지스터 보존 (Saving/Restoring Registers)**:
  - 프로시저 실행 중 호출자의 레지스터 값이 유실되지 않도록 시작 시 `PUSH`로 저장하고, 종료 전 `POP`으로 복원합니다.
  - **주의**: `POP`은 `PUSH`의 역순으로 진행해야 합니다.

```assembly
ArraySum PROC
    push esi        ; ESI 백업
    push ecx        ; ECX 백업

    mov eax, 0      ; 합계 초기화
L1:
    add eax, [esi]  ; 배열 요소 가산
    add esi, TYPE DWORD
    loop L1

    pop ecx         ; ECX 복원 (역순)
    pop esi         ; ESI 복원
    ret
ArraySum ENDP
```

### 2.5 프로시저 문서화 표준 (Documenting Procedures)
프로시저 상단에 주석으로 명시해야 할 필수 요소:
- **Tasks**: 프로시저가 수행하는 작업 내용 설명
- **Receives**: 입력 파라미터 및 사용 레지스터
- **Returns**: 반환값 저장 레지스터/위치
- **Preconditions**: 프로시저 호출 전 충족되어야 하는 전제 조건

---

## 3. Linking to an External Library (외부 라이브러리 링크)

- **링크 라이브러리 (Link Library)**: 이미 기계어로 어셈블된 프로시저들의 집합 파일(`.lib`).
- **프로그램 빌드 과정**:
  1. 소스 파일(`.asm`) 어셈블 $\rightarrow$ 오브젝트 파일(`.obj`) 생성
  2. 링커(Linker)가 `.obj` 파일과 외부 라이브러리(`.lib`)를 결합 $\rightarrow$ 실행 파일(`.exe`) 생성
- **명령어 예시**:
  ```cmd
  link hello.obj irvine32.lib
  ```
- Windows API 활용 시 `kernel32.lib` 등과의 링크를 통해 `kernel32.dll` 내 시스템 함수 호출이 가능합니다.

---

## 4. The Irvine32 Library (Irvine32 라이브러리)

어셈블리 프로그래밍의 입출력 및 유틸리티 처리를 간소화하기 위한 라이브러리입니다.

| 주요 프로시저 | 기능 설명 |
| :--- | :--- |
| `WriteString` | `EDX`가 가리키는 Null 종료 문자열을 화면에 출력 |
| `WriteDec` | `EAX`에 저장된 값을 10진수로 출력 |
| `Crlf` | 줄바꿈(Carriage Return / Line Feed) 수행 |
| `GetMSeconds` | 시스템 시작 후 경과된 시간(밀리초) 반환 (성능 측정용) |

---

## 5. 64-Bit Assembly Programming (64비트 어셈블리)

- **Irvine64 Library**: 64비트 환경을 지원하는 어셈블리 라이브러리.
- **x64 Calling Convention**: 64비트 환경에서는 레지스터 기반의 함수 호출 규약(Calling Convention)을 따라 파라미터를 전달합니다.
