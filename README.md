Synopsis
========

This repository contains my dotfiles settings for Linux (Ubuntu 19.10 LTS) and Mac OS X(10.15), also a bit FreeBSD (10.0);
See [Windots](https://github.com/HongxuChen/Windots) for Windows settings.

<!-- toc -->

- [LICENSE](#license)

- [Setup](#setup)
- [Package managers](#package-managers)
- [Settings](#settings)
  * [Fundamentals](#fundamentals)
  * [Linux Specific](#linux-specific)
  * [Mac Specific](#mac-specific)

<!-- tocstop -->

LICENSE
=======
[MIT License](https://github.com/HongxuChen/dotfiles/tree/master/LICENSE).

Setup
============

  ```bash
  git clone git@github.com:HongxuChen/dotfiles.git /path/to/dotfiles
  # or with https: https://github.com/HongxuChen/dotfiles.git
  # my personal dotfiles folder is ~/tools/dotfiles

  ## close other applications for a smooth installation
  cd /path/to/dotfiles

  # see its usage
  ./install.py -h

  # dryrun to see whether there are dangerous operations
  ./install.py -n

  # install (if you're feeling lucky)
  ./install.py

  ```

* Use `install.py` to setup the environment, which merely adds symlinks to `$HOME` directory as well as backups your original settings (if they do exist).
It's better to *dryrun* it beforehand with `install.py -n` (more details with `install.py -h`) to see the effects.
It is suggested to close other applications (e.g., google-chrome) during setup(especially on Linux).

* Some of my personal information **should be** changed,
you can `grep`or `rg` (see [ripgrep](https://github.com/BurntSushi/ripgrep)) and replace them.

  ```
  # grep my personal info (containing "hongxu") and open in Vi
  git ls-files *[^*.md] | xargs rg 'hongxu' | vi -
  # then you'd change these settings yourself
  ```

* Extra fonts are available [on Dropbox](https://www.dropbox.com/sh/1er7al26qjsjdeg/AACoU5BQ6Ijq_vnBrqLemrRwa?dl=0). Caveats: they are not all free fonts and not under MIT license.

    - can be used by urxvt, etc;
    - note: on Debian derivatives, make sure urxvt is from `rxvt-unicode-256color`;
    - xterm is not recommended as it has poor support for unicode characters.


Settings
================

Fundamentals
------------

1. **NeoVim**(managed by [vim-plug](https://github.com/junegunn/vim-plug))(`~/.vimrc`, `~/.vim`)

1. [Zsh](http://www.zsh.org/)(derived from [oh-my-zsh](https://github.com/robbyrussell/oh-my-zsh))

    - relevant files:
        - `~/.profile`
        - `~/.aliases`
        - `~/.zprofile`
        - `~/.zshrc`
        - `~/.omz/`

1. [**IPython**](http://ipython.org/)(especially for [sh](http://ipython.org/ipython-doc/dev/interactive/shell.html)/[nb](http://ipython.org/notebook.html) profile)(`~/.ipython/`)

    - for **sh** profile (check command alias: `p_sh`), *lots* of packages are pre-imported(installed via `pip`)

1. [**sbt**](http://www.scala-sbt.org/)(`~/.sbt`, `~/.sbtrc`)

1. **git**(`~/.gitconfig`)

    - `_gitignore_global` is available at [misc](https://github.com/HongxuChen/dotfiles/tree/master/misc)
    - [git-extras](https://github.com/tj/git-extras) is awesome

1. [**tmux**](http://tmux.sourceforge.net/)(`~/.tmux.conf`)

1. [**hg**](http://mercurial.selenic.com/)(aka mercurial) (`~/.hgrc`)


Linux Specific
--------------

They are *not* exactly linux only, but *I* tend not to use them on Mac OSX. They lie inside [Linux/](https://github.com/HongxuChen/dotfiles/tree/master/Linux) and are also symlinked to `$HOME` by `install.py`. (Ditto for files in [Darwin/](https://github.com/HongxuChen/dotfiles/tree/master/Darwin), which is supposed to be Mac specific.)

- **gdb**(`~/.gdbinit`, `~/.gdb`)

    - gdb is superseded by [lldb](http://lldb.llvm.org) on newer Mac OSX.

- **X11** settings
    - `~/.Xresources`: for XTerm, URxvt, should run `xrdb -load ~/.Xresources` firstly
    - `~/.xscreensaver`

- **wget**(~/.wgetrc)
    - since wget is GPL

- **svn**(`~/.subversion/`)
    - Mac has better GUI clients

- **mplayer**(`~/.mplayer`)
    - Mac has better players

- [**aptitude**](https://wiki.debian.org/Aptitude)(`~/.aptitude/`)

- **bash**(`~/.bashrc`)

    - share `~/.profile`, `~/.aliases` with zsh;
    - used when there's no alternatives.

Mac Specific
------------

- [**slate**](https://github.com/jigish/slate)(`~/.slate`)

Known Issues
------------
- tmux status right cannot fill
- zsh-syntax-highlighting not work during typing (only after)
- need to install some external commands to make this configurations work correctly.
  * git
  * node+npm/yarn
