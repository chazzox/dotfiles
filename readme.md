# Usage

All of these files have been written to be used in tandem with
[gnu stow](https://www.gnu.org/software/stow/manual/stow.html)

Stow will create symlinks from these files, to your home directory. meaning you can never change one of these files without it getting reflected in both (when you try to edit the files in the `$home` dir, your just editing files inside the repository)

This allows you to clone the repo to wherever, then run the following command to get them up and running

These files configure the following services:

- fish
- neovim
- tmux
- oh-my-posh
- kitty

## setup

open your terminal, and `cd` into wherever you cloned this repo to and run

```bash
stow [PACKAGE-NAME] --target=$HOME
```
