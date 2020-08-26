# If you come from bash you might have to change your $PATH.
LOCAL=$HOME/.local
PATH=/usr/local/bin:$PATH
PATH=$LOCAL/bin:$PATH
PATH=$LOCAL/python/bin:$PATH
PATH=$LOCAL/lua/bin:$PATH
PATH=$LOCAL/go/bin:$PATH
PATH=$LOCAL/node/bin:$PATH
PATH=$LOCAL/rust/bin:$LOCAL/cargo/bin:$PATH
export PATH

export GOROOT=$LOCAL/go

source $LOCAL/antigen.zsh
antigen use oh-my-zsh

antigen bundle skywind3000/z.lua
antigen bundle changyuheng/fz
antigen bundle command-not-found
antigen bundle git
antigen bundle zsh-users/zsh-syntax-highlighting
antigen bundle zsh-users/zsh-completions
antigen bundle zsh-users/zsh-autosuggestions
antigen bundle autopep8
antigen bundle cargo
antigen bundle docker
antigen bundle dotnet
antigen bundle emoji
antigen bundle git-auto-fetch
antigen bundle gradle
antigen bundle npm
antigen bundle python
antigen bundle ruby
antigen bundle sudo
antigen bundle thefuck
antigen bundle ufw
antigen bundle vscode
antigen bundle archlinux
antigen bundle systemd

antigen theme romkatv/powerlevel10k

antigen apply

# To customize prompt, run `p10k configure` or edit ~/.p10k.zsh.
[[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh

eval "$(lua $HOME/.antigen/bundles/skywind3000/z.lua/z.lua  --init zsh once enhanced)" 
