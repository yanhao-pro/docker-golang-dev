set -e

root_dir=$PWD

TERM=xterm-256color

# Setup zsh
SHELL=/usr/bin/zsh && \
  sh -c "$(curl -fsSL https://raw.githubusercontent.com/robbyrussell/oh-my-zsh/master/tools/install.sh)" && \
   git clone https://github.com/zsh-users/zsh-syntax-highlighting.git ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-syntax-highlighting && \
   git clone https://github.com/zsh-users/zsh-autosuggestions.git ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-autosuggestions && \
  git clone --depth 1 https://github.com/junegunn/fzf.git ~/.fzf && \
  ~/.fzf/install --all
cp -rv $root_dir/config/zshrc $HOME/.zshrc

NODE_VERSION=v14.17.1
curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.38.0/install.sh | bash && \
  bash -c "\
    source $HOME/.nvm/nvm.sh && \
    nvm install $NODE_VERSION && \
    npm install -g yarn && \
    echo 'Done!'"

cp -rv $root_dir/config/vim $HOME/.vim
cd ~/.vim && ./setup.sh

cp -rv $root_dir/config/gitignore_global $HOME/.gitignore_global
cp -rv $root_dir/config/gitconfig $HOME/.gitconfig

cd && \
  rm -fr .tmux && \
  git clone https://github.com/gpakosz/.tmux.git && \
  ln -s -f .tmux/.tmux.conf && \
  cp -rv .tmux/.tmux.conf.local .
