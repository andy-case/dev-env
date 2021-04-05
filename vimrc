
" An example for a vimrc file.
"
" Maintainer:	Bram Moolenaar <Bram@vim.org>
" Last change:	2008 Dec 17
"
" To use it, copy it to
"     for Unix and OS/2:  ~/.vimrc
"	      for Amiga:  s:.vimrc
"  for MS-DOS and Win32:  $VIM\_vimrc
"	    for OpenVMS:  sys$login:.vimrc

" When started as "evim", evim.vim will already have done these settings.
if v:progname =~? "evim"
  finish
endif

" Use Vim settings, rather than Vi settings (much better!).
" This must be first, because it changes other options as a side effect.
set nocompatible

" allow backspacing over everything in insert mode
set backspace=indent,eol,start

if has("vms")
  set nobackup		" do not keep a backup file, use versions instead
else
  set backup		" keep a backup file
endif
set history=50		" keep 50 lines of command line history
set ruler		" show the cursor position all the time
set showcmd		" display incomplete commands
set incsearch		" do incremental searching

" For Win32 GUI: remove 't' flag from 'guioptions': no tearoff menu entries
" let &guioptions = substitute(&guioptions, "t", "", "g")

" Don't use Ex mode, use Q for formatting
map Q gq

" CTRL-U in insert mode deletes a lot.  Use CTRL-G u to first break undo,
" so that you can undo CTRL-U after inserting a line break.
inoremap <C-U> <C-G>u<C-U>

" In many terminal emulators the mouse works just fine, thus enable it.
" Setting mouse breaks highlight-copy in vim.  Instead, for cursor placement,
" use option-click.
"if has('mouse')
"  set mouse=a
"endif

" Switch syntax highlighting on, when the terminal has colors
" Also switch on highlighting the last used search pattern.
if &t_Co > 2 || has("gui_running")
  syntax on
  set hlsearch
endif

" Only do this part when compiled with support for autocommands.
if has("autocmd")

  " Enable file type detection.
  " Use the default filetype settings, so that mail gets 'tw' set to 72,
  " 'cindent' is on in C files, etc.
  " Also load indent files, to automatically do language-dependent indenting.
  filetype plugin indent on
  filetype on
  filetype plugin on

  " Put these in an autocmd group, so that we can delete them easily.
  augroup vimrcEx
  au!

  " For all text files set 'textwidth' to 78 characters.
  autocmd FileType text setlocal textwidth=78

  " When editing a file, always jump to the last known cursor position.
  " Don't do it when the position is invalid or when inside an event handler
  " (happens when dropping a file on gvim).
  " Also don't do it when the mark is in the first line, that is the default
  " position when opening a file.
  autocmd BufReadPost *
    \ if line("'\"") > 1 && line("'\"") <= line("$") |
    \   exe "normal! g`\"" |
    \ endif

  augroup END

else

  set autoindent		" always set autoindenting on

endif " has("autocmd")

" Convenient command to see the difference between the current buffer and the
" file it was loaded from, thus the changes you made.
" Only define it when not defined already.
if !exists(":DiffOrig")
  command DiffOrig vert new | set bt=nofile | r # | 0d_ | diffthis
		  \ | wincmd p | diffthis
endif

"
"personal stuff"
"

nnoremap @ga :!git add %
nnoremap @gd :!git diff %
nnoremap @gco :!git checkout -- %
nnoremap @pyf :!pyflakes %
nnoremap @ss :source ~/.vimrc

" Copy/paste to system clipboard.
set clipboard=unnamed


" 4-space tabs
set tabstop=4
set shiftwidth=4
set expandtab

" don't make a backup file on save
set nobackup
set nowritebackup

set dir=/tmp " where the swap file goes
"set number " number lines
set ignorecase " case-insensitive pattern-matching
set smartcase " smarter about sens/insens
set autoread " auto-refresh file if updated
set nowrap " don't wrap
set colorcolumn=73,80,101 " visual column color

"autocmd FileType python set complete+=k~/.vim/syntax/python.vim isk+=.,(

" Strip trailing whitespace.
autocmd BufWritePre * :%s/\s\+$//e

" Strip trailing newlines.
function StripEndLines()
    let save_cursor = getpos(".")
    :silent! %s#\($\n\s*\)\+\%$##
    call setpos('.', save_cursor)
endfunction
autocmd BufWritePre * call StripEndLines()

let g:pydiction_location = '~/.vim/complete-dict'

set statusline=%F\ %m%r[%{&ff}]%=%l/%L\ -\ %c "fullpath, modified, readonly, fileformat || current line, total lines, current column
set laststatus=2
set t_Co=256
set background=dark
let g:solarized_termtrans=1
let g:solarized_termcolors=256
colors solarized

call pathogen#infect()
let g:syntastic_python_checkers=['pep8', 'pylint', 'flake8', 'pyflakes']

" Don't write netrw history in .vim.
let g:netrw_dirhistmax=0
