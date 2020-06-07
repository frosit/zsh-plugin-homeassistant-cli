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
alias hass-cli_check_config='hass-cli service call homeassistant.check_config'
alias hass-cli_restart='hass-cli service call homeassistant.restart'
alias hass-cli_states='hass-cli state list'
alias hass-cli_devices='hass-cli device list'
alias hass-cli_entities='hass-cli entity list'
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
# Run helper
# Globals:
#   HASS_DOTENV
#   HASS_SERVER
#   HASS_TOKEN
#   HASS_PASSWORD
# Arguments:
#   None
# Returns:
#   None
#######################################
function hass-cli_env(){
  echo -e "Homeassistant CLI helper."
  echo -e ""

  if ! which hass-cli &> /dev/null; then # @todo better ways?
    INSTALL_HELP="
      hass-cli installation not detected. Please install:

        OSX: \`brew install homeassistant-cli\`
        pip: \`pip install homeassistant-cli\`

        For others, see docs: https://github.com/home-assistant/home-assistant-cli
    "
    echo -e "${INSTALL_HELP}"
    return
  else # if installed

    echo -e "Hass-CLI environment config:"

    local abspath=$(which hass-cli)
    echo -e " * Install: ${abspath}"

    local _HASS_DOTENV=${HASS_DOTENV:-${HOME}/.hass-cli.env}
    echo -e " * \$HASS_DOTENV: ${_HASS_DOTENV} (env file)"

    local _HASS_SERVER=${HASS_SERVER}
    echo -e " * \$HASS_SERVER: ${_HASS_SERVER} (default: auto)"

    local _HASS_TOKEN=${HASS_TOKEN}
    echo -e " * \$HASS_TOKEN: ${_HASS_TOKEN}"

    # if server + token not set
    if [[ -z $HASS_TOKEN || -z $HASS_SERVER ]]; then
      echo -e "Server and token not set"

      # Create env file
      if [ ! -f "$_HASS_DOTENV" ]; then
        echo -e "No hass .env file found at: ${_HASS_DOTENV}"
          read "a?Do you want to create env file at ${_HASS_DOTENV} [y/N] "
          if [[ $a == "Y" || $a == "y" || $a = "" ]]; then
              echo -e "Creating env file at ${_HASS_DOTENV}"
              touch $_HASS_DOTENV
          else
              echo -e "skip creation"
          fi
      fi

      # Configure server
      if [[ -z "$HASS_SERVER" || $HASS_SERVER == auto ]]; then
          echo -e "\$HASS_SERVER not set, it could be autodetected by hass-cli or specified right now."

          read "s?Do yuo you want to set the server name? or skip? [s|skip or (http...)server url] "
          if [[ $s != "s" || $s != "skip" || $s != "" ]]; then
              echo -e "Setting server to $s"
              echo -e "HASS_SERVER=\"${s}\"" >> "${_HASS_DOTENV}"
          else
              echo -e "Skipping server setup"
          fi
      fi

      # Configure auth
      if [[ -z "$HASS_TOKEN" || -z $HASS_PASSWORD ]]; then
          echo -e "No token or pwd set"

          read "t?Enter your token or leave empty to skip "
          if [[ $t != "" ]]; then
              echo -e "Setting token to $t"
              echo -e "HASS_TOKEN=\"${t}\"" >> "${_HASS_DOTENV}"
          fi
      fi
        echo -e "Source the file by running hass-cli_source_env"
    fi
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
