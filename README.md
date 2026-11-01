# Neovim Config

Personal Neovim config for Arch Linux + Hyprland, using the built-in `vim.pack`
plugin manager (no lazy.nvim). Theming is driven by Noctalia's palette engine
via a generated `matugen.lua`.

---

## Table of contents

- [Quick start](#quick-start)
- [System requirements](#system-requirements)
- [Keyring](#keyring)
- [Post-install steps](#post-install-steps)
- [Noctalia theming](#noctalia-theming)
- [Repository layout](#repository-layout)
- [Load order](#load-order)
- [Plugin manager notes](#plugin-manager-notes)
- [Notable plugin choices](#notable-plugin-choices)
- [Troubleshooting](#troubleshooting)
- [Security notes](#security-notes)

---

## Quick start

```sh
git clone <this-repo> ~/.config/nvim
nvim
```

First launch clones every plugin from `nvim-pack-lock.json`. Then work through
[Post-install steps](#post-install-steps) — nothing there is automated, and
several features fail silently without it.

---

## System requirements

### Required

| Package | Why |
|---|---|
| `neovim >= 0.12` | `vim.pack`, built-in commenting, `vim.lsp.config` |
| `git` | `vim.pack` clone/update, `gitsigns`, `lazygit` |
| `curl`, `tar`, `unzip`, `gzip` | `mason.nvim` package installation |
| `fzf` | `fzf-lua` is only a wrapper — nothing works without it |
| `ripgrep` (`rg`) | `fzf-lua` live grep, `@{grep_search}` tool |
| `fd` | faster file listing |
| `bat` | syntax-highlighted previews in `fzf-lua` |
| `tree-sitter` CLI **>= 0.26.1** | parser builds by `tree-sitter-manager.nvim` |
| `gcc` / `clang` | compiling tree-sitter parsers |
| `lazygit` | the `<leader>gg` git TUI |
| `direnv` | `.envrc` env loading |
| `libsecret` (`secret-tool`) | API key retrieval, see [Keyring](#keyring) |
| a Secret Service provider | `gnome-keyring` — see [Keyring](#keyring) |

Install on Arch:

```sh
sudo pacman -S neovim git curl tar unzip gzip fzf ripgrep fd bat \
               tree-sitter-cli gcc lazygit direnv libsecret gnome-keyring
```

> `tree-sitter-cli` **must** come from the package manager, not npm. The npm
> build is a known source of parser-build breakage.

### Optional

| Package | For |
|---|---|
| `nvr` (`neovim-remote`) | `lazygit_use_neovim_remote`, opening files from lazygit back into nvim |
| `psql` / `sqlite3` / `mysql` | `vim-dadbod` shells out; it bundles no drivers |
| language servers | installed by Mason, see [Post-install steps](#post-install-steps) |
| a Nerd Font (v3.0+) | `mini.icons`, `witch-line`, `trouble` glyphs |

---

## Keyring

The DeepSeek API key is stored in the OS keyring and fetched on demand by
`secret-tool`. It is never in an environment variable and never in this repo.

### Only one provider

`org.freedesktop.secrets` is a single D-Bus name. If both `gnome-keyring` and
`kwallet` are installed, whichever activates first claims it — a race, and
secrets stored under one are invisible to the other.

Check which one is running:

```sh
busctl --user status org.freedesktop.secrets
ps -ef | grep -Ei 'gnome-keyring|kwalletd'
```

Keep exactly one. On a Hyprland session `gnome-keyring` is the usual choice,
unlocked by PAM from your login password.

### Make `Login` the default collection

If more than one keyring exists, PAM unlocks `Login` but `default` may point
elsewhere. Symptom: secrets are unavailable after every reboot until a second
login unlocks the other keyring.

Fix: Seahorse → right-click `Login` → **Set as default**.

### Store the key

```sh
secret-tool store --label='DeepSeek API key' service codecompanion key deepseek
```

Paste the key at the prompt — it does not echo and does not reach shell history.

Verify:

```sh
secret-tool lookup service codecompanion key deepseek
```

The config references it as:

```lua
api_key = 'cmd:secret-tool lookup service codecompanion key deepseek'
```

`cmd:` is resolved per request, so the plaintext key exists only inside the
`curl` process. The `Authorization` header is passed to curl on stdin
(`--config -`), so the key never appears in any process's `argv`.

---

## Post-install steps

These are **not** automated. Each one silently disables a feature if skipped.

### 1. markdown-preview binary

`iamcco/markdown-preview.nvim` needs a prebuilt binary. `vim.pack` does not
build it.

```vim
:call mkdp#util#install()
```

Or, after a `vim.pack.del` + reinstall:

```sh
cd ~/.local/share/nvim/site/pack/core/opt/markdown-preview.nvim/app
./install.sh
```

Verify — you want `markdown-preview-linux`, ~70 MB, executable:

```sh
ls -la ~/.local/share/nvim/site/pack/core/opt/markdown-preview.nvim/app/bin/
```

> `app/out/` is a build intermediate, **not** what the plugin runs. If `bin/`
> is missing, `:MarkdownPreview` opens a blank page.
>
> Do not build from source. The build script wants Node 16 + webpack 4 and
> fails on modern Node with `ERR_OSSL_EVP_UNSUPPORTED`. `install.sh` only
> downloads a tarball.

### 2. Tree-sitter parsers

```vim
:TSInstallSync lua python bash fish go rust sql json yaml toml
```

Or `:TSManager` for the TUI. `yaml` is required for CodeCompanion skills and
markdown prompt-library items.

After any plugin update:

```vim
:TSUpdate
```

Parser revisions are pinned by the plugin; mismatched parsers fail to load.

### 3. Language servers, formatters, linters

Declared in `lua/plugins/mason_lsp_formatters_linters.lua` under
`ensure_installed`, so a fresh machine installs them on first launch. To add
one:

```vim
:MasonInstall <name>
```

Then declare it in `ensure_installed` or it won't be there next time.

`:checkhealth mason` lists missing system dependencies.

### 4. Debug adapters

```vim
:DapInstall python
```

Registered through `mason-nvim-dap`; add to its `ensure_installed` afterwards.

### 5. Verify everything

```vim
:checkhealth
```

Reports on mason, treesitter, fzf-lua, oil, blink.cmp, codecompanion, dap,
gitsigns. Anything red there is your to-do list.

---

## Noctalia theming

`lua/matugen.lua` is **generated output** — do not edit it, it is overwritten on
every palette change.

The editable source is `lua/matugen-template.lua`, rendered by Noctalia's
template engine.

### Register the template

In `~/.config/noctalia/*.toml` (e.g. `nvim.toml`):

```toml
[theme.templates.user.nvim_base16]
input_path  = "~/.config/nvim/lua/matugen-template.lua"
output_path = "~/.config/nvim/lua/matugen.lua"
post_hook   = "pkill -USR1 -x nvim"
```

Older Noctalia builds use `[templates.nvim-base16]` instead — check which form
your version accepts.

### How reload works

```text
wallpaper / palette change
  -> Noctalia renders lua/matugen.lua
  -> post_hook signals every nvim
  -> the SIGUSR1 handler drops the Lua cache and re-runs setup()
```

Test without changing the wallpaper:

```sh
pkill -USR1 -x nvim
```

Colours should reapply. If they don't, check that `matugen.lua`'s mtime
changed:

```sh
stat -c '%y' ~/.config/nvim/lua/matugen.lua
```

### 1Password alternate

If you store the key in 1Password instead, swap the `api_key` line:

```lua
api_key = 'cmd:op read op://personal/DeepSeek/credential --no-newline',
```

`--no-newline` matters — a trailing newline in an auth header produces a
confusing 401 rather than a clear error.

---

## Repository layout

```text
init.lua                 require order; see Load order below
build.lua                PackChanged hooks — must load before any vim.pack.add
lua/
  options.lua            vim.opt settings
  keymaps.lua            every global keymap
  commands.lua           user commands
  matugen.lua            GENERATED — gitignored
  matugen-template.lua   Noctalia template source
  plugins/               one file per plugin group
  tools/                 CodeCompanion custom tools (DeepSeek Search/Fetch)
nvim-pack-lock.json      plugin revisions — COMMIT THIS
```

### Committed vs ignored

```gitignore
# generated by Noctalia on every palette change
lua/matugen.lua

# vim.pack scratch
*.log
```

`nvim-pack-lock.json` **must** be committed. Without it, `vim.pack.update()`
silently drifts every machine to different revisions.

---

## Load order

`init.lua` order is load-bearing in five places:

| Order | Reason | Breaks if wrong |
|---|---|---|
| `options` first | plugins read options at `setup()` | witch-line wrong `laststatus` |
| `build` before first `add` | `:h vim.pack-events` | build hooks never fire on fresh install |
| `base_16` before matugen | matugen requires `base16-colorscheme` | `E5108`, no theme |
| `direnv` before LSP enable | env vars must exist at spawn | LSP misses project env |
| `mason` before `dap` | mason-nvim-dap assumes mason configured | adapter installs fail |
| **matugen last** | `base16-colorscheme.setup()` runs `hi clear` | all prior `hi` groups wiped |

Everything else is order-independent.

Verify matugen won:

```vim
:verbose hi Normal
```

Should name the matugen/base16 source.

---

## Plugin manager notes

`vim.pack` is the built-in manager. Key semantics that shape this config:

- `vim.pack.add()` at `init.lua` time defaults to **`load = false`** — the
  directory joins `'runtimepath'` but `plugin/` files aren't sourced until the
  normal `load-plugins` phase. Pass `load = true` explicitly for anything that
  needs its `plugin/` file immediately.
- `add()` is a no-op on a second call in the same session.
- `PackChanged` hooks must be registered **before** the first `add()` of the
  session, or install events fire before the handler exists.
- No declarative lazy-loading. Deferral is `require()` inside a keymap or
  autocmd; see `plugins/blink.lua` and `plugins/codecompanion.lua`.

Update plugins:

```vim
:lua vim.pack.update()
```

Review the confirmation buffer, `:w` to accept, `:q` to discard, then
`:restart`.

---

## Notable plugin choices

| Area | Choice | Note |
|---|---|---|
| Statusline | `witch-line` | small/young; pin it if it breaks |
| Picker | `fzf-lua` | eager — it's the front door to everything |
| File manager | `oil.nvim` | eager, replaces netrw (`vim.g.loaded_netrw = 1`) |
| Completion | `blink.cmp` | deferred to `InsertEnter`; snippets via built-in `vim.snippet`, **no LuaSnip** |
| Treesitter | `tree-sitter-manager` | native `vim.treesitter`; the manager only installs parsers + queries |
| Commenting | `mini.comment` | or use built-in `gc` (`:h commenting`) |
| Git | `gitsigns` + `lazygit` | gitsigns is hunks only; lazygit does branches/commits |
| AI | `codecompanion` + DeepSeek | key from keyring; custom Search/Fetch tools |

`mini.*` modules all come from the single `echasnovski/mini.nvim` repo — one
`vim.pack.add`, individual `require`s.

---

## Troubleshooting

| Symptom | Cause |
|---|---|
| `E492: Not an editor command: MarkdownPreview` | buffer is not markdown — the commands are buffer-local |
| `:MarkdownPreview` opens a blank page | `app/bin/` missing — run `install.sh` |
| No treesitter highlighting | parser not installed, or `:TSInstall` never run |
| No LSP completing `vim.*` | `lua_ls` `workspace.library` not set to `$VIMRUNTIME` |
| Icons missing everywhere | `MiniIcons.mock_nvim_web_devicons()` not called |
| `Engine thinks you're a bot` | DuckDuckGo search rate-limited — switch adapter |
| 401 from DeepSeek | trailing newline in the key, or wrong secret name |
| Config dies on one bad plugin file | wrap requires in `pcall` (see `init.lua`) |
| Startup jumped 20ms+ | `nvim --startuptime /tmp/st.log +q` then sort by column 2 |

Logs:

```sh
tail -50 ~/.local/state/nvim/codecompanion.log
```

```vim
:checkhealth codecompanion
:checkhealth mason
:checkhealth blink.cmp
```

---

## Security notes

The API key is stored in the OS keyring and passed to `curl` on stdin, so it
appears in neither `vim.env`, this repo, nor any process `argv`.

What this does **not** protect against: a program already running as you, once
the keyring is unlocked. `approval_mode = 'ask'` gates CodeCompanion's
`run_command` tool, and `run_command` asks per distinct command — approving
`git status` does not approve `make test`. Keep it on `ask` or `auto`; `yolo`
removes the gate entirely.

If you use CodeCompanion's `run_command`, assume the agent can read anything
your unlocked user session can.
