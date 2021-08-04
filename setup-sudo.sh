apt-get update && \
  DEBIAN_FRONTEND=noninteractive apt-get install -y \
  # for build vim
  python-dev libncurses5-dev libncursesw5-dev libncurses-dev \
  python3-dev ruby-dev lua5.1 liblua5.1-dev \
  zsh silversearcher-ag curl locales sudo less tmux rsync jq \
  openssh-server

apt-key adv --keyserver hkp://keyserver.ubuntu.com:80 --recv-keys C5AD17C747E3415A3642D57D77C6C491D6AC1D69 && \
  echo "deb https://dl.k6.io/deb stable main" | tee /etc/apt/sources.list.d/k6.list && \
  apt-get update && \
  apt-get install k6

echo "en_US.UTF-8 UTF-8" > /etc/locale.gen && locale-gen

cd /tmp && \
  rm -fr vim && \
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
  sudo make install && \
  cd ~ && \
  rm -rf /tmp/*

