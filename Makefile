.PHONY: setup build compile_libreboot build_nvm apply_mac_addr clean config

# Configuration variables (can be overridden via command line)
BOARD := t480s_vfsp_16mb
TARGET_ROM := seagrub_${BOARD}_libgfxinit_corebootfb_usqwerty.rom
NEW_ROM := ${BOARD}_libreboot.rom
MAC_ADDR := xx:xx:xx:xx:xx:xx
THREADS := $(shell nproc)

# Paths
LBMK_DIR := lbmk
NVMUTIL := ${LBMK_DIR}/util/nvmutil/nvm
BIN_DIR := ${LBMK_DIR}/bin/${BOARD}

# Validate BOARD is set
ifeq (${BOARD},)
$(error BOARD variable is not set. Edit this Makefile and set BOARD to one of the options in lbmk/config/coreboot/)
endif

# Validate MAC_ADDR is set to a real value
ifeq (${MAC_ADDR},xx:xx:xx:xx:xx:xx)
$(error MAC_ADDR is set to placeholder value. Update!)
endif

setup:
	@echo "========================================="
	@echo "Building for board: ${BOARD}"
	@echo "Target ROM: ${TARGET_ROM}"
	@echo "Output ROM: ${NEW_ROM}"
	@echo "========================================="

build: setup compile_libreboot apply_mac_addr

compile_libreboot:
	cd ${LBMK_DIR} && \
		XBMK_RELEASE=y XBMK_THREADS=${THREADS} ./mk -b coreboot ${BOARD}

build_nvm:
	${MAKE} -C ${LBMK_DIR}/util/nvmutil

apply_mac_addr: build_nvm
	@echo "Applying MAC address ${MAC_ADDR}..."
	cp ${BIN_DIR}/${TARGET_ROM} ${NEW_ROM}
	ifdtool --platform sklkbl --unlock ${NEW_ROM} -O ${NEW_ROM}
	ifdtool --platform sklkbl -x ${NEW_ROM}
	${NVMUTIL} flashregion_3_gbe.bin setmac ${MAC_ADDR}
	ifdtool --platform sklkbl -i gbe:flashregion_3_gbe.bin ${NEW_ROM}
	mv ${NEW_ROM}.new ${NEW_ROM}
	rm -f flashregion_*.bin
	@echo "========================================="
	@echo "Final ROM at: ${NEW_ROM}"
	@echo "========================================="

clean:
	rm -f flashregion_*.bin ${NEW_ROM} ${NEW_ROM}.new

clean-all: clean
	cd ${LBMK_DIR} && ./mk -c coreboot ${BOARD}

config:
	cd ${LBMK_DIR} && ./mk -m coreboot ${BOARD}
