#!/bin/bash

# PROGRAM="alpha_mirror"
# PROGRAM="camel_to_snake"
# PROGRAM="ft_atoi"
# PROGRAM="ft_strcmp"
PROGRAM="ft_strdup"

result()
{ 
	./$PROGRAM 
}

camel()
{
	./$PROGRAM "hereIsACamelCaseWord"
	# here_is_a_camel_case_word
	./$PROGRAM "helloWorld" | cat -e
	# hello_world$
	./$PROGRAM | cat -e
}

a_mirror ()
{
	./$PROGRAM "abc"
	# zyx
	./$PROGRAM "My horse is Amazing." | cat -e
	# Nb slihv rh Znzarmt.$
	./$PROGRAM | cat -e 
}

echo "TESTING"
echo ""

cc -Wall -Wextra -Werror $PROGRAM.c -o $PROGRAM
#a_mirror
#camel
result

echo ""
echo "END TESTING"
echo ""