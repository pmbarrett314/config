.PHONY: test

test:
	./tests/bats/bin/bats tests/

install:
	./install.sh

install-no-sudo:
	./install.sh --home
