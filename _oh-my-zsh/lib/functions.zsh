function zsh_stats() {
    history | awk '{CMD[$2]++;count++;}END { for (a in CMD)print CMD[a] " " CMD[a]/count*100 "% " a;}' | grep -v "./" | column -c3 -s " " -t | sort -nr | nl |  head -n20
}

function mv() {
    FILE="${@: -1}" # bash or ksh,zsh
    if [ -f $FILE ];
    then
        command mv -i $@
    else
        command mv $@
    fi
}

function dict(){
    word=$1
    TEMP="/tmp/dict.${word}"
    MEMO=~/.dict/`date +%G%m`
    command dict $word 1>$TEMP
    if [ -s $TEMP ]
    then
        less $TEMP
        echo $word >> $MEMO
        sort -u $MEMO -o $MEMO
    else
        echo 'spell error?'
    fi
}

function encode64(){ echo -n $1 | base64 }
function decode64(){ echo -n $1 | base64 -D }

function emacs() {
        if [[ $OSTYPE == "linux-gnu" ]] && [ $DISPLAY ]; then 
          command emacs -fs $@ &>/dev/null & disown
        else 
          command emacs -nw
        fi
}

function sudo() {
    if [ "$1" = init ] && [ -n "$SSH_CLIENT" ]; then
        echo >&2 "Never use init when ssh"
        return 1
    else
        command sudo "$@"
    fi
}

function clang-ll() {
    clang -std=c99 -emit-llvm -S $1 -o ${1%.*}.ll ${*:2}
}

function clean_llvm(){
    rm -rf klee-* LOG* *.bc *.ll
}

function cmake-ninja(){
    cmake -GNinja -DCMAKE_EXPORT_COMPILE_COMMANDS=ON $@ && ninja
}

function build_and_run_klee(){
    bc_file=${1%.*}.bc
    llvm-gcc $1 -c -emit-llvm -o ${bc_file}
    klee --max-time=120. -watchdog ${bc_file}
}

# Open the node api for your current version to the optional section.
function node-docs() {
    open "http://nodejs.org/docs/$(node --version)/api/all.html#all_$1"
}

function mcd() {
    mkdir -p "$1" && cd "$1";
}

function git-dl(){
    git_url=$1
    folder=${${git_url##*/}%%.*}
    git clone --depth 1 $1 $folder
    rm -rf $folder/.git
}

function pyclean() {
    ZSH_PYCLEAN_PLACES=${*:-'.'}
    find ${ZSH_PYCLEAN_PLACES} -type f -name "*.py[co]" -delete
}

function homebrew-backup () {
    echo '#!/bin/bash'
    echo ''
    echo 'failed_items=""'
    echo 'function install_package() {'
    echo 'echo EXECUTING: brew install $1 $2'
    echo 'brew install $1 $2'
    echo '[ $? -ne 0 ] && $failed_items="$failed_items $1"  # package failed to install.'
    echo '}'

    brew tap | while read tap; do echo "brew tap $tap"; done
    brew list | while read item;
                do
                    echo "install_package $item '$(brew info $item | grep 'Built from source with:' | sed 's/^[ \t]*Built from source with:/ /g; s/\,/ /g')'"
                done
    echo '[ ! -z $failed_items ] && echo The following items were failed to install: && echo $failed_items'
}

function git_prompt_info() {
  ref=$(git symbolic-ref HEAD 2> /dev/null) || return
    echo "$ZSH_THEME_GIT_PROMPT_PREFIX${ref#refs/heads/}$ZSH_THEME_GIT_PROMPT_SUFFIX"
}

# get the difference between the local and remote branches
git_remote_status() {
    remote=${$(git rev-parse --verify ${hook_com[branch]}@{upstream} --symbolic-full-name 2>/dev/null)/refs\/remotes\/}
    if [[ -n ${remote} ]] ; then
        ahead=$(git rev-list ${hook_com[branch]}@{upstream}..HEAD 2>/dev/null | wc -l)
        behind=$(git rev-list HEAD..${hook_com[branch]}@{upstream} 2>/dev/null | wc -l)

        if [ $ahead -eq 0 ] && [ $behind -gt 0 ]
        then
            echo "$ZSH_THEME_GIT_PROMPT_BEHIND_REMOTE"
        elif [ $ahead -gt 0 ] && [ $behind -eq 0 ]
        then
            echo "$ZSH_THEME_GIT_PROMPT_AHEAD_REMOTE"
        elif [ $ahead -gt 0 ] && [ $behind -gt 0 ]
        then
            echo "$ZSH_THEME_GIT_PROMPT_DIVERGED_REMOTE"
        fi
    fi
}

# Formats prompt string for current git commit short SHA
function git_prompt_short_sha() {
  SHA=$(git rev-parse --short HEAD 2> /dev/null) && echo "$ZSH_THEME_GIT_PROMPT_SHA_BEFORE$SHA$ZSH_THEME_GIT_PROMPT_SHA_AFTER"
}

# Formats prompt string for current git commit long SHA
function git_prompt_long_sha() {
  SHA=$(git rev-parse HEAD 2> /dev/null) && echo "$ZSH_THEME_GIT_PROMPT_SHA_BEFORE$SHA$ZSH_THEME_GIT_PROMPT_SHA_AFTER"
}

##########################################################################################
## linux only
##########################################################################################

function zshbuiltin-help(){
    man zshbuiltins | sed -ne "/^       $1 /,/^\$/{s/       //; p}"
}

function watchdir () {
    if [[ "$1" != "" ]]; then
        local dir="$1"; shift
        if [[ -x "`which inotifywait`" ]]; then
            ls $dir
            while true; do
                inotifywait -q $@ $dir
            done
        else
            echo "$0: inotifywait not found" > /dev/stderr
        fi
    else
        echo "Usage: $0 <dir> [-e event1 -e event2 ...]"
    fi
}

pdf-merge() {
    tomerge="";
    for file in "$@"; do
        tomerge=$tomerge" "$file;
    done
    pdftk $tomerge cat output mergd.pdf;
}
