# Art of Arm Assembly Learnings & Code examples


## commands, etc.

To compile:
```
as -arch arm64 listing1-1.s -o listing1-1.o
ld -o listing1-1 listing1-1.o -lSystem -syslibroot `xcrun -sdk macosx --show-sdk-path` -e _main -arch arm64
lldb ./listing1-1
```

```
g++ -o listing1-2 listing1-2.c listing1-2.s 
lldb ./listing-1.2
```

```
g++ -o listing1-examples listing1-examples.s
```

## lldb commands

```
// set breakpoint at symbol
b main

n
c

// read reg x1 value
read reg x1 
```