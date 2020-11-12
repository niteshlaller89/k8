sudo apt-get install git cmake pkg-config flex bison libgtest-dev \
zlib1g-dev doxygen libpq-dev postgresql-server-dev-all libzstd-dev \
libsasl2-2 libsasl2-dev
git clone https://github.com/fluent/fluent-bit
mkdir build
cd build
cmake -DFLB_OUT_KAFKA=On ..
make
