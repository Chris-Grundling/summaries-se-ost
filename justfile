# justfile for my English fork of summaries-se-ost
# `just` shows all commands. Put this file in the repo root.

set shell := ["bash", "-euo", "pipefail", "-c"]
set positional-arguments

fork := "git@github.com:Chris-Grundling/summaries-se-ost.git"
author := "git@github.com:omega-800/summaries-se-ost.git"
just := just_executable()

# show all commands
default:
    @{{ just }} --list --unsorted

# ---------- setup ----------

# arch: install nix + zathura and turn on flakes (needs sudo, once)
install:
    sudo pacman -S --needed nix zathura zathura-pdf-mupdf
    sudo systemctl enable --now nix-daemon.service
    sudo usermod -aG nix-users "$USER"
    grep -q flakes /etc/nix/nix.conf || echo 'experimental-features = nix-command flakes' | sudo tee -a /etc/nix/nix.conf
    sudo systemctl restart nix-daemon.service
    @echo "done. log out and back in once (nix-users group)"

# set origin = my fork, upstream = author (push blocked), then check
setup:
    #!/usr/bin/env bash
    set -uo pipefail
    for r in "origin {{ fork }}" "upstream {{ author }}"; do
      set -- $r
      if git remote get-url "$1" &>/dev/null; then git remote set-url "$1" "$2"; else git remote add "$1" "$2"; fi
    done
    git remote set-url --push upstream /dev/null
    # old git aliases from setup-check.sh, not needed anymore
    for a in save get sync all; do git config --local --unset "alias.$a" 2>/dev/null || true; done
    git remote -v
    {{ just }} check

# ---------- English modules ----------

# German modules and which ones have an -en copy
list:
    #!/usr/bin/env bash
    for m in $({{ just }} _german); do
      if [ -d "$m-en" ]; then echo "  ✔ $m -> $m-en/"; else echo "  · $m"; fi
    done

