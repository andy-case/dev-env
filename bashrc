# Unlimited history.
HISTSIZE=
HISTFILESIZE=

# Keep duplicate lines and lines starting with a space out of the history.
HISTCONTROL=ignoreboth

# Append to history file, don't overwrite it.
shopt -s histappend

# Color support for MacOS.
export CLICOLOR=1

# Color support for *nix.
if [ -x /usr/bin/dircolors ] ; then
    test -r ~/.dircolors && eval "$(dircolors -b ~/.dircolors)" || eval "$(dircolors -b)"
    alias ls="ls --color=auto"
fi

other_bin=/usr/local/sbin
if [ -d ${other_bin} ] ; then
    export PATH=${other_bin}:${PATH}
fi
python_bin=${HOME}/Library/Python/2.7/bin
if [ -d ${python_bin} ] ; then
    export PATH=${python_bin}:${PATH}
fi
home_bin=${HOME}/bin
if [ -d ${home_bin} ] ; then
    export PATH=${home_bin}:${PATH}
fi
psql_bin=/usr/local/opt/postgresql@9.6/bin
if [ -d ${psql_bin} ] ; then
    export PATH=${psql_bin}:${PATH}
fi
export PATH=.:${PATH}

# Enable auto-completion for git commands.
if [ -f ~/.git-completion.bash ]; then
    . ~/.git-completion.bash
fi

# Use immediate Python environment, too.
export PYTHONPATH=.:${HOME}/python:${PYTHONPATH}

# Don't compile .pycs.
export PYTHONDONTWRITEBYTECODE=1

# Myriad MITM.
export AWS_CA_BUNDLE=/etc/ssl/certs/ca-certificates.crt

GIT_ROOT=${HOME}/git
VAGRANT_ROOT=${GIT_ROOT}/dev/vagrant
WEBSITE_ROOT=${GIT_ROOT}/dev/website-1
WEBSITE_TWO_ROOT=${GIT_ROOT}/dev/website-2
WEBSITE_THREE_ROOT=${GIT_ROOT}/dev/website-3
CURRENT_WEBSITE_ROOT=${WEBSITE_ROOT}
EMR_HL7_ROOT=${GIT_ROOT}/dev/emr_hl7
HASTE_SERVER="https://paste.deis.counsyl.com"
TMUXCC='tmux -CC attach || tmux -CC'


cpto () {
    scp -r $2 $1:$3
}

cpfrom () {
    scp -r $1:$2 .
}

remote-diff () {
    diff $2 <(ssh $1 "cat /home/${USER}/$2")
}

portscan () {
    nc -z -v -i 5 $1 $2-$3
}

gocd_diff () {
    diff <(grep Collecting $1 | awk '{print $3}' | sort) <(grep Collecting $2 | awk '{print $3}' | sort)
}

grepdiff () {
    diff <(grep $1 $2) <(grep $1 $3)
}


alias listen-for-host='sudo tcpdump -nn -X -s 0 src' # IP
alias listen-on-port='sudo tcpdump -nn -X -s 0 dst port' # port
alias dev="cd ${GIT_ROOT}/dev"
alias u='cd ..'
alias uu='cd ../..'
alias rsink='rsync -auvPWh --stats'
alias x='exit'
alias s='source ~/.bash_profile'
alias v='vim'
alias c='cat'
alias l='ls'
alias ll='ls -Al'
alias mkdirs='mkdir -p'
alias new='ls -Alrt | tail'
alias p='jupyter-console'
alias ps='ps -Af f'
alias gr='grep --extended-regexp --color=always --text --binary-files=without-match --exclude django.log --exclude-dir .git --exclude-dir .venv --exclude ".js.map"'

