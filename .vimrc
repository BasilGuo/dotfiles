" An example for a vimrc file.
"
" Maintainer:	Bram Moolenaar <Bram@vim.org>
" Last change:	2006 Nov 16
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

" This must be first, because it changes other options as a side effect.
set nocompatible

" allow backspacing over everything in insert mode
set backspace=indent,eol,start

" no temp .swapfile
" set noswapfile

if has("vms")
  set nobackup		" do not keep a backup file, use versions instead
else
  set backup		" keep a backup file
endif
set history=50		" keep 50 lines of command line history
set ruler		    " show the cursor position all the time
set showcmd		    " display incomplete commands
set incsearch		" do incremental searching

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

  set autoindent		" always set autoindenting on

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
set bdir=/tmp
set dir=/tmp/

""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
""""""""""""""""""" New File Predefined Text """""""""""""""""""""
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" 在打开的文件中使用:set ft判断文件类，使用如下命令添加文件类型
" au BufRead,BufNewFile *.txt       setfiletype text
"新建.c,.h,.sh,.java文件，自动插入文件头
autocmd BufNewFile *.cpp,*.[ch],*.sh,*.rb,*.java,*.py,CMakeLists.txt exec ":call SetTitle()"
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
    elseif &filetype == 'cmake'
        call setline(1, "cmake_minimum_required(VERSION 3.5)")
        call append(line("."), "project(PROJECT_NAME)")
        call append(line(".")+1, "")
        call append(line(".")+2, "set(CMAKE_CXX_STANDARD 11)")
        call append(line(".")+3, "include_directories(include) # file .h")
        call append(line(".")+4, "aux_source_directory(./src DIR_SRCS) # file .cpp")
        call append(line(".")+5, "# aux_source_directory(./src/ddd DDIR)")
        call append(line(".")+6, "")
        call append(line(".")+7, "add_executable(BINARY ${DIR_SRCS})")
        call append(line(".")+8, "# add_executable(BINARY ${DIR_SRCS} ${DDIR})")
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
        call setline(1,          "/********************************************************************************")
        call append(line("."), "* MIT License")
        call append(line(".")+1, "*")
        call append(line(".")+2, "* Copyright (c) [".strftime("%Y")."] [Basil Guo]")
        call append(line(".")+3, "*")
        call append(line(".")+4, "* Permission is hereby granted, free of charge, to any person obtaining a copy")
        call append(line(".")+5, "* of this software and associated documentation files (the \"Software\"), to deal")
        call append(line(".")+6, "* in the Software without restriction, including without limitation the rights")
        call append(line(".")+7, "* to use, copy, modify, merge, publish, distribute, sublicense, and/or sell")
        call append(line(".")+8, "* copies of the Software, and to permit persons to whom the Software is")
        call append(line(".")+9, "* furnished to do so, subject to the following conditions:")
        call append(line(".")+10, "*")
        call append(line(".")+11, "* The above copyright notice and this permission notice shall be included in all")
        call append(line(".")+12, "* copies or substantial portions of the Software.")
        call append(line(".")+13, "*")
        call append(line(".")+14, "* THE SOFTWARE IS PROVIDED \"AS IS\", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR")
        call append(line(".")+15, "* IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,")
        call append(line(".")+16, "* FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE")
        call append(line(".")+17, "* AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER")
        call append(line(".")+18, "* LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,")
        call append(line(".")+19, "* OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE")
        call append(line(".")+20, "* SOFTWARE.")
        call append(line(".")+21, "*")
        call append(line(".")+22, "* File Name:    ".expand("%"))
        call append(line(".")+23, "* Author:       basilguo@163.com")
        call append(line(".")+24, "* Created Time: ".strftime("%Y-%m-%d %I:%M:%S"))
        call append(line(".")+25, "* Description:  ")
        call append(line(".")+26, "********************************************************************************/")
        call append(line(".")+27, "")
    endif
    if expand("%:e") == 'cpp'
        call append(line(".")+28, "#include <iostream>")
        call append(line(".")+29, "#include <string>")
        call append(line(".")+30, "#include <vector>")
        call append(line(".")+31, "#include <set>")
        call append(line(".")+32, "#include <map>")
        call append(line(".")+33, "#include <algorithm>")
        call append(line(".")+34, "using namespace std;")
        call append(line(".")+35, "")
    endif
    if &filetype == 'c'
        call append(line(".")+28, "#include <stdio.h>")
        call append(line(".")+29, "#include <stdlib.h>")
        call append(line(".")+30, "")
        call append(line(".")+31, "")
        call append(line(".")+32, "int main(int argc, char *argv[])")
        call append(line(".")+33, "{")
        call append(line(".")+34, "    return 0;")
        call append(line(".")+35, "}")
    endif
    if expand("%:e") == 'h'
        call append(line(".")+28, "#ifndef ".toupper(expand("%:r"))."_H")
        call append(line(".")+29, "#define ".toupper(expand("%:r"))."_H")
        call append(line(".")+30, "#endif // ".toupper(expand("%:r"))."_H")
    endif
    if &filetype == 'java'
        call append(line(".")+28, "package chap7_hiding;")
        call append(line(".")+29, "")
        call append(line(".")+30,"public class ".expand("%:r")." {")
        call append(line(".")+31,"}")
    endif
endfunc
autocmd BufNewFile * normal G

" get vim version
" https://www.zhihu.com/question/265267919
function! te#feat#get_vim_version() abort
    let l:result=[]
    if te#env#IsNvim()
        let v = api_info().version
        call add(l:result,'nvim')
        call add(l:result,printf('%d.%d.%d', v.major, v.minor, v.patch))
    else
        redir => l:msg
        silent! execute ':version'
        redir END
        call add(l:result,matchstr(l:msg,'VIM - Vi IMproved\s\zs\d.\d\ze'))
        call add(l:result, matchstr(l:msg, ':\s\d-\zs\d\{1,4\}\ze'))
    endif
    return l:result
endfunction

" for tab pages, requires vim version >= 7.0
" c means CTRL.
nnoremap <C-n> :tabnew<Space>
nnoremap <C-j> :tabnext<CR>
nnoremap <C-k> :tabprevious<CR>
nnoremap <C-c> :tabclose<CR>

" for ctags and cscope
" set tags+=/path/to/tags
" let CSCOPE_DB="/path/to/cscope.out"
" source ~/.vim/cscope_maps.vim
