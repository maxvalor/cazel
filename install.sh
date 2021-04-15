#!/bin/bash

source scripts/common/util.sh

declare g_system_bin="/usr/bin"
declare g_system_lib="/usr/lib"
declare g_system_completion="/etc/bash_completion.d"
declare g_src="./scripts"

function install()
{
  #local export_str="export CAZEL_LIBS_PATH=$g_system_lib/cazel/"
  #findStringInFile $export_str ~/.bashrc
  #if [ $? -eq 1 ]; then
  #  echo $export_str >> ~/.bashrc
  #fi
  if [[ ! -d scripts ]]; then
    echo "scripts directory not found."
    return 1
  fi
  echo "Installing cazel..."

  for obj in `ls scripts`
  do
    if [ -f scripts/$obj ]; then
      echo -n "Copying $obj into $g_system_bin..."
      cp scripts/$obj $g_system_bin/
      echo "done."
    fi
  done

  mkdir -p $g_system_lib/cazel

  echo -n "Copying common into $g_system_lib/cazel..."
  cp -r scripts/common $g_system_lib/cazel
  echo "done."
  echo -n "Copying commands into $g_system_lib/cazel..."
  cp -r scripts/commands $g_system_lib/cazel
  echo "done."

  echo -n "Setting completion..."
  cp scripts/completion/cazel-completion $g_system_completion
  echo "done."

  source ~/.bashrc

  return $?
}

function uninstall()
{
  if [[ ! -d scripts ]]; then
    echo "scripts directory not found."
    return 1
  fi
  echo "Uninstalling cazel..."

  for obj in `ls scripts`
  do
    if [ -f scripts/$obj ]; then
      echo -n "Removing $g_system_bin/$obj..."
      rm -f $g_system_bin/$obj
      echo "done."
    fi
  done

  if [ -d $g_system_lib/cazel ]; then
    echo -n "Removing $g_system_lib/cazel ..."
    rm -rf $g_system_lib/cazel
    echo "done."
  fi

  if [ -f $g_system_completion/cazel-completion ]; then
    rm -f $g_system_completion/cazel-completion
  fi

  return $?
}


function main()
{
  local option
  option=$1
  if [ "$option" == "" ]; then
    option="--install"
  fi

  case "$option" in
    "--install" | "-i")
      install
      ;;
    "--uninstall" | "-u")
      uninstall
      ;;
    *)
      echo "command not found."
      ;;
  esac

  return $?
}

main $@
