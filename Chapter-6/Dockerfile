FROM jjmerelo/rakudo-nostar:latest
LABEL version="0.0.1" maintainer="JJ Merelo <jjmerelo@GMail.com>"

ADD META6.json .
RUN apt-get update  && apt-get upgrade -y \
    && apt-get install -y wget libcurl4-openssl-dev libarchive13 rsyslog\
    && zef install .
    
RUN useradd -ms /bin/bash rakurecipes
USER rakurecipes

ENTRYPOINT [ "raku" ]

