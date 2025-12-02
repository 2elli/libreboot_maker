makefile and repo to build lbmk and apply a mac address

# Dependencies
- everything for lbmk

# Instructions
## clone
`git clone --recurse-submodules https://github.com/2elli/libreboot_maker.git`

## building using helper
!!!IMPORTANT!!!
- read the guide for your board
- fill out the variables in the top of the makefile with your target information
- double check all commands in the apply_mac_addr makefile target

then to build,
```
make build
```

if you want to change config or enable hyperthreading,
```
make config
```
