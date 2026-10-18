# Setup (Arch)

My fork of [omega-800/summaries-se-ost](https://github.com/omega-800/summaries-se-ost).
I only add English copies of the German modules, e.g. `Dbs1/` -> `Dbs1-en/`.
The original files stay untouched so syncing with the author doesn't break anything.

- `origin` = my fork (push here)
- `upstream` = omega-800 (fetch only, push is blocked)

Everything goes through the `justfile` in the repo root. `just` lists all commands.

## 1. Install

```bash
sudo pacman -S --needed git just
```

## 2. SSH + clone

The remotes use SSH, so GitHub needs your key:

```bash
ssh-keygen -t ed25519                  # skip if ~/.ssh/id_ed25519 exists
cat ~/.ssh/id_ed25519.pub              # paste into GitHub > Settings > SSH keys
ssh -T git@github.com                  # should say "Hi <name>!"

mkdir -p ~/Projects && cd ~/Projects
git clone git@github.com:Chris-Grundling/summaries-se-ost.git
cd summaries-se-ost
```

## 3. Nix + remotes (once)

```bash
just install                           # pacman nix + zathura, nix-daemon, flakes (asks for sudo)
# log out and back in once (nix-users group)
nix --version                          # should print a version

just setup                             # origin/upstream + push block, then checks
```

`just setup` also removes the old `git save/get/sync/all` aliases if I still have them.

## 4. All commands

```bash
just                                   # list everything

# English modules
just list                              # German modules + which have -en already
just create Dbs1                       # Dbs1/ -> Dbs1-en/ (also several: just create Dbs1 DMI)
just create-all                        # all German modules
just book Dbs1                         # add Dbs1-en to book.typ (website menu, optional)
just check                             # check remotes + all -en modules
just outdated                          # German changes I haven't translated yet

# git
just get                               # pull my fork
just save "Dbs1-en: SQL part"          # add all *-en/ folders, commit, push to my fork
just sync                              # pull my fork + merge author + push
just all "Dbs1-en: SQL part"           # save + sync, does everything

# nix
just watch Dbs1-en                     # live preview of the summary (Ctrl+C stops)
just cs Dbs1-en                        # live preview of the cheatsheet
just pdf Dbs1-en                       # build doc.pdf + cs.pdf once
just apkg Dbs1-en                      # build the Anki deck
```

Notes:

- `just create` copies the folder, deletes the German pdf/apkg, sets `module`, `language: "en"`
  and the English name in `info.typ`, and runs `git add` (nix ignores files git doesn't know).
  It never overwrites an existing `-en` folder.
- `just save` only adds `*-en/` folders. Other files (`book.typ`, `justfile`) need `git add` first.
- `just sync` stops if there are uncommitted changes, run `just save` first.
- No message -> "update translations".

## 5. Translating

Nothing in `flake.nix` or `lib/` needs changing. The flake finds every folder with
`doc.typ`/`cs.typ`/`deck.typ`, and `language: "en"` switches the template to English
("Page", "Example", ...). The different module name keeps the Anki deck separate.

By hand: the text in `doc.typ` and `cs.typ`, and German math ops like `ggT`, `kgV`,
`Bild`, `Rang` (-> `gcd`, `lcm`, `im`, `rank`). `deck.typ` just includes `doc.typ`.

German modules: AlgDat, Bsys1, DMI, Dbs1, LinAlg, PmQm, RheKoI, WrStat. The rest is already English.

## 6. Same thing without just

```bash
# remotes
git remote set-url origin git@github.com:Chris-Grundling/summaries-se-ost.git
git remote add upstream git@github.com:omega-800/summaries-se-ost.git
git remote set-url --push upstream /dev/null

# push
git add Dbs1-en/ && git commit -m "Dbs1-en: SQL part" && git push origin main

# pull
git pull --rebase origin main

# sync with the author
git fetch upstream && git merge upstream/main && git push origin main

# nix
nix run .#Dbs1-en                      # / .#Dbs1-en-cs / .#Dbs1-en-apkg
nix develop                            # shell with typst, fonts etc.
```

## Don't

- `nix run .#compile-all` / `watch-all`: rebuilds the German PDFs too -> merge conflicts.
  Undo with `git restore Dbs1/*.pdf`.
- `nix flake update`: changes `flake.lock`, leave that to the author.
- `git reset --hard upstream/main`: deletes all my `-en` folders.

`nix develop` adds a pre-commit hook that formats files. If a commit stops because it
reformatted something, `git add` again and commit again.
