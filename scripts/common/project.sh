#!/bin/bash
#-----------------------------------------------------------------------------#
#                             includes                                        #
#-----------------------------------------------------------------------------#

source ${CAZEL_LIBS_PATH}/common/const.sh
source ${CAZEL_LIBS_PATH}/common/util.sh
source ${CAZEL_LIBS_PATH}/common/json.sh
source ${CAZEL_LIBS_PATH}/common/logger.sh

#-----------------------------------------------------------------------------#
#                             inner functions                                 #
#-----------------------------------------------------------------------------#


#-----------------------------------------------------------------------------#
#                                 APIs                                        #
#-----------------------------------------------------------------------------#

# params:
#   $1 - target: path for check
# returns:
#   0 - target is a cazel proejct
#   1 - target is not a cazel project
#   9 - too many parameters
function isCazelProject()
{
  if [ $# != 1 ]; then
    return 9
  fi
  local target=$1
  if [ -f $target/$const_config_filename ]; then
    return 0
  fi
  return 1
}

# params:
#   $1 - target: path for check
# returns:
#   0 - target is a cazel proejct
#   1 - target is not a cazel project
#   9 - too many parameters
function isCMakeProject()
{
  if [ $# != 1 ]; then
    return 9
  fi
  local target=$1
  if [ -f $target/$const_cmakelists_filename ]; then
    return 0
  fi
  return 1
}

# params:
#   $1 - path for search
#   $2 - target
# echos:
#   string: path for target (first found)
# returns:
#   0 - target found
#   1 - target not found
#   2 - more that one target is found
#   9 - too many parameters
function searchForProject()
{
  if [ $# != 2 ]; then
    return 9
  fi

  local search_path=$1
  local target=$2
  local found_path
  local config_files=`find $search_path -name $const_config_filename`
  if [ "$config_files" == "" ]; then
    return 1
  fi

  local count=0
  local rlt=1
  for config_file in $config_files
  do
    local json_contents
    json_contents=`loadDependsFile $config_file`
    if [[ $? -eq 0 ]]; then
      local name
      name=`getJsonConfigValue "$json_contents" "name"`
      logInfoMsg "searchForProject:"$name
      if [ $? -eq 0 ] && [ "$name" == "$target" ]; then
        logInfoMsg "success, name:$name, target:$target"

        found_path="$found_path `getFilePath $config_file`"
        rlt=0
        count=`expr $count + 1`
        if [ $count -gt 1 ]; then
          rlt=2
        fi
      else
        logInfoMsg "failed. name:$name, target:$target"
      fi
    fi
  done

  echo $found_path
  logInfoMsg "found_path:$found_path"$name

  return $rlt
}
