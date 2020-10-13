# Installation instructions

This chapter uses a series of modules that need external libraries and
utilites. You'll need to install Docker, and also libarchive and curl with

    sudo apt-get install libarchive13 libcurl4-openssl-dev

(in Ubuntu) in order to get the Raku libraries to work

Run, as in the other chapters,

    zef install --deps-only .
    
to install the modules we will be using.
