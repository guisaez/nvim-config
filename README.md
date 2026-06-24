# nvim-config

Personal Neovim configuration. Requires **Neovim 0.12+** (uses the
`vim.lsp.config`/`vim.lsp.enable` runtime and the auto-loaded `lsp/`
directory convention).

## Layout

```
init.lua            -- bootstrap: leader keys, lazy.nvim, require("lsp")
lsp/                -- declarative LSP server configs (auto-loaded by 0.12)
  elp.lua           -- erlang-language-platform (elp)
  erlangls.lua      -- erlang_ls
lua/
  lsp.lua           -- Erlang LSP selection logic (reads env)
  plugins/          -- lazy.nvim plugin specs
    lsp.lua         -- LSP, completion (blink.cmp), formatting (conform)
    treesitter.lua  -- nvim-treesitter + profile-based parser install
    ui.lua          -- telescope, neo-tree, gitsigns, which-key, mini, catppuccin
    claude.lua      -- claudecode.nvim + profile switching
  custom/           -- options, keymaps, autocmds
```

## Environment variables

Two environment variables control which tooling is activated. Set them in
your shell profile or per-project via direnv.

### `NVIM_PROFILES` — parser profiles and LSP tooling

Controls which Treesitter parsers are installed **and** which Mason LSP
servers are set up. Profiles are named bundles:

| Profile   | Treesitter parsers | Extra LSP |
| --------- | ------------------ | --------- |
| `core`    | bash, lua, luadoc, vim, vimdoc, markdown, markdown_inline, diff, query | — |
| `web`     | html, css, javascript, typescript, tsx | — |
| `beam`    | erlang, elixir, heex | `lexical` (Elixir LS via Mason) |
| `systems` | c, rust, zig, cpp | — |
| `infra`   | dockerfile, yaml, toml, json | — |

Selection rules:

- **Unset** → defaults to `core`.
- **Comma-separated list** → union of those profiles. E.g. `core,beam`.
- **`all`** → every profile.

```sh
# one-off
NVIM_PROFILES=core,beam nvim

# per machine (~/.zshrc, ~/.bashrc)
export NVIM_PROFILES=core,web,beam

# everything
NVIM_PROFILES=all nvim
```

Parsers are managed by `nvim-treesitter` (main branch). On startup, any
missing parsers for the active profiles are installed automatically. Parser
management lives in `lua/plugins/treesitter.lua`.

`lexical` (the Elixir language server) is only added to Mason's install list
when the `beam` profile is active. On machines without an Elixir environment,
leave `beam` out of `NVIM_PROFILES` to skip it entirely.

### `NVIM_ERLANG_LSP` — Erlang language server

Neovim 0.12 auto-loads every file under `lsp/` as a server config. Which
one actually starts is decided at startup by `lua/lsp.lua`:

| `NVIM_ERLANG_LSP` | Server started           | Required binary on `PATH` |
| ----------------- | ------------------------ | ------------------------- |
| `elp`             | erlang-language-platform | `elp`                     |
| `erlangls`        | erlang_ls                | `erlang_ls`               |
| unset / other     | none                     | —                         |

If the variable names a server but its binary is missing from `PATH`,
Neovim starts normally and prints a warning instead of attaching.

- **`elp`** — Meta's [erlang-language-platform](https://github.com/WhatsApp/erlang-language-platform).
  Faster, better diagnostics; preferred for rebar3 projects.
- **`erlangls`** — [erlang_ls](https://github.com/erlang-ls/erlang_ls).
  More mature, broader feature coverage on older codebases.

```sh
# Install elp (macOS)
brew install elp
# or grab a release binary: https://github.com/WhatsApp/erlang-language-platform/releases

# Install erlang_ls (needs Erlang/OTP + rebar3)
git clone https://github.com/erlang-ls/erlang_ls
cd erlang_ls && make && cp _build/default/bin/erlang_ls ~/.local/bin/
```

### Combining both

For an Erlang/Elixir session you typically want both:

```sh
NVIM_PROFILES=core,beam NVIM_ERLANG_LSP=elp nvim
```

## Remote / SSH usage

When `SSH_TTY` is set the config automatically reduces rendering and I/O
overhead:

- `relativenumber` and `cursorline` are disabled (fewer redraws over the wire)
- `todo-comments` is disabled (no file scanning on open)
- `checktime` only fires on `FocusGained`, not on every buffer switch