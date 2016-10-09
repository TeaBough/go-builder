FROM alpine:edge

ENV GLIDE_VERSION 0.9.1

ENV GOPATH /opt/workspace
ENV GOBIN $GOPATH/bin
ENV PATH $GOBIN:$PATH

RUN mkdir -p $GOPATH &&\
  apk --update add bash gcc git go go-tools make musl-dev findutils &&\
	apk add tar wget &&\
	wget -q -O glide.tar.gz https://github.com/Masterminds/glide/releases/download/${GLIDE_VERSION}/glide-${GLIDE_VERSION}-linux-amd64.tar.gz &&\
	tar -xzf glide.tar.gz --strip-components=1 linux-amd64/glide &&\
	mv glide /usr/bin &&\
	rm glide.tar.gz &&\
	\
	\
	go get github.com/tools/godep &&\
	go get github.com/golang/lint/golint &&\
	go get github.com/jstemmer/go-junit-report &&\
	go get github.com/axw/gocov/gocov && \
	go get gopkg.in/matm/v1/gocov-html &&\
	go get github.com/AlekSi/gocov-xml &&\
	go get github.com/mitchellh/gox &&\
	\
	\
	go get gopkg.in/check.v1 &&\
	\
	\
	apk del tar wget &&\
	rm -R /var/cache/apk/*

# Make sure ANY kind of session opened via a shell inherits the setgid flag to allow the host to have write access to container-created files
RUN rm /bin/sh &&\
  echo '#!/bin/bash' > /bin/sh &&\
  echo 'umask 002' >> /bin/sh &&\
  echo '/bin/bash "${@:1}"' >> /bin/sh &&\
  chmod +x /bin/sh

WORKDIR $GOPATH
