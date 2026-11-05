# Neovim config (`mac`) — sfw

Neovim 0.12+ setup for macOS: built-in `vim.pack` for plugins, `lz.n` for lazy
loading, moonfly + mini.statusline, Copilot for AI.

## Clone

```sh
git clone -b mac/sfw https://github.com/aggron-redoc/nvim-config ~/.config/nvim
nvim
```

The first start installs every plugin pinned in `nvim-pack-lock.json`. Nothing
else is installed for you.

## Copilot

Both Copilot plugins are lazy; sign in once after cloning:

```vim
:Copilot auth
```

- `<leader>cc` toggle chat, `<leader>ce` / `<leader>cr` explain / review the
  selection, `<leader>ca` prompt picker, `<leader>cm` models, `<leader>cs` open,
  `<leader>cx` reset
- `<leader>cp` suggestion panel, `<leader>cP` toggle for the current buffer

## Tools are installed manually

There is no Mason here. Language servers, formatters, linters, debug adapters
and tree-sitter parsers all have to be installed through the channel that owns
them — Homebrew, `npm -g`, `cargo install`, `pipx`, `gem`, `go install`, … — and
enabled as needed:

```sh
brew install lua-language-server stylua shellcheck
npm install -g typescript-language-server typescript
```

Then enable what you actually installed and restart:

| What | Where | How |
|---|---|---|
| Language servers | `lua/plugins/lsp.lua` | add to the `servers` table (`vim.lsp.enable`) |
| Formatters | `lua/plugins/lsp.lua` | `formatters_by_ft` (conform runs them on save) |
| Linters | `lua/plugins/lsp.lua` | `linters_by_ft` (nvim-lint runs them on write) |
| Debug adapters | `lua/plugins/dap.lua` | `dap.adapters.*` / `dap.configurations.*` |
| Tree-sitter parsers | anywhere | `:TSInstall lua python bash …` |

A missing binary is not an error — the feature stays off until the tool is on
`$PATH`. `:checkhealth` shows what Neovim can see.

Keymaps: `<leader>M` lists them, or read `lua/keymaps.lua`.
