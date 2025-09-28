#!/usr/bin/env bash
# Author:      basilguo@163.com
# Date:        2025-09-27 11:19:56
# File Name:   init.sh
# Version:     0.0.1
# Description:

set -eux

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
# echo $SCRIPT_DIR
# echo $PWD

# backup
if [ -d $HOME/.config ]; then
    mv $HOME/.config    $HOME/.config_bak
fi

if [ -d $HOME/.vim ]; then
    mv $HOME/.vim       $HOME/.vim_bak
fi
if [ -f $HOME/.vimrc ]; then
    mv $HOME/.vimrc     $HOME/.vimrc_bak
fi

# dotfiles
if [ -f $HOME/.bashrc ]; then
    echo ". $PWD/.bashrc" >> $HOME/.bashrc
else
    cp $SCRIPT_DIR/.bashrc $HOME
fi
cp -r $SCRIPT_DIR/.config $HOME
cp -r $SCRIPT_DIR/.vim    $HOME
cp -r $SCRIPT_DIR/.vimrc  $HOME

# directories
mkdir -p $HOME/.local/src
mkdir -p $HOME/.local/lib
mkdir -p $HOME/.local/go/src
mkdir -p $HOME/.local/go/bin
mkdir -p $HOME/.local/go/pkg
