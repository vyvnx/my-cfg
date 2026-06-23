nvim +11.4 =>

:PlugClean
:PlugInstall

bash -c 'set -e; d=$(mktemp -d); cd "$d"; curl -fL -o nvim.tar.gz https://github.com/neovim/neovim/releases/download/stable/nvim-linux-x86_64.tar.gz; tar -xzf nvim.tar.gz; sudo rm -rf /usr/local/nvim; sudo mv nvim-linux* /usr/local/nvim; sudo ln -sf /usr/local/nvim/bin/nvim /usr/local/bin/nvim; /usr/local/bin/nvim --version | head -n1'
