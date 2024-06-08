# ~/.bashrc: executed by bash(1) for non-login shells.
# see /usr/share/doc/bash/examples/startup-files (in the package bash-doc)
# for examples

basher_version="0.1.0"

working_repo='repo_name'
repos_path='~/repos'
working_env='venv'

function basher(){
    echo ''
    echo 'Basher Version: '$basher_version
    echo ''
    
    echo 'working_repo='$working_repo
    echo 'working_env='$working_env
    echo 'repos_path='$repos_path
    echo ''
}
alias basher='basher'

# -----
# Workspaces aliases
# -----
alias setenv='source '$working_env'/bin/activate'
alias sv='source ./venv/bin/activate'
alias ws="cd "$repos_path"/"$working_repo"; setenv"
alias wr="ws; workon "$working_repo"; setenv; shell"
alias cdr="cd "$repos_path"/"$working_repo

# -----
# OS related aliases
# -----
alias icloud='cd ~/Library/Mobile\ Documents/com~apple~CloudDocs'

# -----
# Dev search aliases
# -----
#alias codesearch="grep --color=always -nr $1 --exclude-dir='.git' --exclude-dir=node_modules --exclude-dir=venv"
alias codesearch='function _codesearch() {
    local pattern="$1"
    grep -nr --color=always "$pattern" ./ --exclude-dir=".git" --exclude-dir=node_modules --exclude-dir=venv | awk '"'"'
    {
        filename_color = "\033[35m";
        line_number_color = "\033[32m";
        reset_color = "\033[0m";
        pattern_color = "\033[01;31m";
        pattern = "'"'"'"$pattern"'"'"'";

        # Split the input line into filename, line number, and the rest
        n = split($0, parts, /:/);
        if (n >= 3) {
            filename = parts[1];
            line_number = parts[2];
            line_content = substr($0, length(filename) + length(line_number) + 3);

            # Replace the pattern in the line content
            gsub(pattern, pattern_color pattern reset_color, line_content);

            # Print the colored output
            print filename_color filename reset_color ":" line_number_color line_number reset_color ":" line_content;
        } else {
            print $0;
        }
    }'"'"'
}; _codesearch'
alias cs='codesearch'

# -----
# Git related aliases
# -----
alias gitlc="git log --format='%h %Cgreen%ar%Creset %s' $(git rev-parse --abbrev-ref HEAD) --not $(git merge-base $(git rev-parse --abbrev-ref HEAD) main)"
alias gitlb="git for-each-ref --sort=-committerdate refs/remotes/origin --format='%(committerdate:relative)%09 %(refname:short)'"
alias gitu="git config user.email"
alias gitsu="git config --global user.email $1"

# enable tab completion for git on linux
# source /usr/share/bash-completion/completions/git
# source /usr/share/bash_completion.d/completions/git-completion.bash
# source /usr/local/etc/bash_completion.d/git-completion.bash

# enable tab completion for git on mac
source /Library/Developer/CommandLineTools/usr/share/git-core/git-completion.bash

# -----
# ls aliases
# -----
alias ls="ls -Glha --color=auto"
alias ll='ls -alF'
alias la='ls -A'
alias l='ls -CF'

# -----
# Git push functions / alias
# -----
function git_branch(){
    git branch 2>/dev/null | sed -n '/\* /s///p'
}

function git_commit_msg() {
    git log -1 --pretty=%B
}

function git_check_uncommitted_changes() {
    if output=$(git status --porcelain) && [ -z "$output" ]; then
        echo "No uncommitted changes."
    else
        echo -e "There are\033[1;33m uncommitted changes\033[0m in the current branch."
    fi
}

function git_commit_timestamp() {
    git log -1 --format=%cd
}

function git_push() {
    echo ""
    local current_user=$(git config user.email)
    local current_commit_msg=$(git_commit_msg)
    local current_commit_timestamp=$(git_commit_timestamp)
    local current_branch=$(git_branch)
    
    echo -e "Current user:   \033[0;31m$current_user\033[0m"
    echo -e "Current commit: \033[01;34m$current_commit_msg\033[00m"
    echo -e "Commit time:    $current_commit_timestamp"
    echo -e "Current branch: \033[01;35m$current_branch\033[00m"
    git_check_uncommitted_changes
    echo ""
    read -p $'Proceed push to \e[01;35m'"$current_branch"$'\e[00m ? (Y/n) [Y]: ' confirmation
    if [[ $confirmation == "y" || $confirmation == "Y" || $confirmation == "" ]]; then
        git push origin $current_branch
    else
        echo "Push aborted."
    fi
}

alias gp='git_push'

# -----
# Environment variable exports
# -----
export PATH="$HOME/.local/bin:$PATH"
# export VIRTUALENVWRAPPER_PYTHON=/usr/bin/python3
# export VIRTUALENVWRAPPER_VIRTUALENV=/usr/bin/virtualenv
# export PROJECT_HOME=$HOME/Devel
# export WORKON_HOME=$HOME/Envs
# source /usr/local/bin/virtualenvwrapper.sh

