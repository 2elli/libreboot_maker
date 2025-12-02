makefile and repo to build lbmk and apply a mac address

# Dependencies
- everything for lbmk

# Instructions
!!!IMPORTANT!!!
- fill out the variables in the top of the makefile with your target information
- double check all commands in the apply_mac_addr makefile target

then to build,
```
git submodule update
make build
```

if you want to change config or enable hyperthreading,
```
make config
```