# dev/website testing.
shared_test_settings='--retest --settings=counsyl.product.settings_test --with-olfaction'
shared_test_ui_settings='--with-seleniumnosefilter --only-selenium-tests'
alias test-single="time ./manage.py test ${shared_test_settings}"
# alias test-multi="time ../../util/multiprocess_test_runner.py ${shared_test_settings} --batches $((`python -c 'import multiprocessing; print multiprocessing.cpu_count()'`*10))"
alias test-ui-headless="time ./manage.py test ${shared_test_settings} ${shared_test_ui_settings} --selenium-config-preset=local-chrome-xvfb"
# On Mac, 'chromedriver --port-server 0.0.0.0' first.
alias test-ui="time ./manage.py test ${shared_test_settings} ${shared_test_ui_settings} --selenium-config-preset=remote-chrome --selenium-remote-driver-url=http://10.0.2.2:9515 --selenium-liveserver-external-url=http://testv-dev.counsyl.test:8081/"


alias dj='./manage.py runserver 0.0.0.0:${DJANGO_PORT}'
# alias dj='SERVER_PORT=$DJANGO_PORT make server'
alias djsh='./manage.py shell_plus'

alias hl7='cd ${EMR_HL7_ROOT} && source .venv/bin/activate && cd emr_hl7'
alias go-orders='cd ${EMR_HL7_ROOT}/emr_hl7/test_orders'
alias update-orders='time ${EMR_HL7_ROOT}/emr_hl7/utils/emr_update_order_test_data.py'

alias ww='cd ${WEBSITE_ROOT} && source vendor/venv/bin/activate && cd counsyl/product && export CURRENT_WEBSITE_ROOT=${WEBSITE_ROOT} DJANGO_PORT=8001'
alias ww2='cd ${WEBSITE_TWO_ROOT} && source vendor/venv/bin/activate && cd counsyl/product && export CURRENT_WEBSITE_ROOT=${WEBSITE_TWO_ROOT} DJANGO_PORT=8002'
alias wcleandbs='time ./manage.py cleandb && ./manage.py migrate --fake && wcleantestdbs'
alias wcleantestdbs='time ./manage.py test --settings=counsyl.product.settings_test --no-destroy emr.tests:TestAuth'
alias update-emr-json='xargs -a my/results_scenarios/tests/test_scenarios.txt --max-procs=`getconf _NPROCESSORS_ONLN` --max-lines=1 --verbose ./manage.py my_update_test_report_data --settings=settings_test_report_data --no-pdf-html --no-api-json --no-hl7 --scenario'

alias go-results='cd ${CURRENT_WEBSITE_ROOT}/counsyl/product/emr/test_data/test_results'
alias update-results='time ${CURRENT_WEBSITE_ROOT}/counsyl/product/manage.py emr_update_result_test_data'


# Push to pypi.counsyl.com/$USER/dev using devpi
alias devpi-upload='devpi login $USER && devpi use $USER/dev && devpi upload'


alias go-puppetry='cd ${GIT_ROOT}/dev/puppetry && source .venv/bin/activate'
alias update-puppetmaster-hiera='go-puppetry && fab -u counsyl update_hiera'
alias update-puppetmaster-manifests='go-puppetry && fab -u counsyl update_manifests'
alias update-puppet-counsyl='go-puppetry && fab -u counsyl update_dev_module:counsyl'
alias cssh='ssh -l counsyl'



#######
# Hosts
alias te="ssh testv-phi-emr.aws.counsyl.com"
alias td="venv testv-dev"
alias stg='ssh stg-web-phi.counsyl.com'
alias clone='ssh clone-web-phi'
alias lw='ssh ssh.awsphi.counsyl.com'
alias tv-lastsync='for x in {1..7}; do echo $x && ssh testv-phi-0$x.aws.counsyl.com "sudo db.sh last_sync"; done'

venv () {
    cd ${VAGRANT_ROOT}/boxes/$1 && vagrant up && vagrant ssh
}

tv () {
    ssh testv-phi-$1.aws.counsyl.com
}

ts () {
    ssh testv-phi-sre-$1.aws.counsyl.com
}

aa () {
    ssh $1.herc.counsyl.com
}

#####
### Git
alias gbranch='git branch'
alias gbranchlog='git log master..'
alias gbranchprune='git remote prune origin'
alias gcheckout='git checkout'
alias gcheckoutbranch='git checkout -b'
alias gdiff='git diff --word-diff=color'
alias gpull='git pull'
alias gstatus='git status'
alias g-all-branches='cd ~/git && ls -d */* | xargs -I {} sh -c "cd {} && echo {} && git branch" && cd ~-'
alias g-all-stashes='cd ~/git && ls -d */* | xargs -I {} sh -c "cd {} && echo {} && git stash list" && cd ~-'

