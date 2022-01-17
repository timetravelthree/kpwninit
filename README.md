# Kernel PWN Tooklkit :dragon: :space_invader:	
this program is a con venient tool for writing kernel exploits and manage your kernel filesystem, images. It also has a few key features that may improve your kernel exploit experience. 


## Screenshots

![image](img/banner.png)

## Usage

`bash ./kpwninit.sh [action [filename]]`

## Help
__Argument and filename, can be passed via argument line, or via stdin__


## Actions
_Actions stared (*) require a filename_



___init___
> Creates a simple directory tree. It can be modified in the script

___make___
> Just executes the make command within the exploit directory, so you need a Makefile within the `$EXPLOITD` directory. It can be modified in the script

___backup___ *
> Copies a file from `$KERNELD` into the `$BACKUPD` directory

___restore___ *
> Copies back a file from `$BACKUPD` into the `$KERNELD` directory

___extract___ *
> Extracts an archive within `$KERNELD` into the `$EXTRACTED` directory, then it opens (by default) the extracted archive with `$EDITOR` which is `nvim` by default

___compress___ *
> Compress a previously extracted directory back into `$KERNELD`

___run___
> Just executes `$KERNELD/run.sh`, there should be a script that when run it emulates the kernel. Note your script should use `$KERNELD` to refer to the directory of the kernel and initrd, or instead use an absolute path

___exploit___
> This command is just a macro that executes a series of actions, these actions are `make` `extract` `compress` `run`

<br>

__Default environment variables values:__
<br>


```sh
# Editor
EDITOR=nvim

# Directories
BACKUPD="$MYPATH/src/.backups"
KERNELD="$MYPATH/src/src-kernel"
EXTRACTD="$MYPATH/src/.extracted"
EXPLOITD="$MYPATH/src/src-exploit"
WORKINGD="$MYPATH/src/.working"
SRCD="$MYPATH/src/src-vuln"
```

>NOTE: do not remove $MYPATH from these values if you ar not using an absolute path


## Disclaimers

This is a new project, so the program may contain: bugs, uncompleted features, etc..

## License
This project is licensed under the terms of the MIT license
