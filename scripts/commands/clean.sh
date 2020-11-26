#!/bin/bash
#-----------------------------------------------------------------------------#
#                             includes                                        #
#-----------------------------------------------------------------------------#
source ${CAZEL_LIBS_PATH}/common/project.sh
source ${CAZEL_LIBS_PATH}/common/util.sh
source ${CAZEL_LIBS_PATH}/common/logger.sh

#-----------------------------------------------------------------------------#
#                             local varibles                                  #
#-----------------------------------------------------------------------------#

#-----------------------------------------------------------------------------#
#                             inner functions                                 #
#-----------------------------------------------------------------------------#

function cleanTarget()
{
  if [ $# != 1 ]; then
    return 9
  fi

  local target_path=$1
  local workspace=`pwd`
  cd $target_path
  make clean
  cd $workspace

  return 0
}

#-----------------------------------------------------------------------------#
#                                 APIs                                        #
#-----------------------------------------------------------------------------#

# params:
#   $1 - target to clean
# returns:
#   0 - success
#   1 - failed
#   9 - too many parameters
function commandCazelClean()
{
  if [ $# != 1 ]; then
    return 9
  fi

  logInfoMsg "command: cazel clean."

  local target=$1
  shift
  local target_path
  target_path=`searchInBuild $target`

  case $? in
    0)
      cleanTarget $target_path $@
      ;;
    1)
      echo "Target:"$1" not found. Please check your projects again."
      ;;
    2)
      echo "More than one target path is found:"
      for found_target in $target_path
      do
        echo " - $found_target"
      done
      ;;
    *)
      echo "unkown error."
      ;;
  esac

  return $?
}
