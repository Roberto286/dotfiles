# Dotfiles (bare Git repository)

Questo repository contiene i miei **dotfiles** gestiti tramite **Git bare repository**.
L’obiettivo è poter replicare la stessa configurazione (shell, editor, tool) su più macchine in modo semplice e riproducibile.

## Reference

La struttura e l’approccio usati in questo repository seguono questa guida (che considero la fonte di riferimento):

https://github.com/raven2cz/geek-room/blob/main/git-bare-repo/git-bare-repo.md

---

## How it works (in breve)

- Il repository è un **bare repo**
- I file vengono versionati direttamente nel `$HOME`
- Un alias (es. `dotfiles`) viene usato al posto di `git`
- Le configurazioni (es. `fish`, `neovim`, ecc.) sono caricate automaticamente dai rispettivi programmi

Se un file è versionato qui, **non va ricreato manualmente** su una nuova macchina.

---

## How to install (nuova macchina)

```bash
sh -c "$(curl -fsSL https://raw.githubusercontent.com/Roberto286/dotfiles/master/bootstrap.sh)"
```

Lo script (idempotente, rilanciabile):

- installa Homebrew (macOS) e i tool mancanti (`git`, `fish`, `neovim`, `ripgrep`, `fd`, `fzf`, `lazygit`, `tmux`, `mise`, `lazydocker` solo su macOS)
- clona il bare repo in `~/.dotfiles` e fa checkout del branch `mac` (macOS) o `arch` (Linux); override con `DOTFILES_BRANCH=<nome>`
- sposta in `~/.dotfiles-backup` i file già presenti che andrebbero in conflitto
- installa plugin fish (fisher), tpm e i tool di mise (`~/.config/mise/config.toml`: node, bun, python, go, rust)
- imposta fish come shell di default

> Usa `sh -c "$(curl …)"`, non `curl … | sh`: con la pipe `fisher` legge lo stdin e si mangia il resto dello script.
