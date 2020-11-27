#!/bin/bash

#-----------------------------------------------------------------------------#
#                             includes                                        #
#-----------------------------------------------------------------------------#
source ${CAZEL_LIBS_PATH}/common/logger.sh
source ${CAZEL_LIBS_PATH}/common/util.sh
#-----------------------------------------------------------------------------#
#                             inner functions                                 #
#-----------------------------------------------------------------------------#

function __ftp_getProtocal()
{
  echo "$1" | awk -F':' '{print $1}'
}

function __ftp_getHostnameOrIP()
{
  echo "$1" | awk -F'[/:]' '{print $4}'
}

function __ftp_getPort()
{
  local port=`echo "$1" | awk -F'[/:]' '{print $5}'`
  if [ -n "$(echo $port| sed -n "/^[0-9]\+$/p")" ]; then
    echo $port
    return 0
  else
    return 1
  fi
}

function __ftp_getPath()
{
  echo "$1" | cut -d/ -f4-
}


#-----------------------------------------------------------------------------#
#                                 APIs                                        #
#-----------------------------------------------------------------------------#

# params:
#   $1 - url
#   $2 - username
#   $3 - password
# echos:
#   string: download file filename
# returns:
#   0 - success
#   1 - target is not a cazel config file
#   9 - too many or to few parameters
function ftpDownload()
{
  local url=$1
  local username=$2
  local password=$3

  local protocol=`__ftp_getProtocal $url`
  local hostname=`__ftp_getHostnameOrIP $url`
  local port=`__ftp_getPort $url`
  local path=`__ftp_getPath $url`
  local dir=`getFilePath $path`
  local filename=`getFilename $path`
  if [ "$dir" == "$filename" ]; then
    dir="."
  fi

  logDebugMsg "protocol:$protocol"
  logDebugMsg "hostname:$hostname"
  logDebugMsg "port:$port"
  logDebugMsg "path:$path"
  logDebugMsg "dir:$dir"
  logDebugMsg "filename:$filename"

  if [ "$username" != "" ]; then
    logDebugMsg "with user."
    ${protocol} -v -n $hostname $port << EOF
    user $username $password
    binary
    prompt
    cd $dir
    get $filename
    bye
EOF
  else
    ${protocol} -v -n $hostname $port << EOF
    user anonymous 1
    binary
    prompt
    cd $dir
    get $filename
    bye
EOF
  fi

  return 0
}
