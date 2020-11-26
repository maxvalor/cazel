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

function buildTarget()
{
  if [ $# -gt 2 ]; then
    return 9
  fi

  local target_path=$1
  local workspace=`pwd`
  local target=$2
  local json_all

  json_all=`loadDependsFile $target_path/$const_config_filename`
  if [ $? -ne 0 ]; then
    return 1
  fi

  local depends_path
  depends_path=`getJsonConfigValue "$json_all" "path"`
  if [ $? -ne 0 ]; then
    return 1
  fi
  local target_name
  target_name=`getJsonConfigValue "$json_all" "name"`
  if [ $? -ne 0 ]; then
    return 1
  fi
  if [ ! -d $workspace/$const_depends_pathname/$target_name ]; then
    return 1
  fi

  # re-link depends
  if [ -L $target_path/$depends_path ]; then
    rm -f $target_path/$depends_path
  fi

  ln -s $workspace/$const_depends_pathname/$target_name $target_path/$depends_path

  local include_cmake_str="include($target_path/$depends_path/$const_generated_cmake)"

  cp $target_path/$const_cmakelists_filename $target_path/.$const_cmakelists_filename.cache
  echo " " >> $target_path/$const_cmakelists_filename
  echo "# added by depends_resolver" >> $target_path/$const_cmakelists_filename
  echo $include_cmake_str >> $target_path/$const_cmakelists_filename

  if [ ! -d $workspace/$const_build_pathname/$target_name ]; then
    mkdir -p $workspace/$const_build_pathname/$target_name
  fi
  cd $workspace/$const_build_pathname/$target_name
  local cmake_config
  cmake_config=`getJsonConfigValue "$json_all" "cmake"`
  if [ $? -ne 0 ]; then
    cmake_config=""
  fi
  cmake $cmake_config $target_path

  local make_config
  make_config=`getJsonConfigValue "$json_all" "make"`
  if [ $? -ne 0 ]; then
    make_config=""
  fi
  make $make_config $target

  cd $workspace

  # clean temp files
  rm -f $target_path/$depends_path
  mv $target_path/.$const_cmakelists_filename.cache $target_path/$const_cmakelists_filename

  return 0
}

#-----------------------------------------------------------------------------#
#                                 APIs                                        #
#-----------------------------------------------------------------------------#

# params:
#   $1 - target to build
# returns:
#   0 - success
#   1 - failed
#   9 - too many parameters
function commandCazelBuild()
{
  if [ $# -gt 2 ]; then
    return 9
  fi

  logInfoMsg "command: cazel build."

  local target=$1
  shift
  local ws=`pwd`
  local target_path

  target_path=`searchForProject $ws $target`

  case $? in
    0)
      buildTarget $target_path $@
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
  return 0
}
