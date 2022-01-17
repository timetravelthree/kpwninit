#!/bin/bash

# Save the current script path
MYPATH=$PWD

# Global argument parameters
FIRST=$1
SECOND=$2

# Editor path exploit
EDITOR=nvim

# Explorer program
EXPLORER=open

# Save colors in variables so that can be used 
# easly in the program
RED=$(tput setaf 1)
BACKGROUND_BANNER=
RESET=$(tput sgr0)
WARNINGF=$(tput setaf 3)
WARNINGB=$(tput setab 17)
ERRORF=$(tput setaf 1)
ERRORB=$(tput setab 232)
INFOF=$(tput setaf 255)
INFOB=$(tput setab 235)
SUCCESSF=$(tput setaf 46)
#SUCCESSB=$(tput setab 235)
PROMPTF=$(tput setaf 255)
#PROMPTB=$(tput setab 235)
OPTIONSF=$(tput setaf 46)
CREDITSF=$(tput setab 1)
CREDITB=$(tput setaf 255)

# Initial prompt style
PROMPT="$(tput setaf 2)${RESET}\$"
PS3="$(tput setaf 1)~${PROMPT@P} "

# Here you can change the directories
# that will be used by the script
# NOTE: If you change $KERNELD you must change
# the autocompletition script
BACKUPD="$MYPATH/src/.backups"
KERNELD="$MYPATH/src/src-kernel"
EXTRACTD="$MYPATH/src/.extracted"
EXPLOITD="$MYPATH/src/src-exploit"
WORKINGD="$MYPATH/src/.working"
SRCD="$MYPATH/src/src-vuln"

# Warn the user before running the program
function call_warning(){
    whiptail --title WARNING --msgbox 'This code is under mantainance and has not been full tested, please be concious that it may harm your system' 10 40
}

function banner(){
    clear
    echo ${RED}${BACKGROUND_BANNER}"                                                                 "${RESET}
    echo ${RED}${BACKGROUND_BANNER} ██╗░░██╗██████╗░░██╗░░░░░░░██╗███╗░░██╗██╗███╗░░██╗██╗████████╗ ${RESET}
    echo ${RED}${BACKGROUND_BANNER} ██║░██╔╝██╔══██╗░██║░░██╗░░██║████╗░██║██║████╗░██║██║╚══██╔══╝ ${RESET}
    echo ${RED}${BACKGROUND_BANNER} █████═╝░██████╔╝░╚██╗████╗██╔╝██╔██╗██║██║██╔██╗██║██║░░░██║░░░ ${RESET}
    echo ${RED}${BACKGROUND_BANNER} ██╔═██╗░██╔═══╝░░░████╔═████║░██║╚████║██║██║╚████║██║░░░██║░░░ ${RESET}
    echo ${RED}${BACKGROUND_BANNER} ██║░╚██╗██║░░░░░░░╚██╔╝░╚██╔╝░██║░╚███║██║██║░╚███║██║░░░██║░░░ ${RESET}
    echo ${RED}${BACKGROUND_BANNER} ╚═╝░░╚═╝╚═╝░░░░░░░░╚═╝░░░╚═╝░░╚═╝░░╚══╝╚═╝╚═╝░░╚══╝╚═╝░░░╚═╝░░░ ${RESET}
    echo ${RED}${BACKGROUND_BANNER}"                                                                 "${RESET}
    echo ${CREDITSF}${CREDITB}"       Created by timetravel3 👹 Licensed by MIT license         "${RESET}
    echo
}

# This is a simple log function that takes in input two parameters
# the first one is the message and the second one is the type of
# it, which causes the program to run different outputs
function log(){
    typem=$2
    message=$1
    case $typem in
        info)
            echo "${INFOB}${INFOF}[?] Info: ${RESET}${INFOB} $message ${RESET}"
            ;;
        warning)
            echo "${WARNINGB}${WARNINGF}[*] Warning: ${RESET}${WARNINGB} $message ${RESET}"
            ;;
        prompt)
            echo -n "${PROMPTB}${PROMPTF}$message${RESET}${PROMPTB} ? ${RESET}"
            ;;
        success)
            echo "${SUCCESSB}${SUCCESSF}[@] Success: ${RESET}${SUCCESSB} $message ${RESET}"
            ;;
        error)
            echo "${ERRORB}${ERRORF}[!] Critical Error: ${RESET}${ERRORB} $message ${RESET}"
            exit
            ;;
    esac

}

