> This repo is for dotfiles.
>
> DISCLAIMER: I CANNOT PROMISE IT WOULD RUN AS YOU WANT.
> YOU MAY NEED TO MODIFY THE dotfiles BY YOURSELF.
> I JUST USE AND TEST AT Debian 12.5.
>
> As the saying goes: If you want something done right, do it yourself.
>
> Don't forget to backup your local `dotfiles` before copying.
>
> So, feel free to modify these dotfiles.

# dotfiles

## script

You can run `init.sh` when using basic configurations.
You can run `new-ubuntu.sh` cmd-by-cmd when polishing a new ubuntu VM.

## For Bash

> DIR: ~/

- `.bashrc`

The recommended way is to add following lines in your `~/.bashrc`.

```bash
if [ -f /PATH/TO/dotfiles/.bashrc ]; then
    . /PATH/TO/dotfiles/.bashrc
fi
```

- Running `. ~/.bashrc` after modification.
- You could just comment the line with `#` which is complained by bash.
- The most wrong place is at `Displayed title` when you use `scp`. Feel free to comment them.
- The another one is the color alias which in different version of Ubuntu.
- I just use Ubuntu server now, but the tty always complained when connected by `ssh`. So I commented them.
- etc.

THIS following TWO are not necessary and have been decoupled from `.bashrc`.
I have forgotten why I need them :).

- `.config/.colors.sh`
- `.config/git/.git_prompt.sh`

## For Git

> DIR: ~ and ~/.config/git

Creating `~/.gitconfig` if there is no such file.
And the only thing is to modify the include path.

Of course you could copy them to `~` simplifily.
BUT, REMEMBER TO MODIFY name AND email TO your name AND your email.

- `.config/git/.gitalias`
- `.config/git/.gitconfig`

If you don't want to copy the `.gitalias` to the default path, just modify the
`path` configuration in `~/.gitconfig`.

You could set the `.gitignore_global` as global `.gitignore` by setting
the optional configuration variable `core.excludesFile`.
A demo configuration is

```conf
[core]
    excludesfile = /PATH/TO/.gitignore_global
```

<s>
## For Neovim

> DIR: ~/.config/nvim

I'm changing my vim environment to neovim now. The neovim version is no lower than 0.8.

You could just copy the `.config/nvim` dir to `~/.config` directly and typed
`nvim` to init it. But your network should connect to github.com.
However, in this configuration, I failed to use the snippets.

The configuration I used is mainly copied from this airticle:
[Build your first Neovim configuration in lua | Devlog]
(https://vonheikemen.github.io/devlog/tools/build-your-first-lua-config-for-neovim/).
The author's nvim configuration is
[dotfiles/my-configs/neovim at master · VonHeikemen/dotfiles]
(https://github.com/VonHeikemen/dotfiles/tree/master/my-configs/neovim).
[nvim-lua/kickstart.nvim: A launch point for your personal nvim configuration]
(https://github.com/nvim-lua/kickstart.nvim) is also recommended by the author.

At the end, I try to use the kickstart instead of maintain my own nvim init.lua.
</s>

## For Vim

> DIR: ~/ and ~/.vim

Copy following files to `~`.
`cscope` and `ctags` should be installed before you use `cscope_maps.vim` plugin.
You could use `.vimrc` only if you like it.
But, don't forget to modify the block of `New File Predefined Text` in `.vimrc`.

- `.vim`: including some plugins.
- `.vimrc`
- `.gvimrc`: (not needed. This is for gvim and not updated accordingly.)

## For Tmux

> DIR: ~/

- `.config/tmux/tmux.conf`:
- When you use `man tmux`, you would know: "By default, tmux loads the system configuration file from /etc/tmux.conf, if present, then looks for a user configuration file at ~/.tmux.conf, $XDG_CONFIG_HOME/tmux/tmux.conf or ~/.config/tmux/tmux.conf." So in this way, you don't need to source them manually.

1. in a open tmux-session: Ctrl+B(leader key)
    `:source-file ~/.config/tmux/tmux.conf`
2. for global:  `tmux source-file ~/.config/tmux/tmux.conf`

## For XTerm

> DIR: ~/

Running `xrdb -merge ~/.Xresources` after modification.

I don't need this now :)

- `.Xresources`

# useful_tools.md

This introduces the effient tools for programming or using linux.
