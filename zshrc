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
export PATH=$PATH:/usr/local/git/bin:/Users/Sam/Code/android-sdk-mac_x86/tools:/Users/Sam/Code/android-sdk-mac_x86/platform-tools:/Users/Sam/.rvm/gems/ruby-1.9.3-p0/bin:/Users/Sam/.rvm/gems/ruby-1.9.3-p0@global/bin:/Users/Sam/.rvm/rubies/ruby-1.9.3-p0/bin:/Users/Sam/.rvm/bin:/usr/bin:/bin:/usr/sbin:/sbin:/usr/local/bin:/usr/local/git/bin

################################################################### prompt

# Copied and modified from robbyrussel theme
export PROMPT='%{$fg[red]%}# %{$fg[cyan]%}%c %{$fg_bold[blue]%}$(git_prompt_info)%{$fg_bold[blue]%} % %{$reset_color%}'

ZSH_THEME_GIT_PROMPT_PREFIX="git:(%{$fg[red]%}"
ZSH_THEME_GIT_PROMPT_SUFFIX="%{$reset_color%}"
ZSH_THEME_GIT_PROMPT_DIRTY="%{$fg[blue]%}) %{$fg[yellow]%}✗%{$reset_color%}"
ZSH_THEME_GIT_PROMPT_CLEAN="%{$fg[blue]%})"
ZSH_THEME_GIT_PROMPT_BEHIND_REMOTE="%{$fg_bold[magenta]%}↓%{$reset_color%}"
ZSH_THEME_GIT_PROMPT_AHEAD_REMOTE="%{$fg_bold[magenta]%}↑%{$reset_color%}"
ZSH_THEME_GIT_PROMPT_DIVERGED_REMOTE="%{$fg_bold[magenta]%}↕%{$reset_color%}"

#source ~/.zsh-extras/zsh-git-prompt/zshrc.sh

if [ -z "$HOSTNAME" ]; then
    HOSTNAME="%m"
fi

RPS1=$'%{\e[0;33m%}%B(%D{%m-%d %H:%M})%b%{\e[0m%}'
RETURN_CODE=%(?.."%{${fg[red]}%}"[!]"%{${fg[default]}%}" )

export RPS1=${RETURN_CODE}${RPS1}

################################################################### env
EDITOR=vim

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

################################################################### utilities
function freq() {
    sort $* | uniq -c | sort -rn;
}

# from zsh-users
edit_command_line () {
    # edit current line in $EDITOR
    local tmpfile=${TMPPREFIX:-/tmp/zsh}ecl$$
 
    print -R - "$PREBUFFER$BUFFER" >$tmpfile
    exec </dev/tty
    e $tmpfile
    zle kill-buffer
    BUFFER=${"$(<$tmpfile)"/$PREBUFFER/}
    CURSOR=$#BUFFER
 
    command rm -f $tmpfile
    zle redisplay
}
zle -N edit_command_line
 
# ever used this :?
edit_command_output () {
    local output
    output=$(eval $BUFFER) || return
    BUFFER=$output
    CURSOR=0
}
zle -N edit_command_output