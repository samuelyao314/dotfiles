#!/usr/bin/env zsh
# 前提：chsh -s /bin/zsh

LOCAL=$HOME/.local

err() {
    say "$1" >&2
    exit 1
}

need_cmd() {
    if ! check_cmd "$1"; then
        err "need '$1' (command not found)"
    fi
}

check_cmd() {
    command -v "$1" > /dev/null 2>&1
}

need_cmd curl
need_cmd tr
need_cmd uname
need_cmd python3

OSTYPE=`uname -s | tr 'A-Z' 'a-z'`
echo "OSTYPE: $OSTYPE"


#######################
# Python3
#######################
if [[ ! -d $LOCAL/python  ]]; then
    python3 -m venv $LOCAL/python
    PIP=$LOCAL/python/bin/pip
    $PIP install 'python-language-server[all]'
    $PIP install pylint isort jedi flake8
    $PIP install yapf hererocks thefuck
fi

#######################
# Lua
#######################
if [[ -d $LOCAL/python ]]; then
    HEREROCKS=$LOCAL/python/bin/hererocks
    if [[ ! -d $LOCAL/lua ]]; then
        $HEREROCKS $LOCAL/lua -l5.3 -rlatest
    fi
fi



#######################
# Golang
#######################
if [[ ! -d $LOCAL/go ]]; then
    GOTAR=/tmp/go.tar.gz
    GOURL=https://golang.org/dl/go1.15.${OSTYPE}-amd64.tar.gz
    curl -sL ${GOURL} -o $GOTAR
    tar -zxvf $GOTAR -C $LOCAL
fi

#######################
# RUST
#######################
export RUSTUP_HOME=$LOCAL/rust
export CARGO_HOME=$LOCAL/cargo
if [[ ! -d $RUSTUP_HOME  ]]; then
    curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh -s -- -y
fi

for crate in fd-find ripgrep
do
    $CARGO_HOME/bin/cargo install $crate
done
