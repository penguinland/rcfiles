# ~/.zshrc
# This line gets rid of a "compaudit:117: unknown group" that is displayed at
# the very beginning for no apparent reason.
clear

umask 022
# Add this line to make your own bin file
export PATH="/home/alan/bin:$PATH"

export PAGER="/usr/bin/less"
export EDITOR="/usr/bin/vim"

set history=1000
set autolist=true
set notify=true
set noclobber
unset autologout

# suggested for zsh by Mac
zstyle ':completion:*' use compctl false
autoload -U compinit promptinit
# The following line doesn't seem to work on Duke computers.
compinit
promptinit
export PROMPT='%B%(?..[%?] )%b%n-%F{green}%U%T%u%f>'
export RPROMPT='%F{green}%~%f'

#eval `dircolors -b /etc/DIR_COLORS`
#alias acroread="~/bin/acroread"
alias view="vim -R"
alias veiw="vim -R"
alias viwe="vim -R"
alias ivew="vim -R"
alias viw="vim -R"
alias vmi="vim"
alias gerp="grep"
alias pwmd="pwd"
alias wich='which'

alias one_line="tr '\n' ','"

#alias d="ls -G"
# On Macs, you have to use `ls -G` instead of `ls --color=auto`
# Similarly, use -c instead of --sort=time
alias ls="ls --color=auto"
alias ll="ls --color=auto -lha"
alias lt="ls --color=auto -lha --sort=time"
alias ltd="ls -lh|grep '^d'|sed 's/^.*[ ]//g'|column"
alias l="ls -lha|less"

alias h="history"

alias t='top -d 0.5'

alias thefirefox='firefox -ProfileManager -no-remote'
alias thechrome='chromium-browser --incognito'

# If you add yourself to a group, you're not in it until the next time you log
# out and log back in. This is a kludge to get a single terminal in which
# you're part of the new group, without having to exit everything.
alias updategroups='exec su -l alan'

alias hexdump='hexdump -C'

alias aoeu='setxkbmap us'
#alias asdf='setxkbmap dvorak'       # Ubuntu 23.10 and earlier?
alias asdf='setxkbmap "us(dvorak)"'  # Ubuntu 24.04 and later?
setxkbmap -option ctrl:nocaps
# A way of escaping the times when you hit capslock and then remap capslock to control:
alias SETXKBMAP='setxkbmap -option'

# Print the contents of a directory when you cd to it.
chpwd () {
  ls
}

alias gcont='git rebase --continue'
alias gredo='git reset --mixed HEAD^'  # To redo the current git commit

# Remove our aliases to deleted remote branches, to improve tab completion
alias gcleanup='git fetch --prune --all'

alias ding='say done'

source ~/git.sh

export PATH="/home/alan/.local/bin:$PATH"
