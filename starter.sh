#!/bin/bash
##
holder=$1
mode=$2
  if [[ $1 = "none" ]]; then
    holder="study-project"
  fi
##
  echo "### holder=${holder} mode=${mode} ###"
  prefix='debug'
  if [[ $mode = 'master' ]]; then
    prefix='master'
  fi
  if  [[ -e ./parent/debug.config ]]; then
    ln -sf ./parent/debug.config ${prefix}.config
  elif  [[ -e ./parent/master.config ]]; then
    ln -sf ./parent/master.config ${prefix}.config
  else
    ln -sf /usr/src/master.config ${prefix}.config
  fi
  ln -s $HOME/parent/localconf localconf
  cd web-project
  ln -s $HOME/parent/${holder} html
##
  if [[ -e ./html/es ]]; then
    ./node_modules/.bin/babel ./html/es/ -d ./html/js/
  fi
  cd nodejs
  if [[ $mode = 'master' ]]; then
    sudo forever server.js
  elif [[ $mode = 'debug' ]]; then
    sudo node server.js
  else
    echo "1. 実行には、ソースフォルダとモード（master/debug）を指定してください。"
    pwd
    /bin/bash
  fi
