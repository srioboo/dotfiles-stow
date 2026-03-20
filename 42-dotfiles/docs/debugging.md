# GDB (GNU debuger)

1. compile a program
    
    ```shell
    gcc -g main.c -o program
    ```
the g flag is for allow debuging


2. execute with gdb

    ```shell
    gdb program
    ```

You will prompted, and you can write commands there, examples:

- **help**: show help
- **run**: execute the program
- **break**: break main, put a breakpoint in the main method
    - ex.- break 15 put in line 15 a breakpoint
- **next**: continue to the next line
- **step**: enter a function
- **print x**: show the variable value
- **set x = 42**: set the variable
    - **continue** after set
- **list**: list source code
- **backtrace**: show the previous steps

To si de memory:
x /20xb &p1

- **finish**: to end the process
- **quit**: end debuger
