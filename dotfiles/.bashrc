echo -e "\x1B]2;$(whoami)@$(uname -n)\x07"; # set terminal title

[[ -f /etc/profile ]] && . /etc/profile
[[ -z "$PS1" ]] && return
[[ -f $HOME/.bashrc2 ]] && . $HOME/.bashrc2

PATH=$PATH:$HOME/bin:$HOME/bin/browsers:$HOME/bin/makepkg:$HOME/bin/mounts:$HOME/bin/repo:$HOME/bin/wine

TERM=xterm-256color
export CHROOT=/scratch/chroot64
export EDITOR=vim
export VISUAL=vim
set -o vi
PS1='[\u@\h \W]\$ '

# make multiple shells share the same history file
shopt -s histappend
export PROMPT_COMMAND="history -a ; ${PROMPT_COMMAND:-:}"
export HISTCONTROL=erasedups
export HISTSIZE=10000

#alias makepkg="nice -19 makepkg"
alias dogain="mp3gain -a -k -p *.mp3"
alias aur="aurploader -r -l ~/.aurploader"
alias bb="sudo bleachbit --clean system.cache system.localizations system.trash system.tmp &&  sudo cacheclean 2"
alias gitc="git commit -av ; git push -u origin master"
alias pacman="pacman-color"
alias pp="sudo pacman-color -Syu"
alias upp='reflector -c "United States" -a 1 -f 3 --sort rate --save /etc/pacman.d/mirrorlist && cat /etc/pacman.d/mirrorlist && sudo pacman-color -Syyu'
alias grep="grep --color=auto"
alias zgrep="zgrep --color=auto"
alias ma="cd /home/stuff/my_pkgbuild_files"

alias ls="ls --color=auto"
alias ll="ls -lh"
alias la="ls -lha"
alias lt="ls -lhtr"
alias lta="ls -lhatr"

alias rm="rm -i"
alias mv="mv -i"
alias ..="cd .."
alias ...="cd ../.."
alias ....="cd ../../.."
alias hddtemp="sudo hddtemp"
alias nets="sudo netstat -nlpt"
alias nets2="sudo lsof -i"
alias memrss='while read command percent rss; do if [[ "${command}" != "COMMAND" ]]; then rss="$(bc <<< "scale=2;${rss}/1024")"; fi; printf "%-26s%-8s%s\n" "${command}" "${percent}" "${rss}"; done < <(ps -A --sort -rss -o comm,pmem,rss | head -n 20)'
alias pg='echo "USER       PID %CPU %MEM    VSZ   RSS TTY      STAT START   TIME COMMAND" && ps aux | grep --color=auto'
alias dmesg="dmesg | sed '/UFW/d'"

if [ -z $(dmesg | grep "Kernel command line"|grep systemd) ]; then 	# not using systemd
	start() { 
		sudo rc.d start $1
	}

	restart() { 
		sudo rc.d restart $1
	}

	stop() { 
		sudo rc.d stop $1
	}
else
	start() { 
		sudo systemctl start $1.service
	}

	restart() { 
		sudo systemctl restart $1.service
	}

	stop() { 
		sudo systemctl stop $1.service
	}

	enable() { 
		sudo systemctl enable $1.service
	}

	status() { 
		systemctl status $1.service
	}
fi

disable() { 
	sudo systemctl disable $1.service
}

bi () {
	cp -a "$1" /scratch
	cd /scratch/"$1"
}

x () {
	if [[ -f "$1" ]]; then
		case "$1" in
			*.lrz) lrztar -d "$1" && cd $(basename "$1" .lrz)
				;;
			*.tar.bz2) tar xjf "$1" && cd $(basename "$1" .tar.bz2)
				;;
			*.tar.gz)	tar xzf "$1" && cd $(basename "$1" .tar.gz)
				;;
			*.tar.xz)	tar Jxf "$1" && cd $(basename "$1" .tar.xz)
				;;
			*.bz2) bunzip2 "$1" && cd $(basename "$1" .bz2)
				;;
			*.rar) rar x "$1" && cd $(basename "$1" .rar)
				;;
			*.gz)	gunzip "$1" && cd $(basename "$1" .gz)
				;;
			*.tar) tar xf "$1" && cd $(basename "$1" .tar)
				;;
			*.tbz2) tar xjf "$1" && cd $(basename "$1" .tbz2)
				;;
			*.tgz) tar xzf "$1" && cd $(basename "$1" .tgz)
				;;
			*.zip) unzip "$1" && cd $(basename "$1" .zip)
				;;
			*.Z) uncompress "$1" && cd $(basename "$1" .Z)
				;;
			*.7z) 7z x "$1" && cd $(basename "$1" .7z)
				;;
			*) echo "don't know how to extract '$1'..."
				;;
		esac
	else
		echo "'$1' is not a valid file!"
	fi
}

fix() {
	if [[ -d "$1" ]]; then
		find "$1" -type d -print0 | xargs -0 chmod 755
		find "$1" -type f -print0 | xargs -0 chmod 644
	else
		echo "$1 is not a directory."
	fi
}

orphans() {
	if [[ ! -n $(pacman -Qdt) ]]; then 
		echo no orphans to remove
	else 
		sudo pacman -Rs $(pacman -Qdtq)
	fi
}

r0 () {
	find . -type f -size 0 -print0 | xargs -0 rm -f
}

archey
