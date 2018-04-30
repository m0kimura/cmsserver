#!/bin/bash
#@module ubモードでの標準前処理
#@desc プロジェクトの取り出し、＄DIRの省略時設定
cmd=$1
project=${PWD##*/}
null=
if [[ $DIR = "$null" ]]; then
  DIR=$HOME
fi
echo "### project: ${project}, DIR: ${DIR}, cmd: ${cmd} ###"
##
#@module run-fx ドッカー管理コマンド対応
#@param 1st {String} dockerコマンド push/stop/login/export/save
#@require pp-*
  if [[ ${cmd} = "push" ]]; then
    dex push
    exit
  elif [[ ${cmd} = "stop" ]]; then
    docker stop fx-${project}
    exit
  elif [[ ${cmd} = "login" ]]; then
    docker exec -it fx-${project} /bin/bash
    exit
  elif [[ ${cmd} = "export" ]]; then
    echo Export Container fx-${project} to local/fx-${project}.tar
    docker export fx-${project} -o ../local/fx-${project}.tar
    exit
  elif [[ ${cmd} = "save" ]]; then
    echo Save Image ${project} to local/${project}.tar
    docker save ${project} -o ../local/${project}.tar
    exit
  fi
##
#@module run-fx-daemon デーモン標準処理
#@desc デーモンとして常駐
#@desc 固定コンテナ(fx-)
#@desc ローカルホルダをfxボリュームホルダにひも付け
#@desc makeでHolderを$holderをひも付けする内部パスを指定すること
#@param {String} $1 ローカルひも付けホルダ
holder=$1
if [[ $1 = "$null" ]]; then
  holder='study-project'
fi
##
source=web-project/html
user=docker
it="-d"
echo "### ${source} に　${holder} が割当られました ###"
##
  if  [[ $2 = "$null" ]]; then
    it="-it"
  elif [[ $2 = "debug" ]]; then
    it="-it"
  fi
  docker run ${it} -h ${project} --rm \
    -p 80:80 \
    -p 443:443 \
    -v /mnt:/mnt \
    -v $HOME:/home/${user}/parent \
    m0kimura/${project} $1 $2 $3
##
