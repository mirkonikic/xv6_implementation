# XV6 implementation

xv6 is a re-implementation of Dennis Ritchie's and Ken Thompson's Unix
Version 6 (v6).  xv6 loosely follows the structure and style of v6,
but is implemented for a modern x86-based multiprocessor using ANSI C.

ACKNOWLEDGMENTS

xv6 is inspired by John Lions's Commentary on UNIX 6th Edition (Peer
to Peer Communications; ISBN: 1-57398-013-7; 1st edition (June 14,
2000)). See also https://pdos.csail.mit.edu/6.828/, which
provides pointers to on-line resources for v6.

xv6 borrows code from the following sources:
    JOS (asm.h, elf.h, mmu.h, bootasm.S, ide.c, console.c, and others)
    Plan 9 (entryother.S, mp.h, mp.c, lapic.c)
    FreeBSD (ioapic.c)
    NetBSD (console.c)

The following people have made contributions: Russ Cox (context switching,
locking), Cliff Frey (MP), Xiao Yu (MP), Nickolai Zeldovich, and Austin
Clements.

The code in the files that constitute xv6 is
Copyright 2006-2018 Frans Kaashoek, Robert Morris, and Russ Cox.


### BUILDING AND RUNNING XV6
```
make        - to build xv6 image
make qemu   - to run inside Qemu virtual machine
```


### TODO: <br>
- [ ] Labs 2020 risc-v: https://pdos.csail.mit.edu/6.828/2020/index.html
- [ ] Labs 2018 x86   : https://pdos.csail.mit.edu/6.828/2018/xv6.html
- [ ] Labs 2019 x86   : https://www.cs.virginia.edu/~cr4bd/4414/F2019/assignments.html
