MRUBY_COMMIT ?= iij
SSL_DIR ?= openssl-1.0.1f

all: libmruby.a
	go test

clean:
	rm -rf vendor
	rm -f libmruby.a

libmruby.a: vendor/mruby vendor/openssl
	cd vendor/mruby && ${MAKE}
	cp vendor/mruby/build/host/lib/libmruby.a .
	cp vendor/${SSL_DIR}/libcrypto.a .

vendor/mruby:
	mkdir -p vendor
	git clone https://github.com/iij/mruby.git vendor/mruby
	cd vendor/mruby && git reset --hard && git clean -fdx
	cd vendor/mruby && git checkout ${MRUBY_COMMIT}

vendor/openssl: vendor/openssl-1.0.1f.tar.gz
	cd vendor && tar -xf ${SSL_DIR}.tar.gz
	cd vendor/${SSL_DIR} && ./config no-shared && make

vendor/openssl-1.0.1f.tar.gz:
	mkdir -p vendor
	cd vendor && wget http://www.openssl.org/source/${SSL_DIR}.tar.gz

.PHONY: all clean libmruby.a test
