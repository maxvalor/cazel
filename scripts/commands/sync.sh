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

declare __sync__root_depends_path

#-----------------------------------------------------------------------------#
#                             inner functions                                 #
#-----------------------------------------------------------------------------#

function updateGeneratedCMake()
{
  local depend_project=$1
  local add_sub_str="add_subdirectory($__sync__root_depends_path/$depend_project)"
  findStringInFile $add_sub_str $__sync__root_depends_path/$const_generated_cmake
  if [ $? -eq 1 ]; then
    echo $add_sub_str >> $__sync__root_depends_path/$const_generated_cmake
  fi
}

function syncLocalRepo()
{
  local json_all_local=$1

  local index=0
  local to_break=0

  logInfoMsg "syncLocalRepo"

  while [ $to_break -eq 0 ]
  do
    local json_local
    json_local=`getJsonLocalByIndex "$json_all_local" $index`
    if [ $? -ne 0 ]; then
      return 0
    fi

    logInfoMsg "json_local:$json_local"

    local name
    name=`getJsonValue "$json_local" "name"`
    if [ $? -ne 0 ]; then
      return 1
    fi
    local src
    src=`getJsonValue "$json_local" "src"`
    if [ $? -ne 0 ]; then
      return 1
    fi


    logInfoMsg "copy src:$src to $__sync__root_depends_path"
    cp -r $src $__sync__root_depends_path

    if [ ! -L $name ] && [ ! -d $name ]; then
      ln -s $__sync__root_depends_path/$name `pwd`/$name
    fi

    isCMakeProject $name
    logInfoMsg "depend $name is cmake project? => $?"
    if [ $? -eq 0 ]; then
      updateGeneratedCMake $name
    fi

    isCazelProject $name
    if [ $? -eq 0 ]; then
      logInfoMsg "a nested cazel workspace"
      local target_path=`pwd`/$name
      local json_all
      logInfoMsg "nested target_path:$target_path"
      json_all=`loadDependsFile $target_path/$const_config_filename`
      if [ $? -ne 0 ]; then
        return 1
      fi
      syncRepo $target_path "$json_all"
    fi

    index=`expr $index + 1`
  done

  return 0
}

function syncGitRepo()
{
  local json_all_git=$1

  local index=0
  local to_break=0

  logInfoMsg "syncGitRepo"

  while [ $to_break -eq 0 ]
  do
    local json_git
    json_git=`getJsonArrayByIndex "$json_all_git" $index`
    if [ $? -ne 0 ]; then
      return 0
    fi

    logInfoMsg "json_git:$json_git"

    local name
    name=`getJsonValue "$json_git" "name"`
    if [ $? -ne 0 ]; then
      return 1
    fi

    if [ -d $__sync__root_depends_path/$name ]; then
      logInfoMsg "git pull $__sync__root_depends_path/$name"
      cd $__sync__root_depends_path/$name
      git pull
      cd -
    else
      local url
      url=`getJsonValue "$json_git" "url"`
      if [ $? -ne 0 ]; then
        return 1
      fi
      logInfoMsg "git clone $url $__sync__root_depends_path/$name"
      git clone $url $__sync__root_depends_path/$name
    fi

    local branch
    branch=`getJsonValue "$json_git" "branch"`
    if [ $? -eq 0 ]; then
      cd $name
      git checkout $branch
      cd -
    fi

    local tag
    tag=`getJsonValue "$json_git" "tag"`
    if [ $? -eq 0 ]; then
      cd $name
      git checkout $tag
      cd -
    fi

    local commit
    commit=`getJsonValue "$json_git" "commit"`
    if [ $? -eq 0 ]; then
      cd $name
      git checkout $commit
      cd -
    fi

    if [ ! -L $name ] && [ ! -d $name ]; then
      ln -s $__sync__root_depends_path/$name `pwd`/$name
    fi

    isCMakeProject $name
    logInfoMsg "depend $name is cmake project? => $?"
    if [ $? -eq 0 ]; then
      updateGeneratedCMake $name
    fi

    isCazelProject $name
    if [ $? -eq 0 ]; then
      logInfoMsg "a nested cazel workspace"
      local target_path=`pwd`/$name
      local json_all
      logInfoMsg "nested target_path:$target_path"
      json_all=`loadDependsFile $target_path/$const_config_filename`
      if [ $? -ne 0 ]; then
        return 1
      fi
      syncRepo $target_path "$json_all"
    fi

    index=`expr $index + 1`
  done

  return $?
}

