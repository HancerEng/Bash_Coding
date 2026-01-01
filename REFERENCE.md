# x86 Assembly Reference Guide

## 32-bit Registers and Sub-Categories

### EAX - Accumulator Register
- **32-bit:** `eax` - Full register
- **16-bit:** `ax` - Lower 16-bit
  - **8-bit (High):** `ah` - High 8-bit
  - **8-bit (Low):** `al` - Low 8-bit

**Usage:** Function return values, arithmetic operations

### EBX - Base Register
- **32-bit:** `ebx` - Full register
- **16-bit:** `bx` - Lower 16-bit
  - **8-bit (High):** `bh` - High 8-bit
  - **8-bit (Low):** `bl` - Low 8-bit

**Usage:** Base for indexing operations, syscall arguments

### ECX - Counter Register
- **32-bit:** `ecx` - Full register
- **16-bit:** `cx` - Lower 16-bit
  - **8-bit (High):** `ch` - High 8-bit
  - **8-bit (Low):** `cl` - Low 8-bit

**Usage:** Loop counter, syscall arguments, string operations

### EDX - Data Register
- **32-bit:** `edx` - Full register
- **16-bit:** `dx` - Lower 16-bit
  - **8-bit (High):** `dh` - High 8-bit
  - **8-bit (Low):** `dl` - Low 8-bit

**Usage:** I/O operations, syscall arguments

### ESI - Source Index
- **32-bit:** `esi` - Full register
- **16-bit:** `si` - Lower 16-bit

**Usage:** String source, array operations

### EDI - Destination Index
- **32-bit:** `edi` - Full register
- **16-bit:** `di` - Lower 16-bit

**Usage:** String destination, array operations

### EBP - Base Pointer
- **32-bit:** `ebp` - Full register
- **16-bit:** `bp` - Lower 16-bit

**Usage:** Stack frame pointer, local variables

### ESP - Stack Pointer
- **32-bit:** `esp` - Full register
- **16-bit:** `sp` - Lower 16-bit

**Usage:** Stack top pointer (usually not modified directly)

---

## x86 Linux Syscall Table

| No. | Name | Hex | eax | ebx | ecx | edx | esi | edi |
|-----|------|-----|---------|---------|---------|---------|---------|---------|
| 1 | exit | 0x01 | int error_code | - | - | - | - | - |
| 2 | fork | 0x02 | - | - | - | - | - | - |
| 3 | read | 0x03 | unsigned int fd | char *buf | size_t count | - | - | - |
| 4 | write | 0x04 | unsigned int fd | const char *buf | size_t count | - | - | - |
| 5 | open | 0x05 | const char *filename | int flags | umode_t mode | - | - | - |
| 6 | close | 0x06 | unsigned int fd | - | - | - | - | - |
| 11 | execve | 0x0b | const char *name | const char *const *argv | const char *const *envp | - | - | - |
| 33 | access | 0x21 | const char *filename | int mode | - | - | - | - |
| 39 | mkdir | 0x27 | const char *pathname | umode_t mode | - | - | - | - |
| 40 | rmdir | 0x28 | const char *pathname | - | - | - | - | - |
| 36 | sync | 0x24 | - | - | - | - | - | - |
| 37 | kill | 0x25 | pid_t pid | int sig | - | - | - | - |
| 38 | rename | 0x26 | const char *oldname | const char *newname | - | - | - | - |
| 41 | dup | 0x29 | unsigned int fildes | - | - | - | - | - |
| 42 | pipe | 0x2a | int *fildes | - | - | - | - | - |
| 45 | brk | 0x2d | unsigned long brk | - | - | - | - | - |
| 63 | dup2 | 0x3f | unsigned int oldfd | unsigned int newfd | - | - | - | - |
| 102 | socketcall | 0x66 | int call | unsigned long *args | - | - | - | - |
| 162 | nanosleep | 0xa2 | struct timespec *rqtp | struct timespec *rmtp | - | - | - | - |
| 240 | futex | 0xf0 | u32 *uaddr | int op | u32 val | struct timespec *utime | u32 *uaddr2 | u32 val3 |

### Socketcall Sub-Numbers (syscall 102)
```
1 = socket        - Create a socket
2 = bind          - Bind socket to address
3 = connect       - Connect to address
4 = listen        - Listen for connections
5 = accept        - Accept incoming connection
6 = getsockname   - Get socket name
7 = getpeername   - Get peer name
8 = socketpair    - Create socket pair
9 = send          - Send data
10 = recv         - Receive data
11 = sendto       - Send data to address
12 = recvfrom     - Receive data from address
13 = shutdown     - Shutdown socket
14 = setsockopt   - Set socket option
15 = getsockopt   - Get socket option
16 = listen       - Start listening
```

---

## How to Use Syscalls?

### Setting Values (32-bit)
```asm
; Syscall number in EAX
mov al, 102        ; socketcall
; or
mov eax, 102

; Arguments:
; 1st Arg -> EBX
; 2nd Arg -> ECX
; 3rd Arg -> EDX
; 4th Arg -> ESI
; 5th Arg -> EDI
; 6th Arg -> EBP
```

### Calling Syscall
```asm
int 0x80           ; Syscall call (32-bit)
```

### Return Value
```asm
; Return value is in EAX
mov result, eax
```

---

## Example: socket() Syscall

```asm
; socketcall (102) to create socket
mov al, 102        ; socketcall
mov bl, 1          ; socket sub-number
push 0             ; proto (default)
push 1             ; type (SOCK_STREAM)
push 2             ; family (AF_INET)
mov ecx, esp       ; pointer to socket arguments
int 0x80           ; syscall
```

---

## Stack Operations

Stack is LIFO (Last In First Out) structure:
- `push` - Push data to stack (ESP decreases)
- `pop` - Pop data from stack (ESP increases)
- `esp` - Stack top pointer
- `ebp` - Stack frame pointer

```asm
push 0x5c11        ; Port 4444
push word 2        ; AF_INET
mov ecx, esp       ; ECX = stack address
```
