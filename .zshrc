# Enable Powerlevel10k instant prompt. Should stay close to the top of ~/.zshrc.
# Initialization code that may require console input (password prompts, [y/n]
# confirmations, etc.) must go above this block; everything else may go below.
if [[ -t 0 && -t 1 && -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi

# Oh-my-zsh installation path
ZSH=/usr/share/oh-my-zsh/

# Powerlevel10k theme path
if [[ -r /usr/share/zsh-theme-powerlevel10k/powerlevel10k.zsh-theme ]]; then
  source /usr/share/zsh-theme-powerlevel10k/powerlevel10k.zsh-theme
fi

# List of plugins used
plugins=(git sudo fzf zsh-autosuggestions zsh-syntax-highlighting)
if [[ -r "$ZSH/oh-my-zsh.sh" ]]; then
  source "$ZSH/oh-my-zsh.sh"
fi

setopt autocd hist_ignore_all_dups hist_find_no_dups share_history auto_pushd pushd_ignore_dups

HISTFILE="$HOME/.zsh_history"
HISTSIZE=10000
SAVEHIST=10000

if command -v code >/dev/null 2>&1; then
  export EDITOR="code --wait"
else
  export EDITOR="vi"
fi
export VISUAL="$EDITOR"

if command -v atuin >/dev/null 2>&1; then
  eval "$(atuin init zsh)"
fi

if command -v direnv >/dev/null 2>&1; then
  eval "$(direnv hook zsh)"
fi

if [[ -t 0 && -t 1 ]] && command -v gh >/dev/null 2>&1; then
  eval "$(gh completion -s zsh)"
fi

if command -v zoxide >/dev/null 2>&1; then
  eval "$(zoxide init zsh)"
fi

# In case a command is not found, try to find the package that has it
function command_not_found_handler {
    local purple='\e[1;35m' bright='\e[0;1m' green='\e[1;32m' reset='\e[0m'
    printf 'zsh: command not found: %s\n' "$1"
    local entries=( ${(f)"$(/usr/bin/pacman -F --machinereadable -- "/usr/bin/$1")"} )
    if (( ${#entries[@]} )) ; then
        printf "${bright}$1${reset} may be found in the following packages:\n"
        local pkg
        for entry in "${entries[@]}" ; do
            local fields=( ${(0)entry} )
            if [[ "$pkg" != "${fields[2]}" ]]; then
                printf "${purple}%s/${bright}%s ${green}%s${reset}\n" "${fields[1]}" "${fields[2]}" "${fields[3]}"
            fi
            printf '    /%s\n' "${fields[4]}"
            pkg="${fields[2]}"
        done
    fi
    return 127
}

# Detect AUR wrapper
if command -v yay &>/dev/null; then
   aurhelper="yay"
elif command -v paru &>/dev/null; then
   aurhelper="paru"
fi

function need_aurhelper {
    if [[ -z "${aurhelper:-}" ]]; then
        print -u2 'No AUR helper found. Install yay or paru first.'
        return 1
    fi
}

function in {
    local -a inPkg=("$@")
    local -a arch=()
    local -a aur=()

    for pkg in "${inPkg[@]}"; do
        if pacman -Si "${pkg}" &>/dev/null; then
            arch+=("${pkg}")
        else
            aur+=("${pkg}")
        fi
    done

    if [[ ${#arch[@]} -gt 0 ]]; then
        sudo pacman -S "${arch[@]}"
    fi

    if [[ ${#aur[@]} -gt 0 ]]; then
        need_aurhelper || return 1
        ${aurhelper} -S "${aur[@]}"
    fi
}

function un {
    need_aurhelper || return 1
    ${aurhelper} -Rns "$@"
}

function up {
    need_aurhelper || return 1
    ${aurhelper} -Syu "$@"
}

function pl {
    need_aurhelper || return 1
    ${aurhelper} -Qs "$@"
}

function pa {
    need_aurhelper || return 1
    ${aurhelper} -Ss "$@"
}

function pc {
    need_aurhelper || return 1
    ${aurhelper} -Sc "$@"
}

function po {
    need_aurhelper || return 1
    local -a orphans
    orphans=( ${(f)"$(${aurhelper} -Qtdq 2>/dev/null)"} )
    if (( ${#orphans[@]} == 0 )); then
        print 'No orphan packages found.'
        return 0
    fi

    ${aurhelper} -Rns "${orphans[@]}"
}

# Helpful aliases
alias c='clear' # clear terminal
alias l='eza -lh --icons=auto' # long list
alias ls='eza -1 --icons=auto' # short list
alias ll='eza -lha --icons=auto --sort=name --group-directories-first' # long list all
alias ld='eza -lhD --icons=auto' # long list dirs
alias lt='eza --icons=auto --tree' # list folder as tree
alias cat='bat --style=plain'
alias fdh='fd --hidden --exclude .git'
alias rg='rg --smart-case'
alias prc='gh pr create'
alias ta='tmux attach -t main || tmux new -s main'
alias vc='code' # gui code editor
alias ff='fastfetch'

function fcd {
    local dir
    dir="$(fd --type d --hidden --exclude .git . | fzf)" || return 1
    [[ -n "$dir" ]] && cd "$dir"
}

function fvf {
    local file
    file="$(fd --type f --hidden --exclude .git . | fzf)" || return 1
    [[ -n "$file" ]] && ${EDITOR} "$file"
}


# Directory navigation shortcuts
alias ..='cd ..'
alias ...='cd ../..'
alias .3='cd ../../..'
alias .4='cd ../../../..'
alias .5='cd ../../../../..'

alias mk='mkdir -p'

# To customize prompt, run `p10k configure` or edit ~/.p10k.zsh
[[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh

# Display Pokemon
#pokemon-colorscripts --no-title -r 1,3,6


# opencode
export PATH="$HOME/.opencode/bin:$PATH"

export PATH=$PATH:/home/obito/.spicetify
