# ZSH Plugin for homeassistant-cli
#
# Plugin repository: https://github.com/frosit/zsh-plugin-homeassistant-cli
# Homeassistant-cli: https://github.com/home-assistant/home-assistant-cli
# hass-cli project: https://www.home-assistant.io/blog/2019/02/04/introducing-home-assistant-cli/
#
# Author: Fabio Ros
###################################
export __HASSC_SCRIPT_DIR=${0:a:h}

# Aliases
alias hacli='hass-cli'
alias hasscli='hass-cli'
alias hass-cli_confcheck='hass-cli service call homeassistant.check_config'
alias hass-cli_harestart='hass-cli service call homeassistant.restart'
alias hass-cli_states='hass-cli state list'
alias hass-cli_device='hass-cli device list'
alias hass-cli_entity='hass-cli entity list'
alias hass-cli_syshealth='hass-cli system health'
alias hass-cli_syslog='hass-cli system log'

#######################################
# Show defined environment variables
# Globals:
#   env
# Arguments:
#   None
# Returns:
#   None
#######################################
function hass-cli_show_env(){
    local HASS_CLI_ENV_KEYS=( HASS_SERVER HASS_TOKEN HASS_PASSWORD HASS_CERT )
    while read -r VAR; do
        local VAR_KEY=${VAR%%=*}
        local VAR_VALUE=$(echo ${VAR} | cut -d'=' -f2)
        print "${VAR_KEY}: ${VAR_VALUE}"
    done < <(env | grep -h "^HASS_")
}

#######################################
# Sources variables from .env file
# Globals:
#   HASS_DOTENV
# Arguments:
#   Path to .env file (.hass-cli.env) (optional)
# Returns:
#   None
#######################################
function hass-cli_source_env(){
    local HASS_DOTENV="${1:-${HOME}/.hass-cli.env}"
    if [[ -f $HASS_DOTENV ]]; then
        zsh -fn $HASS_DOTENV || echo "dotenv: error when sourcing '$HASS_DOTENV' file" >&2
        if [[ -o a ]]; then
            source $HASS_DOTENV
        else
            set -a
            source $HASS_DOTENV
            set +a
        fi
  fi
}

#######################################
# Open ha instance
# Globals:
#   HASS_SERVER
# Arguments:
#   None
# Returns:
#   None
#######################################
function hass-cli_open(){
    if [[ -n $HASS_SERVER && $HASS_SERVER != auto ]]; then
        open_command "${HASS_SERVER}"
    else
        print "HASS_SERVER is not defined or auto, can't open url."
    fi
}

#######################################
# Generate completion code
# Globals:
#   HASS_SERVER
# Arguments:
#   None
# Returns:
#   None
# TODO: test properly and invalidate on lifetime
#######################################
_hass-cli_completion(){

	local __HASS_CLI_CACHE_COMPLETION_FILE="${ZSH_CACHE_DIR}/_hass-cli_completion"
	local __HASS_CLI_LOCAL_COMPLETION_FILE="${__HASSC_SCRIPT_DIR}/_hass-cli"

	# Generate
	if [[ ! -f $__HASS_CLI_CACHE_COMPLETION_FILE || -z $(cat $__HASS_CLI_CACHE_COMPLETION_FILE) ]]; then # if bad cache
		if [[ ! -x "${commands[hass-cli]}" ]]; then # if hass-cli not defined, copy completion from repo
			cat $__HASS_CLI_LOCAL_COMPLETION_FILE > $__HASS_CLI_CACHE_COMPLETION_FILE
		else # generate
			hass-cli completion zsh >! $__HASS_CLI_CACHE_COMPLETION_FILE
		fi
	fi

	# Load
	[ -f $__HASS_CLI_CACHE_COMPLETION_FILE ] && source $__HASS_CLI_CACHE_COMPLETION_FILE
}

# Source
hass-cli_source_env ${HASS_DOTENV:-${HOME}/.hass-cli.env}
_hass-cli_completion
