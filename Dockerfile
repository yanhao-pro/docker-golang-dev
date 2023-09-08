ARG  GO_VERSION=1.21.0
FROM golang:${GO_VERSION}-bullseye

# Development tools
RUN \
  apt-get update && \
  DEBIAN_FRONTEND=noninteractive apt-get install -y \
  zsh silversearcher-ag locales sudo less tmux rsync jq \
  ninja-build gettext cmake unzip curl \
  openssh-server \
  && \
  apt-get autoremove -y && \
  apt-get autoclean && \
  apt-get clean && \
  rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

RUN cd /tmp && \
  git clone https://github.com/neovim/neovim && \
  cd neovim && make CMAKE_BUILD_TYPE=RelWithDebInfo && \
  make install && \
  apt-get update && \
  apt-get install -y python3-pip && \
  apt-get clean && \
  python3 -m pip uninstall neovim pynvim && \
  python3 -m pip install --user --upgrade pynvim && \
  rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

RUN curl -sS https://starship.rs/install.sh -o /tmp/install.sh && sh /tmp/install.sh --yes && rm -rf /tmp/*

RUN \
  echo "en_US.UTF-8 UTF-8" > /etc/locale.gen && \
  locale-gen && \
  groupadd --gid 1000 docker && \
  useradd --gid 1000 --uid 1000 --create-home --shell /bin/bash docker && \
  echo "docker ALL=(root) NOPASSWD:ALL" > /etc/sudoers.d/user && \
  chmod 0440 /etc/sudoers.d/user && \
  chown -R docker:docker /go && \
  chown -R docker:docker /etc/ssh && \
  mkdir /app && chown -R docker /app

ENV TERM=xterm-256color

USER docker

# Setup zsh
RUN export SHELL=/usr/bin/zsh && \
  sh -c "$(curl -fsSL https://raw.githubusercontent.com/robbyrussell/oh-my-zsh/master/tools/install.sh)" && \
   git clone https://github.com/zsh-users/zsh-syntax-highlighting.git ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-syntax-highlighting && \
   git clone https://github.com/zsh-users/zsh-autosuggestions.git ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-autosuggestions && \
  git clone --depth 1 https://github.com/junegunn/fzf.git ~/.fzf && \
  ~/.fzf/install --all
COPY --chown=docker:docker config/zshrc /home/docker/.zshrc

ENV NODE_VERSION v18.16.0
RUN curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.38.0/install.sh | bash && \
  bash -c "\
    source $HOME/.nvm/nvm.sh && \
    nvm install $NODE_VERSION && \
    npm install -g yarn && \
    echo 'Done!'"

# Enable VSCode remote
# ADD vsc-go.tgz /home/docker/
# ADD vsc-server.tgz /home/docker/

RUN cd /tmp && \
  git clone https://github.com/jesseduffield/lazygit.git && \
  cd lazygit && \
  go install && \
  rm -fr /tmp/* && \
  rm -fr /home/docker/.cache/go-build

RUN go install github.com/fullstorydev/grpcurl/cmd/grpcurl@latest && \
  CGO_ENABLED=1 go install -tags extended github.com/gohugoio/hugo@latest && \
  rm -fr /home/docker/.cache/go-build

RUN mkdir -p ~/.ssh && \
  ssh-keyscan github.com >> ~/.ssh/known_hosts && \
  mkdir -p /home/docker/.config/nvim

# tmux new-session -c $PWD
RUN cd && \
  git clone https://github.com/gpakosz/.tmux.git && \
  ln -s -f .tmux/.tmux.conf && \
  cp .tmux/.tmux.conf.local .

COPY --chown=docker:docker bin/sync-in.sh /usr/local/bin/sync-in
COPY --chown=docker:docker bin/sync-out.sh /usr/local/bin/sync-out

COPY --chown=docker:docker bin/gs /usr/local/bin/gs
COPY --chown=docker:docker bin/nb /usr/local/bin/nb
COPY --chown=docker:docker config/gitignore_global /home/docker/.gitignore_global
COPY --chown=docker:docker config/gitconfig /home/docker/.gitconfig
COPY --chown=docker:docker config/starship.toml /home/docker/.config/starship.toml

COPY --chown=docker:docker config/nvim /home/docker/.config/nvim
RUN cd ~/.config/nvim && ./setup.sh

EXPOSE 2222
CMD ["/usr/sbin/sshd", "-D", "-p", "2222"]