log "This project is under maintenance right now so use it wisely" "warning"

# Read second parameter if it is necessary 
function read_param() {

    # If the PARAM variable ( second parameter of the action, e.g. init backup etc... ) is not set ask for it
    if [[ ! $PARAM ]]; then

        # Changing directory is used for autocompletition since the -e parameter in read is used
        cd $KERNELD
        while true; do
                echo; log $'second parameter not detected' 'info'; echo

                # Print the prompt and then take the PARAM variable in input
                log "$1" prompt
                read -e PARAM

                # Check for non empty input, otherwise ask it again
                if [[ ! $PARAM ]]; then
                    log "insert a valid input" "warning" 
                    continue
                fi
            break
            echo
        done

        # Go back to you original path
        cd $MYPATH
    fi
}

# Main functionalities

function do_run() {
    # ./run.sh is a simple scripts that runs your kernel
    # here we are passing via $KERNELD the path to the script
    # which should be used by the script to find
    # the kernel and initrd

    KERNELD=$KERNELD /bin/bash $KERNELD/run.sh
}

function do_make() {
    # Simple compiling function
    log "trying compiling" "info"
    make -C $EXPLOITD || log "couldn't compile the exploit" "error"
    log "successfully compiled" "success"
}

function do_backup() {
        read_param "kernel filename to backup"
        log "trying backup" "info"
        [[ -d $BACKUPD ]] || { mkdir $BACKUPD; log "Created directory $BACKUPD" "info"; }

        log "Running: cp \"$KERNELD/$PARAM\" \"$BACKUPD/$PARAM.bak\"" "info"

        # Preserve the original cpio
        cp --backup=t "$KERNELD/$PARAM" $BACKUPD/$PARAM.bak || { log "Failed to make a backup" "error"; }
        log "created a backup" "success"
}

function do_compress() {
        # NOTE: read_param sets the $PARAM global variable
        read_param "directory to compress"

        # Debugging info
        log "trying compressing" info
        log "compressing folder $dirname" info

        # Take the second parameter of the action an use it 
        # as a filename, then remove the extension from it
        # and create a directory in $EXTRACTD/ with the name
        # of the file with an .extracted extension
        local filename=$PARAM
        local filename=${filename%%.*}
        local dirname="$EXTRACTD/${filename}.extracted"

        # Passing all the filnames on the directory
        # to cpio/gzip to compress them 
        cd $dirname
        find . -print0 | cpio --null -ov --format=newc | gzip -9 > $KERNELD/$filename.cpio.gz
        cd $MYPATH
}

function do_extract() {
        # NOTE: read_param sets the $PARAM global variable
        read_param "filename to extract"

        # Debugging info
        log "trying extracting" "info"

        # Set the filename, filename full path variables
        # and the future extracted directory path
        filename=$PARAM
        filename_fp="$KERNELD/$filename"
        dirname="$EXTRACTD/${filename%%.*}.extracted"

        # from the filname take the last extension
        extension="${filename##*.}"

        # If the filename does not exist raise an error and exit (default behaviour for errors)
        [[ -f $filename_fp ]] || { log "filename $filename_fp not found" error; }

        # Checking for supported extension
        case $extension in
            'gz'|'gzip')
                # gunzip the file and remove from the filaname full path variable the last extension
                # gzip -k keeps the original
                zcat  -k -d $filename_fp > $WORKINGD/${filename%.*}.extracted || { log "error $filename_fp is a corrupted gzip"; exit; }
                filename_fp=${filename_fp%.*}
            ;;
            'cpio')
                # for cpio file decompression is not needed in this
                # part of the function
                :;
            ;;
            *)
            log "unknown extension .$extension" "error"
        esac

        # Prompt to delete the directory if it exists
        [[ -d $dirname ]] && log "remove directory $dirname (y/n)" prompt; read -N 1 choice; [[ ${choice,,} =~ y ]] && { rm -r $dirname; } || log "user exited" error
        echo

        log "creating $dirname" info
        mkdir $dirname

        # Extract the archive and list all the extracted archives
        log "extracting $filename_fp -> $dirname" info
        cpio -idD${dirname} < $filename_fp && { log "opening $dirname with \`$EXPLORER\`" warning; $EXPLORER $dirname; echo; } \
            && log "successfully extracted!" "success" || log 'Failed to extract $filename_fp' "error"

}

