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

function execTarget()
{
  local target_path=$1
  local binfile=$2
  shift 2


  #export LD_LIBRARY_PATH=$LD_LIBRARY_PATH:$workspace/$const_build_pathname/$target_name/depends/mini_ros
  #echo $LD_LIBRARY_PATH

  if [ -f $target_path/$binfile ]; then
    $target_path/$binfile $@
    return 0
  fi

  return 1
}

#-----------------------------------------------------------------------------#
#                                 APIs                                        #
#-----------------------------------------------------------------------------#

# params:
#   $1 - target project to exec
#   $2 - binary file
# returns:
#   0 - success
#   1 - failed
#   9 - too many parameters
function commandCazelExec()
{
  if [ $# != 2 ]; then
    return 9
  fi

  logInfoMsg "command: cazel exec."

  local target=$1
  shift
  local target_path
  target_path=`searchInBuild $target`

  case $? in
    0)
      execTarget $target_path $@
      ;;
    1)
      echo "Target:"$target" not found. Please check your projects again."
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
