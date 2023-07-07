#!/usr/bin/env fish

curl -sL https://raw.githubusercontent.com/jorgebucaran/fisher/main/functions/fisher.fish | source && fisher install jorgebucaran/fisher

# fisher plugins
fisher install jethrokuan/z
fisher install jorgebucaran/nvm.fish
fisher install patrickf1/fzf.fish
fisher install ilancosman/tide@v5

nvm install lts
nvm use lts
set --universal nvm_default_version lts

tide configure
