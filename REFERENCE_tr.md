# x86 Assembly Referans Belgesi

## 32-bit Registerler ve Alt Kategorileri

### EAX - Biriktiricinin (Accumulator)
- **32-bit:** `eax` - Tam kayıt
- **16-bit:** `ax` - Düşük 16-bit
  - **8-bit (Yüksek):** `ah` - Yüksek 8-bit
  - **8-bit (Düşük):** `al` - Düşük 8-bit

**Kullanım:** Fonksiyon dönüş değerleri, aritmetik işlemler

### EBX - Taban (Base) Registerı
- **32-bit:** `ebx` - Tam kayıt
- **16-bit:** `bx` - Düşük 16-bit
  - **8-bit (Yüksek):** `bh` - Yüksek 8-bit
  - **8-bit (Düşük):** `bl` - Düşük 8-bit

**Kullanım:** Dizin işlemlerinde taban, syscall argümanları

### ECX - Sayaç (Counter) Registerı
- **32-bit:** `ecx` - Tam kayıt
- **16-bit:** `cx` - Düşük 16-bit
  - **8-bit (Yüksek):** `ch` - Yüksek 8-bit
  - **8-bit (Düşük):** `cl` - Düşük 8-bit

**Kullanım:** Döngü sayacı, syscall argümanları, string işlemleri

### EDX - Veri (Data) Registerı
- **32-bit:** `edx` - Tam kayıt
- **16-bit:** `dx` - Düşük 16-bit
  - **8-bit (Yüksek):** `dh` - Yüksek 8-bit
  - **8-bit (Düşük):** `dl` - Düşük 8-bit

**Kullanım:** I/O işlemleri, syscall argümanları

### ESI - Kaynak İndeksi (Source Index)
- **32-bit:** `esi` - Tam kayıt
- **16-bit:** `si` - Düşük 16-bit

**Kullanım:** String kaynağı, dizi işlemleri

### EDI - Hedef İndeksi (Destination Index)
- **32-bit:** `edi` - Tam kayıt
- **16-bit:** `di` - Düşük 16-bit

**Kullanım:** String hedefi, dizi işlemleri

### EBP - Taban İşaretçi (Base Pointer)
- **32-bit:** `ebp` - Tam kayıt
- **16-bit:** `bp` - Düşük 16-bit

**Kullanım:** Stack çerçeve işaretçisi, yerel değişkenler

### ESP - Stack İşaretçi (Stack Pointer)
- **32-bit:** `esp` - Tam kayıt
- **16-bit:** `sp` - Düşük 16-bit

**Kullanım:** Stack üst işaretçisi (genelde doğrudan değiştirilmez)

---

## x86 Linux Syscall Tablosu

| No. | Adı | Hex | 1. Arg | 2. Arg | 3. Arg | 4. Arg | 5. Arg | 6. Arg |
|-----|-----|-----|--------|--------|--------|--------|--------|--------|
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

### Socketcall Alt Numaraları (syscall 102)
```
1 = socket        - Soket oluştur
2 = bind          - Soketi bağla
3 = connect       - Sokete bağlan
4 = listen        - Gelen bağlantıları dinle
5 = accept        - Bağlantıyı kabul et
6 = getsockname   - Soket adını al
7 = getpeername   - Eş adını al
8 = socketpair    - Soket çiftini oluştur
9 = send          - Veri gönder
10 = recv         - Veri al
11 = sendto       - Adrese veri gönder
12 = recvfrom     - Adresten veri al
13 = shutdown     - Soketi kapat
14 = setsockopt   - Soket seçeneği ayarla
15 = getsockopt   - Soket seçeneğini al
16 = listen       - Dinlemeye başla
```

---

## Syscall Nasıl Kullanılır?

### Değer Ayarlama (32-bit)
```asm
; Syscall numarası EAX'e
mov al, 102        ; socketcall
; veya
mov eax, 102

; Argümanlar:
; 1. Arg -> EBX
; 2. Arg -> ECX
; 3. Arg -> EDX
; 4. Arg -> ESI
; 5. Arg -> EDI
; 6. Arg -> EBP
```

### Syscall Çağırma
```asm
int 0x80           ; Syscall çağrısı (32-bit)
```

### Dönüş Değeri
```asm
; EAX'te dönüş değeri bulunur
mov result, eax
```

---

## Örnek: socket() Syscall

```asm
; socketcall (102) ile socket oluştur
mov al, 102        ; socketcall
mov bl, 1          ; socket alt numarası
push 0             ; proto (varsayılan)
push 1             ; type (SOCK_STREAM)
push 2             ; family (AF_INET)
mov ecx, esp       ; socket argümanlarına işaretçi
int 0x80           ; syscall
```

---

## Stack İşlemleri

Stack LIFO (Last In First Out) yapısıdır:
- `push` - Veriyi stack'e ekle (ESP azalır)
- `pop` - Stack'ten veriyi al (ESP artar)
- `esp` - Stack üstü işaretçisi
- `ebp` - Stack çerçeve işaretçisi

```asm
push 0x5c11        ; Port 4444
push word 2        ; AF_INET
mov ecx, esp       ; ECX = stack adresi
```
