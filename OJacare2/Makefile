all:
	make -C src depend
	make -C src all

install:
	make -C src install

uninstall:
	make -C src uninstall

reinstall:
	${MAKE} uninstall
	${MAKE} install

clean:
	make -C src clean