function syncFtpRepo()
{
  return 0
}

function syncRepo()
{
  local workspace=`pwd`
  local project_path=$1
  cd $project_path

  local json_all=$2

  local depends_path
  depends_path=`getJsonConfigValue "$json_all" "path"`
  if [ $? -ne 0 ]; then
    return 1
  fi
  if [ ! -L $depends_path ]; then
    #mkdir -p $depends_path
    ln -s $__sync__root_depends_path $depends_path
  fi

  cd $depends_path

  # get all depends
  local index=0
  local to_break=0

  while [ $to_break -eq 0 ]
  do
    logInfoMsg "try to get depends[$index]"
    json_depend=`getJsonDependsByIndex "$json_all" $index`
    if [ $? -eq 0 ]; then

      local json_all_local
      json_all_local=`getJsonAllLocal "$json_depend"`
      if [ $? -eq 0 ]; then
        syncLocalRepo "$json_all_local"
        logInfoMsg "return code of syncLocalRepo:$?"
      fi

      local json_git
      json_all_git=`getJsonAllGit "$json_depend"`
      if [ $? -eq 0 ]; then
        syncGitRepo "$json_all_git"
        temp=1
      fi

      local json_ftp
      json_all_ftp=`getJsonAllFtp "$json_depend"`
      if [ $? -eq 0 ]; then
        syncFtpRepo "$json_all_ftp"
      fi
    else
      to_break=1
    fi
    index=`expr $index + 1`
  done

  cd $workspace
  return $?
}

# params:
#   $1 - target path
# returns:
#   0 - success
#   1 - failed
#   9 - too many parameters
function syncRootRepo()
{
  if [ $# != 1 ]; then
    return 9
  fi

  local target_path=$1
  local json_all
  json_all=`loadDependsFile $target_path/$const_config_filename`
  if [ $? -ne 0 ]; then
    return 1
  fi

  local workspace=`pwd`
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
  # make the path of cazel-depends
  if [ ! -d $workspace/$const_depends_pathname/$target_name ]; then
    mkdir -p $workspace/$const_depends_pathname/$target_name
  fi
  # re-link depends
  if [ -L $target_path/$depends_path ]; then
    rm -f $target_path/$depends_path
    ln -s $workspace/$const_depends_pathname/$target_name $target_path/$depends_path
  fi

  # re-touch depends.cmake
  if [ -f $workspace/$const_depends_pathname/$target_name/$const_generated_cmake ]; then
    rm -f $workspace/$const_depends_pathname/$target_name/$const_generated_cmake
  fi
  touch $workspace/$const_depends_pathname/$target_name/$const_generated_cmake

  __sync__root_depends_path=$target_path/$depends_path

  syncRepo "$target_path" "$json_all"

  return $?
}

#-----------------------------------------------------------------------------#
#                                 APIs                                        #
#-----------------------------------------------------------------------------#

# params:
#   $1 - target to sync
# returns:
#   0 - success
#   1 - failed
#   9 - too many parameters
function commandCazelSync()
{
  if [ $# != 1 ]; then
    return 9
  fi

  logInfoMsg "command: cazel sync."

  local target=$1
  local ws=`pwd`
  local target_path
  target_path=`searchForProject $ws $target`

  case $? in
    0)
      syncRootRepo $target_path
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

  return 0
}
