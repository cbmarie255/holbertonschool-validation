FROM golang:1.15.8-buster
WORKDIR /app
COPY . .

RUN /app/setup.sh

ENV PATH=$PATH:/usr/local/go/bin
