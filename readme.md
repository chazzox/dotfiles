# Usage

all of these files have been written to be used in tandem with
[gnu stow](https://www.gnu.org/software/stow/manual/stow.html)

stow will create symlinks from these files, to your home directory. meaning you can never change one of these files without it getting reflected in both (when you try to edit the files in the `$home` dir, your just editing files inside the repository)

this allows you to clone the repo to wherever, then run the following command to get them up and running

these files configure the following services:

-   fish
-   neovim
-   tmux
-   oh-my-posh
-   alacritty

## setup

open your terminal, and `cd` into wherever you cloned this repo to and run

```bash
stow  --dir=[full-repo-path] --target=$HOME .
```

that's it! if you ever want to add a new file, create it inside this repo, then re run the stow command



make sure you switch the correct branch. main is for my ubunutu setup, and you can figure out the rest
