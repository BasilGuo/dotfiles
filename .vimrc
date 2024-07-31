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
    set nobackup        " do not keep a backup file, use versions instead
else
    set backup          " keep a backup file
endif
set autoread            " reload the file when modified outside vim
set autowrite           " auto write file
set confirm             " need confirm when processing unsaved/readonly file
set backupdir=/tmp      " backup dir
set dir=/tmp            " directory for vim swap file

" In many terminal emulators the mouse works just fine, thus enable it.
" But it does not work as my expectation. Don't use it.
" set mouse=a

set history=50          " keep 50 lines of command line history
set ruler               " show the cursor position all the time
set showcmd             " display incomplete commands
set incsearch           " do incremental searching
set vb t_vb=            " no alarm
set cmdheight=1         " cmd line height
set laststatus=2        " display status line always
set number              " line nubmer
set colorcolumn=80      " color column 80, an verticle line
set relativenumber      " line relative number, e.g. 4,3,2,1,30,1,2,3
set cursorline          " highlight current cusor line
set whichwrap+=<,>,h,l  " cursor could be cross lines
set ttimeoutlen=0       " the <ESC> key response time
set cindent             " indent in the way of c/c++
set cinoptions=g0,:0,N-s,(0 " the indent format of c/c++
set expandtab           " tab => space
set tabstop=4           " 1 tab = 4 spaces, in editing
set shiftwidth=4        " 1 tab = 4 spaces, in formatting
set softtabstop=4       " 4 spaces = 1 tab
set smarttab            " use tab in the start of line/paragraph
set backspace=2         " process indent,eol,start,etc. with enter key
set sidescroll=0        " chars scroll to right
set sidescrolloff=4     " chars margin to right
set nofoldenable        " no code folded
set list lcs=tab:¦\     " enable the align line

" code/file encodings
set fileencodings=utf-8,gb2312,gbk,gb18030
set termencoding=utf-8
set fileformats=unix,dos
set encoding=utf-8

" open file to display the file with :ex
set path=**
set wildmenu

" enable term 256 colors
set t_Co=256
" Switch syntax highlighting on, when the terminal has colors
" Also switch on highlighting the last used search pattern.
if &t_Co > 2 || has("gui_running")
    syntax on       " syntax highlighting
    set hlsearch    " highlight search result
    set incsearch   " incremental search
    set smartcase   " smartly match the case, case insentive
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
        " Don't do it when the position is invalid or when inside an event
        " handler (happens when dropping a file on gvim).
        autocmd BufReadPost *
                    \ if line("'\"") > 0 && line("'\"") <= line("$") |
                    \   exe "normal! g`\"" |
                    \ endif
    augroup END

else
    set autoindent        " always set autoindenting on
endif " has("autocmd")

" For Win32 GUI: remove 't' flag from 'guioptions': no tearoff menu entries
" let &guioptions = substitute(&guioptions, "t", "", "g")

" Don't use Ex mode, use Q for formatting
map Q gq

" Convenient command to see the difference between the current buffer and the
" file it was loaded from, thus the changes you made.
command DiffOrig vert new | set bt=nofile | r # | 0d_ | diffthis
            \ | wincmd p | diffthis

colorscheme onedark
"colorscheme desert
"colorscheme delek

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

" remove trailing spaces
if linux == 0
    autocmd BufWritePre * :%s/\s\+$//e
endif

match Todo /\s\+$/

""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
""""""""""""""""""" New File Predefined Text """""""""""""""""""""
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Use `:set ft` to atest the file type in opening files and add filetypes with
" following command.
" au BufRead,BufNewFile *.txt       setfiletype text
"
" Insert the header automatically when crateing .c,.h,.sh,.java files
autocmd BufNewFile *.go,*.cpp,*.hpp,*.[ch],*.sh,*.rb,*.java,*.py,CMakeLists.txt,*.md exec ":call SetTitle()"
func SetTitle()
    if &filetype == 'go'
        call setline(1,             "// Author:      basilguo@163.com")
        call append(line(".")+0,    "// Date:        ".strftime("%Y-%m-%d %I:%M:%S"))
        call append(line(".")+1,    "// File Name:   ".expand("%"))
        call append(line(".")+2,    "// Version:     0.0.1")
        call append(line(".")+3,    "// Description: ")
        call append(line(".")+4,    "")
        call append(line(".")+5,    "package main")
        call append(line(".")+6,    "")
        call append(line(".")+7,    "import (")
        call append(line(".")+8,    "   \"fmt\"")
        call append(line(".")+9,    ")")
        call append(line(".")+10,   "")
        call append(line(".")+11,   "func main() {")
        call append(line(".")+12,   "}")
    elseif &filetype == 'sh'
        call setline(1,             "#!/usr/bin/env bash")
        call append(line(".")+0,    "# Author:      basilguo@163.com")
        call append(line(".")+1,    "# Date:        ".strftime("%Y-%m-%d %I:%M:%S"))
        call append(line(".")+2,    "# File Name:   ".expand("%"))
        call append(line(".")+3,    "# Version:     0.0.1")
        call append(line(".")+4,    "# Description: ")
        call append(line(".")+5,    "")
        call append(line(".")+6,    "set -eux")
    elseif &filetype == 'cmake'
        call setline(1,             "cmake_minimum_required(VERSION 3.21)")
        call append(line(".")+0,    "project(PROJECT_NAME VERSION 0.0.1)")
        call append(line(".")+1,    "")
        call append(line(".")+2,    "set(CMAKE_CXX_STANDARD 11)")
        call append(line(".")+3,    "include_directories(include) # file .h")
        call append(line(".")+4,    "aux_source_directory(./src DIR_SRCS) # file .cpp")
        call append(line(".")+5,    "# aux_source_directory(./src/ddd DDIR)")
        call append(line(".")+6,    "")
        call append(line(".")+7,    "add_executable(BINARY ${DIR_SRCS})")
        call append(line(".")+8,    "# add_executable(BINARY ${DIR_SRCS} ${DDIR})")
    elseif &filetype == 'python'
        call setline(1,             "#!/usr/bin/env python3")
        call append(line(".")+0,    "# -*- coding: utf-8 -*-")
        call append(line(".")+1,    "# Author:      basilguo@163.com")
        call append(line(".")+2,    "# Date:        ".strftime("%Y-%m-%d %I:%M:%S"))
        call append(line(".")+3,    "# File Name:   ".expand("%"))
        call append(line(".")+4,    "# Version:     0.0.1")
        call append(line(".")+5,    "# Description: ")
        call append(line(".")+6,    "")
        call append(line(".")+7,    "def main():")
        call append(line(".")+8,    "    pass")
        call append(line(".")+9,    "")
        call append(line(".")+10,   "")
        call append(line(".")+11,   "if __name__ == '__main__':")
        call append(line(".")+12,   "    main()")
    elseif &filetype == 'ruby'
        call setline(1,             "#!/usr/bin/env ruby")
        call append(line(".")+0,    "# encoding:    utf-8")
        call append(line(".")+1,    "# Author:      basilguo@163.com")
        call append(line(".")+2,    "# Date:        ".strftime("%Y-%m-%d %I:%M:%S"))
        call append(line(".")+3,    "# File Name:   ".expand("%"))
        call append(line(".")+4,    "# Version:     0.0.1")
        call append(line(".")+5,    "# Description: ")
        call append(line(".")+6,    "")
    elseif &filetype == 'markdown'
        call setline(1,             "# ".expand("%:r"))
        call append(line(".")+0,    "")
        call append(line(".")+1,    "> **Author**       <mailto:basilguo@163.com>")
        call append(line(".")+2,    ">")
        call append(line(".")+3,    "> **Date**         ".expand("%Y-%m-%d"))
        call append(line(".")+4,    ">")
        call append(line(".")+5,    "> **Description**  ")
        call append(line(".")+6,    "")
    else
        call setline(1,             "/********************************************************************************")
        call append(line(".")+0,    " * File Name:    ".expand("%"))
        call append(line(".")+1,    " * Author:       basilguo@163.com")
        call append(line(".")+2,    " * Version:      0.0.1")
        call append(line(".")+3,    " * Created Time: ".strftime("%Y-%m-%d %I:%M:%S"))
        call append(line(".")+4,    " * Description:  ")
        call append(line(".")+5,    " *******************************************************************************/")
        call append(line(".")+6,    "")
    endif

    if expand("%:e") == 'hpp'
        call append(line(".")+7,    "#ifndef ".toupper(expand("%:r"))."_HPP")
        call append(line(".")+8,    "#define ".toupper(expand("%:r"))."_HPP")
        call append(line(".")+9,    "")
        call append(line(".")+10,   "#endif // ".toupper(expand("%:r"))."_HPP")
    endif
    if expand("%:e") == 'cpp'
        call append(line(".")+7,    "#include <iostream>")
        call append(line(".")+8,    "#include <string>")
        call append(line(".")+9,    "#include <vector>")
        call append(line(".")+10,   "#include <set>")
        call append(line(".")+11,   "#include <map>")
        call append(line(".")+12,   "#include <algorithm>")
        call append(line(".")+13,   "using namespace std;")
        call append(line(".")+14,   "")
        call append(line(".")+15,   "int main(int argc, char *argv[])")
        call append(line(".")+16,   "{")
        call append(line(".")+17,   "    return 0;")
        call append(line(".")+18,   "}")
    endif
    if &filetype == 'c'
        call append(line(".")+7,    "#include <stdio.h>")
        call append(line(".")+8,    "#include <stdlib.h>")
        call append(line(".")+9,    "")
        call append(line(".")+10,   "int main(int argc, char *argv[])")
        call append(line(".")+11,   "{")
        call append(line(".")+12,   "    return 0;")
        call append(line(".")+13,   "}")
    endif
    if expand("%:e") == 'h'
        call append(line(".")+7,    "#ifndef ".toupper(expand("%:r"))."_H")
        call append(line(".")+8,    "#define ".toupper(expand("%:r"))."_H")
        call append(line(".")+9,    "")
        call append(line(".")+10,   "#endif // ".toupper(expand("%:r"))."_H")
    endif
    if &filetype == 'java'
        call append(line(".")+7,    "package xxx;")
        call append(line(".")+8,    "")
        call append(line(".")+9,    "public class ".expand("%:r")." {")
        call append(line(".")+10,   "}")
    endif
endfunc
autocmd BufNewFile * normal G

" Get vim version.
" But maybe not all vim are supported.
" Just have a try after uncomment this.
" <https://www.zhihu.com/question/265267919>
"
" function! te#feat#get_vim_version() abort
"     let l:result=[]
"     if te#env#IsNvim()
"         let v = api_info().version
"         call add(l:result,'nvim')
"         call add(l:result,printf('%d.%d.%d', v.major, v.minor, v.patch))
"     else
"         redir => l:msg
"         silent! execute ':version'
"         redir END
"         call add(l:result,matchstr(l:msg,'VIM - Vi IMproved\s\zs\d.\d\ze'))
"         call add(l:result, matchstr(l:msg, ':\s\d-\zs\d\{1,4\}\ze'))
"     endif
"     return l:result
" endfunction

" cscope enable
if has("cscope")
    call cscope_maps#EnableCscope()
endif

" move cursor in insert mode
imap <c-j> <down>
imap <c-k> <up>
imap <c-l> <right>
imap <c-h> <left>
inoremap <c-e> <end>
inoremap <c-a> <c-o>^
inoremap <c-d> <del>
inoremap <c-f> <c-o>W
inoremap <c-q> <c-o>dd


" for tab pages, requires vim version >= 7.0
let g:mapleader = "\<Space>"
let g:maplocalleader = ","
nnoremap <g f> <C-w> g f
nnoremap <leader>n :tabnew<Space>
nnoremap <leader>j :tabnext<CR>
nnoremap <leader>k :tabprevious<CR>
nnoremap <leader>c :tabclose<CR>
nnoremap <leader>w :bd<CR>
nnoremap <leader>f gg=G

" change window width
nnoremap <c-up> <c-w>+
nnoremap <c-down> <c-w>-
nnoremap <c-left> <c-w><
nnoremap <c-right> <c-w>>

" change window in normal
nnoremap <c-k> <c-w>k
nnoremap <c-j> <c-w>j
nnoremap <c-h> <c-w>h
nnoremap <c-l> <c-w>l
nnoremap <s-up>    <c-w>k
nnoremap <s-down>  <c-w>j
nnoremap <s-left>  <c-w>h
nnoremap <s-right> <c-w>l

" change window location
nnoremap <c-s-up> <c-w>K
nnoremap <c-s-down> <c-w>J
nnoremap <c-s-left> <c-w>H
nnoremap <c-s-right> <c-w>L
