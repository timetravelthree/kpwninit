#!/bin/bash

# Save the current script path
MYPATH=$PWD

# Global argument parameters
FIRST=$1
SECOND=$2

# Editor path exploit
EDITOR=vim

# Explorer program
EXPLORER=emacs

# GDB Cli arguments
GDB_SCRIPT=".gdbrun"
GDB_ARGS=("-x" "${GDB_SCRIPT}")
GDB_REMOTE_CMD="target remote localhost:1234"

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
# CREDITSF=$(tput setab 1)
# CREDITB=$(tput setaf 255)
CREDITSF=
CREDITB=$(tput setaf 255)

# Initial prompt style
PROMPT="$(tput setaf 2)${RESET}\$"
PS3="$(tput setaf 1)~ ${PROMPT@P} "

# Here you can change the directories
# that will be used by the script
# NOTE: If you change $KERNELD you must change
# the autocompletition script
BACKUPD="$MYPATH/.backups"
KERNELD="$MYPATH/kernel"
EXTRACTD="$MYPATH/fs"
EXPLOITD="$MYPATH/exploit"
WORKINGD="$MYPATH/.working"

# Warn the user before running the program
function call_warning() {
	whiptail --title WARNING --msgbox 'This code is under mantainance and has not been full tested, please be concious that it may harm your system' 10 40
}

function banner() {
	clear
	echo
	echo "                     ${RED}⠀⢀⣴⣶⣦⣴⣿⣷⣆${RESET}"
	echo "${CREDITSF}${CREDITB}          Created w/  ${RED}⢸⣿⣿⣿⣿⣿⣿⡿${RESET}${CREDITSF}${CREDITB}  by timetravel3 @ Licensed under GPLv2 license"
	echo "⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀${RED}⠀⠀⠀⠀⠀⠀⢻⣿⣿⣿⣿⡿⠁${RESET}"
	echo "⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀${RED}⠀⠀⠀⠀⠀⠀⠀⠻⣿⠿⠋⠀⠀${RESET}"
	echo "⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀${RED}⠀⠀⠀⠀⠀⠀⢠⡘⠁⠀⠀⠀⠀${RESET}"
	echo "⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀${RED}⠀⠀⠀⠀⠀⠆⠀⠇⠀⠀⠀⠀⠀${RESET}"
	echo "${CREDITB}⠀⣠⣴⣶⣾⢶⡖⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀${RED}⠀⠀⠀⠀⠸⠀⠀⠀⠀⠀⠀⠀⠀${RESET}"
	echo "${CREDITB}⢰⣿⣿⣿⡃⠀⠹⠃⠀⠀⠀⠀⠀⢀⣄⠀⠀${RED}⠀⠀⠈⠉⠀⠀⠀⠀⠀⠀⠀⠀⠀${RESET}"
	echo "${CREDITB}⠸⣿⣿⣿⣷⣦⠀⠀⠀⠀⠀⣀⣴⣿⡁⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀"
	echo "⠀⠙⠿⣿⠿⠟⠋⣀⣤⣾⠿⠋⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀"
	echo "⠀⢠⣾⡗⠠⡀⠙⡟⠉⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀"
	echo "⠀⢈⣿⢠⣾⠀⠀⠰⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀"
	echo "⠀⠘⢣⣿⣿⣀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀"
	echo "⠀⠀⢿⣿⣿⣿⡄⠹⡄⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀"
	echo "⠀⣼⡬⣿⣿⣿⣿⡔⡠⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀"
	echo "⠀⣿⣿⣿⣿⣿⣿⣿⡴⡀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀"
	echo "⢸⣿⣿⣿⣿⣿⣿⣿⣿⣾⣆⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀"
	echo "⢸⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣷⡄⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀"
	echo "⠛⠻⢿⣿⣿⣿⠿⠿⠿⠿⠛⠛⠋⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀"
	echo "⠀⠀⣾⣿⣿⣿⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀"
	echo "⠀⠰⣿⣿⣿⡇⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀"
	echo "⠀⠀⣿⣿⣿⠇⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀"
	echo "⠀⠀⣿⣿⣿⣦⣤⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀${RESET}"
	echo
}

