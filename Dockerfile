FROM archlinux/base 

MAINTAINER blackraider <er.blacky@gmail.com>

ENV LANG       es_ES.UTF-8
ENV LC_ALL     es_ES.UTF-8

ADD locale.gen /etc
ADD locale.conf /etc

RUN locale-gen

ADD mirrorlist /etc/pacman.d

RUN pacman -Sy --noconfirm

RUN pacman -S archlinux-keyring --noconfirm
RUN pacman-key --refresh-keys

RUN pacman -Syu --noconfirm

RUN pacman-db-upgrade

RUN pacman -S --needed --noconfirm base-devel

RUN pacman -S --noconfirm ca-certificates-mozilla hub subversion cvs git rsync strace vim vim-runtime zsh zsh-completions zsh-lovers zshdb zsh-doc openssh screen mutt powerline-fonts awesome-terminal-fonts

RUN useradd -m -s /bin/zsh -U developer -G users,wheel 

USER root

RUN echo "root:Docker!" | chpasswd
RUN echo "developer:developer" | chpasswd

RUN sed -i '$ a AllowUsers	developer' /etc/ssh/sshd_config
RUN sed -i '$ a PermitRootLogin 	no' /etc/ssh/sshd_config
RUN sed -i '$ a Port	45505' /etc/ssh/sshd_config

RUN echo "%wheel    ALL=(ALL)  ALL" >> /etc/sudoers

RUN systemctl enable sshd.service

USER developer

WORKDIR /home/developer

# bash

ADD --chown=developer:developer .bashrc /home/developer
ADD --chown=developer:developer .bash_profile /home/developer

# tools

ADD --chown=developer:developer .muttrc /home/developer
ADD --chown=developer:developer .screenrc /home/developer

# Vim

ADD --chown=developer:developer .vimrc /home/developer
RUN mkdir -p ~/.vim/autoload ~/.vim/bundle
RUN curl -LSso ~/.vim/autoload/pathogen.vim https://tpo.pe/pathogen.vim

# vim plugins

WORKDIR /home/developer/.vim/bundle

RUN git clone https://github.com/tpope/vim-fugitive
RUN git clone https://github.com/scrooloose/nerdtree
RUN git clone https://github.com/vim-airline/vim-airline
RUN git clone https://github.com/vim-airline/vim-airline-themes
RUN git clone https://github.com/pangloss/vim-javascript
RUN git clone https://github.com/klen/python-mode
RUN git clone https://github.com/tpope/vim-rails
RUN git clone https://github.com/neovimhaskell/haskell-vim

# zsh

WORKDIR /home/developer

RUN sh -c "$(curl -fsSL https://raw.githubusercontent.com/robbyrussell/oh-my-zsh/master/tools/install.sh)"
ADD --chown=developer:developer .zshrc /home/developer

