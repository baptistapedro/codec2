FROM fuzzers/afl:2.52

RUN apt-get update
RUN apt install -y build-essential wget git clang cmake  automake autotools-dev  libtool zlib1g zlib1g-dev libexif-dev
RUN git clone https://github.com/drowe67/codec2.git
WORKDIR /codec2
RUN mkdir ./build
WORKDIR /codec2/build
RUN  cmake -DCMAKE_C_COMPILER=afl-clang -DCMAKE_CXX_COMPILER=afl-clang .
RUN make
RUN mkdir /rawCorpus
RUN wget https://chromium.googlesource.com/chromium/src/+/lkgr/media/test/data/speech_16b_stereo_48kHz.raw
RUN cp ../raw/cross.raw .
RUN cp ../raw/hts1.raw .
RUN cp ../raw/g3plx.raw .
RUN cp ../raw/forig.raw .
RUN cp ../raw/kristoff.raw .
RUN cp ../raw/m2400.raw .
RUN mv *.raw /rawCorpus
ENV LD_LIBRARY_PATH=/usr/local/lib/


ENTRYPOINT  ["afl-fuzz", "-i", "/rawCorpus", "-o", "/codec2Out"]
CMD ["/codec2/build/src/c2enc", "2400", "@@", "out.bit"]