# This is a simple log function that takes in input two parameters
# the first one is the message and the second one is the type of
# it, which causes the program to run different outputs
function log() {
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

# Read second parameter if it is necessary
function read_param() {

	# If the PARAM variable ( second parameter of the action, e.g. init backup etc... ) is not set ask for it
	if [[ ! $PARAM ]]; then

		# Changing directory is used for autocompletition since the -e parameter in read is used
		if [[ ! $2 ]]; then
			cd $KERNELD || exit
		else
			cd $2 || exit
		fi
		while true; do
			echo
			log $'second parameter not detected' 'info'
			echo

			# Print the prompt and then take the PARAM variable in input
			log "$1" prompt
			read -e PARAM

			# Check for non empty input, otherwise ask it again
			if [[ ! $PARAM ]]; then
				log "Insert a valid input" "warning"
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

	do_compress || "Compression of the filesystem was not successful!" "warning"
	(cd "${KERNELD}" && "$KERNELD/run.sh") || log "Could not run the kernel, maybe some file is missing in the ${KERNELD} directory" error
}

function do_make() {
	# Simple compiling function
	log "Trying compiling" "info"
	make --always-make -C "${EXPLOITD}" || log "Couldn't compile the exploit" "error"
	log "Successfully compiled" "success"
}

function do_backup() {
	PARAM=$(basename ${KERNELD}/init*.cpio*)

	log "Trying backup" "info"
	[[ -d $BACKUPD ]] || {
		mkdir -p $BACKUPD
		log "Created directory $BACKUPD" "info"
	}

	log "Running: cp \"$KERNELD/$PARAM\" \"$BACKUPD/$PARAM.bak\"" "info"

	# Preserve the original cpio
	cp --backup=t "$KERNELD/$PARAM" $BACKUPD/$PARAM.bak || { log "Failed to make a backup" "error"; }
	log "Created a backup" "success"
}

function do_compress() {
	# NOTE: read_param sets the $PARAM global variable

	PARAM=$(basename "${KERNELD}"/init*.cpio*)

	# Take the second parameter of the action an use it
	# as a filename, then remove the extension from it
	# and create a directory in $EXTRACTD/ with the name
	# of the file with an .extracted extension
	local filename=$PARAM
	# local filename=${filename}
	local dirname="$EXTRACTD/${filename}.extracted"

	# Debugging info
	log "Trying compressing" info
	log "Compressing folder $dirname -> $KERNELD/$filename" info

	# Passing all the filnames on the directory
	# to cpio/gzip to compress them
	if [[ ! -d "${dirname}" ]]; then
		log "Extracting filesystem for the first time" info
		do_extract
	fi

	cd "$dirname" || log "Could not extract file system" error

	# from the filname take the last extension
	extension="${filename##*.}"

	set -x
	case $extension in
	'gz' | 'gzip')
		find . -print0 2>/dev/null | cpio --null -ov --format=newc 2>/dev/null | gzip -1 >"$KERNELD/$filename"

		;;
	'cpio')
		find . -print0 2>/dev/null | cpio --null -ov --format=newc 2>/dev/null >"$KERNELD/$filename"
		;;
	*)
		log "Unknown extension .$extension" "error"
		;;
	esac
	set +x

	cd "$MYPATH" || return
}

function do_extract() {
	# NOTE: read_param sets the $PARAM global variable
	PARAM=$(basename "${KERNELD}"/init*.cpio*)

	# Debugging info
	log "Trying extracting" "info"

	# Set the filename, filename full path variables
	# and the future extracted directory path
	filename=$PARAM
	filename_fp="$KERNELD/$filename"
	dirname="$EXTRACTD/${filename}.extracted"

	# from the filname take the last extension
	extension="${filename##*.}"

	# If the filename does not exist raise an error and exit (default behaviour for errors)
	[[ -f $filename_fp ]] || { log "Filename $filename_fp not found" error; }

	# Checking for supported extension
	case $extension in
	'gz' | 'gzip')
		# gunzip the file and remove from the filaname full path variable the last extension
		# gzip -k keeps the original
		zcat -k -d "$filename_fp" >"$WORKINGD/${filename%.*}.extracted" || {
			log "Error $filename_fp is a corrupted gzip"
			exit
		}
		filename_fp=$WORKINGD/${filename%.*}.extracted
		;;
	'cpio')
		# for cpio file decompression is not needed in this
		# part of the function
		:
		;;
	*)
		log "Unknown extension .$extension" "error"
		;;
	esac

	# Prompt to delete the directory if it exists
	choice="y"
	# rm -rf $dirname
	if [[ -d $dirname ]]; then
		log "Remove directory $dirname (y/n)" prompt && read -N 1 choice
		echo

		if [[ ${choice,,} =~ y ]]; then
			set -x
			rm -rf ${dirname} 2>/dev/null
			set +x
		else
			log "User exited" error
		fi
	fi

	log "Creating ${dirname}" info
	mkdir -p ${dirname}

	# Extract the archive and list all the extracted archives
	log "Extracting $filename_fp -> $dirname" info
	(cpio -idD"${dirname}" <"$filename_fp" 2>/dev/null && log "Successfully extracted!" "success") || log "Failed to extract ${filename_fp}" "error"

}

