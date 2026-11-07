FROM ubuntu:22.04

RUN apt-get update \
    && apt-get install -y --no-install-recommends ansible sshpass openssh-client curl \
    && rm -rf /var/lib/apt/lists/*

CMD ["sleep", "infinity"]
