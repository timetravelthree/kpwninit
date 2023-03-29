#!/bin/sh

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

# Simple log helping function
log() {
	typem=$2
	message=$1
	case $typem in
	info)
		echo "${INFOB}${INFOF}[?] Info: ${RESET}${INFOB} $message ${RESET}"
		;;
	warning)
		echo "${WARNINGB}${WARNINGF}[*] Warning: ${RESET}${WARNINGB} $message ${RESET}"
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

# Installation directory of kini
INSTALLATION_DIR="${HOME}"/.local/bin

# Just make sure that the user local bin directory exists download the latest script from Github
log "Installing latest Github scripts" info
set -x
mkdir -p "${INSTALLATION_DIR}"
wget -q https://raw.githubusercontent.com/timetravelthree/kpwninit/main/kini.sh -O "${INSTALLATION_DIR}/kini"
chmod +x "${INSTALLATION_DIR}/kini"
set +x

log "Try running \`which kini\` you should see a result" success
log "Installation was successfull!" success
