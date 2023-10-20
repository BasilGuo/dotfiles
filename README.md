> This repo is for dotfiles.

# dotfiles

## For Bash

> DIR: ~/, running `. ~/.vimrc` after modification.

- `.bashrc`
- `.colors.sh`
- `.git_prompt.sh`

## For Git

> DIR: ~/

Creating `~/.gitconfig` if there is no such file.
And the only thing is to modify the include path.

Of course you could copy them to `~` simplifily.
BUT, REMEMBER TO MODIFY name AND email TO your name AND your email.

- `.gitalias`
- `.gitconfig

## For Vim

> DIR: ~/

copy following files to `~` and `.vim/cscope_maps.vim` to `~/.vim`

- `.vimrc`
- `.gvimrc`

## For Tmux

> DIR: ~/.config/tmux/

- `.tmux.conf`:

    1. in a open tmux-session: Ctrl+B(leader key) `:source-file ~/.config/tmux/.tmux.conf`
    2. for global:  `tmux source-file ~/.tmux.conf`

## For XTerm

> DIR: ~/, running `xrdb -merge ~/.Xresources` after modification.

- `.Xresources`

# useful_tools.md

This introduces the effient tools for programming or using linux.
