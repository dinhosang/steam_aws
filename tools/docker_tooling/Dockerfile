FROM alpine:3.16.0


###


RUN apk update

RUN apk upgrade


###


RUN apk add bash

RUN apk add shellcheck

RUN apk add shfmt


###


ENV USER_NAME=steam_aws_tooling

ENV UID=12345

ENV GID=23456


###


RUN addgroup -g $GID $USER_NAME

RUN adduser --disabled-password --ingroup $USER_NAME --uid $UID $USER_NAME


###


USER $USER_NAME


###


WORKDIR /src


###


ENTRYPOINT [ "/bin/bash", "-c" ]
