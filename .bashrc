# ~/.bashrc: executed by bash(1) for non-login shells.
# see /usr/share/doc/bash/examples/startup-files (in the package bash-doc)
# for examples

# If not running interactively, don't do anything
[ -z "$PS1" ] && return

# don't put duplicate lines or lines starting with space in the history.
# See bash(1) for more options
HISTCONTROL=ignoreboth

# append to the history file, don't overwrite it
shopt -s histappend

# for setting history length see HISTSIZE and HISTFILESIZE in bash(1)
HISTSIZE=1000
HISTFILESIZE=2000

# check the window size after each command and, if necessary,
# update the values of LINES and COLUMNS.
shopt -s checkwinsize

# If set, the pattern "**" used in a pathname expansion context will
# match all files and zero or more directories and subdirectories.
#shopt -s globstar

# make less more friendly for non-text input files, see lesspipe(1)
#[ -x /usr/bin/lesspipe ] && eval "$(SHELL=/bin/sh lesspipe)"

# set variable identifying the chroot you work in (used in the prompt below)
if [ -z "$debian_chroot" ] && [ -r /etc/debian_chroot ]; then
    debian_chroot=$(cat /etc/debian_chroot)
fi

# set a fancy prompt (non-color, unless we know we "want" color)
case "$TERM" in
    xterm-color) color_prompt=yes;;
esac

# uncomment for a colored prompt, if the terminal has the capability; turned
# off by default to not distract the user: the focus in a terminal window
# should be on the output of commands, not on the prompt
force_color_prompt=yes

if [ -n "$force_color_prompt" ]; then
    if [ -x /usr/bin/tput ] && tput setaf 1 >&/dev/null; then
  # We have color support; assume it's compliant with Ecma-48
  # (ISO/IEC-6429). (Lack of such support is extremely rare, and such
  # a case would tend to support setf rather than setaf.)
  color_prompt=yes
    else
  color_prompt=
    fi
fi

parse_git_branch() {
     git branch 2> /dev/null | sed -e '/^[^*]/d' -e 's/* \(.*\)/ (\1)/';
}

if [ "$color_prompt" = yes ]; then
#    PS1='${debian_chroot:+($debian_chroot)}\[\033[01;32m\]\u@\h\[\033[00m\] \[\033[01;34m\]\w \$\[\033[00m\] '
PS1='\[\033[01;30m\]\t `if [ $? = 0 ]; then echo "\[\033[01;32m\]ツ"; else echo "\[\033[01;31m\]✗"; fi` \[\033[01;32m\]\u@\h\[\033[01;34m\]:\w\[\033[00m\]$(__git_ps1)\[\033[00m\] > '
else
    PS1='${debian_chroot:+($debian_chroot)}\u@\h:\w\$ '
fi
unset color_prompt force_color_prompt

# If this is an xterm set the title to user@host:dir
case "$TERM" in
xterm*|rxvt*)
    PS1="\[\e]0;${debian_chroot:+($debian_chroot)}\u@\h: \w\a\]$PS1"
    ;;
*)
    ;;
esac

# enable color support of ls and also add handy aliases
if [ -x /usr/bin/dircolors ]; then
    test -r ~/.dircolors && eval "$(dircolors -b ~/.dircolors)" || eval "$(dircolors -b)"
    alias ls='ls --color=auto'
    #alias dir='dir --color=auto'
    #alias vdir='vdir --color=auto'

    alias grep='grep --color=auto'
    alias fgrep='fgrep --color=auto'
    alias egrep='egrep --color=auto'
fi

# add my scripts folder to my path
PATH=/home/pi/scripts/:"$PATH"

# custom functions
bu() { cp "$@" "$@.backup-`date +%s`"; echo "`date +%Y-%m-%d` backed up $PWD/$@" >> ~/.backups.log; } 
colortail() { tail -500 $*|ccze -A; }

# some more ls aliases
alias ll='ls -alh'
alias la='ls -A'
alias l='ls -CF'
alias c='clear'
alias nano='sudo nano'

