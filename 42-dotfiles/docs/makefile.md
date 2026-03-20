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
