[![asciicast](https://asciinema.org/a/572171.svg)](https://asciinema.org/a/572171)

# KINI Kernel PWN Toolkit :dragon:
Introducing a lightweight powerful tool that streamlines the process of writing kernel exploits and managing your kernel filesystem and images. This tool offers a range of essential features that enhance your kernel exploit experience, making it a convenient and reliable choice for developers. With efficient functionality, you can easily create, edit, and manipulate kernel exploits with ease. Plus, its capabilities allow for seamless management of kernel filesystem and images, making your work faster and more efficient.


## Install

With curl:
``` sh
curl https://raw.githubusercontent.com/timetravelthree/kpwninit/main/install.sh | sh
```

With wget:

``` sh
wget -q https://raw.githubusercontent.com/timetravelthree/kpwninit/main/install.sh -O- | sh  
```

## Uninstall

To uninstall just simply run the following
``` sh
rm "${HOME}"/.local/bin/kini
```

## Usage

`kini [action ...]`

## Features

`kini` has various features called "actions", actions are as you might already guessed just a series of command which are grouped together in something more abstract, actions are described in the next section.

## Actions

> NOTE: for this actions to properly work they need a certain file structure and certain files in certain directories, if you have custom configuration or non-standard names, it may fail to recognize them and so this will cause a failure in the beginning. If possible make sure files has standard naming conventions and formats.

* `exploit` 
  * This command needs a `Makefile` in the `exploit/` is similar to run, with the exception that compiles the content of the `exploit/`  directory and outputs them in the initial kernel filesystem

* `run`
  * Just executes `kernel/run.sh` and syncs the changes of the extracted filesystem to the initial kernel filesystem.

* `extract`
  * Extracts the initial ram disk to the `fs/` folder

* `backup` 
  * Backups the initramfs of the kernel. You can find it in the `.backups/` directory, this tool makes a copy on the first run

* `restore` 
  *  Restores back the initramfs from `.backups/` into the `kernel/` directory. Note the file it replaces shall not be saved

* `debug` 
  *  Opens a TMUX split (Working on support for terminator) where on the pane on the left it executes `kini exploit`, in the other one it tries to attach with gdb at port `localhost:1234` by default

* `update` 
  *  Just updates the installated version 


## License
This project is licensed under the terms of the MIT license

## Todo
- [x] add debugging
- [x] add installation & deletion sections
- [x] auto update
- [x] improve debugging
- [ ] improve autocompletition 
- [ ] add support for terminator
- [ ] checking for updates at startup
