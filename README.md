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

### 1. Prerequisiti

Assicurati di avere installato almeno:

- `git`
- `fish`

Opzionali ma consigliati (dipendono dai dotfiles presenti):
- `neovim`
- `ripgrep`
- `fd`
- `lazygit`
- altri tool referenziati negli alias o config

> Nota: gli alias e le config funzionano **solo se i binari esistono**.

---

### 2. Clone del bare repository

```bash
git clone --bare <REPO_URL> ~/.dotfiles
```

### 3. Setup automatizzato

```bash
curl -sL https://raw.githubusercontent.com/Roberto286/dotfiles/refs/heads/master/bootstrap.sh | bash
```
