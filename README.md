# config-model-systemd

check and edit systemd configuration files

## Description

This project provides a configuration editor for the 
configuration file of Systemd, i.e. all files in `~/.config/systemd/user/` or
all files in `/etc/systemd/system/`

## Usage

### invoke editor

The following command loads **user** systemd files and launch a graphical
editor:

    cme edit systemd-user

Likewise, the following command loads **system** systemd configuration
files and launch a graphical editor:

    sudo cme edit systemd

### Just check systemd configuration

You can also use cme to run sanity checks on the configuration file:

    cme check systemd-user
    cme check systemd

## Installation

On Debian (soon), run:

    apt install cme libconfig-model-systemd-perl

You can also install this project from CPAN (soon):

    cpanm install App::Cme
    cpanm install Config::Model::Systemd

Please follow these [instructions](README.build-from-git) to build from git.

## More information

* [Using cme](https://github.com/dod38fr/config-model/wiki/Using-cme)
    
