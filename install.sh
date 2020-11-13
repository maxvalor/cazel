#!/bin/bash

declare g_system_bin="/usr/bin"
declare g_src="./scripts"

function copy_scripts()
{
  local file=$1
  cp scripts/$file $g_system_bin
  chmod +x $g_system_bin/$file
}

function remove_scripts()
{
  local file=$1
  rm -f $g_system_bin/$file
}

function traversal
{
  local process=$1
  local files
  if [ ! -d $g_src ]; then
    echo "scripts directory not found."
    return 1
  fi
  if [ ! -d $g_system_bin ]; then
    echo "systen bin directory not found."
    return 1
  fi
  files=`ls $g_src`
  for file in $files
  do
    ${process} $file
  done
  return 0
}

function install()
{
  echo -n "Installing..."
  traversal copy_scripts
  if [ $? -eq 0 ]; then
    echo "done."
  fi
  return $?
}

function uninstall()
{
  echo -n "Uninstalling..."
  traversal remove_scripts
  if [ $? -eq 0 ]; then
    echo "done."
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
    "-i")
      install
      ;;
    "--install")
      install
      ;;
    "-u")
      uninstall
      ;;
    "--uninstall")
      uninstall
      ;;
    *)
      echo "command not found."
      ;;
  esac

  return $?
}

main $@
