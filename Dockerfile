FROM golang:1.12.4
MAINTAINER Yanhao Yang <yanhao.yang@gmail.com>

# Development tools
RUN \
  apt-get update && \
  DEBIAN_FRONTEND=noninteractive apt-get install -y \
  # for build vim
  python-dev libncurses5-dev libncursesw5-dev \
  python3-dev ruby-dev lua5.1 liblua5.1-dev \
  zsh silversearcher-ag curl locales sudo less \
  && \
  apt-get autoremove -y && \
  apt-get autoclean && \
  apt-get clean && \
  rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

RUN \
  chsh --shell /bin/zsh && \
  echo "en_US.UTF-8 UTF-8" > /etc/locale.gen && \
  locale-gen && \
  groupadd --gid 1000 docker && \
  useradd --gid 1000 --uid 1000 --create-home docker && \
  echo "docker ALL=(root) NOPASSWD:ALL" > /etc/sudoers.d/user && \
  chmod 0440 /etc/sudoers.d/user && \
  chown -R docker:docker /go && \
  # build vim
  cd /tmp && \
  git clone https://github.com/vim/vim.git && \
  cd /tmp/vim && \
  ./configure \
    --with-features=huge \
    --enable-multibyte \
    --enable-rubyinterp=yes \
    --enable-pythoninterp=yes \
    --with-python-config-dir=/usr/lib/python2.7/config-x86_64-linux-gnu \
    --enable-python3interp=yes \
    --with-python3-config-dir=/usr/lib/python3.4/config-3.4m-x86_64-linux-gnu \
    --enable-luainterp=yes \
    --enable-cscope \
  && \
  make && \
  make install && \
  cd ~ && \
  rm -rf /tmp/*

ENV TERM=xterm-256color

# To make oh-my-zsh installer happy
ENV SHELL=/usr/bin/zsh

COPY bin/spark /usr/local/bin/spark

USER docker

# nvm && yarn
ENV NODE_VERSION v10.16.0
RUN curl -o- https://raw.githubusercontent.com/creationix/nvm/v0.33.11/install.sh | bash && \
  bash -c "\
    source $HOME/.nvm/nvm.sh && \
    nvm install $NODE_VERSION && \
    npm install -g yarn && \
    echo 'Done!'"

RUN \
  sh -c "$(curl -fsSL https://raw.githubusercontent.com/robbyrussell/oh-my-zsh/master/tools/install.sh)" && \
   git clone https://github.com/zsh-users/zsh-syntax-highlighting.git ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-syntax-highlighting && \
   git clone https://github.com/zsh-users/zsh-autosuggestions.git ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-autosuggestions && \
  git clone --depth 1 https://github.com/junegunn/fzf.git ~/.fzf && \
  ~/.fzf/install --all

COPY --chown=docker:docker bin/gs /usr/local/bin/gs
COPY --chown=docker:docker bin/nb /usr/local/bin/nb
COPY --chown=docker:docker bin/gocilint.sh /usr/local/bin/gocilint.sh
COPY --chown=docker:docker bin/install-protoc.sh /usr/local/bin/install-protoc.sh
COPY --chown=docker:docker config/zshrc /home/docker/.zshrc
COPY --chown=docker:docker config/gitignore_global /home/docker/.gitignore_global
COPY --chown=docker:docker config/gitconfig /home/docker/.gitconfig
COPY --chown=docker:docker config/vim /home/docker/.vim

RUN cd ~/.vim && ./setup.sh

EXPOSE 3000
WORKDIR /go/src
CMD ["spark", "-port", "65533", "<h1>Hello world!</h1>"]
