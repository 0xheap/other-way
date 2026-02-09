# If you come from bash you might have to change your $PATH.
# export PATH=$HOME/bin:$HOME/.local/bin:/usr/local/bin:$PATH

# Path to your Oh My Zsh installation.
export ZSH="$HOME/.oh-my-zsh"

# Set name of the theme to load --- if set to "random", it will
# load a random theme each time Oh My Zsh is loaded, in which case,
# to know which specific one was loaded, run: echo $RANDOM_THEME
# See https://github.com/ohmyzsh/ohmyzsh/wiki/Themes
#ZSH_THEME="custom"
#ZSH_THEME="robbyrussell"
# Set list of themes to pick from when loading at random
# Setting this variable when ZSH_THEME=random will cause zsh to load
# a theme from this variable instead of looking in $ZSH/themes/
# If set to an empty array, this variable will have no effect.
# ZSH_THEME_RANDOM_CANDIDATES=( "robbyrussell" "agnoster" )

# Uncomment the following line to use case-sensitive completion.
# CASE_SENSITIVE="true"

# Uncomment the following line to use hyphen-insensitive completion.
# Case-sensitive completion must be off. _ and - will be interchangeable.
# HYPHEN_INSENSITIVE="true"

# Uncomment one of the following lines to change the auto-update behavior
# zstyle ':omz:update' mode disabled  # disable automatic updates
# zstyle ':omz:update' mode auto      # update automatically without asking
# zstyle ':omz:update' mode reminder  # just remind me to update when it's time

# Uncomment the following line to change how often to auto-update (in days).
# zstyle ':omz:update' frequency 13

# Uncomment the following line if pasting URLs and other text is messed up.
# DISABLE_MAGIC_FUNCTIONS="true"

# Uncomment the following line to disable colors in ls.
# DISABLE_LS_COLORS="true"

# Uncomment the following line to disable auto-setting terminal title.
# DISABLE_AUTO_TITLE="true"

# Uncomment the following line to enable command auto-correction.
#
# ENABLE_CORRECTION="true"

# Uncomment the following line to display red dots whilst waiting for completion.
# You can also set it to another string to have that shown instead of the default red dots.
# e.g. COMPLETION_WAITING_DOTS="%F{yellow}waiting...%f"
# Caution: this setting can cause issues with multiline prompts in zsh < 5.7.1 (see #5765)
# COMPLETION_WAITING_DOTS="true"

# Uncomment the following line if you want to disable marking untracked files
# under VCS as dirty. This makes repository status check for large repositories
# much, much faster.
# DISABLE_UNTRACKED_FILES_DIRTY="true"

# Uncomment the following line if you want to change the command execution time
# stamp shown in the history command output.
# You can set one of the optional three formats:
# "mm/dd/yyyy"|"dd.mm.yyyy"|"yyyy-mm-dd"
# or set a custom format using the strftime function format specifications,
# see 'man strftime' for details.
# HIST_STAMPS="mm/dd/yyyy"

# Would you like to use another custom folder than $ZSH/custom?
# ZSH_CUSTOM=/path/to/new-custom-folder

# Which plugins would you like to load?
# Standard plugins can be found in $ZSH/plugins/
# Custom plugins may be added to $ZSH_CUSTOM/plugins/
# Example format: plugins=(rails git textmate ruby lighthouse)
# Add wisely, as too many plugins slow down shell startup.
plugins=(git zsh-autosuggestions zsh-syntax-highlighting)

source $ZSH/oh-my-zsh.sh
export PATH="$HOME/.local/bin:$PATH"
eval "$(starship init zsh)"


# User configuration

# export MANPATH="/usr/local/man:$MANPATH"

# You may need to manually set your language environment
# export LANG=en_US.UTF-8

# Preferred editor for local and remote sessions
# if [[ -n $SSH_CONNECTION ]]; then
#   export EDITOR='vim'
# else
#   export EDITOR='nvim'
# fi

# Compilation flags
# export ARCHFLAGS="-arch $(uname -m)"

# Set personal aliases, overriding those provided by Oh My Zsh libs,
# plugins, and themes. Aliases can be placed here, though Oh My Zsh
# users are encouraged to define aliases within a top-level file in
# the $ZSH_CUSTOM folder, with .zsh extension. Examples:
# - $ZSH_CUSTOM/aliases.zsh
# - $ZSH_CUSTOM/macos.zsh
# For a full list of active aliases, run `alias`.
#
# Example aliases
# alias zshconfig="mate ~/.zshrc"
#alias nvim="$HOME/goinfre/nvim/nvim"
alias cls="clear"

yy () {
	touch ft_$1.c
}