function do_edit(){
    # This function restore a previously made
    # backup, this is a very simple function and overwrites
    # whatever is in the kernel directory
    # this function takes the filename to backup
    log "opening editor" info

    # -i to prompt before overwriting, -v verbose, -r recurse
    # in case of backing up a directory
    $EDITOR $EXPLOITD/exploit.c

    # log in case of success
    log "finish" success
}

function do_restore(){
    # This function restore a previously made
    # backup, this is a very simple function and overwrites
    # whatever is in the kernel directory
    # this function takes the filename to backup
    read_param "kernel filename to restore"
    log "trying restoring" info

    # -i to prompt before overwriting, -v verbose, -r recurse
    # in case of backing up a directory
    cp -i -v -r $BACKUPD/$PARAM.bak $KERNELD/$PARAM || log "error could not restore the backup" error

    # log in case of success
    log "successfully restored backup" success
}

function do_exploit(){
    # this function is a macro that executes a series of function 
    do_make
    do_extract
    cp -r -v $EXPLOITD/*.o  $EXTRACTD/${PARAM%%.*}.extracted
    do_compress
    do_run
}

function do_init(){
    # create basic directory tree
    # if you do not like it, you can change the paths
    # in the upper part of the program with the env variables
    log "creating directory tree" info
    mkdir -p $BACKUPD
    mkdir -p $WORKINGD
    mkdir -p $EXTRACTD
    mkdir -p $EXPLOITD
    mkdir -p $SRCD
    log "successfully created" success
}

function main(){
    # call the banner and warnings
    banner
    call_warning
    log 'This code is under mantainance and has not been full tested, please be concious that it may harm your system' warning

    # if this script has never been run, run this 
    if [[ ! -f ".initialized" ]]; then
        log "executing the script for the first time executing init" info
        touch .initialized
        if [[ $BASH_VERSION ]]; then
            # this is used for autocompletition
            log "loading auto-completition" info
            echo -e "\n# Autocompletition for kpwninit.sh\nsource $MYPATH/autocomplete/autocomplete.bash" >> $HOME/.bashrc
        else
            log "this script supports auto-completition only in bash" warning
        fi
        do_init
    fi

    # also create the directory tree

    # Check if you passed the first argument via CLI otherwise ask it via stdin
    if [[ ! $FIRST ]]; then
        echo $FIRST
        log "first parameter not detected" "info"; echo
        echo "${OPTIONSF}select action: 'init' 'run' 'exploit' 'make' 'restore' 'compress' 'extract' 'backup'${RESET}"
        read -e -p "$PS3" CHOICE
    else
        # even if the $SECOND is not set
        # read_param checks if it has been
        # if not it asks for it
        CHOICE=$FIRST
        PARAM=$SECOND
    fi

    # this is a switch case which calls functions
    case $CHOICE in
        init)
            do_init
            ;;
        exploit)
            do_exploit
            ;;
        make)
            do_make
            ;;
        backup)
            do_backup
            ;;
        extract)
            do_extract
            ;;
        compress)
            do_compress
            ;;
        run)
            do_run
            ;;
        restore)
            do_restore
            ;;
        edit)
            do_edit
            ;;
    esac
}

main
