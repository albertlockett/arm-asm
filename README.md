# Arm Asm snippets and examples

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

Can use this if the listing file is pure C (e.g no `exter` "C"`) and avoid warnings
```
gcc -o listing1-5 ./listing1-5.c ./listing1-5.s
```

## lldb commands

```
// set breakpoint at symbol
b main

n
c

// read reg x1 value
read reg x1 

reg read // read all registers

// exit
q
```
