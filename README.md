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
  custom/           -- options, keymaps, autocmds
```

Most language servers (`lua_ls`, `lexical`) are installed and started
automatically through Mason — no action needed. Erlang is the exception:
its server is **chosen by an environment variable** and the binary must be
installed yourself.

## Erlang LSP

Neovim 0.12 auto-loads every file under `lsp/` as a server config. Which
one actually starts is decided at startup by `lua/lsp.lua` based on the
`NVIM_ERLANG_LSP` environment variable.

| `NVIM_ERLANG_LSP` | Server started | Required binary on `PATH` |
| ----------------- | -------------- | ------------------------- |
| `elp`             | erlang-language-platform | `elp` |
| `erlangls`        | erlang_ls      | `erlang_ls` |
| unset / other     | none           | — |

If the variable names a server but its binary is missing from `PATH`,
Neovim starts normally and prints a warning instead of attaching.

### Choosing a server

- **`elp`** — Meta's [erlang-language-platform](https://github.com/WhatsApp/erlang-language-platform).
  Faster, better diagnostics/hover; preferred for rebar3 projects.
- **`erlangls`** — [erlang_ls](https://github.com/erlang-ls/erlang_ls).
  More mature, broader feature coverage on older codebases.

### Installing the binary

**elp** — download a release binary and put it on your `PATH`:

```sh
# macOS (Homebrew tap) or grab from GitHub releases
brew install elp            # if available, otherwise:
# https://github.com/WhatsApp/erlang-language-platform/releases
```

**erlang_ls** — build from source (needs Erlang/OTP + rebar3):

```sh
git clone https://github.com/erlang-ls/erlang_ls
cd erlang_ls && make && cp _build/default/bin/erlang_ls ~/.local/bin/
```

### Selecting per environment

Set the variable wherever you launch Neovim. Examples:

```sh
# one-off
NVIM_ERLANG_LSP=elp nvim

# per machine / shell profile (~/.zshrc, ~/.bashrc)
export NVIM_ERLANG_LSP=erlangls

# per project, via direnv (.envrc)
export NVIM_ERLANG_LSP=elp
```

Leaving it unset disables the Erlang LSP entirely — useful on machines
where neither binary is installed.

### Project root detection

Both servers attach when one of these markers is found walking up from the
file: `rebar.config`, `.git`, plus `erlang.mk` (elp) or `erlang_ls.config`
(erlang_ls). Because `.git` is included, the server will attach to any
`.erl` file inside a git repo even without a build file.

## Treesitter parsers (`NVIM_PROFILES`)

Parsers are managed by `lua/custom/autocmds.lua` using Neovim's **built-in**
`vim.treesitter.install` (0.12+) — there is no `nvim-treesitter` plugin and
no `:TSInstall`. On startup the config installs any missing parsers for the
**active profiles**, then starts Treesitter per-buffer for filetypes that
have a parser.

Which parsers are active is controlled by the `NVIM_PROFILES` environment
variable. Profiles are named bundles of parsers:

| Profile   | Parsers |
| --------- | ------- |
| `core`    | bash, lua, luadoc, vim, vimdoc, markdown, markdown_inline, diff, query |
| `web`     | html, css, javascript, typescript, tsx |
| `beam`    | erlang, elixir, heex |
| `systems` | c, rust, zig, cpp |
| `infra`   | dockerfile, yaml, toml, json |

Selection rules:

- **Unset** → defaults to `core`.
- **Comma-separated list** → union of those profiles (unknown names are
  ignored). E.g. `core,beam`.
- **`all`** → every profile.

```sh
# one-off: Erlang/Elixir work this session
NVIM_PROFILES=core,beam nvim

# per machine / shell profile (~/.zshrc, ~/.bashrc)
export NVIM_PROFILES=core,web,beam

# everything
NVIM_PROFILES=all nvim
```

> Requires Neovim 0.12+ for `vim.treesitter.install`. To add a new language,
> drop its parser into the relevant profile table in
> `lua/custom/autocmds.lua`.

### Combining with the Erlang LSP

For an Erlang session you typically want both the `beam` parser profile and
an Erlang language server:

```sh
NVIM_PROFILES=core,beam NVIM_ERLANG_LSP=elp nvim
```