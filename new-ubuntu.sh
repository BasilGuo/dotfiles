# #!/usr/bin/env bash
# Author:      basilguo@163.com
# Date:        2024-08-06
# File Name:   new-vm.sh
# Version:
#   - 0.0.6 fix: \ in export
#   - 0.0.5 backup apt source before modification
#   - 0.0.4 add tig, text-mode interface for Git
#   - 0.0.3 Polish a new Ubuntu 22.04 server VM. Install some applications, software, and/or libraries.

# Choose one mirror for speed up, such as, https://mirrors.tuna.tsinghua.edu.cn/help/ubuntu/
# sudo mv /etc/apt/sources.list /etc/apt/sources.list.bak
# sudo vim /etc/apt/sources.list # Modify /etc/apt/sources.list according to guidance.
# Enable multiverse repository if you like.
# sudo sed -i "/^# deb.*multiverse/ s/^# //" /etc/apt/sources.list
# Then
sudo apt update

# Language
export LANGUAGE=en_US.UTF-8
export LANG=en_US.UTF-8
export LC_ALL=en_US.UTF-8
sudo locale-gen en_US.UTF-8
sudo dpkg-reconfigure locales

# Necessary packages.
sudo apt install -y htop openssh-server curl wget fzf rsync openssl \
                    autoconf automake libtool make build-essential gdb cmake pkg-config \
                    vim git tig tmux cscope universal-ctags bison flex perl install-info \
                    python3 python-is-python3 python3-pip python3-venv python3-dev

# Python
sudo apt install -y python3-sphinx
pip install virtualenv requests

# ops may need
sudo apt install -y mtr iperf3

# dev may need
sudo apt install -y libssl-dev openssl-dev libcurl4-openssl-dev \
                    libpython3-dev \
                    libc-ares-dev libreadline6 libreadline-dev \
                    libgit2-dev libsqlite3-dev libxml2-dev libjson-c-dev \
                    libpam0g-dev libsnmp-dev libcap-dev libelf-dev libunwind-dev \
                    protobuf-c-compiler libprotobuf-c-dev \
                    zlib1g-dev

# You may also need clash and cpolar. But this is not supplied with apt.

# dotfiles
mkdir -p ~/downloads; cd ~/downloads; git clone https://github.com/BasilGuo/dotfiles.git
if [ -f ~/.bashrc ]; then
	echo ". ~/downloads/dotfiles/.bashrc" >> ~/.bashrc
else
	cp ~/downloads/dotfiles/.bashrc ~ # or just:
fi
source ~/.bashrc
cp -r ~/downloads/dotfiles/.vimrc ~
cp -r ~/downloads/dotfiles/.vim ~
cp -r ~/downloads/dotfiles/.gitconfig ~ # you need to modify [user] configuration
cp -r ~/downloads/dotfiles/.config ~
