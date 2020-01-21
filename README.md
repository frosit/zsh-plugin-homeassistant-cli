# Hass-cli Plugin for Oh-My-Zsh

This plugin provides completion and helpers for the [Home Assistant Command-line interface (hass-cli)](https://github.com/home-assistant/home-assistant-cli) which allows one to work with a local or a remote [Home Assistant](https://home-assistant.io/) instance directly from the command-line.

# Getting started

*Hass-cli should be [installed](https://github.com/home-assistant/home-assistant-cli#installation) and optionally [setup](https://github.com/home-assistant/home-assistant-cli#setup) for this plugin to work*

__Installing the plugin from the repository.__

```bash
git clone https://github.com/frosit/zsh-plugin-homeassistant-cli $ZSH_CUSTOM/plugins/hass-cli
```

__Enabling the plugin in oh-my-zsh__

To use, add `hass-cli` to the list of plugins in your `.zshrc` file:

`plugins=(... hass-cli)`

__Minimal configuration__

Hass-cli requires a server `$HASS_SERVER / --server` and `$HASS_TOKEN / --token` to be defined in order to communicate with home assistant.
These could be added to your .zshrc file or specified at runtime.

*The `$HASS_SERVER` is actually optional and autodetected within your network by default, however this is not recommended*

```bash
# .zshrc
export HASS_SERVER=https://hassio.local:8123
export HASS_TOKEN=<secret>

# at runtime
hass-cli --server=https://hassio.local:8123 --token=xxxxxxxxxx <arguments>
```

__Functions__

* `hass-cli_show_env` : shows currently defined HASS_* env variables.
* `hass-cli_source_env` : Sources a dotenv file, optionally accepts a path to an env file.
* `hass-cli_open` : Opens the homeassistant instance in the browser.

# Advanced configuration

This plugin has more advanced configurations possible in terms of defining variables and additional functions to aid in handling variables.

__Using a dotenv file__

A dotenv file can be used to have these variables active. Automatically this plugin will look for an `.hass-cli.env` file located in the home directory.
The env var `HASS_DOTENV` can be set to a different dotenv file.

```bash
export HASS_DOTENV=$HOME/path/to/my/project/.env
```

# To Do

* Testing
* Finish extended arguments handling
