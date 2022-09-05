# .bashrc
# Source global definitions
if [ -f /etc/bashrc ]; then
    . /etc/bashrc
fi

if [ -f /etc/bash_completion ] && ! shopt -oq posix; then
    . /etc/bash_completion
fi

# for git prompt, stolen from bash wiki.
if [ -f ~/.git_prompt.sh ]; then
    . ~/.git_prompt.sh
fi

# Stolen from zhanghuitao for cscope and ctags.
# This will be useful for C language.
function maketags()
{
    find -H $PWD -name "*.[chsS]" -o -name "*.cpp" > cscope.files
        cscope -bkq -i cscope.files
        ctags -L cscope.files
}

# Don't use only if you know what you does!
function makelinuxtags()
{
    lkr=$1
    arch=$2
    if [ -z "$lkr" ]; then lkr=$PWD; fi
    if [ -z "$arch" ]; then arch="x86"; fi
    find -H $lkr/include -name "*.[ch]" > cscope.files
        find -H $lkr/lib -name "*.[ch]" >> cscope.files
        find -H $lkr/kernel -name "*.[ch]" >> cscope.files
        find -H $lkr/mm -name "*.[ch]" >> cscope.files
        find -H $lkr/init -name "*.[ch]" >> cscope.files
        find -H $lkr/fs -name "*.[ch]" >> cscope.files
        find -H $lkr/arch/$arch -name "*.[ch]" >> cscope.files
        find -H $lkr/drivers/net -name "*.[ch]" >> cscope.files
        find -H $lkr/drivers/of -name "*.[ch]" >> cscope.files
        find -H $lkr/drivers/base -name "*.[ch]" >> cscope.files
        find -H $lkr/drivers/char -name "*.[ch]" >> cscope.files
        find -H $lkr/drivers/mtd -name "*.[ch]" >> cscope.files
        find -H $lkr/drivers/memory -name "*.[ch]" >> cscope.files
        find -H $lkr/drivers/spi -name "*.[ch]" >> cscope.files
        find -H $lkr/drivers/gpio -name "*.[ch]" >> cscope.files
        find -H $lkr/drivers/mmc -name "*.[ch]" >> cscope.files
        find -H $lkr/drivers/usb -name "*.[ch]" >> cscope.files
        find -H $lkr/net/core -name "*.[ch]" >> cscope.files
        find -H $lkr/net/ipv4 -name "*.[ch]" >> cscope.files
        find -H $lkr/net/ethernet -name "*.[ch]" >> cscope.files
        cscope -bkq -i cscope.files
        ctags -L cscope.files
}

################ FROM https://hub.fastgit.org/tomnomnom/dotfiles/blob/master/.bashrc #######################

# Modify the displayed title
# echo -ne '\033]0;New Title\a'
echo -ne '\033]0;Home sma\a'

# History control
HISTCONTROL=ignoredups:ignorespace
HISTSIZE=100000
HISTFILESIZE=2000000
shopt -s histappend

# COLOURS! YAAAY!
export EDITOR=/usr/bin/vim
export PATH=.:${PATH}
# Personal binaries
export PATH=${PATH}:~/bin:~/.local/bin:~/etc/scripts

# I'd quite like for Go to work please.
export PATH=${PATH}:/usr/local/go/bin
export GOPATH=~

# For RUST
if [ -f $HOME/.cargo ]; then
    export PATH="${PATH}:$HOME/.cargo/bin"
    . "$HOME/.cargo/env"
fi

function zhi() {
    echo -e "\033[0;31m[EXEC]: $@\033[0m"
    echo
    `"$@" > /dev/null`
    echo -e "\033[0;31m[DONE]: $@\033[0m"
}

# Change up a variable number of directories
# E.g:
#   cu   -> cd ../
#   cu 2 -> cd ../../
#   cu 3 -> cd ../../../
function cu {
    local count=$1
    if [ -z "${count}" ]; then
        count=1
    fi
    local path=""
    for i in $(seq 1 ${count}); do
        path="${path}../"
    done
    cd $path
}


# Open all modified files in vim tabs
function vimod {
    vim -p $(git status -suall | awk '{print $2}')
}

# Open files modified in a git commit in vim tabs; defaults to HEAD. Pop it in your .bashrc
# Examples:
#     virev 49808d5
#     virev HEAD~3
function virev {
    commit=$1
    if [ -z "${commit}" ]; then
        commit="HEAD"
    fi
    rootdir=$(git rev-parse --show-toplevel)
    sourceFiles=$(git show --name-only --pretty="format:" ${commit} | grep -v '^$')
    toOpen=""
    for file in ${sourceFiles}; do
        file="${rootdir}/${file}"
        if [ -e "${file}" ]; then
            toOpen="${toOpen} ${file}"
        fi
    done
    if [ -z "${toOpen}" ]; then
        echo "No files were modified in ${commit}"
        return 1
    fi
    vim -p ${toOpen}
}

