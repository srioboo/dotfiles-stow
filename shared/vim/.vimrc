"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" => General
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
syntax on		" activate vim syntax coloring
set number		" enable numbers 'set nu' for short
set ru			" enable row numbers
set mouse=a		" allow cursor movement by clicking
" set expandtab		" use spaces instead of tabs
set smarttab		" be smart when using tabs 
set shiftwidth=4	" set (1 tab == 4 spaces)
" set tabstop=4

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" => Indentation
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
set autoindent		" enable autoindent 'set ai' for short
set si			" smart indent
set wrap		" enable lines wrapping
" set cindent		" enable c lang indent
set tabstop=4		" this enable vscode format like alignement

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" => key bindings
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Copy and paste to system clipboard
vmap <Leader>y "+y
vmap <Leader>d "+d
nmap <Leader>p "+p
nmap <Leader>P "+P
vmap <Leader>p "+p
vmap <Leader>P "+P
" nnoremap q <c-v>	" wsl avoid ctrl+v

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" => Add the 42 stdheader command
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
try
	source /.vim/stdheader.vim
catch
	" silently fail if there is no stdheader file
endtry

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" = > Add Plugins, be iMproved
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
set nocompatible
filetype off " required

" set the runtime path to include Vundle an initialize
try
	set rtp+=~/.vim/bundle/Vundle.vim
	call vundle#begin()

	" plugins
	"" NERDTree
	Plugin 'scrooloose/nerdtree'


	call vundle#end()			" required
	filetype plugin indent on 	" required
catch
	" if can't load bundle, no info it is show
endtry


