.PHONY: apply_mac_addr clean config build

BOARD='LIBREBOOT BOARD NAME'
TARGET_ROM='TARGET ROM YOU WANT TO USE ONCE BUILT'
NEW_ROM='${BOARD}_libreboot.rom'
MAC_ADDR='xx:xx:xx:xx:xx:xx'
THREADS=8

build: compile_libreboot apply_mac_addr

compile_libreboot:
	cd lbmk; \
		XBMK_THREADS=${THREADS} ./mk -b coreboot ${BOARD}

build_nvm:
	$(MAKE) -C ./lbmk/util/nvmutil

apply_mac_addr: build_nvm
	cp lbmk/bin/${BOARD}/${TARGET_ROM} ${NEW_ROM} 
	ifdtool --platform sklkbl --unlock ${NEW_ROM} -O ${NEW_ROM}
	ifdtool --platform sklkbl -x ${NEW_ROM}
	./lbmk/util/nvmutil/nvm flashregion_3_gbe.bin setmac ${MAC_ADDR}
	ifdtool --platform sklkbl -i gbe:flashregion_3_gbe.bin ${NEW_ROM}
	mv ${NEW_ROM}.new ${NEW_ROM} 
	rm -f *.bin
	@echo ----------------------
	@echo Final rom at ${NEW_ROM}
	@echo ----------------------

clean:
	rm *.bin *.rom

config:
	cd lbmk; \
		./mk -m coreboot ${BOARD}
