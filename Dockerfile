FROM eduhds/linuxdeploy-deb:latest

RUN sudo apt update -y
RUN sudo apt install -y gnustep gnustep-devel curl

RUN echo '. /usr/share/GNUstep/Makefiles/GNUstep.sh' > ~/.bash_profile

RUN curl -fsSL https://xmake.io/shget.text | bash
RUN echo 'source ~/.xmake/profile' >> ~/.bash_profile

RUN echo 'export PATH=$HOME/.local/bin:$PATH' >> ~/.bash_profile
