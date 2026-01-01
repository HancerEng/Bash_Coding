Bash commands written in assembly for x86 architecture

Commands:

Creating .o file:

nasm -f elf32 socket.asm -o socket.asm

Log Dump:

objdump -d socket.o

Creating bash command:

ld -m elf_i386 socket.o -o socket
