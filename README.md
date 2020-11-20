# Cazel
The bazel is great build tool, but a lot of projects do not support being built by it. We can ONLY build these projects by cmake. Since I like the repo management function of bazel so much, I write this tool - depends_resolver, to make the cmake manage depends of project like what bazel does. With this, you can easily get depends from several git repo and build then automatically. The reason that I call it cazel is that the word "cazel" is like a "cmake" takes suits of the "bazel" :)

# Install
The depends resolver can be install with:

    sudo apt install jq
    git clone https://github.com/maxvalor/cazel cazel
    cd cazel
    sudo ./install.sh

And you can uninstall it with:

    sudo ./install.sh -u

# How To Use
Build the sample with:

    cazel sync from_mini_ros
    cazel build from_mini_ros

Or you can simply build it with:

    cazel auto from_mini_ros

Clean the build files with:

    cazel clean from_mini_ros

Remove the depends and build files with:

    cazel remove from_mini_ros

Execute the binary file with:

    cazel exec from_mini_ros sample
    
Another sample is as the same:

    cazel re-auto for_local_files
    

# To Do
Supportting for dowloading zip, tar files from ftp.
