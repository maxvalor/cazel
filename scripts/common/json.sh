#!/bin/bash

#-----------------------------------------------------------------------------#
#                             includes                                        #
#-----------------------------------------------------------------------------#

source ${CAZEL_LIBS_PATH}/common/const.sh
source ${CAZEL_LIBS_PATH}/common/util.sh
source ${CAZEL_LIBS_PATH}/common/logger.sh

#-----------------------------------------------------------------------------#
#                             global constants                                #
#-----------------------------------------------------------------------------#

#-----------------------------------------------------------------------------#
#                             global varibles                                 #
#-----------------------------------------------------------------------------#

#-----------------------------------------------------------------------------#
#                             inner functions                                 #
#-----------------------------------------------------------------------------#

#-----------------------------------------------------------------------------#
#                                 APIs                                        #
#-----------------------------------------------------------------------------#

# params:
#   $1 - target file
# echos:
#   string: content of the config file
# returns:
#   0 - success
#   1 - target is not a cazel config file
#   9 - too many or to few parameters
function loadDependsFile()
{
  if [ $# != 1 ]; then
    return 9
  fi

  local config_file=$1
  local filename=`getFilename $config_file`
  if [ "$filename" != "$const_config_filename" ]; then
    return 1
  fi

  cat $config_file

  return 0
}

# params:
#   $1 - json string
#   $2 - name of value
# echos:
#   string: the value
# returns:
#   0 - success
#   1 - value not found
#   9 - too many or to few parameters
function getJsonValue()
{
  if [ $# != 2 ]; then
    return 9
  fi
  local json_string=$1
  local pattern=".$2"

  local rlt=`echo "$json_string" | jq -r $pattern`
  if [ "$rlt" == "null" ] || [ "$rlt" == ""  ];then
    return 1
  fi
  echo $rlt
  return 0
}



# params:
#   $1 - json string
#   $2 - index
# echos:
#   string: local json string
# returns:
#   0 - success
#   1 - value not found
#   9 - too many or to few parameters
function getJsonArrayByIndex()
{
  if [ $# != 2 ]; then
    return 9
  fi
  local json_string=$1
  local pattern=".[$2]"

  local rlt=`echo "$json_string" | jq -r $pattern`
  if [ "$rlt" == "null" ] || [ "$rlt" == "" ];then
    return 1
  fi
  echo $rlt
  return 0
}

# params:
#   $1 - json string
#   $2 - name of value
# echos:
#   string: the value
# returns:
#   0 - success
#   1 - value not found
#   9 - too many or to few parameters
function getJsonConfigValue()
{
  if [ $# != 2 ]; then
    return 9
  fi
  local json_string=$1
  local pattern=".config.$2"

  local rlt=`echo "$json_string" | jq -r $pattern`
  if [ "$rlt" == "null" ] || [ "$rlt" == ""  ];then
    return 1
  fi
  echo $rlt
  return 0
}

# params:
#   $1 - json string
#   $2 - index
# echos:
#   string: depend json string
# returns:
#   0 - success
#   1 - value not found
#   9 - too many or to few parameters
function getJsonDependsByIndex()
{
  if [ $# != 2 ]; then
    return 9
  fi
  local json_string=$1
  local pattern=".depends[$2]"

  local rlt=`echo "$json_string" | jq -r $pattern`
  if [ "$rlt" == "null" ] || [ "$rlt" == ""  ];then
    return 1
  fi
  echo $rlt
  return 0
}

# params:
#   $1 - json string
# echos:
#   string: all of "local" json string
# returns:
#   0 - success
#   1 - value not found
#   9 - too many or to few parameters
function getJsonAllLocal()
{
  if [ $# != 1 ]; then
    return 9
  fi
  local json_string=$1
  local pattern=".local"

  local rlt=`echo "$json_string" | jq -r $pattern`
  if [ "$rlt" == "null" ] || [ "$rlt" == ""  ];then
    return 1
  fi
  echo $rlt
  return 0
}

# params:
#   $1 - json string
# echos:
#   string: all of "local" json string
# returns:
#   0 - success
#   1 - value not found
#   9 - too many or to few parameters
function getJsonAllGit()
{
  if [ $# != 1 ]; then
    return 9
  fi
  local json_string=$1
  local pattern=".git"

  local rlt=`echo "$json_string" | jq -r $pattern`
  if [ "$rlt" == "null" ] || [ "$rlt" == ""  ];then
    return 1
  fi
  echo $rlt
  return 0
}

# params:
#   $1 - json string
# echos:
#   string: all of "local" json string
# returns:
#   0 - success
#   1 - value not found
#   9 - too many or to few parameters
function getJsonAllFtp()
{
  if [ $# != 1 ]; then
    return 9
  fi
  local json_string=$1
  local pattern=".ftp"

  local rlt=`echo "$json_string" | jq -r $pattern`
  if [ "$rlt" == "null" ] || [ "$rlt" == ""  ];then
    return 1
  fi
  echo $rlt
  return 0
}


# params:
#   $1 - json string
#   $2 - index
# echos:
#   string: local json string
# returns:
#   0 - success
#   1 - value not found
#   9 - too many or to few parameters
function getJsonLocalByIndex()
{
  if [ $# != 2 ]; then
    return 9
  fi
  local json_string=$1
  local pattern=".[$2]"

  local rlt=`echo "$json_string" | jq -r $pattern`
  if [ "$rlt" == "null" ] || [ "$rlt" == "" ];then
    return 1
  fi
  echo $rlt
  return 0
}
