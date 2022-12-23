FROM ubuntu

RUN echo "echo hello world" > hello.sh

RUN chmod +x hello.sh

ENTRYPOINT ["/bin/bash","./hello.sh"]
