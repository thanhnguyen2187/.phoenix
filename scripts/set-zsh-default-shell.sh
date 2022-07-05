#!/bin/bash

echo "Make sure that this line exists within /etc/shells"
echo
echo "  " $(which zsh)
echo
read -r line

chsh -s $(which zsh)
