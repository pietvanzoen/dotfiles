# Command line talk

## Description
Getting to know the shell can be intimidating. In this talk I'll give you some tips on the basics of the unix shell and how to increase your knowledge.

## Overview

### A little history
* How did it start? tty machines
* how did modern shell come about?

### Why bother learning it now?
* ?

### How to learn
* man command
* tldr command
* website resources?

### The Basics
* aliases
  * Using aliases to set defaults
* bash_profile
  * sourcing other files
* writing a script
  * shebang (why is it called that?)
  * chmod +x
  * home `bin` directory

### Piping
* small programs that do one thing well, combined do a lot

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
