FROM debian:12.5

# Development tools
RUN \
  apt-get update && \
  DEBIAN_FRONTEND=noninteractive apt-get install -y \
  zsh silversearcher-ag curl locales sudo less tmux rsync jq \
  git gnupg lsb-release openssh-server \
  && \
  apt-get autoremove -y && \
  apt-get autoclean && \
  apt-get clean && \
  rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

RUN curl -sS https://starship.rs/install.sh -o /tmp/install.sh && sh /tmp/install.sh --yes && rm -rf /tmp/*

RUN \
  echo "en_US.UTF-8 UTF-8" > /etc/locale.gen && \
  locale-gen && \
  groupadd --gid 1000 docker && \
  useradd --gid 1000 --uid 1000 --create-home --shell /bin/bash docker && \
  echo "docker ALL=(root) NOPASSWD:ALL" > /etc/sudoers.d/user && \
  chmod 0440 /etc/sudoers.d/user && \
  chown -R docker:docker /etc/ssh

ENV TERM=xterm-256color

USER docker

# Setup zsh
RUN export SHELL=/usr/bin/zsh && \
  sh -c "$(curl -fsSL https://raw.githubusercontent.com/robbyrussell/oh-my-zsh/master/tools/install.sh)" && \
   git clone https://github.com/zsh-users/zsh-syntax-highlighting.git ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-syntax-highlighting && \
   git clone https://github.com/zsh-users/zsh-autosuggestions.git ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-autosuggestions && \
  git clone --depth 1 https://github.com/junegunn/fzf.git ~/.fzf && \
  ~/.fzf/install --all
COPY --chown=docker:docker zshrc /home/docker/.zshrc

RUN mkdir -p ~/.ssh && \
  ssh-keyscan github.com >> ~/.ssh/known_hosts && \
  mkdir -p /home/docker/.config/nvim

RUN sudo apt-get install -y \
  ca-certificates \
  curl \
  gnupg \
  lsb-release && \
  curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo gpg --dearmor -o /usr/share/keyrings/docker-archive-keyring.gpg && \
  echo \
    "deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/docker-archive-keyring.gpg] https://download.docker.com/linux/debian \
    $(lsb_release -cs) stable" | sudo tee /etc/apt/sources.list.d/docker.list > /dev/null && \
  sudo apt-get update && \
  sudo apt-get install -y docker-ce-cli && \
  sudo curl -L "https://github.com/docker/compose/releases/download/1.29.2/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose && \
  sudo chmod +x /usr/local/bin/docker-compose

COPY --chown=docker:docker starship.toml /home/docker/.config/starship.toml

EXPOSE 2222
CMD ["/usr/sbin/sshd", "-D", "-p", "2222"]
