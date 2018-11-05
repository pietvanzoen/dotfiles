FROM debian:latest
ARG USER=piet
ENV HOME=/users/${USER}
ENV SHELL=/bin/bash

WORKDIR ${HOME}/dotfiles

COPY ./_scripts/install-linux ./_scripts/install-linux
RUN ./_scripts/install-linux

COPY ./_scripts/install-dev ./_scripts/install-dev
RUN ./_scripts/install-dev

COPY ./_scripts/install-autojump ./_scripts/install-autojump
RUN ./_scripts/install-autojump

COPY . .
RUN CONFIRM_ALL=true ./install
RUN TERM=xterm vim -V -es +'source ~/.vim/plugins.vim' +PlugInstall +qa

RUN useradd ${USER}
RUN chown -R ${USER}:${USER} ${HOME}

USER ${USER}
WORKDIR ${HOME}

CMD ["/bin/bash"]
