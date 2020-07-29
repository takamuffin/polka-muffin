export ZSH="/home/takamuffin/git/oh-my-zsh"
export LC_CTYPE="en_US.UTF-8"
export LC_ALL="en_US.UTF-8"
export LANG="en_US.UTF-8"
export TERM="rxvt-unicode"
export EDITOR="/usr/bin/vim"
export GPG_TTY=$(tty)

export PATH=$PATH:/usr/local/lib:~/.local/bin
export LD_LIBRARY_PATH=$LD_LIBRARY_PATH:/usr/local/lib
export ENV="dev"
export AWS_REGION="us-west-2"
export CONFIG_FILE="./data/config.json"
export CONFIG_TABLE="dev1-config"
export DYNAMO_ENDPOINT="127.0.0.1:8000"
export GAMESIM_DLL_FILE="/mnt/c/Users/asansone/Documents/unity/asansone_maverick/server/GameSim/bin/Release/GameSim.dll"
#export GAMESIM_PROTODATA_DIR="/mnt/c/Users/asansone/Documents/unity/asansone_maverick/server/setup/data_pipeline/"
export NODE_TLS_REJECT_UNAUTHORIZED=1
export AWS_PROFILE=dev1
export AWS_SDK_LOAD_CONFIG=1
#export AWS_CONFIG_FILE="/home/takamuffin/.aws/config"

function elasticsearch_latest() {
    export ES_HOME="/home/takamuffin/downloads/elasticsearch-7.8.0"
    screen -dmS elasticsearch $ES_HOME/bin/elasticsearch
}

function elasticsearch() {
    docker service create --publish 9200:9200 --publish 9300:9300 barnybug/elasticsearch:1.7.2
}

function redis() {
    screen -dmS redis redis-server
}

function ping_port() {
    bash -c "(echo >/dev/tcp/$1/$2) &>/dev/null && echo 'Open ${1}:${2}' || echo 'Close ${1}:${2}'"
}

function start_docker_services() {
    for image in $(docker images | awk '(NR>1) && ($1 !~ /ubuntu/) && ($1 !~ /barnybug\/elasticsearch/) {print $1":"$2}')
    do
        eval $(echo $image | awk -F"/" '{print "domain="$1;print "codename="$2;print "service="$3;print "opt="$4}')
        config_dir=$service
        if [[ $service == "segmentation" ]]; then
            config_dir="bf-$service"
        fi
        if [[ "public private" =~ (^|[[:space:]])"$opt"($|[[:space:]]) ]]; then
            service="$service-$opt"
        fi
        port=$(jq '.port' ~/configs/$service.config)
        redis=$(ip addr show eth0 | grep "inet\b" | awk '{print $2}' | cut -d/ -f1)

        docker config rm $service-config
        docker config create $service-config ~/configs/$service.config

        docker service create --name $service --host redis_server:$redis -e NO_AUTH=yes -e AWS_REGION=us-west-2 -e AWS_SDK_LOAD_CONFIG=1 -e AWS_PROFILE=dev1 --publish $port:$port --config src=$service-config,target=/usr/src/$config_dir/config.json --config src=aws-credentials,target=/root/.aws/credentials --config src=aws-config,target=/root/.aws/config $image
    done
}

function docker_aws_confg_copy() {
    aws-mfa --profile dev1
    aws-mfa --profile default
    aws ecr get-login-password --region us-west-2 | docker login --username AWS --password-stdin 216252131343.dkr.ecr.us-west-2.amazonaws.com
    docker service rm $(docker service ls | awk '(NR>1) && ($5 ~ /amazonaws/) {print $1}')
    while [[ $(docker service ls | awk '(NR>1) && ($5 ~ /amazonaws/) {print $1}') ]]
    do
        sleep 10
    done
    docker config rm aws-config aws-credentials
    docker config create aws-config ~/.aws/config
    docker config create aws-credentials ~/.aws/credentials
    start_docker_services
}


ZSH_THEME="gnzh"

plugins=(git zsh-dircolors-solarized vi-mode)

source $ZSH/oh-my-zsh.sh
source ~/.minttyrc

setopt extendedglob nobeep

# Use modern completion system
autoload -Uz compinit
compinit

autoload -U up-line-or-beginning-search
autoload -U down-line-or-beginning-search
zle -N up-line-or-beginning-search
zle -N down-line-or-beginning-search
bindkey "^[[A" up-line-or-beginning-search # Up
bindkey "^[[B" down-line-or-beginning-search # Down

alias grep="grep --color=auto"

#keybinds for x terminals
bindkey '^[[H' beginning-of-line
bindkey '^[[F' end-of-line

#for tmux
bindkey '^[[1~' beginning-of-line
bindkey '^[[4~' end-of-line

#for urxvt
bindkey	'^[[7~' beginning-of-line
bindkey '^[[8~' end-of-line

#for both
bindkey '^[[3~' delete-char
bindkey '^[[Z' undo

setupsolarized

export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion

function dynam(){
 cd $HOME/.dynamolocal
 nohup java -Djava.library.path=./DynamoDBLocal_lib/ -jar DynamoDBLocal.jar &
}

function override_dns(){
 echo "nameserver 8.8.8.8" | sudo tee /etc/resolv.conf
}

override_dns

cd ~/
