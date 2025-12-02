# libreboot_maker
this repo contains
- a makefile
- lbmk as a submodule
to facilitate compiling libreboot

# Dependencies
- everything for lbmk

# Usage
## clone
`git clone --recurse-submodules https://github.com/2elli/libreboot_maker.git`

## building using helper
!!!IMPORTANT!!!
- read the guide for your board
- fill out the BOARD and MAC_ADDR variables in the top of the makefile with your target information
- double check all commands in the apply_mac_addr makefile target, it is using platform sklkbl by default (t480)

then to build,
```
make
```

if you want to change config or enable hyperthreading,
```
make config
```
