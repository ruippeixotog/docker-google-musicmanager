FROM ubuntu:14.04
MAINTAINER Rui Gonçalves <ruippeixotog@gmail.com>

RUN apt-get -y update
RUN apt-get install -y wget

RUN echo "deb http://dl.google.com/linux/musicmanager/deb/ stable main" >> /etc/apt/sources.list.d/google-musicmanager.list
RUN wget -q -O - https://dl-ssl.google.com/linux/linux_signing_key.pub | apt-key add -

RUN apt-get -y update
RUN apt-get install -y google-musicmanager-beta xvfb supervisor

RUN apt-get install -y build-essential libxtst-dev libssl-dev libjpeg-dev checkinstall
RUN wget http://x11vnc.sourceforge.net/dev/x11vnc-0.9.14-dev.tar.gz
RUN gzip -dc x11vnc-0.9.14-dev.tar.gz | tar -xvf -
RUN cd x11vnc-0.9.14 && ./configure && make && \
  checkinstall --pkgname=x11vnc --default --pkgversion="2:0.9.14-0.1" --backup=no --deldoc=yes

RUN mkdir /music
VOLUME /music

RUN mkdir /appdata /.config
RUN ln -s /appdata /.config/google-musicmanager
VOLUME /appdata

EXPOSE 5900

ADD supervisord.conf /etc/supervisor/conf.d/supervisord.conf
ADD google-musicmanager.sh /google-musicmanager.sh

CMD ["/usr/bin/supervisord"]
