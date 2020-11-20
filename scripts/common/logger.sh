#!/bin/bash

#-----------------------------------------------------------------------------#
#                             local varibles                                 #
#-----------------------------------------------------------------------------#



#-----------------------------------------------------------------------------#
#                                 APIs                                        #
#-----------------------------------------------------------------------------#

# params:
#   $1 - log file
function logInit()
{
  local rlt=$?
  if [ "$CAZEL_LOG_PATH" == "" ]; then
    CAZEL_LOG_PATH=`pwd`
  fi
  echo "***************************************start cazel log***************************************" > ${CAZEL_LOG_PATH}/cazel.log
  return $rlt
}

# params:
#   $* - message
function logErrorMsg()
{
  local rlt=$?
  echo "[error] $*" >> ${CAZEL_LOG_PATH}/cazel.log
  return $rlt
}

# params:
#   $* - message
function logInfoMsg()
{
  local rlt=$?
  echo "[info] $*" >> ${CAZEL_LOG_PATH}/cazel.log
  return $rlt
}
