%title:
%author: @pietvanzoen

-> ┏━┓┏━╸┏━╸╻┏    ┏━┓┏┓╻╺┳┓   ╻ ╻┏━┓╻ ╻   ┏━┓╻ ╻┏━╸╻  ╻     ┏━╸╻┏┓╻╺┳┓
-> ┗━┓┣╸ ┣╸ ┣┻┓   ┣━┫┃┗┫ ┃┃   ┗┳┛┃ ┃┃ ┃   ┗━┓┣━┫┣╸ ┃  ┃     ┣╸ ┃┃┗┫ ┃┃
-> ┗━┛┗━╸┗━╸╹ ╹   ╹ ╹╹ ╹╺┻┛    ╹ ┗━┛┗━┛   ┗━┛╹ ╹┗━╸┗━╸┗━╸   ╹  ╹╹ ╹╺┻┛
-> Tips and tricks to increase your command line fu.

-> ᕕ( ᐛ )ᕗ

---

-> What we'll cover
===

^
* a little history
^
* why?
^
* how to learn
^
* general tips

---

-> Not covered :(
===

* shell scripting
* vim
* git

---

-> A little (semi-ancient) history
===

^
* Morse code, and *teletype*, and the Datapoint 3300, oh my! ✇__✇
^
* Bell labs, *Unix*, and communal computing. 🔔
^
* The kernel, the *shell*, and the utilities. 🐚
^
* The *terminal*. 📺 ⌨️

---

-> Be unix with me, do I really need to know this?
===

^
* MOAR CONTROL. One interface to rule them all. 💍
^
  * File management
  * Text processing
  > * Process management
  > * System level control
  > * Downloading files
  * Automation of all of the above
  * and much much more.
^
* Becuase NPM
  * Super useful with `npm run/yarn run` scripts.
  * A small shell script > npm install <something-shell-already-does>
^
* It's fun!
  * A piece of history.
  * Magical 🔮

<!--
* speed of tasks
  * list of tasks
* the assumption is that you know what you're doing
* if the task can be accomplished in shell
-->

---

-> With great power comes great responsibility
===

^
* The assumption is that you know what you're doing
^
* e.g. `rm -rf /` (do not try this at home)

---

-> How do you learn, man?
===

^
-> *man* command

> man - format and display the on-line manual pages

```
man <any command>
```

^
* `man man`

^
*another tip*
  * bash builtins https://www.gnu.org/software/bash/manual/bash.html

---

-> Navigation `man` using `less`
---

* arrow keys, j, k
* `/` to search
* G or g to navigate to the top/bottom

^
*tip*
   MANPAGER="less -FXi"


<!--
* how to navigate man pages
  * modify less
-->

---

... That's a bit bruTL DeaR, got something simpler?

^
-> *tldr* command

^
Install
```
brew install tldr
```
^
Example...

---

# Aliases & Functions
^
* aliases
  ^
  * `alias` to list all aliases
  ^
  * setting default options

```
alias ls="ls --color=auto --group-directories-first --ignore='.DS_Store'"
```

^
* functions
  * aliases that take an argument
^
But where do you put these?...

---

# Bash profile

^
`.bash_profile`

^
```
| # ls aliases
| alias ll='ls -alF'
| alias la='ls -A'
| alias l='ls -CF'
|
| mktouch() {
|   if [ $# -lt 1 ]; then
|     echo "Missing argument";
|     return 1;
|   fi
|
|   for f in "$@"; do
|     mkdir -p -- "$(dirname -- "$f")"
|     touch -- "$f"
|   done
| }
```

---

-> Piping
===

Pass text from one command to the next.

```
ls | grep '^_' | xargs -I {} mv {} __{}
```

---

-> Exit codes
===

^
* 0 success
^
* non-0 failure
^
* how do you evaluate the last exit code?
  ^
  * `echo $?`
^
* logical operators
  * &&
  * ||

---

# Tips

^
* setup your terminal
  * quick command for access to terminal

^
* Setup editor command: `subl`, `code`
^
* dotfiles

---

-> ┏━╸╻┏┓╻
-> ┣╸ ┃┃┗┫
-> ╹  ╹╹ ╹

---

# Quick fire list of commands to learn

---

## learn you some command line
    * man - docs for commands
    * tldr - tldr docs for commands

---

## filesystem
    * ls - list files in a directory
    * find - quickly find files across a file system
    * chmod - modify the ownership/interface of a file
    * df - disk usage
    * rm - remove a file
    * cd - change directory
    * cp - copy a file
    * mv - move a file
    * mkdir - make a directory
    * rmdir - remove a directory
    * cat - concatenate files and output the result (99% used with one file)
    * pwd - print the current working directory path
    * filename wildcard

---

## job management
    * jobs - show list of running jobs
    * ctrl-z - suspend a process
    * fg - put the most recently suspended job in the foreground
    * bg - background the most recently suspended job
    * %[0-9] - forground the specific job
    * & - run a command in the back ground

---

## strings
    * sed - edit a stream. use substitute regex to manipulate text
    * cut - cut up lines of text and get a specific field
    * “$()” - run a command and return the string
    * tr - find and replace characters
    * sort - sort lines of text
    * uniq - make lines of text uniq (must be sorted)
    * grep - filter strings in text
    * head - return the first few lines of a chunk of text
    * tail - return the last few lines of a chunk of text
    * column - print text in a nice column format
    * echo - print some text with a line break

---

## network
    * ping - ping a server
    * ssh - securely access the shell of a remote server
    * curl - Client for URLs, download files
    * wget - nicer curl

---

## system
    * top - process overview
    * htop - fancy process overview
    * ps - list running processes
    * kill - kill a process

---

## other
    * time - show how long it takes to run a command
    * sudo - run a command as the super user (Super User DO)
    * date - get the current date
    * clear - clear your terminal window
    * while/read - looping over text
    * watch - repeat a command
    * jq - parse json

---

## fun
    * yes - just say y alot, or something else
    * telnet towel.blinkenlights.nl

---

<!--

---

# Exit codes
* exit statuses
  * 0 success
  * non-0 failure
  * how to evaluate `echo $?`
  * logical operators
    * &&
    * ||
^
* expansion/word splitting
  * wildcard expansion
^
* variables
  * scope
  * construction

> Profile vs RC
  > profile gets loaded once (login shell)
    > ENV variables
  > RC loaded for each new shell
    > aliases

> * writing a script
>   * shebang (why is it called that?)
>   * chmod +x
>   * home `bin` directory

---

# Piping
* small programs that do one thing well, combined do a lot
* exit status
  * by default get the exit status of the last command run

---
--->
