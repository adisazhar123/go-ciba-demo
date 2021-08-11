FROM golang:1.14-alpine as BUILD

ENV GO111MODULE=on \
    CGO_ENABLED=0 \
    GOOS=linux \
    GOARCH=amd64

WORKDIR /build

COPY . .

RUN apk --no-cache add git
RUN go build -o app .

EXPOSE 20000

ENV GOOGLE_APPLICATION_CREDENTIALS=/build/service_account_key.json

ENTRYPOINT ["/build/app"]