# export PYTHONPATH=~/repo/repo_name

# -----
# Google cloud aliases
# -----

# export GOOGLE_APPLICATION_CREDENTIALS=/app/credentials.json
#alias get_kubernetes='gcloud container clusters get-credentials tagx-2 --zone us-central1-a --project infoxel-tagx'
#alias get_elastic='gcloud container clusters get-credentials elastic-cluster --zone us-central1-a --project infoxel-support'
#alias srv_db='sudo gcloud compute ssh --zone "us-central1-a" "media-db" --tunnel-through-iap --project "infoxel-tagx" -- -L 8432:localhost:6432 -N -f'
#alias kill_srv_db='sudo pkill -f "8432:localhost:6432"'
#alias srv_elastic='(sudo gcloud container clusters get-credentials elastic-cluster --zone us-central1-a --project infoxel-support; kubectl port-forward --namespace default raw-master-0 9200:9200)'
#alias srv_elastic_bg='(sudo gcloud container clusters get-credentials elastic-cluster --zone us-central1-a --project infoxel-support; kubectl port-forward --namespace default raw-master-0 9200:9200) &'
#alias srv_sources='gcloud container clusters get-credentials elastic-cluster --zone us-central1-a --project infoxel-support; kubectl port-forward --namespace default sources-client-0 9200'
#alias srv_audiomatch='gcloud container clusters get-credentials elastic-cluster --zone us-central1-a --project infoxel-support; kubectl port-forward --namespace default audiomatch-client-2 9203:9200'
#alias srv_whisper='kubectl port-forward $(kubectl get pod --selector="app=mlflow-whisper-s2t" --output jsonpath='{.items[0].metadata.name}') 8091:5000'
#alias srv_clickhouse='clickhouse-client --host="clickhouse.host.com" --port=9000 --user=default --password=abc12345'
#alias srv_yolo='gcloud container clusters get-credentials tagx-2 --zone us-central1-a --project infoxel-tagx && kubectl port-forward $(kubectl get pod --selector="app=mlflow-yolo-detection" --output jsonpath="{.items[0].metadata.name}") 8080:5000'
#alias srv_imatch='gcloud container clusters get-credentials tagx-2 --zone us-central1-a --project infoxel-tagx && kubectl port-forward $(kubectl get pod --selector="app=dsys" --output jsonpath="{.items[0].metadata.name}") 8099:80'
#alias srv_entities='kubectl port-forward $(kubectl get pod --selector="app=mlflow-ner-v2" --output jsonpath="{.items[0].metadata.name}") 8089:5000'
#alias srv_transcript='kubectl port-forward $(kubectl get pod --selector="app=mlflow-whisper-s2t" --output jsonpath="{.items[0].metadata.name}") 8091:5000'
#alias log_datadog='kubectl logs -f $(kubectl get pod --selector="app=datadog" --output jsonpath='{.items[0].metadata.name}')'
#alias log_predicttag='kubectl logs -f $(kubectl get pod --selector="app=complete-predicted-tag" --output jsonpath='{.items[0].metadata.name}')'
#alias srv_mediacoverage='kubectl exec -it $(kubectl get pod --selector="app=media-coverage" --output jsonpath='{.items[0].metadata.name}') -- bash'
#alias log_mediacoverage='kubectl logs -f $(kubectl get pod --selector="app=media-coverage" --output jsonpath='{.items[0].metadata.name}')'
#alias ssh_tagx='gcloud compute ssh tagx-apps --project infoxel-tagx'
#alias ssh_mediadb='gcloud compute ssh media-db --project infoxel-tagx'
#alias ssh_asrun='gcloud compute ssh dtv-integration --project infoxel-tagx'
#alias ssh_dns='gcloud compute ssh dns --project infoxel-tagx'
#alias ssh_clickhouse='gcloud compute ssh clickhouse --project infoxel-tagx'
 
# -----
# Django aliases
# -----

# alias pypath='export PYTHONPATH=$(pwd)'
# alias staging_db='cd ~/repo/repo_name; workon repo_name; set -o allexport; source $(pwd)/environments/remote*; set +o allexport; set -o allexport; source $(pwd)/environments/staging*; set +o allexport; python service/manage.py dbshell'
# alias staging_debug='cd ~/repo/repo_name; workon repo_name; set -o allexport; source $(pwd)/environments/remote*; set +o allexport; set -o allexport; source $(pwd)/environments/staging*; set +o allexport'
alias runserver='python service/manage.py runserver'
alias runiserver='python manage.py runserver 0.0.0.0:8000'
alias shell='python service/manage.py shell_plus'
alias test='pytest'
alias stest='pytest -vv -s'
alias unmigrated="python service/manage.py showmigrations | grep '\[ \]\|^[a-z]' | grep '[  ]' -B 1"
# alias kubelog="kubectl logs -f $(kubectl get pod --selector='app=$1' --output jsonpath='{.items[0].metadata.name}')"