gstashdiff () {
    git stash show -p stash@{$1}
}

gstashpop () {
    git stash pop stash@{$1}
}



#####
### Vault
get-vault-for-environment () {
    if [ $1 == "prd" ]; then
        local VAULT_ADDR=https://vault.counsyl.com
    else
        local VAULT_ADDR=https://vault-dev.counsyl.com
    fi
    echo "$VAULT_ADDR"
}
vault-login () {
    local VAULT_ADDR=$(get-vault-for-environment $1)
    env VAULT_ADDR=$VAULT_ADDR /usr/local/bin/vault login -token-only -method=ldap username=$USER > ~/vault-tokens/$USER.$1
}
vault () {
    local VAULT_ADDR=$(get-vault-for-environment $1)
    local VAULT_TOKEN=$(cat ~/vault-tokens/$USER.$1)
    shift
    env VAULT_ADDR=$VAULT_ADDR VAULT_TOKEN=$VAULT_TOKEN /usr/local/bin/vault "$@"
}
vault-approle-login () {
    local VAULT_ADDR=$(get-vault-for-environment $1)
    TOKEN=$(env VAULT_ADDR=$VAULT_ADDR /usr/local/bin/vault write -field=token auth/approle/login role_id=$2 secret_id=$3)
    env VAULT_ADDR=$VAULT_ADDR /usr/local/bin/vault login -token-only $TOKEN > ~/vault-tokens/approle.$1
}
vault-approle () {
    local VAULT_ADDR=$(get-vault-for-environment $1)
    local VAULT_TOKEN=$(cat ~/vault-tokens/approle.$1)
    shift
    env VAULT_ADDR=$VAULT_ADDR VAULT_TOKEN=$VAULT_TOKEN /usr/local/bin/vault $*
}
vault-appid-login () {
    local VAULT_ADDR=$(get-vault-for-environment $1)
    TOKEN=$(env VAULT_ADDR=$VAULT_ADDR /usr/local/bin/vault write -field=token auth/app-id/login/$2 user_id=$3)
    env VAULT_ADDR=$VAULT_ADDR /usr/local/bin/vault login -token-only $TOKEN > ~/vault-tokens/appid.$1
}
vault-appid () {
    local VAULT_ADDR=$(get-vault-for-environment $1)
    local VAULT_TOKEN=$(cat ~/vault-tokens/appid.$1)
    shift
    env VAULT_ADDR=$VAULT_ADDR VAULT_TOKEN=$VAULT_TOKEN /usr/local/bin/vault $*
}

#####
### Prompt
COLOR_PROMPT='0;35m' # purple
COLOR_DEFAULT='0;37m' # light grey
COLOR_SAFE="0;32m" # green
COLOR_DEV="0;36m" # cyan
COLOR_WARNING="1;33m" # yellow
COLOR_DANGER="0;31m" # red
DATETIME="\D{%F} \t \D{%a}"

