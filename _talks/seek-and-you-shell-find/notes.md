# Command line talk

## Description
Getting to know the shell can be intimidating. In this talk I'll give you some tips on the basics of the unix shell and how to increase your knowledge.

## Overview

### A little history
* How did it start? tty machines
  * morse code, teletype, Datapoint 3300
* how did modern shell come about?
  * Unix
  * Kernel, shell, utilities
  * terminal

### Why bother learning it now?
* MOAR CONTROL. One interface to rule them all. 💍
  * File management
  * Text processing
  > * Process management
  > * System level control
  > * Downloading files
  * Automation of all of the above
  * and much much more.
* Becuase NPM
  * Super useful with `npm run/yarn run` scripts.
  * A small shell script > npm install <something-shell-already-does>
* It's fun!
  * A piece of history.
  * Magical 🔮

<!--
* speed of tasks
  * list of tasks
* the assumption is that you know what you're doing
* if the task can be accomplished in shell
-->


### How to learn
* man command
  * how to use man?
    * -k search
  * less
    * / search
    * leave content behind `MANPAGER="less -XFis"`
  * man sections
    * 1 commandline
    * 5 format
  * bash builtins https://www.gnu.org/software/bash/manual/bash.html
* tldr command

### The Basics
* aliases & functions
  * Using aliases to set defaults
  * `alias` to list all aliases
  * backslash command
* .bash_profile/.bashrc/.profile
  * sourcing other files
  * sourcing vs executing
* exit statuses
  * 0 success
  * non-0 failure
  * how to evaluate `echo $?`
  * logical operators
    * &&
    * ||
* expansion/word splitting
  * wildcard expansion
* variables
  * scope
  * construction

> * writing a script
>   * shebang (why is it called that?)
>   * chmod +x
>   * home `bin` directory

# Piping
* small programs that do one thing well, combined do a lot
* exit status
  * by default get the exit status of the last command run

### Tips
* setup your terminal
  * quick command for access to terminal
* Setup editor command
* dotfiles

### Quick fire list of commands to learn
* learn you some command line
    * man - docs for commands
    * tldr - tldr docs for commands
* filesystem
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
* job management
    * jobs - show list of running jobs
    * ctrl-z - suspend a process
    * fg - put the most recently suspended job in the foreground
    * bg - background the most recently suspended job
    * %[0-9] - forground the specific job
    * & - run a command in the back ground
* strings
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
* debug
    * time - show how long it takes to run a command
    * strace -
* network
    * ping - ping a server
    * ssh - securely access the shell of a remote server
    * curl - Client for URLs, download files
    * wget - nicer curl
* system
    * top - process overview
    * htop - fancy process overview
    * ps - list running processes
    * kill - kill a process
* other
    * sudo - run a command as the super user (Super User DO)
    * date - get the current date
    * clear - clear your terminal window
    * while/read - looping over text
    * watch - repeat a command
* fun
    * yes - just say y alot, or something else
    * telnet towel.blinkenlights.nl


-------------------

## Ideas

Unix vs osx vs windows

GNU vs BSD

Commands:
* learn you some command line
    * man
    * tldr
* filesystem
    * ls
    * find
    * locate
    * chmod
    * df
    * rm
    * cd
    * cp
    * mv
    * mkdir
    * rmdir
    * cat
    * pwd
* pipeline
    * |
    * >
    * >>
    * test
    * &&
    * ||
    * stdin vs stout vs sterr
* jobs
    * fg
    * bg
    * %
    * &
* strings
    * sed
    * cut
    * “$()”
    * tr
    * sort
    * uniq
    * grep
    * head
    * tail
    * column
    * echo
* debug
    * time
    * debug
* network
    * ping
    * ssh
    * curl
* system
    * htop
    * top
    * ps
    * kill
* other
    * sudo
    * date
    * clear
    * while/read
    * watch
    * jq
* fun
    * yes
    * at
    * telnet towel.blinkenlights.nl

Not covered
* tmux & screen
* vim 🙌
* git
* awk


## Resources:
- https://www.commandlinefu.com/commands/browse/sort-by-votes
