# Assembly Memory Management Examples

This repository contains examples of memory management implemented in x86-64 assembly on Windows. Each example
demonstrates different approaches to handling memory allocation and deallocation.

## Contents

1. **Simple Memory Management Example**
   A basic example that demonstrates manual memory management using a statically allocated memory pool.
2. **Simple Memory Management with Heap**
   An extension of the basic example that includes dynamic memory allocation using heap memory.
3. **First Fit Allocation Example**
   An example implementing a simple first-fit memory allocation strategy, showing how to manage a memory pool
   efficiently.

## Getting Started
### Prerequisites
- NASM (Netwide Assembler)
- MinGW-win64 (Minimalist GNU for Windows)

### Compilation

```bash
nasm -f win64 -o example.exe example.asm
gcc -m64 -o example example.o -lkernel32 -lmsvcrt
```
Replace `example.asm` with the desired file name.

### Running the program

```bash
.\example.exe
```

### Examples
- `simple_memory_management.asm` (EX2): Demonstrates basic manual memory allocation and deallocation.
- `simple_memory_management_with_heap.asm` (EX1): Shows how to manage dynamic memory using the heap.
- `first_fit_allocation.asm` (EX3): Implements a first-fit allocation strategy with a custom memory pool.

## License
This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.
