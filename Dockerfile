FROM jruby:9.1-jdk

MAINTAINER Peter Fitzgibbons "peter.fitzgibbons@gmail.com"
ENV REFRESHED_AT 2017-07-12


## Connection ports for controlling the UI:
# VNC port:5901
# noVNC webport, connect via http://IP:6901/?password=vncpassword
ENV DISPLAY :1
ENV VNC_PORT 5901
ENV NO_VNC_PORT 6901
EXPOSE $VNC_PORT $NO_VNC_PORT


### Envrionment config
ENV DEBIAN_FRONTEND noninteractive
ENV NO_VNC_HOME $HOME/noVNC
ENV VNC_COL_DEPTH 24
ENV VNC_RESOLUTION 1280x1024
ENV VNC_PW vncpassword

ENV HOME /headless
ENV STARTUPDIR /dockerstartup

### Add all install scripts for further steps
ENV INST_SCRIPTS $HOME/install
ADD ./docker/common/install/ $INST_SCRIPTS/
ADD ./docker/ubuntu/install/ $INST_SCRIPTS/
RUN find $INST_SCRIPTS -name '*.sh' -exec chmod a+x {} +

### Install some common tools
RUN $INST_SCRIPTS/tools.sh

### Install xvnc-server & noVNC - HTML5 based VNC viewer
RUN $INST_SCRIPTS/tigervnc.sh
RUN $INST_SCRIPTS/no_vnc.sh

### Install firfox and chrome browser
RUN $INST_SCRIPTS/firefox.sh
RUN $INST_SCRIPTS/chrome.sh

### Install xfce UI
RUN $INST_SCRIPTS/xfce_ui.sh
ADD ./docker/common/xfce/ $HOME/


### configure startup
ADD ./docker/common/scripts $STARTUPDIR
RUN $INST_SCRIPTS/set_user_permission.sh $STARTUPDIR $HOME

COPY . /usr/src/app

WORKDIR /usr/src/app

ENTRYPOINT ["/dockerstartup/vnc_startup.sh"]
CMD ["--tail-log"]

# RUN bundle install --system

# ## Switch to root user for installs
# USER 0
# 
# ## Install openjdk and a few deps
# RUN apt-get update && apt-get -y install openjdk-8-jdk git curl make
# 
# 
# ## install RVM
# RUN gpg --keyserver hkp://keys.gnupg.net --recv-keys 409B6B1796C275462A1703113804BB82D39DC0E3
# RUN \curl -sSL https://get.rvm.io | bash -s stable
# RUN ["/bin/bash", "-c", "source /etc/profile.d/rvm.sh && rvm install jruby-9.1.10.0"]
# 
# ## switch back to default user
# USER 1984

