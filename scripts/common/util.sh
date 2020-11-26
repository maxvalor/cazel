#!/bin/bash

#-----------------------------------------------------------------------------#
#                             global constants                                #
#-----------------------------------------------------------------------------#

#-----------------------------------------------------------------------------#
#                             global varibles                                 #
#-----------------------------------------------------------------------------#

#-----------------------------------------------------------------------------#
#                             inner functions                                 #
#-----------------------------------------------------------------------------#

# params:
#   $1 - origin string
# echos:
#   strng: left of the string
# returns
#   0 - success
function _strLeftBySlash()
{
    str=$1
    echo ${str%/*}
    return 0
}

# params:
#   $1 - origin string
# echos:
#   strng: right of the string
# returns
#   0 - success
function _strRightBySlash()
{
  str=$1
  echo ${str##*/}
  return 0
}


#-----------------------------------------------------------------------------#
#                                 APIs                                        #
#-----------------------------------------------------------------------------#

# params:
#   $1 - target file
# echos:
#   string - file path
#   0 - success
#   1 - file not existed
#   9 - too many or to few parameters
function getFilePath()
{
  if [ $# != 1 ]; then
    return 9
  fi

  local target_file=$1
  if [ -d $target_file ] || [ -f $target_file ]; then
    local target_path
    target_path=`_strLeftBySlash $target_file`
    if [[ $? -eq 0 ]]; then
      echo $target_path
      return 0
    fi
  fi

  return 1
}

# params:
#   $1 - target file
# echos:
#   string - filename
#   0 - success
#   1 - file not existed
#   9 - too many or to few parameters
function getFilename()
{
  if [ $# != 1 ]; then
    return 9
  fi

  local target_file=$1
  if [ -d $target_file ] || [ -f $target_file ]; then
    local target_path
    target_path=`_strRightBySlash $target_file`
    if [[ $? -eq 0 ]]; then
      echo $target_path
      return 0
    fi
  fi
  return 1
}

# params:
#   $1 - string to find
#   $2 - target filestring to find
# echos:
#   string - filename
#   0 - not found
#   1 - found
#   9 - too many or to few parameters
function findStringInFile()
{
  if [ $# != 2 ]; then
    return 9
  fi

  local str=$1
  local target_file=$2

  local found=1
  for txt in `cat $target_file`
  do
    if [ "$txt" == "$str" ]; then
      found=0
      break
    fi
  done

  return $found
}
