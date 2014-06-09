shopt -s promptvars
export GIT_PS1_SHOWDIRTYSTATE=1
export GIT_PS1_SHOWUPSTREAM='verbose git'
export PS1='\[\033[1;36m\]\[\033[0m\]\[\033[1;34m\]\w\[\033[0m\] \[\033[1;32m\]$(__git_ps1)\[\033[0m\]\$ '

# Enable color support of ls
alias ls='ls --color=auto -alhX'