MRUBY_COMMIT ?= iij
SSL_DIR ?= openssl-1.0.1g
MRUBY_DIR ?= /tmp/go-mruby

CGO_CFLAGS= -I${MRUBY_DIR}/mruby/include
CGO_LDFLAGS= ${MRUBY_DIR}/mruby/build/host/lib/libmruby.a ${MRUBY_DIR}/${SSL_DIR}/libcrypto.a -ldl -lm

export CGO_CFLAGS
export CGO_LDFLAGS

all: libmruby.a
	go test

clean:
	rm -rf ${MRUBY_DIR}

libmruby.a: ${MRUBY_DIR}/mruby ${MRUBY_DIR}/${SSL_DIR}
	cd ${MRUBY_DIR}/mruby && ${MAKE}

${MRUBY_DIR}/mruby:
	mkdir -p ${MRUBY_DIR}
	git clone https://github.com/iij/mruby.git ${MRUBY_DIR}/mruby
	cd ${MRUBY_DIR}/mruby && git reset --hard && git clean -fdx
	cd ${MRUBY_DIR}/mruby && git checkout ${MRUBY_COMMIT}

${MRUBY_DIR}/${SSL_DIR}: ${MRUBY_DIR}/${SSL_DIR}.tar.gz
	cd ${MRUBY_DIR} && tar -xf ${SSL_DIR}.tar.gz
	cd ${MRUBY_DIR}/${SSL_DIR} && ./config no-shared && make

${MRUBY_DIR}/${SSL_DIR}.tar.gz:
	mkdir -p ${MRUBY_DIR}
	cd ${MRUBY_DIR} && wget http://www.openssl.org/source/${SSL_DIR}.tar.gz

.PHONY: all clean libmruby.a test
