# 🧠 Neovim Keybind Cheat Sheet

> `<leader>` = `Space`

---

## ⚙️ General
| Keybind | Description |
|----------|-------------|
| `<C-s>` / `<M-s>` | Save file (force) |
| `<C-a>` | Select entire file |
| `<C-f>` | Find and replace word (prompted) |
| `<C-g>` | Go to definition (LSP) |
| `<C-b>` | Jump back (jumplist) |
| `<leader>q` | Save and quit window |
| `<leader>qq` | Force quit window |
| `kk` (insert) | Exit insert mode |
| `[` | Jump to line start |
| `]` | Jump to line end |
| `gb` | Go to last line |

---

## 🪟 Window Management
| Keybind | Description |
|----------|-------------|
| `<leader>wv` | Vertical split |
| `<leader>ws` | Horizontal split |
| `<leader>wo` | Keep only current window |
| `<leader>w=` | Equalize split sizes |
| `<leader>w<` | Shrink width |
| `<leader>w>` | Grow width |
| `<leader>tk` | Stack splits horizontally |
| `<leader>th` | Arrange splits side by side |
| `<C-h>` | Move to split left (tmux-aware) |
| `<C-j>` | Move to split down (tmux-aware) |
| `<C-k>` | Move to split up (tmux-aware) |
| `<C-l>` | Move to split right (tmux-aware) |

---

## 📂 Code Folding
| Keybind | Description |
|----------|-------------|
| `<CR>` (Enter) | Toggle fold under cursor (open/close block) |
| `zc` / `zo` | Close / open fold under cursor |
| `zM` / `zR` | Close all / open all folds |
| `zj` / `zk` | Jump to next / previous fold |

---

## 🌳 File Explorer (nvim-tree)
| Keybind | Description |
|----------|-------------|
| `<leader>e` | Toggle file explorer |
| `<CR>` | Open file |
| `l` | Open / expand |
| `h` | Collapse |
| `s` | Open in vertical split |
| `x` | Open in horizontal split |
| `t` | Open in new tab |
| `f` | Reveal current file |
| `a` | New file / directory |
| `<F2>` | Rename |
| `c` | Copy |
| `p` | Paste |
| `<Del>` | Delete |
| `H` | Toggle hidden (dotfiles) |
| `R` | Refresh |
| `q` | Close explorer |

---

## 🔍 Telescope
| Keybind | Description |
|----------|-------------|
| `<leader>ff` | Find files |
| `<leader><leader>` | Live grep |

---

## 🧩 LSP
| Keybind | Description |
|----------|-------------|
| `gd` | Go to definition |
| `gD` | Go to declaration |
| `gi` | Go to implementation |
| `gr` | List references |
| `K` | Hover documentation |
| `<leader>rn` | Rename symbol |
| `<leader>ca` | Code action |
| `<leader>f` | Format buffer |

---

## 🔷 TypeScript
| Keybind | Description |
|----------|-------------|
| `<leader>fq` | Add missing imports |
| `<leader>fw` | Organize imports |

---

## 🩺 Diagnostics & Trouble
| Keybind | Description |
|----------|-------------|
| `<C-e>` | Open diagnostic float |
| `<leader>dd` | Toggle Trouble diagnostics |
| `<leader>yc` | Copy diagnostic at cursor |

### Inside Trouble
| Keybind | Description |
|----------|-------------|
| `q` / `<esc>` | Close Trouble |
| `<cr>` | Jump to diagnostic |
| `o` | Jump + close Trouble |
| `r` | Refresh list |
| `p` | Preview diagnostic |
| `P` | Toggle preview |
| `k` / `j` | Navigate up / down |
| `zM` | Close all folds |
| `zR` | Open all folds |
| `za` | Toggle fold |

---

## 🔔 Notifications
| Keybind | Description |
|----------|-------------|
| `<leader>cl` | Clear notifications |
