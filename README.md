# Cazel
The bazel is great build tool, but a lot of projects do not support being built by it. We can ONLY build these projects by cmake. Since I like the repo management function of bazel so much, I write this tool - depends_resolver, to make the cmake manage depends of project like what bazel does. With this, you can easily get depends from several git repo and build then automatically.

# Install
The depends resolver can be install with:

    sudo apt install jq
    git clone https://github.com/maxvalor/depends_resolver dr
    cd dr
    sudo ./install.sh

And you can uninstall it with:

    sudo ./install.sh -u

# How To Use
Build the sample with:

    cd sample/from_mini_ros
    dr_sync
    mkdir build && cd build
    cmake .. && make

Or you can simply build it with:

    dr_sync sample/from_mini_ros
    dr_make sample/from_mini_ros

Clean the build files with:

    dr_clean sample/from_mini_ros
    
Remove the depends with:

    dr_remove sample/from_mini_ros

# To Do
Supportting for dowloading zip, tar files from ftp.
