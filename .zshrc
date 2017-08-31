# ~/.zshrc - zsh rc-file sourced by interactive shells
# Author: Sascha 'karasu' Biberhofer
# mailto: karasu FOO inode BAR at
#   Please beware that this file will most likely
#   only run with zsh 4.2.0 or newer and has only been tested
#   on two Gentoo-boxes. Mind my stupidity if you plan using this.

# loading colors support
autoload -U colors && colors
# loading completion support
autoload -U compinit && compinit
# we can't live without zmv :>
autoload zmv
# we need a calculator!
zmodload zsh/mathfunc &> /dev/null

# some terminal-specific stuff
case $TERM in
xterm*)
  precmd () {print -Pn "\e]0;%T %n@%m: %~\a"}
  preexec () {print -Pn "\e]0;$1\a"}
  bindkey "^[[H" beginning-of-line	# Pos1
  bindkey "^[[F" end-of-line		# End
  ;;
screen*|linux*)
  bindkey "^[[1~" beginning-of-line	# Pos1
  bindkey "^[[4~" end-of-line		# End
  if [[ $TERM == screen* ]]; then
    # See http://www.strcat.de/blog/archives/360-GNU-Screen-Titel-setzen.html
    # man zshexpn | less -p 'Parameter Expansion Flags'
    # man zshexpn in general... ;)
    precmd () { print -nR $'\033k'${${SSH_TTY:+${HOST}}:-${SHELL:t}}$'\033'\\ }
    preexec () { print -nR $'\033k'"${${${(z)1}[1]}:/?/$1}"$'\033'\\ }
    # known issue: Doesn't print things like "vi .zshrc", just "vi".
    # Would be nice to fix this, yet I still need to work on this...
    # It also doesn't care about one-character-commands e.g. L foo.txt
    # will set the title to "L foo.txt" instead of just "L".
  fi
  ;;
esac

bindkey "^[[5~" up-line-or-history	# PgUp
bindkey "^[[6~" down-line-or-history	# PgDown
bindkey "\e[3~" delete-char		# Del
bindkey "^[[2~" yank			# Ins

# source aliases, options, etc...
[[ -r ~/.zsh/zshoptions ]] && . ~/.zsh/zshoptions
[[ -r ~/.zsh/zshvars    ]] && . ~/.zsh/zshvars
[[ -r ~/.zsh/zshalias   ]] && . ~/.zsh/zshalias
[[ -r ~/.zsh/zshfunct   ]] && . ~/.zsh/zshfunct
[[ -r ~/.zsh/aptituz-zsh/directory-based-environment-configuration ]] && . ~/.zsh/aptituz-zsh/directory-based-environment-configuration
[[ -r ~/.zsh/grml-etc-core/etc/zsh/zshrc ]] && . ~/.zsh/grml-etc-core/etc/zsh/zshrc
[[ -r ~/.zsh/switch-contexts ]] && . ~/.zsh/switch-contexts

# make less more friendly for non-text input files, see lesspipe(1)
if [ -x /usr/bin/lesspipe ]; then
  eval "$(lesspipe)"
fi

# update dotfiles
#cd ~/dotfiles && git pull
