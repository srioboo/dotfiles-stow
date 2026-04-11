#!/bin/bash

# create new files with same name, diferent extension

show_files_extensions()
{
	for file in $(ls *.txt);
	do
		echo "file: $file"
		echo "basename: ${file%.*}"
		echo "extension: ${file#*.}"
	done
}


create_file_with_extension()
{
	for file in $(ls *.txt);
	do
		echo -e "create file: ${file%.*}.c from $file"
		# echo "basename: ${file%.*}.c"
		touch ${file%.*}.c
		echo -e "created\n"
	done
}

# show_files_extensions
create_file_with_extension