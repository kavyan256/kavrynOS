# Ka-OS

A minimal educational operating system written in C for RISC-V 32-bit architecture. This OS demonstrates fundamental operating system concepts including process management, memory management, system calls, and file system operations.

## Features

### Core Functionality
- ✅ **Bare-metal Boot** - Boots directly on RISC-V hardware/emulator
- ✅ **Memory Management** - Page-based memory allocation with MMU support (SV32)
- ✅ **Process Management** - Multi-process support with context switching
- ✅ **System Calls** - User-to-kernel communication via `ecall` instruction
- ✅ **Trap Handling** - Exception and system call handling
- ✅ **SBI Interface** - OpenSBI for hardware abstraction

### Advanced Features
- 🗂️ **File System** - TAR-based file system with read/write operations
- 💾 **Disk I/O** - VirtIO block device driver for persistent storage
- 🔄 **Cooperative Multitasking** - Process scheduling with yield mechanism
- 📝 **Standard I/O** - Character input/output via UART

## System Calls

The OS supports the following system calls:

| System Call | Number | Description |
|------------|--------|-------------|
| `SYS_PUTCHAR` | 1 | Output a character to console |
| `SYS_GETCHAR` | 2 | Read a character from console |
| `SYS_EXIT` | 3 | Terminate the current process |
| `SYS_READFILE` | 4 | Read data from a file |
| `SYS_WRITEFILE` | 5 | Write data to a file |

## Architecture

### Memory Layout
- **Kernel Space**: Identity-mapped kernel code and data
- **User Space**: Mapped at `0x1000000` with separate page tables per process
- **Stack**: User stack at `0x1100000`, kernel stack per process
- **VirtIO Device**: Memory-mapped at `0x10001000`

### Process States
- `PROC_UNUSED` - Process slot available
- `PROC_RUNNABLE` - Process ready to run
- `PROC_EXITED` - Process has terminated

### File System
Uses TAR format for simplicity:
- Maximum 8 files (`FILES_MAX`)
- Maximum 1MB disk size (`DISK_MAX_SIZE`)
- 512-byte sectors (`SECTOR_SIZE`)
- In-memory caching with flush to disk on writes

## Building and Running

### Prerequisites
- **QEMU**: `qemu-system-riscv32`
- **LLVM/Clang**: Cross-compiler for RISC-V
- **llvm-objcopy**: For binary manipulation

#### Install Dependencies (Ubuntu/Debian)

```bash
sudo apt update && sudo apt install -y clang llvm lld qemu-system-riscv32
```

### Build Instructions

```bash
# Build and run the OS
./run.sh
```

The build script:
1. Compiles the user shell application
2. Embeds the shell binary into the kernel
3. Compiles the kernel
4. Launches QEMU with VirtIO block device

### Creating a Disk Image

```bash
# Create disk directory with files
mkdir -p disk
echo "Hello World!" > disk/hello.txt
echo "Test file" > disk/test.txt

# Create TAR archive
cd disk
tar cf ../disk.tar *
cd ..
```

### Extracting Files After Running

```bash
# Exit QEMU (Ctrl+A, then X)

# Extract and view files
mkdir tmp
cd tmp
tar xf ../disk.tar
cat hello.txt
```

## File Structure

```
KaOS/
├── kernel.c          # Kernel implementation
├── kernel.h          # Kernel headers and structures
├── kernel.ld         # Kernel linker script
├── user.c            # User-space library
├── user.h            # User-space headers
├── user.ld           # User linker script
├── shell.c           # User shell application
├── common.c          # Shared utility functions
├── common.h          # Shared headers and macros
├── run.sh            # Build and run script
├── disk.tar          # Disk image (TAR format)
└── disk/             # Source files for disk image
    └── hello.txt
```

## Example Usage

### Shell Application

```c
#include "user.h"

void main(void) {
    printf("Hello World from shell!\n");
    
    // Read a file
    char buf[256];
    int len = readfile("hello.txt", buf, sizeof(buf));
    if (len > 0) {
        printf("Read: ");
        for (int i = 0; i < len; i++) {
            putchar(buf[i]);
        }
        printf("\n");
    }
    
    // Write to a file
    writefile("hello.txt", "Updated content!", 16);
    
    exit();
}
```

## Technical Details

### Trap Handling
- Traps save all registers to kernel stack
- System call number in `a3` register
- Arguments in `a0`, `a1`, `a2`
- Return value in `a0`
- PC incremented by 4 after `ecall`

### VirtIO Block Device
- Uses virtqueues for request/response
- 3-descriptor chain per request
- Supports read and write operations
- Synchronous I/O with busy-wait

### Page Tables (SV32)
- Two-level page table structure
- 4KB pages
- Separate address space per process
- Kernel mapped in all address spaces

## Debugging

QEMU logs are written to `qemu.log` with:
- Unimplemented instructions
- Guest errors
- Interrupts
- CPU resets

## Limitations

- Maximum 8 processes
- No preemptive scheduling (cooperative only)
- Single-core only
- No dynamic memory allocation in userspace
- Fixed-size file system (1MB)
- No file creation/deletion (pre-created via TAR)

## Learning Resources

This OS demonstrates concepts from:
- RISC-V Privileged Specification
- VirtIO Specification v1.0
- TAR file format (USTAR)
- Operating Systems: Three Easy Pieces

## License

Educational project - feel free to use and modify for learning purposes.

## Acknowledgments

Based on educational OS development principles and inspired by various minimal OS implementations for RISC-V architecture.
