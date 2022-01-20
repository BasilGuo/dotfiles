" An example for a vimrc file.
"
" Maintainer:   Bram Moolenaar <Bram@vim.org>
" Last change:  2006 Nov 16
"
" To use it, copy it to
"     for Unix and OS/2:  ~/.vimrc
"             for Amiga:  s:.vimrc
"  for MS-DOS and Win32:  $VIM\_vimrc
"           for OpenVMS:  sys$login:.vimrc

" When started as "evim", evim.vim will already have done these settings.
if v:progname =~? "evim"
  finish
endif

" This must be first, because it changes other options as a side effect.
set nocompatible

" allow backspacing over everything in insert mode
set backspace=indent,eol,start

" no temp .swapfile
" set noswapfile

if has("vms")
  set nobackup          " do not keep a backup file, use versions instead
else
  set backup            " keep a backup file
endif
set history=50          " keep 50 lines of command line history
set ruler                   " show the cursor position all the time
set showcmd                 " display incomplete commands
set incsearch           " do incremental searching

" For Win32 GUI: remove 't' flag from 'guioptions': no tearoff menu entries
" let &guioptions = substitute(&guioptions, "t", "", "g")

" Don't use Ex mode, use Q for formatting
map Q gq

" In many terminal emulators the mouse works just fine, thus enable it.
"set mouse=a

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

  " Put these in an autocmd group, so that we can delete them easily.
  augroup vimrcEx
  au!

  " For all text files set 'textwidth' to 78 characters.
  autocmd FileType text setlocal textwidth=78

  " When editing a file, always jump to the last known cursor position.
  " Don't do it when the position is invalid or when inside an event handler
  " (happens when dropping a file on gvim).
  autocmd BufReadPost *
    \ if line("'\"") > 0 && line("'\"") <= line("$") |
    \   exe "normal! g`\"" |
    \ endif

  augroup END

else

  set autoindent                " always set autoindenting on

endif " has("autocmd")

" Convenient command to see the difference between the current buffer and the
" file it was loaded from, thus the changes you made.
command DiffOrig vert new | set bt=nofile | r # | 0d_ | diffthis
                \ | wincmd p | diffthis

"colo desert
colo delek
set number
set expandtab
set tabstop=4
set shiftwidth=4
set cino+=:0

set fileencodings=utf-8,gb2312,gbk,gb18030
set termencoding=utf-8
set fileformats=unix,dos
set encoding=prc

" reset the expandtab in the kernel source tree.
let linux = 0
let filename = argv(0)
let isdts = strridx(filename, ".dts")
let isdtsi = strridx(filename, ".dtsi")
if isdts != -1 || isdtsi != -1
    "echo "edit the device tree source, disable expandtab."
    set noexpandtab
    let linux = 1
else
    let isabspath = stridx(filename, "/")
    if isabspath == 0
        let dirlist = split(filename, "/")
        let parentdirlist = dirlist[:-2]
        let parentdir = join(parentdirlist, "/")
        let pwd = parentdir
    else
        if isabspath == -1
            let pwd = getcwd()
        else
            let dirlist = split(filename, "/")
            let parentdirlist = dirlist[:-2]
            let parentdir = join(parentdirlist, "/")
            let pwd = getcwd() . "/" . parentdir
        endif
    endif

    let cnt = 1
    while cnt < 20
        if filereadable(pwd . "/Kconfig")
            "echo "in linux kernel source tree, disable expandtab."
            set noexpandtab
            let linux = 1
            break
        else
            let pwd = pwd . "/.."
            let cnt = cnt + 1
        endif
    endwhile
endif

if linux == 0
autocmd BufWritePre * :%s/\s\+$//e
endif

let $CSCOPE_DB=$PWD . "/cscope.out"
let $CTAGS_DB=$PWD . "/tags"

if has("cscope")
        let current = $PWD
        let num = 1

        while num < 20
                if filereadable(current . "/cscope.out")
                        let $CSCOPE_DB = current . "/cscope.out"
                        let $CTAGS_DB = current . "/tags"
                        break
                else
                        let current = current . "/.."
                        let num = num + 1
                endif
        endwhile
