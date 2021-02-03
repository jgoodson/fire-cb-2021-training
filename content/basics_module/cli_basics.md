---
title: Manipulating file contents and data
date: "2021-01-28"
---

## Manipulating file contents and data

So far you have learned how to move around a filesystem and how manipulate files and folders, but done nothing with the contents of those files. Its time to change that! You may choose to complete the [DataCamp Chapter Manipulating Data](https://campus.datacamp.com/courses/introduction-to-shell/manipulating-data?ex=1) instead of or in addition to this section. I strongly recommend the DataCamps for their interactivity.

If you are using ssh to connect to our remote server: [save time connecting with ssh](https://umd.hosted.panopto.com/Panopto/Pages/Viewer.aspx?id=f9ad098e-e5b5-4884-9623-acc20122030b).

### Viewing file contents

<iframe src="https://umd.hosted.panopto.com/Panopto/Pages/Embed.aspx?id=71fb0191-d85a-4e12-b066-acc201220923&autoplay=false&offerviewer=true&showtitle=true&showbrand=false&start=0&interactivity=all" height="405" width="720" style="border: 1px solid #464646;" allowfullscreen allow="autoplay"></iframe>

[Watch the video "Working with File Contents"](https://umd.hosted.panopto.com/Panopto/Pages/Viewer.aspx?id=71fb0191-d85a-4e12-b066-acc201220923)

While there are some equivalents to "opening" a file on the command-line like you might open a text document in Notepad, TextEdit, or Word (or any other application), we will first focus on more traditional Unix tools for viewing and modifying file contents. 

The simplest way to view the contents of a file is with the `cat` command. So far most of the commands have been more-plausibly abbreviated. `cat` is short for con**cat**enate. 

- `cat` takes one or more arguments and **outputs** the contents sequentially to **standard output**. Standard output is a concept we will learn more about in the next section. On its own, this command will simply output the contents of the files to the screen.

For instance, these command will output the contents of one or more of the files in the shared folder we worked in last section:

```bash
$ cat /shared/module1/people/jgoodson.txt
$ cat /shared/module1/people/mmodak.txt
$ cat /shared/module1/people/jgoodson.txt /shared/module1/people/mmodak.txt
```

Run each command sequentially. Note how the first two commands each output the two lines of each file, while the third prints both files at once. 

At this point I'd like to point out an incredibly useful feature of this particular shell. If you begin typing a command or path, you can hit the TAB key to **autocomplete** as much of the string as possible. For instance if you type `cat /shared/mo` followed by hitting TAB, the shell should automatically insert text to make your command read `cat /shared/module1/`. This feature is convenient both for working faster as well as avoiding typos and ensuring the path you type really exists!

Some files are extremely large. Some text files we will work with in this stream can be hundreds, thousands, or even millions of lines long. Clearly we don't have any use for printing millions of lines of text to our screen! If you want to view only the first lines of a file, you can use the command `head`. Similarly, the `tail` command will output only the last lines:

- `head` accepts an argument which is the file to print out only the opening lines. By default, `head` will print the first (up to) ten lines. You can modify how many lines the command prints with a parameter `-n`. `head -n 5 [filename]` will print out the first five lines of whichever file you use for `[filename]`. A space between `-n` and the number is optional. Head can also accept more than one file path and will print out both the name of the file as well as the initial lines.
- `tail` works identically to `head`, except it is the last lines printed instead of the first.

<details>
 <summary><i>Question: How would you print out the first line of both the jgoodson.txt and mmodak.txt files?</i> </summary>
 
```bash
$ head -n1 /shared/module1/people/jgoodson.txt /shared/module1/people/mmodak.txt
```
 
</details>

There are two other ways I will show how to view files that are more similar to programs you may be used to. These are the commands `less` and `nano`. 

- `less` is a command dedicated to interactively viewing a long file piece-by-piece. Let's view the Markdown-format source code for an earlier section:

```bash
$ less /shared/module1/assignments/asn1.txt
```

Unlike many other commands we run, `less` does not immediately output data and exit, it stays open and is *interactable*. You can use up or down arrows to scroll up or down. When you are ready to exit, hit the `q` key. More information about options and keys for `less` can be found [here](https://linuxize.com/post/less-command-in-linux/).

- `nano` is a full-featured text editor you can use from inside your terminal window. You can open files by calling `nano [filename]`. If the file does not already exist, `nano` will create it when you save.

```bash
$ nano my_file.txt
```

When you open this new file, the window should be empty, with a title bar at the top saying something like `GNU Nano 4.8` and a few lines at the bottom showing a variety of options. Many of these options look something like `^X Exit`. In many cases, the `^` symbol represents the control or CTRL key on your keyboard, usually near the bottom left. In nano this lines explain the different commands that you can do by hitting CTRL followed by the key. Other keys may read `M-U Undo`. The `M` stands for "meta" and means either your Alt or Option key depending on whether you have a PC or Mac motherboard. 

You can enter text simply by typing. Unless you hit a special key combination listed at the bottom, you can simply type into the `nano` window, navigate with arrow keys, and delete characters with delete or backspace. Try writing some text into your file! When you are ready to save, hit CTRL + O for the "Write Out" option. When you do this, the bottom bar will change and ask "File Name to Write: my_file.txt". You have an option to change where the file is saved, but we are fine with that name, so go ahead and hit your enter key. The bottom bars will go back to the original commands with a message `[ Wrote 1 line ]` or similar depending on how much text you saved. When you are ready to exit, hit CTRL + X.

<details>
 <summary><i>Question: How would you verify that you saved the text that you wrote to my_file.txt?</i> </summary>
 
```bash
$ cat my_file.txt
```

This should output the text you saved in `nano`!
 
</details>


### Getting Help

Although you can always ask for help from your RE or PRMs, sometimes you might just need a reminder about exactly how the options for a command work or to see what other options are available. You can certainly consult these training modules, but they are far from comprehensive, tools in Linux are extremely flexible and powerful and have many many more options than I could ever teach you or remember myself. You can always look up a manual for a command online, but you can get the exact manual for the version installed on your computer with the `man` or **man**ual command. 

```bash
$ man cat
```

This will pull up a text page explaining how the command works and all of its options, among with other information. This uses the `less` command, so you can navigate and exit the same way you did `less`, by hitting the `q` key.

### Avoiding typing, part two

We already learned one way to cut down on typing: tab-completion. Another, perhaps even more helpful tool for avoiding typing is **history**. Our shell keeps track of all the commands we run. In fact, if you want to run the same command again, instead of typing out the whole command, simply hit the up arrow key. This will put the last command you run back on the command line. You can either run this again, or edit it to fix, or tweak what you run. If you hit the up arrow multiple times, it will iterate through your history one command at a time. Please expirment with this now!

Additionally, you can use the `history` command to output a list of all of the command you've run in your current session. This is helpful if you want to reconstruct what you've done, or simply remember a command you ran previously.

### Manipulating file contents programmatically

Many times we will work with text files structured in a specific way. Very frequently we will use files containing tabular data, think spreadsheets. The format Excel or Google Sheets use natively are not very convenient to work with as text files. The primary formats we will use are tables formatted as "csv" or "tsv" files. In these formats you have one table per file. Each line of the file is like a row in a spreadsheet, and each line is seperated by a "seperator symbol" like a comma `,` or tab character `	`. You can save or export spreadsheets from Excel or Sheets as .csv or .tsv files to use in many command line tools. 

Let's take a look at one comma-seperated values (.csv) file in our shared folder:

```bash
$ cat /shared/module1/people/firecb.csv
```

This should print a comma-separated list of names and positions, everyone in our stream when I wrote this document. This is basically the same list you can find in Canvas in the People tab. This is reasonably readable for us humans and is also extremely convenient to use with a computer. There are many commands for programmatic manipulation of file contents that let use quickly and easily change even very large, complicated files that would takes ages to do by hand. We will learn more about these later. For now, I would like to try out the `cut` command. Unless `head` or `tail` which select only certain rows of a text file, `cut` allows you to output *certain columns*. 

To run `cut`, in addition to the file name, you need to specific two things:

1. The column or *field*, or range of columns, to output. This is specified with the `-f` parameter. You may specify either one column, for instance `-f 2` to output the second column, a range of columns, for instance `-f 2-5` to print columns two through 4, or a selection of columns, for instance `-f 2,4,6` to print columns two, four, and six. You can combine ranges and single columns freely.
2. The *separator*. Different file types frequently use different character to distinguish columns. Tabs and commas are common, though spaces, colons `:`, semicolons `;`, and pipes `|` are sometimes used. You specify your separater with the `-d` or **d**elimiter parameter. To use commas, use `-d ,`. To use tabs, you need to use the "escape character" or `\` to specify an otherwise-invisible character: `-d \t`. The `\t` is a special escape character representing a tab.

Putting this together, if we want to just print the first and last name columns of our class:

```bash
$ cut -d , -f 1-2 /shared/module1/people/firecb.csv
```

<details>
 <summary><i>Question: How would you output only  the first names and positions of each person in our stream?</i> </summary>
 
```bash
$ cut -d , -f 1,3 /shared/module1/people/firecb.csv
```
 
</details>


### Searching file contents

<iframe src="https://umd.hosted.panopto.com/Panopto/Pages/Embed.aspx?id=6c52acd5-8d4a-414f-9b14-acc2012203e5&autoplay=false&offerviewer=true&showtitle=true&showbrand=false&start=0&interactivity=all" height="405" width="720" style="border: 1px solid #464646;" allowfullscreen allow="autoplay"></iframe>

[Watch the video "Using grep"](https://umd.hosted.panopto.com/Panopto/Pages/Viewer.aspx?id=6c52acd5-8d4a-414f-9b14-acc2012203e5)

The final tool we'll learn about in this section completes a missing set up the puzzle. We can create files, delete files, move them around, modify them both manually and programmatically, but how do we search through them? There are separate commands for searing for files themselves and searching through their contents. Here, we are going to focus on searching through specific files. We do this with an amazingly-powerful program called `grep`. `grep` is useful not only through the command line, tools that use the same search scheme are frequent in advanced text and code editing programs.

I'm not even going to tell you what `grep` stands for, but it was made to search through files for instances of particular **patterns**. While `grep` can simply look to find a certain string of text or "literal pattern" in a file, it uses a system called **regular expressions** that let it search for variable patterns that can be as simple or complicated as you can imagine.

You run `grep` with the following command, substituting in the text you want to search for in the filename you specify.

```bash
$ grep [pattern] [filename]
```

Try searching for your first name in the `/shared/module1/people/firecb.csv`

<details>
 <summary><i>Hint</i> </summary>
 
You need to run the command something like this
 
```bash
$ grep Jonathan /shared/module1/people/firecb.csv
```

By default `grep` is **case-sensitive**, so you need to match and upper- or lower-case letters. You can use the `-i` flag to *ignore case* and match regardless of upper- or lower-case.
 
</details>

We will discuss the more advanced features of `grep` in the next major part of the module, but there are a variety of simple options that are quite helpful:

- You can include more than one filename and `grep` will search through all of them and prefix the matches with the file they were in
- `-c` prints out a *count* of how many lines contained the pattern
- `-i` ignores case, letting you match upper-case letters with lower-case, and vice-versa
- `-l` prints only the filenames if you search more than one file
- `-n` prints the line number of the matches
- `-v` prints the **inverse** of the match - only those lines that *don't* have the pattern in them


If you had any trouble with this, please reach out to Dr. Goodson or one of your PRMs via Slack or email.