# copy German modules to <Module>-en/, e.g. `just create Dbs1 DMI`
create +modules:
    #!/usr/bin/env bash
    set -uo pipefail
    declare -A EN=(
      [AlgDat]="Algorithms and Data Structures"
      [Bsys1]="Operating Systems 1"
      [DMI]="Discrete Mathematics"
      [Dbs1]="Database Systems 1"
      [LinAlg]="Linear Algebra: Introduction"
      [PmQm]="Project and Quality Management"
      [RheKoI]="Rhetorical Communication for Computer Scientists"
      [WrStat]="Probability and Statistics"
    )
    err=0; done_mods=()
    for m in "$@"; do
      m=${m%/}; en="$m-en"
      if [ ! -f "$m/info.typ" ]; then echo "✘ $m/info.typ not found (case matters)"; err=1; continue; fi
      if ! grep -qE 'language: *"de"' "$m/info.typ"; then echo "✘ $m isn't German, skipping"; err=1; continue; fi
      if [ -e "$en" ]; then
        echo "· $en/ already exists, not overwriting"
      else
        cp -a "$m" "$en"
        rm -f "$en"/*.pdf "$en"/*.apkg "$en"/*.html
        echo "+ $m/ -> $en/"
      fi
      sed -i -E -e "s/(module: *\")$m(\")/\1$en\2/" -e 's/(language: *")de(")/\1en\2/' "$en/info.typ"
      de=$(sed -nE 's/.*name: *"([^"]*)".*/\1/p' "$m/info.typ")
      if [ -n "${EN[$m]:-}" ]; then
        sed -i "s|name: \"$de\"|name: \"${EN[$m]}\"|" "$en/info.typ"
      else
        echo "  ! no English name for $m, change name: in $en/info.typ"
      fi
      git add "$en"   # nix only sees files git knows about
      done_mods+=("$m")
    done
    [ ${#done_mods[@]} -gt 0 ] && { {{ just }} check "${done_mods[@]}" || err=1; }
    exit $err

# create -en copies of all German modules
create-all:
    {{ just }} create $({{ just }} _german)

# add the -en modules to book.typ (website menu), e.g. `just book Dbs1`
book +modules:
    #!/usr/bin/env bash
    set -uo pipefail
    for m in "$@"; do
      m=${m%/}; m=${m%-en}; en="$m-en"
      for k in chd:doc chs:cs; do
        kind=${k%:*}; f=${k#*:}
        [ -f "$en/$f.typ" ] || continue
        if grep -qF "#$kind(\"$en\")" book.typ; then
          echo "· #$kind(\"$en\") already in book.typ"
        elif grep -qE "^[[:space:]]*- #$kind\(\"$m\"\)[[:space:]]*$" book.typ; then
          awk -v k="$kind" -v m="$m" -v en="$en" '{ print }
            $0 ~ "^[[:space:]]*- #" k "\\(\"" m "\"\\)[[:space:]]*$" { match($0, /^[[:space:]]*/); print substr($0, 1, RLENGTH) "- #" k "(\"" en "\")" }' \
            book.typ > book.typ.tmp && mv book.typ.tmp book.typ
          echo "+ #$kind(\"$en\")"
        else
          echo "! no #$kind(\"$m\") in book.typ, add #$kind(\"$en\") by hand"
        fi
      done
    done
    git add book.typ

# check remotes + -en modules (all, or e.g. `just check Dbs1`)
check *modules:
    #!/usr/bin/env bash
    set -uo pipefail
    ok=0; bad=0
    pass() { echo "  ✔ $*"; ok=$((ok+1)); }
    fail() { echo "  ✘ $*"; bad=$((bad+1)); }
    echo "git:"
    [[ $(git remote get-url origin 2>/dev/null) == *Chris-Grundling/summaries-se-ost* ]] && pass "origin = my fork" || fail "origin is wrong, run: just setup"
    [[ $(git remote get-url upstream 2>/dev/null) == *omega-800/summaries-se-ost* ]] && pass "upstream = author" || fail "upstream is wrong, run: just setup"
    [[ $(git remote get-url --push upstream 2>/dev/null) == /dev/null ]] && pass "push to upstream blocked" || fail "upstream push not blocked, run: just setup"
    git config --local --get-regexp '^alias\.(save|get|sync|all)$' &>/dev/null && echo "  ! old git aliases still there, run: just setup"
    if [ $# -gt 0 ]; then mods=(); for m in "$@"; do m=${m%/}; mods+=("${m%-en}-en"); done
    else shopt -s nullglob; mods=(*-en); fi
    [ ${#mods[@]} -eq 0 ] && echo "  · no -en modules yet (just create Dbs1)"
    for en in "${mods[@]}"; do
      m=${en%-en}; f="$en/info.typ"
      echo "$en:"
      [ -f "$f" ] || { fail "$f missing"; continue; }
      grep -qE "module: *\"$en\"" "$f" && pass "module: \"$en\"" || fail "module isn't \"$en\" (Anki deck would clash with $m)"
      grep -qE 'language: *"en"' "$f" && pass 'language: "en"' || fail 'language isn'"'"'t "en"'
      name=$(sed -nE 's/.*name: *"([^"]*)".*/\1/p' "$f")
      [ -f "$m/info.typ" ] && [ "$name" == "$(sed -nE 's/.*name: *"([^"]*)".*/\1/p' "$m/info.typ")" ] && echo "  ! name is still German"
      [ -z "$(git ls-files --others --exclude-standard -- "$en")" ] && pass "tracked by git" || fail "untracked files, run: git add $en/"
      grep -rqE "[\"/]$m/" "$en" --include='*.typ' && echo "  ! has paths pointing to $m/: $(grep -rlE "[\"/]$m/" "$en" --include='*.typ' | tr '\n' ' ')"
      if command -v nix &>/dev/null; then
        apps=${apps:-$(nix eval --json ".#apps.$(nix eval --impure --raw --expr builtins.currentSystem)" --apply builtins.attrNames 2>/dev/null || echo none)}
        grep -qE "\"$en(-cs)?\"" <<<"$apps" && pass "nix: $(grep -oE "\"$en(-cs|-apkg)?\"" <<<"$apps" | tr -d '"' | tr '\n' ' ')" || fail "nix doesn't see $en"
      fi
    done
    command -v nix &>/dev/null || echo "  · nix not installed, skipped nix check"
    echo "$ok ok, $bad failed"
    [ $bad -eq 0 ]

# German changes not translated yet (all, or e.g. `just outdated Dbs1`)
outdated *modules:
    #!/usr/bin/env bash
    set -uo pipefail
    if [ $# -gt 0 ]; then mods=("$@"); else shopt -s nullglob; mods=(*-en); fi
    for m in "${mods[@]}"; do
      m=${m%/}; m=${m%-en}; en="$m-en"
      since=$(git log -1 --format=%h -- "$en")
      if [ -z "$since" ]; then echo "$m: $en/ not committed yet"; continue; fi
      out=$(git log --oneline "$since"..HEAD -- "$m/*.typ")
      if [ -z "$out" ]; then echo "$m: up to date"
      else echo "$m: changed since $since:"; echo "$out" | sed 's/^/  /'; echo "  diff: git diff $since HEAD -- $m/"; fi
    done

# ---------- git ----------

# pull my fork
get:
    git pull --rebase --autostash origin main

# add all -en folders, commit, push to my fork, e.g. `just save "Dbs1-en: SQL"`
save msg="update translations":
    #!/usr/bin/env bash
    set -euo pipefail
    shopt -s nullglob
    for d in *-en/; do git add -- "$d"; done
    if git diff --cached --quiet; then echo "nothing new to commit"; else git commit -m "$1"; fi
    git push origin HEAD:main

# pull my fork, merge the author's changes, push to my fork
sync:
    #!/usr/bin/env bash
    set -euo pipefail
    if [ -n "$(git status --porcelain --untracked-files=no)" ]; then echo "uncommitted changes, run: just save"; exit 1; fi
    git pull --rebase origin main
    git fetch upstream
    git merge --no-edit upstream/main
    git push origin HEAD:main
    {{ just }} outdated

# save + sync in one go
all msg="update translations":
    {{ just }} save "$1"
    {{ just }} sync

# ---------- nix ----------

# live preview of the summary, e.g. `just watch Dbs1-en` (Ctrl+C stops)
watch module:
    nix run ".#$1"

# live preview of the cheatsheet, e.g. `just cs Dbs1-en`
cs module:
    nix run ".#$1-cs"

# build doc.pdf + cs.pdf once, e.g. `just pdf Dbs1-en`
pdf module:
    #!/usr/bin/env bash
    set -euo pipefail
    for f in doc cs; do
      [ -f "$1/$f.typ" ] || continue
      echo "building $1/$f.pdf"
      nix develop --command typst compile --features html --root . "$1/$f.typ" "$1/$f.pdf"
    done

# build the Anki deck, e.g. `just apkg Dbs1-en`
apkg module:
    nix run ".#$1-apkg"

_german:
    #!/usr/bin/env bash
    for f in */info.typ; do
      d=${f%/info.typ}
      [[ $d == template || $d == *-en ]] && continue
      grep -qE 'language: *"de"' "$f" && echo "$d"
    done
    true
