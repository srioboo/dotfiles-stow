

## Gest ascii character

```shell
printf '%d' "'3" # example number 3 to ascii
```

iterate list
```shell
	while (aux)
	{
		if (aux->content)
			printf("c: %s\n", (char *)(aux->content));
		aux = aux->next;
	}
```

## Casting example

```c
#include <stdio.h>

int main() {
    int a = 5;
    int b = 2;

    // División sin casting: resultado entero
    int resultado_entero = a / b;

    // División con casting: resultado flotante
    float resultado_flotante = (float)a / b; // con casting
	// float resultado_flotante = a / b; // sin casting - esto dará un resultado diferente 

    printf("División sin casting (int): %d\n", resultado_entero);
    printf("División con casting (float): %.2f\n", resultado_flotante);

    return 0;
}
```
