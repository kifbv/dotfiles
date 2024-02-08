## Installation

* `git clone https://github.com/kifbv/dotfiles.git`
* `cd dotfiles`
* `stow --target ~ .`


Note:
- the `--dotfiles` option is interesting but doesn't work with directories (e.g. `~/.config`) if they are already populated (see [this](https://github.com/aspiers/stow/issues/33) issue);
- `README.md` is part of `stow` default ignored files (see `info stow`).
