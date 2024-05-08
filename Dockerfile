FROM alpine
RUN apk add --no-cache gcc autoconf gperf make g++ bison flex wget cmake python3 git \
    && wget https://github.com/steveicarus/iverilog/archive/refs/tags/v12_0.tar.gz \
    && tar -xzvf v12_0.tar.gz \
    && rm v12_0.tar.gz \
    && cd ./iverilog-12_0 \
    && autoconf \
    && ./configure \
    && make install -j8 \
    && cd / \
    && rm -r ./iverilog-12_0 \
    && wget https://github.com/MikePopoloski/slang/archive/refs/tags/v6.0.tar.gz \
    && tar -xzvf  v6.0.tar.gz \
    && rm v6.0.tar.gz \
    && cd slang-6.0/ \
    && cmake -B build \
    && cmake --build build -j8 \
    && cmake --install build --strip \
    && cd / \
    && rm -r slang-6.0/ \
    && apk del autoconf gperf make g++ bison flex wget cmake python3 git

