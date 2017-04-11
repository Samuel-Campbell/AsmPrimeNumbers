asmprime: asmprime.o
	ld -m elf_i386 -s -o asmprime asmprime.o
asmprime.o: asmprime.asm
	nasm -f elf32 asmprime.asm
clean:
	rm *.o asmprime
