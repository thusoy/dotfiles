# Uncomment the following line if you want to change the command execution time
# stamp shown in the history command output.
# You can set one of the optional three formats:
# "mm/dd/yyyy"|"dd.mm.yyyy"|"yyyy-mm-dd"
# or set a custom format using the strftime function format specifications,
# see 'man strftime' for details.
HIST_STAMPS="yyyy-mm-dd"

# append to the history file, don't overwrite it
unsetopt share_history
setopt APPEND_HISTORY

# Save timestamp and execution time in history
setopt EXTENDED_HISTORY

# Don't add to history if identical to previous
setopt HIST_IGNORE_DUPS

# Set total history size
HISTSIZE=10000
SAVEHIST=10000

# Don't write some common commands to history to remove some junk
HISTORY_IGNORE="(exit|ls *|ll *|g st|history|clear|cd *)"

# Case-insensitive completion
autoload -Uz compinit && compinit
zstyle ':completion:*' matcher-list 'm:{a-z}={A-Za-z}'

# Use menu selector for autocomplete
zstyle ':completion:*' menu select

# Enable bash-style interactive comments
setopt interactivecomments

# Enable paramter and function substition in prompt
setopt PROMPT_SUBST

# Configure history behavior to ignore space-prefixed lines
setopt HIST_IGNORE_SPACE

# Prepend cd to directory names automatically
setopt AUTOCD

# Enable colors
autoload -U colors && colors

# If not running interactively, don't do anything
case $- in
    *i*) ;;
      *) return;;
esac

find_git_branch() {
    local branch
    if branch=$(git rev-parse --abbrev-ref HEAD 2> /dev/null); then
        if [[ "$branch" == "HEAD" ]]; then
            echo ' detached*'
        else
            echo " ($branch)"
        fi
    fi
}

function check_last_exit_code() {
    # From https://zenbro.github.io/2015/07/23/show-exit-code-of-last-command-in-zsh
    local LAST_EXIT_CODE=$?
    if [[ $LAST_EXIT_CODE -ne 0 ]]; then
        local EXIT_CODE_PROMPT=' '
        EXIT_CODE_PROMPT+="%{$fg[red]%}-%{$reset_color%}"
        EXIT_CODE_PROMPT+="%{$fg_bold[red]%}$LAST_EXIT_CODE%{$reset_color%}"
        EXIT_CODE_PROMPT+="%{$fg[red]%}-%{$reset_color%}"
        echo "$EXIT_CODE_PROMPT"
    fi
}

# Show the previous exit code in the right-hand prompt if non-zero
RPROMPT='$(check_last_exit_code)'

# Customize the standard prompt
PROMPT='%n:%1~$(find_git_branch) $ '

# Alias definitions.
. ~/.zsh_aliases

export EDITOR=vim

# Configure locale
export LANG=en_US.UTF-8
export LC_ALL=en_US.UTF-8
export LC_TIME=en_GB.UTF-8

# Auto-complete git commands
zstyle ':completion:*:*:git:*' script ~/.git-completion.zsh

# Highlight section titles in manual pages.
export LESS_TERMCAP_md="${yellow}";
export GEM_HOME=~/.local/gem
export GEM_PATH=~/.local/gem

# Don't clear the screen after quitting a manual page.
export MANPAGER='less -X';

# MacPorts installs to /opt/local
export MANPATH="/opt/local/man:$MANPATH"
export PATH="/opt/local/bin:/opt/local/sbin:$PATH:$HOME/.local/bin:$HOME/.cargo/bin:$HOME/.local/gem/bin"
export LDFLAGS=-L/opt/local/lib
export CFLAGS=-I/opt/local/include
export CPPFLAGS=-I/opt/local/include

# Key bindings for line navigation
bindkey "[D" backward-word # alt-left
bindkey "[C" forward-word # alt-right
bindkey "^[a" beginning-of-line # ctrl-a
bindkey "^[e" end-of-line # ctrl-e
bindkey "^[[H" beginning-of-line  # home
bindkey "^[[F" end-of-line # end

# Ignore everything after the cursor for completion
bindkey '\CI' expand-or-complete-prefix

# Increase key repeat rate
defaults write -g InitialKeyRepeat -int 10
defaults write -g KeyRepeat -int 1

# Enable color support of ls
if [ -x /opt/local/bin/gdircolors ]; then
    test -r ~/.dircolors && eval "$(gdircolors -b ~/.dircolors)" || eval "$(gdircolors -b)"
fi
