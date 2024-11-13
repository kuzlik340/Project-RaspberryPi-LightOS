# Sonima OS
```
 _____             _                   _____ _____ 
/  ___|           (_)                 |  _  /  ___|
\ `--.  ___  _ __  _ _ __ ___   __ _  | | | \ `--. 
 `--. \/ _ \| '_ \| | '_ ` _ \ / _` | | | | |`--. \
/\__/ / (_) | | | | | | | | | | (_| | \ \_/ /\__/ /
\____/ \___/|_| |_|_|_| |_| |_|\__,_|  \___/\____/ 
```

# Introduction
Sonima OS is just a small Opertaing System that is currently updating. It won't replace OSes on Linux kernel but still will be better than Windows. The main idea of project is to create an Operational System and test it on the Raspberry PI 4B.

# Modules
Sonima OS has this modules:
1. Boot program 
2. Exception and interrupt handler (will be created in newer versions)
3. Memory manager (will be created in newer versions)
4. File system (will be created in newer versions)
5. Processes manager (will be created in newer versions)

This system has basic set of modules that every OS should have. It will be updating and the functionality of system will grow.

# How to run OS
1. Flash the SD-card with Raspbian OS
2. Build the kernel8.img with build.sh (will be added in version 0.1)
3. Replace current kernel8.img with this kernel8.img
4. In config.txt add this two lines:
```
enable_uart=1
dtoverlay=disable-bt
```

# Current stage
Currently working with memory paging.
