export PATH=~/dev/bin:$PATH
export PYTHONPATH=~/dev/python:$PYTHONPATH
export HISTSIZE=999999
export SAVEHIST=$HISTSIZE
setopt hist_ignore_all_dups
setopt INC_APPEND_HISTORY
export HISTTIMEFORMAT="[%F %T] "
setopt EXTENDED_HISTORY

alias l="ls -1"
alias ll="ls -Al"
alias p="python"
alias ss="source ~/.zshrc"
alias u="cd .."
alias v="vi"
alias x="exit"
alias ph="cd ~/dev/repos/picnichealth/picnic/bin"
alias new="ls -Alrt | tail -n10"

pdata-pod () {
  pdata-kubectl exec -itc $1 $2 -- bash
}
data-analysis-nfs-server () {
  pod=$(pdata-kubectl get pods -l role=data-analysis-nfs-server -o jsonpath="{.items[*].metadata.name}")
  pdata-pod data-analysis-nfs-server $pod
}

tls-examine-kubectl () {
  yq r /usr/local/etc/k8s/$1 'clusters[0].cluster.certificate-authority-data' | base64 --decode | openssl x509 -noout -text
}
tls-examine-host () {
  echo | openssl s_client -connect $1 -showcerts 2>/dev/null | openssl x509 -text -noout
}

fix-global-load-balancers () {
  for project (staging-176122 prod-176122); do
    LB=$(gcloud --project=$project compute backend-services list --global --format="value(name)")
    gcloud --project=$project compute health-checks update http $LB --host=GoogleHC.local
    gcloud --project=$project compute backend-services update --global $LB --timeout=900
  done
}

# RStudio Connect
alias rsc="gcloud compute ssh --project rstudio-connect-202103 rstudio-connect --zone us-central1-a --tunnel-through-iap"
alias rspm="gcloud compute ssh --project rstudio-connect-202103 rstudio-package-manager --zone us-central1-a --tunnel-through-iap"
rsc-cp () {
  gcloud compute scp --project rstudio-connect-202103 --zone us-central1-a --tunnel-through-iap "$1" rstudio-connect:~/
}

alias flag="gcloud compute ssh --project=sec-prismavpn-poc-20210429 flag --zone us-central1-a --tunnel-through-iap"
alias doc="gcloud compute ssh --project=sec-prismavpn-poc-20210429 doc --zone us-central1-a --tunnel-through-iap"

# Run at picnic/.
alias gcp-kms-decrypt-dev="GCLOUD_PROJECT=local-184120 make decrypt-environment-secrets ENVIRONMENT_SECRETS_FILE=infra/local/secrets/local.env"
alias gcp-kms-decrypt-stg="GCLOUD_PROJECT=staging-176122 make decrypt-environment-secrets ENVIRONMENT_SECRETS_FILE=infra/local/secrets/staging.env"
alias gcp-kms-decrypt-prd="GCLOUD_PROJECT=prod-176122 make decrypt-environment-secrets ENVIRONMENT_SECRETS_FILE=infra/local/secrets/prod.env"


GCP_ORG_ID="574083298316"
alias gcp-list-projects="gcloud projects list | cut -f 1 -d ' ' | tail -n +2"
alias gcp-get-resources="gcloud asset search-all-resources --scope organizations/$GCP_ORG_ID"
alias gcp-get-policies="gcloud asset search-all-iam-policies --scope organizations/$GCP_ORG_ID"
gcp-get-cloudsqls () {
  FILE=gcp.cloudsql.$(date +%Y%m%d%H%M%S).yaml
  gcp-get-resources --asset-types=sqladmin.googleapis.com/Instance > $FILE
  echo $FILE
}
gcp-get-clusters () {
  FILE=gcp.gke.$(date +%Y%m%d%H%M%S).json
  gcp-get-resources --asset-types=containers.googleapis.com/Cluster > $FILE
  echo $FILE
}
gcp-get-all-ips () {
  FILE=gcp.ips.$(date +%Y%m%d%H%M%S).json
  gcp-get-resources --asset-types=compute.googleapis.com/Instance,compute.googleapis.com/ForwardingRule --format json > $FILE
  echo $FILE
}
gcp-get-dns-managed-zones () {
  FILE=gcp.dns.managed_zones.$(date +%Y%m%d%H%M%S).yaml
  gcp-get-resources --asset-types=dns.googleapis.com/ManagedZone --format yaml > $FILE
  echo $FILE
}
gcp-get-all-buckets () {
  FILE=gcp.buckets.$(date +%Y%m%d%H%M%S).json
  gcp-get-resources --asset-types=storage.googleapis.com/Bucket --format json > $FILE
  echo $FILE
}
display-project-buckets () {
  cat $1 | jq '.[] | ["|", .parentFullResourceName, "|", .displayName, "|"] | join(" ")' -r | sed "s/\/\/cloudresourcemanager.googleapis.com\/projects\///g" | sort
}

