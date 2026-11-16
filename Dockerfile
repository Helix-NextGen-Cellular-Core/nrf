# Builds the Helix image ghcr.io/helix-nextgen-cellular-core/nrf:v1.0.0
# (the image used for the Helix SoCC 2026 experiments), the same way it was built and verified:
#   docker build -t nrf:local .
FROM golang:1.16.0-stretch AS builder
WORKDIR /go/src/nrf
COPY . .
RUN go mod vendor \
 && make all && mkdir -p /out/free5gc/nrf && cp bin/* /out/free5gc/nrf/

FROM alpine:3.16
LABEL org.opencontainers.image.source="https://github.com/Helix-NextGen-Cellular-Core/nrf" \
      org.opencontainers.image.licenses="Apache-2.0"
RUN apk update && apk add -U vim strace net-tools curl netcat-openbsd bind-tools
COPY --from=builder /out/ /
WORKDIR /free5gc/nrf
