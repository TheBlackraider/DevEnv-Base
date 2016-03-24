FROM base/devel

MAINTAINER blackraider <er.blacky@gmail.com>

ENV LANG       es_ES.UTF-8
ENV LC_ALL     es_ES.UTF-8

ADD locale.gen /etc
ADD locale.conf /etc

RUN locale-gen

ADD mirrorlist /etc/pacman.d

RUN pacman-key --refresh-keys

RUN pacman -Syu --noconfirm
RUN pacman-db-upgrade

RUN pacman -S --needed --noconfirm base-devel

RUN pacman -S --noconfirm hub subversion cvs git rsync strace vim vim-runtime vim-rails vim-colorsamplerpack vim-fugitive zsh zsh-completions zsh-lovers zshdb zsh-doc openssh

RUN useradd -m -s /bin/zsh -U developer -G users,wheel 


USER root

RUN echo "root:Docker!" | chpasswd
RUN echo "developer:developer" | chpasswd

RUN sed -i '$ a AllowUsers	developer' /etc/ssh/sshd_config
RUN sed -i '$ a PermitRootLogin 	no' /etc/ssh/sshd_config
RUN sed -i '$ a Port	45505' /etc/ssh/sshd_config

RUN echo "%wheel    ALL=(ALL)  ALL" >> /etc/sudoers

RUN systemctl enable sshd.service

ADD .zshrc /home/developer

RUN chown developer:users /home/developer/.zshrc

USER developer

RUN cd /home/developer

WORKDIR /home/developer

RUN sh -c "$(curl -fsSL https://raw.githubusercontent.com/robbyrussell/oh-my-zsh/master/tools/install.sh)"

RUN mv .zshrc .zshrc.generated
RUN mv .zshrc.pre-oh-my-zsh .zshrc
