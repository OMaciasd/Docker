FROM ubuntu:lunar

RUN apt-get update -y && apt-get install -y --no-install-recommends \
    postgresql \
    sudo; \
    apt-get clean \
&& rm -rf /var/lib/apt/lists/*

LABEL sigstore-type="docker" \
      pubkey-id="omaciasnarvaez@gmail.com"