awsenv () {
    export AWS_ACCESS_KEY_ID=$(aws --profile $1 configure get aws_access_key_id)
    export AWS_SECRET_ACCESS_KEY=$(aws --profile $1 configure get aws_secret_access_key)
    export AWS_SESSION_TOKEN=$(aws --profile $1 configure get aws_session_token)
    export AWS_ACTIVE_PROFILE=$1
    export AWS_PROFILE=$1
}
awsenvmfa () {
    export AWS_ACCESS_KEY_ID=$(aws configure get aws_access_key_id --profile $1)
    export AWS_SECRET_ACCESS_KEY=$(aws configure get aws_secret_access_key --profile $1)
    SESSION=$(aws sts get-session-token --serial-number arn:aws:iam::896552222739:mfa/$1 --token-code $2)
    export AWS_ACCESS_KEY_ID=$(echo $SESSION | jq -r '.Credentials.AccessKeyId')
    export AWS_SECRET_ACCESS_KEY=$(echo $SESSION | jq -r '.Credentials.SecretAccessKey')
    export AWS_SESSION_TOKEN=$(echo $SESSION | jq -r '.Credentials.SessionToken')
    export AWS_ACTIVE_PROFILE=$1-mfa
    export AWS_PROFILE=$1-mfa
}
githubenv () {
    export ACCESS_TOKEN='55cf97f4a676c8376dd94b7055fc6cb42e99ac48'
}
ldapenv () {
    export LDAP_AUTH_DN='CN=auth,DC=counsyl,DC=com'
    export LDAP_AUTH_PASSWORD=$(vault prd read -field data secret/common/env/LDAP_BIND_PASSWORD)
    export AUTH_LDAP_BIND_PASSWORD=$(vault prd read -field data secret/common/env/LDAP_BIND_PASSWORD)
    export LDAP_ADMIN_PASSWORD=$(vault prd read -field data secret/platform/ldap/admin)
    export LDAP_SVC_DN=$(vault prd read -field dn secret/platform/ldap/svc_wh_git)
    export LDAP_SVC_PASSWORD=$(vault prd read -field password secret/platform/ldap/svc_wh_git)
}

ldap-counsyl-access () {
    ldapsearch -H ldaps://ldap.counsyl.com -D 'cn=auth,dc=counsyl,dc=com' -w `vault prd read -field data secret/common/env/LDAP_BIND_PASSWORD` -b 'ou=access,dc=counsyl,dc=com' "cn=$1"
}

print_user () {
    if [ ${USER} == "ahuang" ]; then
        COLOR_USER=${COLOR_SAFE}
    else
        COLOR_USER=${COLOR_WARNING}
    fi
    printf "\e[${COLOR_USER}${USER}\e[${COLOR_PROMPT}"
}

print_host () {
    if [[ ${HOSTNAME} == C12127ahuang ]]; then
        COLOR_HOST=${COLOR_SAFE}
    elif [[ ${HOSTNAME} == testv-dev* ]]; then
        COLOR_HOST=${COLOR_DEV}
    else
        COLOR_HOST=${COLOR_WARNING}
    fi
    printf "\e[${COLOR_HOST}${HOSTNAME}\e[${COLOR_PROMPT}"
}

get_git_branch () {
    git branch 2> /dev/null | grep '^\*\ .*' | cut -c 3-
}

get_git_stashes () {
    git stash list 2> /dev/null | grep -c "WIP on $(get_git_branch):"
}

get_git_changes () {
    git status --porcelain 2> /dev/null
}

print_git_branch () {
    git_branch=$(get_git_branch)
    if [ "$git_branch" ] ; then
        if [ $(get_git_stashes) != 0 ] ; then
            COLOR_BRANCH=${COLOR_DANGER}
        elif [ "$(get_git_changes)" ] ; then
            COLOR_BRANCH=${COLOR_WARNING}
        elif [ "${git_branch}" == "master" ] ; then
            COLOR_BRANCH=${COLOR_SAFE}
        else
            COLOR_BRANCH=${COLOR_DEV}
        fi
        printf "  [\e[${COLOR_BRANCH}${git_branch}\e[${COLOR_PROMPT}]"
    fi
}

PS1="\n\e[${COLOR_PROMPT}[${DATETIME}]  [\$(print_user)@\$(print_host)]\$(print_git_branch)  \w\e[${COLOR_DEFAULT}\n\$ "

complete -C /usr/local/bin/vault vault

# pyenv
if command -v pyenv 1>/dev/null 2>&1; then
  eval "$(pyenv init -)"
fi

# jenv
# if command -v jenv 1>/dev/null 2>&1; then
#   eval "$(jenv init -)"
# fi

# If ruby<2.4: Use openssl installed by rvm pkg to ~/.rvm/usr
alias rvm-install='rvm install --with-openssl-dir=`brew --prefix openssl`'
alias rvm-reinstall='rvm reinstall --with-openssl-dir=`brew --prefix openssl`'
# Load RVM into a shell session *as a function*
[[ -s "$HOME/.rvm/scripts/rvm" ]] && source "$HOME/.rvm/scripts/rvm"

export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion
