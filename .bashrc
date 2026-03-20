# Prompt
PS1='$(git branch &>/dev/null; if [ $? -eq 0 ]; then \
     echo "\[\033[00;33m\][\t] \[\033[01;32m\]\u \[\033[01;34m\]\w \[\033[0;33m\][$(git branch | grep ^* | sed s/\*\ //)]\[\e[0m\] \n\[\033[00;36m\]$ \[\033[00m\] "; else \
     echo "\[\033[00;33m\][\t] \[\033[01;32m\]\u \[\033[01;34m\]\w \n\[\033[00;36m\]$ \[\033[00m\]"; fi )'
# Enable autocomplete
eval "$(/opt/homebrew/bin/brew shellenv)"
[[ -r "/opt/homebrew/etc/profile.d/bash_completion.sh" ]] && . "/opt/homebrew/etc/profile.d/bash_completion.sh"

# Alias
alias ls='ls --color=auto'
alias ll='ls -alFG'