function do_restore() {
	# This function restore a previously made
	# backup, this is a very simple function and overwrites
	# whatever is in the kernel directory
	# this function takes the filename to backup
	read_param "which initfs do you want to restore?" "$BACKUPD"
	log "Trying restoring" info

	# -i to prompt before overwriting, -v verbose, -r recurse
	# in case of backing up a directory
	cp -v -r "$BACKUPD/$PARAM" "$KERNELD/${PARAM%.*}" || log "Error could not restore the backup" error

	# log in case of success
	log "Successfully restored backup" success
}

function do_exploit() {
	# this function is a macro that executes a series of function
	PARAM=$(basename "${KERNELD}"/init*.cpio*)

	do_make || exit
	EXPLOIT=$(file "${EXPLOITD}"/* | grep "executable" | cut -d: -f1)
	log ${EXPLOIT} errror

	cp -v "${EXPLOIT[@]}" --target-directory="$EXTRACTD/${PARAM}.extracted/"
	do_run || exit
}

function do_debug() {
	log "Loading debugging..." info

	if ! grep -q "${GDB_REMOTE_CMD}" "${GDB_SCRIPT}"; then
		log "Target remote not detected in ${GDB_SCRIPT}" info
		set -x
		echo "${GDB_REMOTE_CMD}" >>"${GDB_SCRIPT}"
		set +x
	fi

	if [[ $(command -v tmux 2>/dev/null) && "${TMUX}" ]]; then
		tmux set-option remain-on-exit on
		tmux kill-pane -a
		tmux splitw -h "kini exploit"
		tmux select-pane -t 0
		if [[ $(command -v gef24 2>/dev/null) ]]; then
			log "Loading Gef24!" info
			gef24 "${GDB_ARGS[@]}"
		elif [[ $(command -v gdb 2>/dev/null) ]]; then
			log "Loading GDB" info
			gdb "${GDB_ARGS[@]}"
		else
			log "Could not find gdb..." error
		fi

		tmux kill-pane -a
	else
		log "Only TMUX sessions are supported, If you have TMUX join a session" error
	fi
}

function do_init() {
	# create basic directory tree
	# if you do not like it, you can change the paths
	# in the upper part of the program with the env variables

	KERNEL_FILES=$(ls ./flag.txt ./bzImage ./vmlinu* ./run.sh ./*.img ./init*.cpio* 2>/dev/null)

	if [[ ! "${KERNEL_FILES}" ]]; then
		log "Could not detect any valid Linux kernel files" error
	fi

	mkdir -p "$KERNELD"
	mv ${KERNEL_FILES} --target-dir="${KERNELD}/" 2>/dev/null || log "Some kernel files might be missing, like: bzImage, run.sh, ..." "warning"

	log "Creating directory tree" info
	mkdir -p "$BACKUPD"
	mkdir -p "$WORKINGD"
	mkdir -p "$EXTRACTD"
	mkdir -p "$EXPLOITD"

	log "Backing up fs" info
	do_backup

	log "Successfully created" success
}

function main() {
	# call the banner and warnings
	banner
	# call_warning
	log "This project is under maintenance right now so use it wisely" warning

	# also create the directory tree

	# Check if you passed the first argument via CLI otherwise ask it via stdin
	if [[ ! $FIRST ]]; then
		log "First parameter not detected" "info"
		echo
		echo "${OPTIONSF}select action: 'run' 'debug' 'exploit' 'extract' 'backup' 'restore'${RESET}"
		read -e -p "$PS3" CHOICE
	else
		# even if the $SECOND is not set
		# read_param checks if it has been
		# if not it asks for it
		CHOICE=$FIRST

		PARAM=$SECOND
	fi

	if [[ $CHOICE =~ [-]{0,2}update ]]; then
		log "Upgrading kini..." info
		wget -q https://raw.githubusercontent.com/timetravelthree/kpwninit/main/install.sh -O- | sh
		log "Upgraded kini successfully" success
		exit 0
	fi

	# if this script has never been run, run this
	if [[ ! -f ".kini" ]]; then
		log "Executing the script for the first time executing init" info

		# if [[ $BASH_VERSION ]]; then
		# 	# this is used for autocompletition
		# 	log "Loading auto-completition" info
		# 	echo -e "\n# Autocompletition for kpwninit.sh\nsource $MYPATH/autocomplete/autocomplete.bash" >>$HOME/.bashrc
		# else
		# 	log "This script supports auto-completition only in bash" warning
		# fi

		do_init && touch .kini
	fi

	# this is a switch case which calls functions
	case $CHOICE in
	exploit | exp)
		do_exploit
		;;
	backup | bak)
		do_backup
		;;
	debug | dbg | gdb)
		do_debug
		;;
	extract | ext)
		do_extract
		;;
	run)
		do_run
		;;
	restore | rst)
		do_restore
		;;
	*)
		log "Command not found" error
		;;
	esac
}

main