# -----
# Enviroments
# -----
alias env_local='set -o allexport; source $(pwd)/environments/local*; set +o allexport'
alias env_remote='set -o allexport; source $(pwd)/environments/remote*; set +o allexport'
alias env_staging='set -o allexport; source $(pwd)/environments/staging*; set +o allexport'
alias env_prod='set -o allexport; source $(pwd)/environments/prod*; set +o allexport'

# ---
# Color python error output
# ---

norm="$(printf '\033[0m')" #returns to "normal"
bold="$(printf '\033[0;1m')" #set bold
red="$(printf '\033[0;31m')" #set red
boldyellowonblue="$(printf '\033[0;1;33;44m')" #set blue bkgrd, bold yellow text
boldyellow="$(printf '\033[0;1;33m')" #set gold yellow text
boldred="$(printf '\033[0;1;31m')" #set bold red

# Color error messages from python, use as "copython test.py" instead of "python test.py"
# WARNING: Takes time to run (small but noticeable)
# May also interfer with print to console (for long running programs)
copython() {
    
    python $@ 2>&1 | sed -e "s/Traceback/${boldyellowonblue}&${norm}/g" \
        -e "s/File \".*\.py\".*$/${boldyellow}&${norm}/g" \
        -e "s/\, line [[:digit:]]\+/${boldred}&${norm}/g"
    
    # python $@ 2>&1 | sed -e "s/Traceback/${boldyellowonblue}&${norm}/g" \
    #    -e "s/File \".*\.py\".*$/${bold}&${norm}/g" \
    #    -re "s/\, line [0-9]\+/${boldred}&${norm}/g" \
    #    -re "s/ {4}(.*)$/${boldyellow}&${norm}/g" \
    #    -e "s/.*Error:.*$/${boldred}&${norm}/g" \
    }

# If not running interactively, don't do anything
case $- in
    *i*) ;;
      *) return;;
esac

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
[ -x /usr/bin/lesspipe ] && eval "$(SHELL=/bin/sh lesspipe)"

# set variable identifying the chroot you work in (used in the prompt below)
if [ -z "${debian_chroot:-}" ] && [ -r /etc/debian_chroot ]; then
    debian_chroot=$(cat /etc/debian_chroot)
fi

# set a fancy prompt (non-color, unless we know we "want" color)
case "$TERM" in
    xterm-color|*-256color) color_prompt=yes;;
esac

# uncomment for a colored prompt, if the terminal has the capability; turned
# off by default to not distract the user: the focus in a terminal window
# should be on the output of commands, not on the prompt
#force_color_prompt=yes

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

parse_git_branch(){
    git branch 2>/dev/null | sed -n '/\* /s///p'
}

update_prompt(){
    #PS1="< \[$(tput setaf 3)\]${VIRTUAL_ENV##*/}\[\033[00m\]:\[\033[01;38m\]$ENV\[\033[00m\] \[\033[00m\]>\[$(tput sgr0)\] ${debian_chroot:+($debian_chroot)}\[\033[01;33m\]\u\[\033[01;32m\]@\h\[\033[00m\]:\[\033[01;34m\]\w\[\033[00m\] \[\033[01;35m\]{\[\$(parse_git_branch)\]} \[\033[00m\]\n\$ "
    PS1="\[$(tput sgr0)\]${debian_chroot:+($debian_chroot)}\[\033[01;33m\]\u\[\033[01;32m\]@\h\[\033[00m\]:\[\033[01;34m\]\w\[\033[00m\] \[\033[01;35m\]{\[\$(parse_git_branch)\]} \[\033[00m\]\n\$ "
}

if [ "$color_prompt" = yes ]; then
    update_prompt
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
    #test -r ~/.dircolors && eval "$(dircolors -b ~/.dircolors)" || eval "$(dircolors -b)"
    #alias dir='dir --color=auto'
    #alias vdir='vdir --color=auto'

    alias grep='grep --color=auto'
    alias fgrep='fgrep --color=auto'
    alias egrep='egrep --color=auto'
fi

# colored GCC warnings and errors
# export GCC_COLORS='error=01;31:warning=01;35:note=01;36:caret=01;32:locus=01:quote=01'

# Add an "alert" alias for long running commands.  Use like so:
#   sleep 10; alert
alias alert='notify-send --urgency=low -i "$([ $? = 0 ] && echo terminal || echo error)" "$(history|tail -n1|sed -e '\''s/^\s*[0-9]\+\s*//;s/[;&|]\s*alert$//'\'')"'

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
if ! shopt -oq posix; then
  if [ -f /usr/share/bash-completion/bash_completion ]; then
    . /usr/share/bash-completion/bash_completion
  elif [ -f /etc/bash_completion ]; then
    . /etc/bash_completion
  fi
fi
