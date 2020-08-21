#
# ~/.bashrc
#

# If not running interactively, don't do anything
[[ $- != *i* ]] && return

#PS1='[\u@\h \W]\$ '
PS1='\W $ '

alias ..='cd ..'
alias ...='cd ../..'
alias vi=nvim
alias vim=nvim
alias ls='ls -lah --color=auto'
alias plex='sudo systemctl start plexmediaserver.service && echo "Plex started!"'
alias unplex='sudo systemctl stop plexmediaserver.service && echo "Plex stopped!"'
alias i3conf='vim ~/.config/i3/config'
alias pbconf='vim ~/.config/polybar/config'
alias bsconf='vim ~/.config/bspwm/bspwmrc'
alias keys='vim ~/.config/sxhkd/sxhkdrc'
alias nburls='vim ~/.newsboat/urls'
alias nbconf='vim ~/.newsboat/config'
alias nvimrc='vim ~/.config/nvim/init.vim'
alias disp2='xrandr --output "DP1" --auto --output "eDP1" --off'
export PATH="$HOME/.cargo/bin:$PATH"
if systemctl -q is-active graphical.target && [[ ! $DISPLAY && $XDG_VTNR -eq 1 ]]; then
  exec startx
fi
