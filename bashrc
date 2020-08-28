# init script for interactive shells
# vim: set ft=sh :

# prevent loading twice
if [ -z "$_INIT_SH_LOADED" ]; then
	_INIT_SH_LOADED=1
else
	return
fi

# skip if in non-interactive mode
case "$-" in
	*i*) ;;
	*) return
esac

# set PATH so it includes user's private bin if it exists
LOCAL=$HOME/.local
PATH=/usr/local/bin:$PATH
PATH=$LOCAL/bin:$PATH
PATH=$LOCAL/python/bin:$PATH
PATH=$LOCAL/lua/bin:$PATH
PATH=$LOCAL/go/bin:$PATH
PATH=$LOCAL/node/bin:$PATH
PATH=$LOCAL/rust/bin:$LOCAL/cargo/bin:$PATH
export PATH

# golang
export GOROOT=$LOCAL/go


# execute post script if it exists
if [ -f "$HOME/.local/etc/local.sh" ]; then
	. "$HOME/.local/etc/local.sh"
fi

# remove duplicate path
if [ -n "$PATH" ]; then
	old_PATH=$PATH:; PATH=
	while [ -n "$old_PATH" ]; do
		x=${old_PATH%%:*}        # the first remaining entry
		case $PATH: in
			*:"$x":*) ;;         # already there
			*) PATH=$PATH:$x;;   # not there yet
		esac
		old_PATH=${old_PATH#*:}
	done
	PATH=${PATH#:}
	unset old_PATH x
fi

export PATH

# check if bash
if [ -n "$BASH_VERSION" ]; then
	# run script for interactive mode of bash/zsh
	if [[ $- == *i* ]] && [ -z "$INIT_SH_NOFUN" ]; then
		if [ -f "$HOME/.local/etc/function.sh" ]; then
			. "$HOME/.local/etc/function.sh"
		fi
	fi
fi
