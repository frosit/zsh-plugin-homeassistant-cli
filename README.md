# Hass-cli Plugin for Oh-My-Zsh

This plugin provides completion and (configuration) helpers for the [Home Assistant Command-line interface (hass-cli)](https://github.com/home-assistant/home-assistant-cli). It allows command line interaction with [Home Assistant](https://home-assistant.io/) instances.

# Prerequisites

* [hass-cli](https://github.com/home-assistant/home-assistant-cli#installation)
* [oh-my-zsh](https://github.com/ohmyzsh/ohmyzsh#getting-started)

```bash
git clone https://github.com/frosit/zsh-plugin-homeassistant-cli $ZSH_CUSTOM/plugins/hass-cli
```

To use, add `hass-cli` to the list of plugins in your `.zshrc` file:

`plugins=(... hass-cli)`

# Configuration

`hass-cli` can autodetect the server url of a local [Home Assistant](https://home-assistant.io/) instance. If this can't be detected you have to specify it together with either a token or password. These can be specified in your session, env vars or on the command line.

```.env
$HASS_SERVER / --server [server]
$HASS_TOKEN / --token [token]
# or
$HASS_PASSWORD / --password [password]
```

_supported variables_

```.env
HASS_SERVER="" (required - server url or "auto")
HASS_TOKEN="" (preffered - Brearer long lasting token)
HASS_PASSWORD="" (optional - API password)
HASS_CERT="" (optional - path to client cert.pem)
```
_example_

```bash
# .zshrc
export HASS_SERVER=https://hassio.local:8123
export HASS_TOKEN=<secret>

# at runtime
hass-cli --server=https://hassio.local:8123 --token=xxxxxxxxxx <arguments>
```

__Using the wizard (optional)__

Running `hass-cli_env` will start a wizard that shows the current variables and asks for the missing and writes them to `~/.hass-cli.env`

Currently the following variables are supported, future branches support all possible variables.

# Additional functions and aliases

Besides easy autocomplete, this plugin was meant to simplify all the options by defining the command arguments in mostly .env files. The aliases are reminders to help you fly a bit more through your terminal.

_aliases_

```
alias hacli='hass-cli'
alias hasscli='hass-cli'
alias hass-cli_check_config='hass-cli service call homeassistant.check_config'
alias hass-cli_restart='hass-cli service call homeassistant.restart'
alias hass-cli_states='hass-cli state list'
alias hass-cli_devices='hass-cli device list'
alias hass-cli_entities='hass-cli entity list'
alias hass-cli_syshealth='hass-cli system health'
alias hass-cli_syslog='hass-cli system log'
```

_Functions_

* `hass-cli_show_env` : shows currently defined HASS_* env variables.
* `hass-cli_source_env [file]` : Sources your .hass-cli.env file or the file specified as argument
* `hass-cli_open` : Open HA in your browser
* `hass-cli_env` : Shows the current env var or starts the wizard if vars are missing.
* `_hass-cli_completion`: (re)generate completion

# Advanced configuration

The [Home Assistant](https://home-assistant.io/) API is poorly documented but has a lot of options that are really useful. Using the advanced configuration you can basically preset options to use in different situations / environments (using .env files). This way you can for example preset additional columns for certain queries and have the output in json so it can easily be parsed with `jq`.

For now this branch is limited to different .env files. The dev branch supports all the options.

```bash
export HASS_DOTENV=$HOME/path/to/my/project/.env

# or 

hass-cli_source_env [file]
```

You can also just activate the dotenv zsh plugin, works the same, for now.
