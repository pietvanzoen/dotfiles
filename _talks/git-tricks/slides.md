%title:
%author: @pietvanzoen

-> ┏━╸╻╺┳╸   ╺┳╸┏━┓╻┏━╸╻┏ ┏━┓
-> ┃╺┓┃ ┃     ┃ ┣┳┛┃┃  ┣┻┓┗━┓
-> ┗━┛╹ ╹     ╹ ╹┗╸╹┗━╸╹ ╹┗━┛
-> Tips and tricks to increase your git fu.

-> ᕕ( ᐛ )ᕗ

---

-> What we'll cover
===

^
* back to the future
^
* may the force push be with you
^
* alias pindakaas
^
* configuring git

---

-> Back to the future
===

## Turns out history can be rewritten

^
* `git reset`
^
* `git rebase --interactive`
^
* DANGER 🙅 `git reset --hard`

---

-> May the force push be with you
===

^
-> Don't do this `git push --force`.
^

-> ## DO THIS
-> 🙌 `git push --force-with-lease` 🙌


---

-> Alias pindakaas
===

^
## Nice singleline logging with graph
`l = "log --graph --oneline --topo-order"`

^
## Show the "trunk" branch of a repo.
Set the trunk branch using `git config local.trunk develop`
`trunk = "!git config --get local.trunk || echo master"`

^
## Log the commits on this branch only (vs trunk branch)
`lb = "!git l origin/$(git trunk)..$(git symbolic-ref --short HEAD)"`

^
## Log recent commits (last 12)
`r = "l -12"`

^
## Show more verbose branch list
`b = "branch -vvv"`

^
## Show only files in status
`st = "status -s"`

^
## Shows diff in commit message editor
`ci = "commit --verbose"`

^
## Reset to the last commit (keeping changes)
`roll-back-one = "reset HEAD~1"`

^
## Shortcut for checkout
`co = checkout`

^
## Shortcut for diff
`di = diff`

^
## Diff staged changes
`dc = diff --cached`

^
## Amend last commit
`amend = commit --amend`

^
## Force push with lease
`pushf = push --force-with-lease`

^
## git add --all shortcut
`aa = add --all`


---

-> Configuring git
===

_I couldn't think of a snappy title_


^
## After misspelling git command, use closest match after 2s.
```
[help]
  autocorrect = 20
```

^

## Setup a global ignores file
```
[core]
  excludesfile = ~/.gitignore_global
```

^
## Use a nicer diff highlighter

```
pager = diff-highlight | less -F -X
```

---

-> ┏━╸╻┏┓╻
-> ┣╸ ┃┃┗┫
-> ╹  ╹╹ ╹

---
