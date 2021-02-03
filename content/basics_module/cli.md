---
title: Using the Command Line
date: "2021-01-28"
---

## Using the Command Line

You have all extensively used computers in your life, whether that is a traditional desktop/laptop or just a smart phone. But so far, you've likely only interacted with computer programs through **graphical user interfaces.** For example, you would use an email client program through a **graphical user interface,** and select various options and buttons depending on what you wanted to do. 

![Example GUI](/images/GUI%20example.jpeg)

During a single run of the email program, you could, for example, both add a new contact and then edit their name. This is because these programs have **state**: you do something and the program keeps that information in memory.   We will largely be working with **command-line programs** which operate on a drastically different paradigm.

Command-line programs generally do *one thing per execution*, and you tell the program what to do by *typing in the command-line* instead of pressing buttons in a program-specific graphical interface.  **This is both less convenient but potentially much more powerful.** 
### Anatomy of a Command

To run a command-line program, you need one or more things:

- **An executable program or command to run.** Our example here will be `ls`, a command that lists files. By default, running `ls` lists the files in the current directory. You can find the manual for `ls` by running the command `man ls` or on a variety of websites: [https://man7.org/linux/man-pages/man1/ls.1.html](https://man7.org/linux/man-pages/man1/ls.1.html)
- **Arguments** - these are a set of "strings", basically textual words (though they need not be actual words!) that provide information to modify how the program runs. These can come in different flavors:
  - **Options** are a type of argument, usually beginning with a dash, that modify how the command runs. These options are predefined in the code of each program, and a list and explanation of each can be found in the manual. Options can be **short**, starting with a single dash and consisting of a single letter, or **long**, two dashes followed by one or more words (without spaces). For `ls`, the option `-l` tells the command to provide a longer, more detailed, **l**ist format. This command invocation  might be called by running `ls -l`. 
  - **Parameters** are another type of argument that provides *information* to the command. Unlike options, these strings can be many possible values. There are two types of parameters:
    - *Positional parameters* that provide information directly to the command. For `ls`, positional parameters tell the command which folder to list files for, instead of the current folder. The command `ls my_folder` lists the files in a folder called "my_folder", not the files in the current directory.
    - *Option parameters* provide information that modify an **option**. Some options have either optional or required parameters that can be provided. Our example, `ls`, for instance, has an option to color the filenames. This option is `--color`. This option optionally takes a parameter to specify when output should be colored, and can be "always", "auto", or "never". For `ls`, this option parameter is given by adding an equal symbol and then the parameter: `ls --color=always`. **Not all programs work exactly the same way, for some, the parameter is given by putting a space between the option and the parameter.** You can find out how to specify these parameters from instructions or the command manual.


These different arguments are often combined in a variety of ways. **Options replace extensive and complicated menu systems in graphical programs, while parameters take the place of things like text boxes and tick boxes.** 

![Example CLI](/images/CLI%20example.png)

We will be practicing using a variety of commands very soon.


### Common Notation

Both in our following training modules as well as other documentation and helpful sites on the internet, there are certain conventions regarding describing how commands work. We will use the manual page for `ls` as an example here: [https://man7.org/linux/man-pages/man1/ls.1.html](https://man7.org/linux/man-pages/man1/ls.1.html) 

The synopsis of a command might look like this: 

```
ls [OPTION]... [FILE]...
```
NOTE: **square brackets indicate something you need to replace**. Literal square brackets have an advanced particular function in shell commands that we may or may not get to, you don't want them in your command for now!

Let's look at each part of the command:
- `ls` This is the **command**.
- `[OPTION]` You would substitute whichever **options** you wish to use for this.
- `...` This is an ellipsis, and it means that you can specify multiple options sequentially, for instance: `ls -l -a`
- `[FILE]` You may substitute in one or more filepaths at this position. These are **positional parameters.**
The *order* of these elements is frequently important. **Many programs require that options be specified before the positional parameters.**



### Documentation

**Any command we use in this stream will likely have good documentation available somewhere.** If these are built-in or common commands, which we will learn about in the next part of this module, you can get the manual inside of the shell by using the man or "manual" command followed by the command name (as a parameter!). You can also find (as I usually do) these manuals on the internet just by googling the name of the command followed by "manual". Although your RE and PRMs are available to help, I can recommend learning to read command "man pages" as well as web searching the command and finding often-helpful pages on [Stack Overflow](https://stackoverflow.com/).
