> This repo is for dotfiles.
>
> DISCLAIMER: I CANNOT PROMISE IT WOULD RUN AS YOU WANT.
> YOU MAY NEED TO MODIFY THE dotfiles BY YOURSELF.
> I JUST USE AND TEST AT Ubuntu 20.04.
>
> As the saying goes: If you want something done right, do it yourself.
>
> Don't forget to backup your local `dotfiles` before copying.
>
> So, feel free to modify these dotfiles.

# dotfiles

## For Bash

> DIR: ~/

- `.bashrc`

The recommended way is to add following lines in your `~/.bashrc`.

```bash
if [ -f /path/to/dotfiles/.bashrc ]; then
    . /path/to/dotfiles/.bashrc
fi
```

- Running `. ~/.bashrc` after modification.
- You could just comment the line with `#` which is complained by bash.
- The most wrong place is at `The displayed title` when you use `scp`. Feel free to comment them.
- The another one is the color alias which in different version of Ubuntu.
- I just use Ubuntu server now, but the tty always complained when connected by `ssh`. So I commented them.
- etc.

THIS following TWO are not necessary and have been decoupled from `.bashrc`.
I have forgotten why I need them :).

- `.colors.sh`
- `.git_prompt.sh`

## For Git

> DIR: ~/

Creating `~/.gitconfig` if there is no such file.
And the only thing is to modify the include path.

Of course you could copy them to `~` simplifily.
BUT, REMEMBER TO MODIFY name AND email TO your name AND your email.

- `.gitalias`
- `.gitconfig`

If you don't want to copy the `.gitalias` to `~`, just modify the
`path` configuration in `~/.gitconfig`.

## For Vim

> DIR: ~/

Copy following files to `~` and `.vim/cscope_maps.vim` to `~/.vim`.

Well, I have also forgotten why I need `.vim/cscope_maps.vim`.
You could just use `.vimrc` if you like it.
But, don't forget to modify the block of `New File Predefined Text`.

- `.vim`
- `.vimrc`
- `.gvimrc`

## For Tmux

> DIR: ~/

- `.tmux.conf`:

1. in a open tmux-session: Ctrl+B(leader key) `:source-file ~/.config/tmux/.tmux.conf`
2. for global:  `tmux source-file ~/.tmux.conf`

## For XTerm

> DIR: ~/

Running `xrdb -merge ~/.Xresources` after modification.

I don't need this now :)

- `.Xresources`

# useful_tools.md

This introduces the effient tools for programming or using linux.
