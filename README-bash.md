# git shortcuts for bash

This is a **bash port** of the [zsh plugin](./git.plugin.zsh), for distros whose
login shell is bash — most importantly **Omarchy** and **CachyOS/Hyprland**,
where changing the login shell is discouraged and will break the boot chain.

It sources cleanly from `~/.bashrc` and defines the same shortcuts as the zsh
version, with the few differences noted below.

## Install

The easiest way, no checkout needed:

```bash
bash <(curl -fsSL https://raw.githubusercontent.com/lautalom/git/master/install.sh) --shell bash
```

Or from a local clone:

```bash
git clone https://github.com/lautalom/git.git
cd git
./install.sh --shell bash
```

The installer appends a managed block to `~/.bashrc`:

```bash
# >>> git-plugin (lautalom/git) >>>
source "/path/to/git-plugin/git.plugin.bash"
# <<< git-plugin (lautalom/git) <<<
```

Then reload your shell with `source ~/.bashrc` (or just open a new terminal) and
try `gs`, `glo`, `gaa`, `galias`.

To remove it again:

```bash
./install.sh --shell bash --uninstall
```

## Manual install

If you prefer to do it yourself, clone the repo anywhere and add this line to the
end of `~/.bashrc`:

```bash
source ~/path/to/git/git.plugin.bash
```

## Coexistence with Omarchy's built-in aliases

Omarchy already defines a handful of git aliases in
`/usr/share/omarchy/default/bash/aliases`:

```bash
alias g='git'
alias gcm='git commit -m'
alias gcam='git commit -a -m'
alias gcad='git commit -a --amend'
```

Because `~/.bashrc` sources the Omarchy defaults **before** this plugin, the
plugin's definitions win. The one exception is `gcad`, which is not part of the
zsh plugin upstream; this port keeps it so Omarchy's bindings keep working.

## Differences from the zsh plugin

The tag map is intentionally identical to the zsh version. Two small deltas:

- **`gstshl`** maps to `git diff stash@{0}`. Upstream uses `git stash show -l`,
  but `git stash show` has no `-l` flag, so the upstream alias errors out. The
  two are documented as equivalent in the zsh comments above the alias.
- **`galias`** reads `README.md` from `$GIT_PLUGIN_DIR` when set, otherwise from
  the directory containing `git.plugin.bash`. The zsh version hard-codes the
  oh-my-zsh path `~/.oh-my-zsh/custom/plugins/git/README.md`, which does not
  exist on a bash setup.

## Cheatsheet

The full alias table lives in the main [README](./README.md#aliases-cheatsheet).
Run `galias` in your shell for the same list, or `alias` to see every definition.