# SAMBA Start, Stop, and Restart
alias sambarestart='sudo service smbd restart'
alias sambastop='sudo service smbd stop'
alias sambastart='sudo service smbd start'

# SQUID Start, Stop, and Restart
alias squidrestart='sudo service squid restart'
alias squidstop='sudo service squid stop'
alias squidstart='sudo service squid start'

# PRIVOXY Start, Stop, and Restart
alias proxyrestart='sudo service privoxy restart'
alias proxystop='sudo service privoxy stop'
alias proxystart='sudo service privoxy start'

# TOR Start, Stop, and Restart
alias torrestart='sudo service tor restart'
alias torstop='sudo service tor stop'
alias torstart='sudo service tor start'

#restart proxy chain
alias chainrestart='sudo service privoxy restart && sudo service squid restart'

#my scripts
#alias backup='/home/pi/scripts/backup'
alias tv='exp openelec ssh root@openelec.lan -p 22'
alias tm='exp gibson ssh Paul@timemachine.lan -p 22'
alias ps='ps -elf | grep'
#alias update='sudo apt-get update -y && sudo apt-get upgrade -y'
alias install='sudo apt-get install'
alias nocomment='sudo grep -Ev '\''^(#|$)'\'''
alias firewall='sudo iptables -L -n -v --line-numbers'
alias startup="sudo chkconfig --list | grep $(runlevel | awk '{ print $2}'):on"
alias eb="sudo nano ~/.bashrc"
alias loadbash=". ~/.bashrc"
alias ct='colortail'
alias log='colortail /var/log/syslog'
alias weather='curl wttr.in/London'
alias moon='curl wttr.in/moon'
alias fuck='sudo $(history -p \!\!)'
alias docker='sudo docker'
alias ports='sudo netstat -tulpn'

# Show all logs in /var/log
alias logs="sudo find /var/log -type f -exec file {} \; | grep 'text' | cut -d' ' -f1 | sed -e's/:$//g' | grep -v '[0-9]$' | xargs tail -f"
alias weblogs="tail -n 100 -f /var/log/nginx/access.log"

# Alias definitions.
# You may want to put all your additions into a separate file like
# ~/.bash_aliases, instead of adding them here directly.
# See /usr/share/doc/bash-doc/examples in the bash-doc package.

if [ -f ~/.bash_aliases ]; then
    . ~/.bash_aliases
fi

# enable programmable completion features (you don't need to enable
# this, if it's already enabled in /etc/bash.bashrc and /etc/profile
# sources /etc/bash.bashrc).
if [ -f /etc/bash_completion ] && ! shopt -oq posix; then
    . /etc/bash_completion
fi

let upSeconds="$(/usr/bin/cut -d. -f1 /proc/uptime)"
let secs=$((upSeconds%60))
let mins=$((upSeconds/60%60))
let hours=$((upSeconds/3600%24))
let days=$((upSeconds/86400))
UPTIME=$(printf "%d days, %02dh%02dm%02ds" "$days" "$hours" "$mins" "$secs")

ponyArray[0]="rainbow"
ponyArray[1]="rainbowsalute"
ponyArray[2]="rainbowfim"
ponyArray[3]="rainbowfly"
ponyArray[4]="rainbowgala"
ponyArray[5]="rainbowhurricane"
ponyArray[6]="rainbowsleep"

rand=$[ RANDOM % 7 ]

ponysay -o -f ${ponyArray[$rand]}

echo "
$(date +"%A, %e %B %Y, %r")
$(uname -srmo)$(tput setaf 5)
$(tput setaf 190)$(df -h | grep Filesystem)$(tput setaf 190)
$(tput setaf 190)$(df -h|grep /dev/sda1)$(tput setaf 190)

Uptime.............: ${UPTIME}
IP Address.........: $(ifconfig eth1 | grep 'inet'| grep -v '127.0.0.1' | cut -d ' ' -f10 | awk '{ printf "%s ", $1}') $(tput setaf 7)
"

# setup python environment wrapper homes
#export WORKON_HOME=~/Envs
#source /usr/local/bin/virtualenvwrapper.sh > /dev/null 2>&1