# 'Safe' version of __git_ps1 to avoid errors on systems that don't have it
function gitPrompt {
    command -v __git_ps1 > /dev/null && __git_ps1 " (%s)"
}


####################### COLOURFUL
# Colours have names too. Stolen from Arch wiki
# https://wiki.archlinux.org/title/Color_output_in_console#Environment_variables
txtblk='\e[0;30m' # Black - Regular
txtred='\e[0;31m' # Red
txtgrn='\e[0;32m' # Green
txtylw='\e[0;33m' # Yellow
txtblu='\e[0;34m' # Blue
txtpur='\e[0;35m' # Purple
txtcyn='\e[0;36m' # Cyan
txtwht='\e[0;37m' # White
bldblk='\e[1;30m' # Black - Bold
bldred='\e[1;31m' # Red
bldgrn='\e[1;32m' # Green
bldylw='\e[1;33m' # Yellow
bldblu='\e[1;34m' # Blue
bldpur='\e[1;35m' # Purple
bldcyn='\e[1;36m' # Cyan
bldwht='\e[1;37m' # White
unkblk='\e[4;30m' # Black - Underline
undred='\e[4;31m' # Red
undgrn='\e[4;32m' # Green
undylw='\e[4;33m' # Yellow
undblu='\e[4;34m' # Blue
undpur='\e[4;35m' # Purple
undcyn='\e[4;36m' # Cyan
undwht='\e[4;37m' # White
bakblk='\e[40m'   # Black - Background
bakred='\e[41m'   # Red
badgrn='\e[42m'   # Green
bakylw='\e[43m'   # Yellow
bakblu='\e[44m'   # Blue
bakpur='\e[45m'   # Purple
bakcyn='\e[46m'   # Cyan
bakwht='\e[47m'   # White
txtrst='\e[0m'    # Text Reset

# Prompt colours
atC="${txtwht}"
nameC="${txtpur}"
hostC="${txtylw}"
pathC="${txtgrn}"
gitC="${txtpur}"
pointerC="${txtgrn}"
normalC="${txtwht}"

# Red name for root
if [ "${UID}" -eq "0" ]; then
    nameC="${txtred}"
fi

# Patent Pending Prompt
export PS1="${undblu}${nameBGC}${nameC}\u${atC}@${hostC}\h${normalC}:${pathC}\w${gitC}\$(gitPrompt)${pointerC}${normalC}\n\$ "

# colorful MAN pages
export LESS_TERMCAP_md=$'\e[01;31m'   # Start bold effect (double-bright).
export LESS_TERMCAP_me=$'\e[0m'       # Stop bold effect.
export LESS_TERMCAP_us=$'\e[1;4;32m'  # Start underline effect.
export LESS_TERMCAP_ue=$'\e[0m'       # Stop underline effect.
export LESS_TERMCAP_so=$'\e[1;45;93m' # Start stand-out effect (similar to reverse text).
export LESS_TERMCAP_se=$'\e[0m'       # Stop stand-out effect (similar to reverse text).

# after sudo apt install most
# export PARGER="most"
## export PARGER="/usr/bin/most -s"

if [ 'pts' != `tty | cut -d'/' -f3` ] # not ssh connection.
then
    ### fcitx
    export GTX_IM_MODULE=fcitx
    export QT_IM_MODULE=fcitx
    export XMODIFIERS="@im=fcitx"
    fcitx-autostart
fi

# alias
alias cdbin="cd /home/sma/sma-srv/debug/x86_64-linux-gnu/bin"
alias cdacs="cd /home/sma/sma-srv"
alias biggest="du -h --max-depth=1 | sort -h"
alias cdcpp='cd /home/basil/code/cpp/cpp_server_develop'
alias diff='diff --color=auto'
alias follow="tail -f -n +1"
alias grep='grep --color=auto'
alias ip='ip --color=auto'
alias ll='ls -ahl'
alias ls='/bin/ls -F --color=auto'
alias phpunit='phpunit --colors'
alias py3='python3'
alias remake='make clean; make'
alias rmtags='rm cscope.* tags'
alias vimpress="VIMENV=talk vim"
alias vi='/usr/bin/vim'
alias tn='tmux new-session -s'
alias ts='tn'
alias ta='tmux attach'
alias tt='tmux attach -t'
# browser
alias ff="firefox"
alias edge='microsoft-edge-stable'

# current working directory
alias cdd='cd /home/basil/code/c/test/ipc'

# tmux
alias ta='tmux attach'
alias ts='tmux new-session -s'
alias tls='tmux ls'
# Git
alias gpom='git push -u origin master'
alias gs='git status'
alias gg='git grep -ni'
alias g='git'
alias cdd='cd /home/basil/code/c/projects'
alias cdd='cd /home/basil/code/c/projects/c_interfaces_and_implementations_techniques_for_creating_reusable_software'
