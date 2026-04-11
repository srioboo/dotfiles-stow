# Documentación

## Makefile

```make
NAME=libft.a
CC=cc
CFLAGS=-Wall -Werror -Wextra
CFILES= ft_isalpha.c
OFILES=$(CFILES:.c=.o)

all: $(NAME) clean

$(NAME): $(OFILES)
	ar rcs $(NAME) $(OFILES)

clean:
	rm -f $(OFILES)

fclean: clean 
	rm -f ${NAME}

re: fclean $(NAME)
```
Donde:
NAME -> variable que define el nombre de la librerías a generar
CC, CFLAGS -> variables que definen el compilador y los flags
CFILES, OFILES -> variables que definen los ficheros de entrada (.c) y los de salida (.o)

OFILES se genera a partir de las CFILES ???

A continuación están las tareas que se lanzan con make:

- all: ejectua la generacion y realiza un clean de los outputs
- $(NAME): ¿?¿?¿?¿
- clean: borra los outputs
- fclean: borra los outputs y el compilado
- re: borra los output y el compilado y vuelve a ejecutar

## Compilar con liberia libft.c

Necesario previamente ejecutar la compilacion para generar la librería (libft.a)

```shell
cc -Wall -Wextra -Werror main.c libft.a -o nombre_ejecutable
```

## GDB (GNU debuger)

1. compile a program
    
    ```shell
    gcc -g main.c -o program
    ```
    the g flag is for allow debuging

    Program example:

    ```c
    #include <stdio.h>
    #include <string.h>

    typedef struct {
        char nombre[50];
        int edad;
    } Persona;

    void inicializarPersona(Persona *p, const char *nombre, int edad) {
        strcpy(p->nombre, nombre);
        p->edad = edad;
    }

    int calcularPromedio(int suma, int cantidad) {
        if (cantidad == 0) {
            printf("Error: División por cero\n");
            return -1; // Indicador de error
        }
        return suma / cantidad;
    }

    int main() {
        Persona p1, p2;
        inicializarPersona(&p1, "Alice", 30);
        inicializarPersona(&p2, "Bob", 25);

        printf("Persona 1: %s, Edad: %d\n", p1.nombre, p1.edad);
        printf("Persona 2: %s, Edad: %d\n", p2.nombre, p2.edad);

        int totalEdad = p1.edad + p2.edad;
        int promedio = calcularPromedio(totalEdad, 0); // Error lógico

        printf("Promedio de edad: %d\n", promedio);
        return 0;
    }
    ```

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
