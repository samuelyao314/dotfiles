#!/usr/bin/env bash
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
    virtualenv $LOCAL/python
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
        $HEREROCKS $LOCAL/lua -l5.4 -rlatest
    fi
fi


#######################
# Golang
#######################
if [[ ! -d $LOCAL/go ]]; then
    GOTAR=/tmp/go.tar.gz
    GOVER="1.15.3"
    GOURL="https://golang.org/dl/go${GOVER}.${OSTYPE}-amd64.tar.gz"
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


#######################
# Node
#######################
if [[ ! -d $LOCAL/node  ]]; then
    mkdir -p $LOCAL/node
    NODE_SCRIPT=/tmp/install-node.sh
    curl -sL install-node.now.sh/lts -o $NODE_SCRIPT
    chmod +x $NODE_SCRIPT
    PREFIX=$LOCAL/node $NODE_SCRIPT -y
fi


################################
# 根据操作系统，选择不同二进制
################################
BIN_DIR=$LOCAL/bin
BIN_DIR_2=$LOCAL/bin2  # 不会放入git仓库
for name in fzf
do
    exe=${BIN_DIR}/${name}
    if [[ ! -d ${exe} ]]; then
        chmod a+x ${exe}.${OSTYPE}
        ln -sf ${exe}.${OSTYPE} ${BIN_DIR_2}/${name}
    fi
done
