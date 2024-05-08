FROM alpine
RUN apk add --no-cache autoconf gperf make gcc g++ bison flex wget \
    && wget https://github.com/steveicarus/iverilog/archive/refs/tags/v12_0.tar.gz \
    && tar -xzvf v12_0.tar.gz \
    && rm v12_0.tar.gz \
    && cd ./iverilog-12_0 \
    && autoconf \
    && ./configure \
    && make install\
    && cd / \
    && rm -r ./iverilog-12_0 \
    && apk del autoconf gperf g++ bison flex wget
