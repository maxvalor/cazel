import os
import sys
import json
import git

def get_depends(path):
    configfile = path + '/depends.json'
    if os.path.exists(configfile):
        with open(configfile, 'r') as f:
            data = json.load(f)
            depends = data['depends']
            cmake_subdir = ''
            for depend in depends:
                lrepo = path + '/' + depend['dest'] + '/' + depend['name']
                if not os.path.exists(lrepo):
                    print('cloning ' + depend['repo'] + ' to ' + lrepo + ' ...')
                    clone_repo = git.Repo.clone_from(depend['repo'], lrepo)
                    print('finished.')
                else:
                    print(depend['name'] + ' is alread existed.')

                cmake_subdir = cmake_subdir + 'add_subdirectory(' \
                    + depend['name'] + ')\n'
                get_depends(lrepo)
            cmake_file = path + '/' + 'depends.cmake'
            with open(cmake_file, 'w+') as fo:
                fo.write(cmake_subdir)

def main():
    get_depends(sys.argv[1])


if __name__ == '__main__':
    main()