display-project-buckets2 () {
  cat $1 | jq '.[] | [.parentFullResourceName, "\t", .displayName] | join("")' -r | sed "s/\/\/cloudresourcemanager.googleapis.com\/projects\///g" | sort
}

# gcloud asset search-all-resources --scope="organizations/574083298316" --asset-types="compute.googleapis.com/Instance,compute.googleapis.com/ForwardingRule" --format=json | jq '.[] | select(.state != "TERMINATED") | [.assetType,.displayName,.additionalAttributes.IPAddress//.additionalAttributes.networkInterfaces[].accessConfigs[].natIP] | join(",")' -r > ips.csv
gcp-get-keys () {
  FILE=gcp.keys.$(date +%Y%m%d%H%M%S).txt
  gcp-get-resources --asset-types=iam.googleapis.com/ServiceAccountKey > $FILE
  echo $FILE
}
gcp-get-all-resources () {
  FILE=gcp.all_resources.$(date +%Y%m%d%H%M%S).txt
  gcp-get-resources > $FILE
  echo $FILE
}
gcp-get-all-policies () {
  FILE=gcp.all_policies.$(date +%Y%m%d%H%M%S).txt
  gcp-get-policies > $FILE
  echo $FILE
}
gcp-get-policies-for-user () {
  FILE=gcp.policies_for."$1".$(date +%Y%m%d%H%M%S).txt
  gcp-get-policies --query "policy:$1" > $FILE
  echo $FILE
}
gcp-find-enabled-api () {
  for project in $(gcp-list-projects); do
    echo $project
    gcloud services list --enabled --project $project;
  done
}
gcp-list-custom-roles () {
  gcloud iam roles list --organization=$GCP_ORG_ID
  for project in $(gcp-list-projects); do
    echo $project
    gcloud iam roles list --project=$project;
  done
}



git-stash-diff () {
  git stash show -p stash@{"$1"}
}

source "/usr/local/Caskroom/google-cloud-sdk/latest/google-cloud-sdk/path.zsh.inc"
source "/usr/local/Caskroom/google-cloud-sdk/latest/google-cloud-sdk/completion.zsh.inc"

eval "$(pyenv init -)"
test -e /Users/andy/.iterm2_shell_integration.zsh && source /Users/andy/.iterm2_shell_integration.zsh || true

### PROMPT
# Named colors: black, red, green, yellow, blue, magenta, cyan, white.
setopt PROMPT_SUBST
COLOR_PROMPT='magenta'
COLOR_SAFE='green'
COLOR_WARNING='yellow'
COLOR_DANGER='red'
COLOR_DEV='cyan'

print_user () {
  if [ ${USER} = 'root' ]; then
    COLOR=${COLOR_DANGER}
  elif [ ${USER} = 'andy' ]; then
    COLOR=${COLOR_SAFE}
  else
    COLOR=${COLOR_WARNING}
  fi
  print -P "%F{${COLOR}}%n%F{${COLOR_PROMPT}}"
}

print_host () {
  if [ ${HOST} = 'Andys-MacBook-Pro.local' ]; then
    COLOR=${COLOR_SAFE}
  else
    COLOR=${COLOR_WARNING}
  fi
  print -P "%F{${COLOR}}%M%F{${COLOR_PROMPT}}"
}

get_git_branch () {
  git branch 2> /dev/null | grep '^\*\ .*' | cut -c 3-
}

get_git_stashes () {
  git stash list 2> /dev/null | grep -c "WIP on $(get_git_branch)"
}

get_git_changes () {
  git status --porcelain 2> /dev/null
}

print_git_branch () {
  git_branch=$(get_git_branch)
  if [ ${git_branch} ]; then
    if [ $(get_git_stashes) != 0 ]; then
      COLOR=${COLOR_DANGER}
    elif [ "$(get_git_changes)" ]; then
      COLOR=${COLOR_WARNING}
    elif [ "${git_branch}" = "master" ]; then
      COLOR=${COLOR_SAFE}
    else
      COLOR=${COLOR_DEV}
    fi
    print -P "[%F{${COLOR}}${git_branch}%F{${COLOR_PROMPT}}]  "
  fi
}


PROMPT="
%F{${COLOR_PROMPT}}[%D{%Y-%m-%d %a %T}]  [\$(print_user)@\$(print_host)]  \$(print_git_branch)%~
%#%f "
eval "$(pyenv init -)"
