# my-cfg

My portable terminal setup — **zsh**, **Neovim**, and **tmux** in one repo. Clone
it on a new machine, run one script, and everything is wired up.

## What's inside

| Path | What it is | Symlinked to |
|------|------------|--------------|
| `zsh/.zshrc` | zsh config (oh-my-zsh, `half-life` theme) | `~/.zshrc` |
| `zsh/.zprofile` | login-shell PATH | `~/.zprofile` |
| `zsh/.zshrc.local.example` | template for per-machine env | copy to `~/.zshrc.local` |
| `nvim/` | Neovim config (`init.lua` + cheatsheet) | `~/.config/nvim` |
| `tmux/` | tmux config (`tmux.conf`) | `~/.config/tmux` |

## Prerequisites

Install these first (package names vary by distro):

- `git`, `zsh`, `tmux`
- `nvim` (Neovim 0.9+)

oh-my-zsh and **tpm** (the tmux plugin manager) are bootstrapped automatically by
the install script — you don't need to install them by hand.

## Setup

```bash
git clone git@github.com:vyvnx/my-cfg.git ~/my-cfg
cd ~/my-cfg
./install.sh
```

`install.sh` is idempotent and safe to re-run. It symlinks each config into place
(backing up anything already there to `~/.dotfiles-backup/<timestamp>/`), then
clones oh-my-zsh and tpm if they're missing.

### Finish up

1. **Machine-specific env** — copy the template and edit it for this machine
   (Java, CUDA, etc.):
   ```bash
   cp zsh/.zshrc.local.example ~/.zshrc.local
   $EDITOR ~/.zshrc.local
   ```
2. **Reload zsh:** `exec zsh`
3. **tmux plugins:** start `tmux`, then press the prefix `Ctrl-Space` followed by
   `I` (capital i) to install plugins into `~/.tmux/plugins/`.
4. **Neovim:** open `nvim` and let the plugin manager finish syncing.

## Notes

- **tmux prefix** is `Ctrl-Space` (not the default `Ctrl-b`). Reload the config
  in a running session with `prefix` + `r`.
- See `nvim/cheatsheet.md` for Neovim keybindings.
- Machine-specific paths and anything sensitive belong in `~/.zshrc.local`, which
  is **not** tracked by git. The portable `~/.zshrc` sources it automatically if
  it exists.

## Adding another tool later

1. Put its config under a new top-level folder, e.g. `git/`.
2. Add a `"source:target"` entry to the `LINKS` array in `install.sh`.
3. Re-run `./install.sh`.
