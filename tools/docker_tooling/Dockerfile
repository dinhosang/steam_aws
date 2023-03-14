FROM alpine:3.17.0 as kcov_test_coverage_builder


###


RUN apk add --no-cache build-base cmake ninja python3 \
    binutils-dev curl-dev elfutils-dev


###


WORKDIR /root

ENV KCOV_URL=https://github.com/SimonKagstrom/kcov/archive/v41.tar.gz

RUN wget -q $KCOV_URL -O - | tar xz -C ./ --strip-components 1


###


WORKDIR /root/build

ENV CXXFLAGS="-D__ptrace_request=int"

RUN cmake -G Ninja ..

RUN cmake --build . --target install


#
#
#


FROM alpine:3.17.0


###


RUN apk update

RUN apk upgrade


###


RUN apk add bash

RUN apk add shellcheck

RUN apk add shfmt

RUN apk add shellspec


###


RUN apk add binutils-dev curl-dev elfutils-libelf

COPY --from=kcov_test_coverage_builder /usr/local/bin/kcov* /usr/local/bin/

COPY --from=kcov_test_coverage_builder /usr/local/share/doc/kcov /usr/local/share/doc/kcov


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
