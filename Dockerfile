FROM jjmerelo/alpine-raku:latest
LABEL version="0.0.2" maintainer="JJ Merelo <jjmerelo@GMail.com>"

ADD META6.json Chapter-5/filter-ingredients-proteins.p6 ./
RUN mkdir lib && mkdir data
ADD lib/ lib
ADD data/calories.csv data
ADD Chapter-12/ingredients.sqlite3 .

RUN apk update && apk upgrade && apk add gcc && zef install . \
    && chmod +x filter-ingredients-proteins.p6

ENTRYPOINT [ "./filter-ingredients-proteins.p6" ]

