#!/bin/bash

echo -e "Applying vim configuration\n"
cp -f dotvimrc ~/.vimrc

echo -e "Applying ~/.vim folder\n"
rm -Rf ~/.vim
mkdir -p ~/.vim
cp -r dotvim/* ~/.vim

# command-T
vim --version | grep -q '\+ruby'
if [ $? -eq 0 ];then
    ruby --version | egrep -q '1\.8\.7|1.9|2.0'
    if [ $? -eq 0 ];then
        cd ~/.vim/bundle/command-t/ruby/command-t 1>/dev/null
        rm -f *.o *.so
        ruby extconf.rb
        make
        cd - 1>/dev/null
    else
        rm -rf ~/.vim/bundle/command-t
    fi
else
    rm -rf ~/.vim/bundle/command-t
fi

# Pyflakes, Flake8 and Jedi only for Python 2.5+
python -V 2>&1 | grep -q '2\.4'
if [ $? -eq 0 ];then
    rm -rf ~/.vim/bundle/flake8
    rm -rf ~/.vim/bundle/jedi-vim
fi
