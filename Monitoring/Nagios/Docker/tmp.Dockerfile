FROM ubuntu:lunar-20230522

COPY . .

ENTRYPOINT bash ./install.sh && tail -f /dev/null
