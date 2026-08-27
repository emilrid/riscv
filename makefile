program.hex: program.s link.ld
	riscv64-elf-gcc -march=rv32i_zicsr -mabi=ilp32 -nostdlib -nostartfiles -T link.ld -o program.elf program.s
	riscv64-elf-objcopy -O binary program.elf program.bin
	od -An -tx4 -v program.bin | tr -s ' ' '\n' | grep -v '^$$' > program.hex
 
dump:
	riscv64-unknown-elf-objdump -d program.elf
 
clean:
	rm -f program.elf program.bin program.hex
 