ft() {
    local headername="header.h"

    if [[ "$2" == "-h" ]]; then
        if [ -z "$3" ]; then
            echo "Error: -h requires a header name argument."
            return 1
        fi
        headername="$3"
        shift 3
    elif [[ "$1" == "-h" ]]; then
        if [ -z "$2" ]; then
            echo "Error: -h requires a header name argument."
            return 1
        fi
        headername="$2"
        shift 2
    fi

    if [ -z "$1" ]; then
        echo "Usage: ft [ -h custom_header.h ] <function_name>"
        return 1
    fi

    local filename="ft_$1.c"
    
    if [ -f "$filename" ]; then
        echo "Error: $filename already exists!"
        return 1
    fi
    
    echo "#include \"$headername\"" > "$filename"
    vim -c "Stdheader" -c "wq" "$filename"

    echo "Created $filename using the header: $headername"
}

#in () {
# 	vim -c "Stdheader" -c "wq" "$@"
# }

in() {
	if [ $# -eq 0 ]; then
		for file in *.c; do
			[ -f "$file" ] && vim -c "Stdheader" -c "wq" "$file"
		done
	else
		vim -c "Stdheader" -c "wq" "$@"
	fi
}

RepoPilot () {
	$HOME/Tools/RepoPilot.py "$@"
}

#compile () {
#	cc -Wall -Werror -Wextra $@
#}

compile() {
    local output="program"
    local run=false
    local files=()
    local flags=()
    local sanitize=false
    local clear_sleep=0
    local erase=false
    
    while [[ $# -gt 0 ]]; do
        case $1 in
            -h)
                echo "Usage: compile [OPTIONS] file..."
                echo "Options:"
                echo "  -o <name>  Output filename (default: program)"
                echo "  -w         Compile with -Wall -Werror -Wextra"
                echo "  -c [n]     Clear screen after n seconds (default: 5)"
                echo "  -f         Add -fsanitize=address for debugging"
                echo "  -r         Run the program after compilation"
                echo "  -e         Erase executable after running"
                echo "  -h         Show this help message"
                return 0
                ;;
            -r)
                run=true
                shift
                ;;
            -e)
                erase=true
                shift
                ;;
            -o)
                if [[ -n $2 && $2 != -* ]]; then
                    output="$2"
                    shift 2
                else
                    echo "Error: -o requires an output filename" >&2
                    return 1
                fi
                ;;
            -w)
                flags=(-Wall -Werror -Wextra)
                shift
                ;;
            -c)
                if [[ -n $2 && $2 =~ ^[0-9]+$ ]]; then
                    clear_sleep="$2"
                    shift 2
                else
                    clear_sleep=5
                    shift
                fi
                ;;
            -f)
                sanitize=true
                shift
                ;;
            *)
                files+=("$1")
                shift
                ;;
        esac
    done
    
    if [[ ${#files[@]} -eq 0 ]]; then
        echo "Error: No source files specified" >&2
        return 1
    fi
    
    if $sanitize; then
        flags+=(-fsanitize=address)
    fi
    
    if cc "${flags[@]}" "${files[@]}" -o "$output"; then
        if $run; then
            "./$output"
        fi
        if $erase; then
            rm -f "$output"
        fi
        if [[ $clear_sleep -gt 0 ]]; then
            sleep "$clear_sleep"
            clear
        fi
    else
        return 1
    fi
}
push_nvim () {
	red='\e[31m'
	pink='\e[35m'
	green='\e[92m'
	reset='\e[0m'
	echo -e  "${green}[1] = Cloning The Repo .....${reset}"
	git clone git@github.com:codewith-abdessamad/nvim.git /home/abdessel/goinfre/nEo
	echo -e "${green}[2] = Entering To nEo .....${reset}"
	cd /home/abdessel/goinfre/nEo
	echo -e "${green}[3] = Copy Config Files .....${reset}"
	cp -r ~/.config/nvim/* /home/abdessel/goinfre/nEo/nvim
	echo -e "${green}[4] = Pushing .....${reset}"
	git add .
	git commit -m "New Config Made In $(date)"
	git push
	rm -rf /home/abdessel/goinfre/nEo
	echo -e "${pink}[5] = DOne , Enjoy${reset}"
}

alias xclean="/bin/bash $HOME/Tools/xclean.sh"
alias py="python3.10"
alias void="python3 /home/abdessel/Tools/Void/void.py"
mkdir -p ~/goinfre/vscode-extensions ~/.vscode


bin!() {
	dpkg-deb -c $1 | grep bin/		
}
# Create symlink to goinfre extensions directory
if [ ! -L ~/.vscode/extensions ]; then
    rm -rf ~/.vscode/extensions 2>/dev/null
    ln -sf ~/goinfre/vscode-extensions ~/.vscode/extensions
fi

# Auto-install extensions if list exists and extensions dir is empty
if [ -f ~/Tools/vscode-extensions-list.txt ] && [ -z "$(ls -A ~/goinfre/vscode-extensions 2>/dev/null)" ]; then
    echo "Installing VS Code extensions..."
    ~/Tools/sync-vscode-extensions.sh install
fi
alias ff= "find /home/abdessel -type f -printf '%s %p\n' 2>/dev/null | sort -rn | head -20 | awk '{size=$1/1024/1024; printf "%.2f MB\t%s\n", size, $2}'"
font () { echo "'JetBrainsMono Nerd Font'"  }
echo $(void install-all) > /dev/null

export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion
export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"
