#!/bin/bash

echo -e "Applying vim configuration\n"
cp -f dotvimrc ~/.vimrc
cp -f gvimrc ~/.gvimrc

echo -e "Applying ~/.vim folder\n"
rm -Rf ~/.vim
mkdir -p ~/.vim
cp -r dotvim/* ~/.vim

# Pyflakes, Flake8 and Jedi only for Python 2.5+
python -V 2>&1 | grep -q '2\.4'
if [ $? -eq 0 ];then
    rm -rf ~/.vim/bundle/flake8
    rm -rf ~/.vim/bundle/jedi-vim
fi
