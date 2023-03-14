FROM alpine:3.16.0


###


ARG USER_NAME_PROVIDED


###


RUN apk update

RUN apk upgrade


###


RUN apk add bash

RUN apk add aws-cli

RUN apk add jq

RUN apk add packer


###


ENV USER_NAME=$USER_NAME_PROVIDED

ENV UID=12345

ENV GID=23456


###


RUN addgroup -g $GID $USER_NAME

RUN adduser --disabled-password --ingroup $USER_NAME --uid $UID $USER_NAME


###


USER $USER_NAME


###


RUN mkdir ~/.aws

WORKDIR /home/$USER_NAME/src


###


# NOTE: can't use variable substitution with exec form of ENTRYPOINT
#       so the user name had to be hard-coded here instead of using $USER_NAME
ENTRYPOINT [ "/bin/bash", "/home/steam_aws_runner/src/cli.sh" ]