endif

set csprg=/usr/bin/cscope
set csto=0
set cst
set nocsverb
set colorcolumn=90
cs add $CSCOPE_DB
set tags=$CTAGS_DB
set csverb

match Todo /\s\+$/

set cul " highlight current cusor line
set bdir=~/tmp
set dir=~/tmp/

""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
""""""""""""""""""" New File Predefined Text """""""""""""""""""""
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
"新建.c,.h,.sh,.java文件，自动插入文件头
autocmd BufNewFile *.cpp,*.[ch],*.sh,*.rb,*.java,*.py exec ":call SetTitle()"
""定义函数SetTitle，自动插入文件头
func SetTitle()
    "如果文件类型为.sh文件
    if &filetype == 'sh'
        call setline(1, "#!/usr/bin/env bash")
        call append(line("."),   "# Author:      basilguo@163.com")
        call append(line(".")+1, "# Date:        ".strftime("%Y-%m-%d %I:%M:%S"))
        call append(line(".")+2, "# File Name:   ".expand("%"))
        call append(line(".")+3, "# Version:     1.0.0")
        call append(line(".")+4, "# Description: ")
        call append(line(".")+5, "")
    elseif &filetype == 'python'
        call setline(1,          "#!/usr/bin/env python3")
        call append(line("."),   "# -*- coding: utf-8 -*-")
        call append(line(".")+1, "# Author:      basilguo@163.com")
        call append(line(".")+2, "# Date:        ".strftime("%Y-%m-%d %I:%M:%S"))
        call append(line(".")+3, "# File Name:   ".expand("%"))
        call append(line(".")+4, "# Version:     1.0.0")
        call append(line(".")+5, "# Description: ")
        call append(line(".")+6, "")
    elseif &filetype == 'ruby'
        call setline(1,"#!/usr/bin/env ruby")
        call append(line("."),   "# encoding:    utf-8")
        call append(line(".")+1, "# Author:      basilguo@163.com")
        call append(line(".")+2, "# Date:        ".strftime("%Y-%m-%d %I:%M:%S"))
        call append(line(".")+3, "# File Name:   ".expand("%"))
        call append(line(".")+4, "# Version:     1.0.0")
        call append(line(".")+5, "# Description: ")
        call append(line(".")+6, "")

    elseif &filetype == 'mkd'
        call setline(1,"<head><meta charset=\"UTF-8\"></head>")
    else
        call setline(1,          "/*************************************************************************")
        call append(line("."),   " * File Name:    ".expand("%"))
        call append(line(".")+1, " * Author:       basilguo@163.com")
        call append(line(".")+2, " * Created Time: ".strftime("%Y-%m-%d %I:%M:%S"))
        call append(line(".")+3, " * Description:  ")
        call append(line(".")+4, " ************************************************************************/")
        call append(line(".")+5, "")
    endif
    if expand("%:e") == 'cpp'
        call append(line(".")+6, "#include <iostream>")
        call append(line(".")+7, "using namespace std;")
        call append(line(".")+8, "")
    endif
    if &filetype == 'c'
        call append(line(".")+6, "#include <stdio.h>")
        call append(line(".")+7, "#include <stdlib.h>")
        call append(line(".")+8, "")
        " call append(line(".")+9, "int main(void)")
        " call append(line(".")+10, "{")
        " call append(line(".")+11, "    return 0;")
        " call append(line(".")+12, "}")
    endif
    if expand("%:e") == 'h'
        call append(line(".")+5, "#ifndef _".toupper(expand("%:r"))."_H")
        call append(line(".")+6, "#define _".toupper(expand("%:r"))."_H")
        call append(line(".")+7, "#endif")
    endif
    if &filetype == 'java'
        call append(line(".")+5,"public class ".expand("%:r")." {")
        call append(line(".")+6,"}")
    endif
endfunc
autocmd BufNewFile * normal G

" for ctags and cscope
" set tags+=/home/basil/code/sma-srv/tags
" let CSCOPE_DB="/home/basil/code/sma-srv/cscope.out"
" source ~/.vim/cscope_maps.vim
