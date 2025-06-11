FROM ubuntu:24.04
RUN apt update && apt install -y python3 build-essential libssl-dev
#  libgoogle-glog-dev libfmt-dev

ENV TORCH_HOME=/home/torch

COPY . /home
WORKDIR /home

RUN python3 ./build/fbcode_builder/getdeps.py install-system-deps --recursive
RUN python3 ./build/fbcode_builder/getdeps.py --allow-system-packages build --install-dir /home

RUN apt install -y python3-pip
RUN pip install numpy pillow torch --index-url https://download.pytorch.org/whl/cpu --break-system-packages

RUN python3 get_model.py

ENV CPLUS_INCLUDE_PATH=/tmp/fbcode_builder_getdeps-ZhomeZfollyZbuildZfbcode_builder-root/installed/glog-vs7ydRJDSPMPJnUwMrV0qGZqXygNKDvBk5KtfHTTtpk/include:$CPLUS_INCLUDE_PATH
ENV CPLUS_INCLUDE_PATH=/tmp/fbcode_builder_getdeps-ZhomeZfollyZbuildZfbcode_builder-root/installed/fmt-s_x_f9L62b7Lb1NgISZgrnsrxSBQaLzsM5KA6bQmrI8/include:$CPLUS_INCLUDE_PATH
ENV LIBRARY_PATH=/tmp/fbcode_builder_getdeps-ZhomeZfollyZbuildZfbcode_builder-root/installed/glog-vs7ydRJDSPMPJnUwMrV0qGZqXygNKDvBk5KtfHTTtpk/lib:$LIBRARY_PATH
ENV LIBRARY_PATH=/tmp/fbcode_builder_getdeps-ZhomeZfollyZbuildZfbcode_builder-root/installed/fmt-s_x_f9L62b7Lb1NgISZgrnsrxSBQaLzsM5KA6bQmrI8/lib:$LIBRARY_PATH
ENV LD_LIBRARY_PATH=$LIBRARY_PATH

RUN g++ '-fPIC' -o main main.cpp -Iinclude -Llib -lfolly -lfmt -lsodium -lglog

CMD ./main
