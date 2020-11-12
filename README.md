# Depends Resolver
The bazel is great build tool, but a lot of projects do not support being built by it. We can ONLY build these projects by cmake. Since I like the repo management function of bazel so much, I write this tool - depends_resolver, to make the cmake manage depends of project like what bazel does. With this, you can easily get depends from several git repo and build then automatically.

# Install
Firstly, install package and clone the code:

    sudo apt install jq
    git clone https://github.com/maxvalor/depends_resolver dr
    
And then, build it:

    cd dr
    mkdir build && cd build
    cmake .. && make && sudo make install (not finished)

# How To Use
Build the sample with:

    cd sample/from_mini_ros
    dr_sync
    mkdir build && cd build
    cmake .. && make

# To Do
Supportting for dowloading zip, tar files from ftp.
