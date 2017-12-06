%title:
%author: @pietvanzoen

-> ┏━┓┏━╸┏━╸╻┏    ┏━┓┏┓╻╺┳┓   ╻ ╻┏━┓╻ ╻   ┏━┓╻ ╻┏━╸╻  ╻     ┏━╸╻┏┓╻╺┳┓
-> ┗━┓┣╸ ┣╸ ┣┻┓   ┣━┫┃┗┫ ┃┃   ┗┳┛┃ ┃┃ ┃   ┗━┓┣━┫┣╸ ┃  ┃     ┣╸ ┃┃┗┫ ┃┃
-> ┗━┛┗━╸┗━╸╹ ╹   ╹ ╹╹ ╹╺┻┛    ╹ ┗━┛┗━┛   ┗━┛╹ ╹┗━╸┗━╸┗━╸   ╹  ╹╹ ╹╺┻┛
-> Tips and tricks to increase your command line fu.

-> ᕕ( ᐛ )ᕗ


---

-> A little (semi-ancient) history
===

^
* Morse code, and *teletype*, and the Datapoint 3300, oh my! ✇__✇
^
* Bell labs, *Unix*, and communal computing. 🔔
^

> What we wanted to preserve was not just a good environment
> in which to do programming, but a system around which a fellowship
> could form. We knew from experience that the essence of communal
> computing, [...] is not just to type programs into a terminal
> instead of a  keypunch, but to encourage close communication.
~ 1969, Dennis Ritchie

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
  * Process management
  * System level control
  * Downloading files
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
... well, almost any.

---

... That's a bit bruTL DeaR, got something simpler?

^
-> *tldr* command

^
Install
```
brew install tldr
```

Example
```
|  $ tldr tar
|
|  ls
|
|  List directory contents.
|
|  - List files one per line:
|     ls -1
|
|  - List all files, including hidden files:
|     ls -a
|
|  - Long format list (permissions, ownership, size and modification date) of all files:
|     ls -la
```

* website resources?

---

# The Basics
* aliases
  * Using aliases to set defaults
* bash_profile
  * sourcing other files
* writing a script
  * shebang (why is it called that?)
  * chmod +x
  * home `bin` directory

---

# Piping
* small programs that do one thing well, combined do a lot

---

# Tips
* setup your terminal
  * quick command for access to terminal
* Setup editor command
* dotfiles
* with great power comes great responsibility

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

## debug
    * time - show how long it takes to run a command
    * strace -

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
