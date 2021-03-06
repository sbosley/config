# Path to your oh-my-zsh configuration.
ZSH=$HOME/.oh-my-zsh

# Set name of the theme to load.
# Look in ~/.oh-my-zsh/themes/
# Optionally, if you set this to "random", it'll load a random theme each
# time that oh-my-zsh is loaded.
ZSH_THEME="robbyrussell"

# Example aliases
# alias zshconfig="mate ~/.zshrc"
# alias ohmyzsh="mate ~/.oh-my-zsh"

# Set to this to use case-sensitive completion
# CASE_SENSITIVE="true"

# Uncomment this to disable bi-weekly auto-update checks
# DISABLE_AUTO_UPDATE="true"

# Uncomment to change how often before auto-updates occur? (in days)
# export UPDATE_ZSH_DAYS=13

# Uncomment following line if you want to disable colors in ls
# DISABLE_LS_COLORS="true"

# Uncomment following line if you want to disable autosetting terminal title.
# DISABLE_AUTO_TITLE="true"

# Uncomment following line if you want to disable command autocorrection
# DISABLE_CORRECTION="true"

# Uncomment following line if you want red dots to be displayed while waiting for completion
# COMPLETION_WAITING_DOTS="true"

# Uncomment following line if you want to disable marking untracked files under
# VCS as dirty. This makes repository status check for large repositories much,
# much faster.
# DISABLE_UNTRACKED_FILES_DIRTY="true"

# Which plugins would you like to load? (plugins can be found in ~/.oh-my-zsh/plugins/*)
# Custom plugins may be added to ~/.oh-my-zsh/custom/plugins/
# Example format: plugins=(rails git textmate ruby lighthouse)
plugins=(git brew osx)

source $ZSH/oh-my-zsh.sh

# Customize to your needs...
ANDROID_SDK=/Users/sbosley/Library/Android/sdk
export PATH=$PATH:$ANDROID_SDK/tools:$ANDROID_SDK/platform-tools:$ANDROID_SDK/ndk-bundle

################################################################### prompt

# Copied and modified from robbyrussel theme
local ret_status="%(?:%{$fg[green]%}➜ :%{$fg[red]%}➜ )"
local hostname_prompt=$(if [[ -n $SSH_CLIENT ]]; then echo " %n@%M"; else echo ""; fi)
PROMPT='${ret_status}%{$reset_color%}${hostname_prompt} %{$fg_bold[cyan]%}%c%{$reset_color%} %F{033}$(git_prompt_info)%f % %{$reset_color%}'

ZSH_THEME_GIT_PROMPT_PREFIX="git:(%{$fg[red]%}"
ZSH_THEME_GIT_PROMPT_SUFFIX="%{$reset_color%}"
ZSH_THEME_GIT_PROMPT_DIRTY="%F{033}) %{$fg[yellow]%}✗%{$reset_color%}"
ZSH_THEME_GIT_PROMPT_CLEAN="%F{033})"
ZSH_THEME_GIT_PROMPT_BEHIND_REMOTE=" %{$fg_bold[magenta]%}↓%{$reset_color%}"
ZSH_THEME_GIT_PROMPT_AHEAD_REMOTE=" %{$fg_bold[magenta]%}↑%{$reset_color%}"
ZSH_THEME_GIT_PROMPT_DIVERGED_REMOTE=" %{$fg_bold[magenta]%}↕%{$reset_color%}"

#source ~/.zsh-extras/zsh-git-prompt/zshrc.sh

if [ -z "$HOSTNAME" ]; then
    HOSTNAME=$(hostname)
fi

RPS1=$'%{\e[0;33m%}%B(%D{%m-%d %H:%M})%b%{\e[0m%}'
RETURN_CODE=%(?.."%{${fg[red]}%}"[!]"%{${fg[default]}%}" )

export RPS1=${RETURN_CODE}${RPS1}

################################################################### env
EDITOR=atom

# return if not interactive
[ -z "$PS1" ] && return

################################################################### osx
if [ `uname` = "Darwin" ]; then
    alias ls='ls -G'
    export LSCOLORS=dxfxcxdxbxegedabagacad
    bindkey "\e[3~" delete-char
elif [ "$TERM" != "dumb" ]; then
    if [ -e "~/.dir_colors" ]; then
        eval `dircolors ~/.dir_colors`
    fi
    alias ls='ls --color'
fi

################################################################### java
export JAVA_HOME=$(/usr/libexec/java_home -v1.8)
# export J2OBJC_HOME=/Users/sbosley/Code/j2objc-1.1

################################################################### utilities
sloc () { # count sloc
    command find $1 -name "*.$2" | xargs wc -l | sort -n -r -k2
}

alias https='http --default-scheme=https'
