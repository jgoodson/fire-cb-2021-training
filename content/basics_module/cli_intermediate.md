---
title: Intermediate CLI Usage
date: "2021-01-28"
---

## More-advanced command-line usage

Previously I promised you that there were some big advantages to command-line tools that leads to people actively using them decades after they were made when there are attractive, graphical alternatives. So far, we haven't really seen anything that can't be trivially done with tools you are more familiar with. That will change now. Like before, you may choose to follow this section here, [in DataCamp](https://campus.datacamp.com/courses/introduction-to-shell/combining-tools?ex=1), or both. I strongly recommend doing the DataCamps.

<iframe src="https://umd.hosted.panopto.com/Panopto/Pages/Embed.aspx?id=b5f627f3-2ba3-40ee-a40c-acc2012acf5f&autoplay=false&offerviewer=true&showtitle=true&showbrand=false&start=0&interactivity=all" height="405" width="720" style="border: 1px solid #464646;" allowfullscreen allow="autoplay"></iframe>

[Watch the video "Intermediate Input/Output"](https://umd.hosted.panopto.com/Panopto/Pages/Viewer.aspx?id=b5f627f3-2ba3-40ee-a40c-acc2012acf5f)

### Command input and output

So far we have used commands in a way that only takes input from files and prints output to the screen. You may have heard me use the term **standard output**. At the core of Unix-style tools is a very structured system for managing input and output data. This system allows for us to use and combine tools in amazingly powerful ways. 

When we run the commands we have run, like `cat`, `head`, or `grep`, they have printed their output to your screen. This is not an integral part of those commands. Under the hood, these programs are sending their output to a specific place called **standard output**. Think of this like an output nozzle on a machine. By default, that nozzle is hooked up to your screen, but using some command line tools you can **redirect** that output to other places. The simplest way to redirect that output is with the greater-than sign or right angle-bracket `>` **redirection operator**. If you construct a command that outputs data, then insert a `>` symbol followed by a filename, the output of that command will be *saved to that file* instead of printed to the screen.

Try the following commands:

```bash
$ head -n 7 /shared/module1/people/firecb.csv
$ head -n 7 /shared/module1/people/firecb.csv > non-students.csv
```

You should find that the first command, which we learned last section, prints the first seven lines, containing the names of the Research Educator and Peer Mentors for our stream. The second command doesn't output anything to the screen!

<details>
 <summary><i>Check whether you've created a new file and what the contents are.</i> </summary>
 
You can check for the new file in the current folder (where we created it by using just a relative path name) with `ls`. You can use the `cat` command to output its contents:

```bash
$ cat non-students.csv
```

</details>

We can use this **redirection** method as a simple way to combine two commands. If we wanted to get a list of only the Peer Mentors in our stream, we could take the output from our first command in `non-students.csv` and use `tail` to extract only the last five lines:

```bash
$ tail -n 5 non-students.csv > peer-mentors.csv
```

### Combining commands more elegantly

Simply saving output and using it as the input for another command does work well, but can result in many temporary files and needs multiple commands. One of the most powerful features available with Unix tools is another method of redirecting command output: a **pipe** `|`. 

A pipe lets you directly connect the output of one command to the input of another command. This also introduces a new concept that we haven't yet mentioned. We've talked about **standard output**, but there is also a **standard input**. Unix commands not only have an output nozzle, they all have an *input nozzle* as well. We have been feeding our commands input information by giving them a file path as an argument, but almost all of the commands (except `nano` and `less`) that we have worked with will happily accept input as a **pipe** using their **standard input**. 

We can combine `head` and `tail` to directly output the middle of a file in one command:

```bash
$ head -n 7 /shared/module1/people/firecb.csv | tail -n 5
```

In this case we provide `head` with the file path as an argument, but hook the output of `head` directly up to the input of our `tail` command with a **pipe** `|`. Since `tail` is getting its input from the pipe, we don't need to give it a filename. This should output only those five lines containing Peer Mentors!

<details>
 <summary><i>How would you connect `cut` and `head`/`tail` to see only the first names of the PMs?</i> </summary>
 
You could insert the `cut` command anywhere in the chain of commands. For instance, any of the following commands would be equivalent:

```bash
$ cut -f 1 -d , /shared/module1/people/firecb.csv | head -n 7 | tail -n 5
$ head -n 7 /shared/module1/people/firecb.csv | tail -n 5 | cut -f 1 -d ,
$ head -n 7 /shared/module1/people/firecb.csv | cut -f 1 -d , | tail -n 5
```

</details>

You can chain together as many commands as you want, as long as they each provide output on **standard output** and take input from **standard input**! This can lead to some incredibly powerful commands that combine multiple steps simultaneously without any temporary files. This can be very important when our files can be gigabytes in size.

There are even more advanced uses of redirection and piping that we won't discuss here. If you are interested, I'd be happy to talk about it more. You can also find good explanatory pages [here](https://developer.ibm.com/technologies/linux/tutorials/l-lpic1-103-4/), [here](https://thoughtbot.com/blog/input-output-redirection-in-the-shell), or [here](https://catonmat.net/bash-one-liners-explained-part-three), as well as many other places!

** *An important note **
* Once you start combining commands and using more complicated tools, you can occasionally get stuck with a command that hasn't crashed, but is expecting input it will never get. If you run a command and don't get presented with a new prompt ending with* `$ ` *afterward, you may have reached this kind of deadlock. To interrupt a running command, you can hit `^C` or Ctrl-c to stop the command. If this fails to stop the command and give you a new prompt, something more serious may be wrong. Since we are working remotely, you can simply close your SSH window and open a new one


### Wildcards and more

Most common commands accept more than one file at a time, as we have seen. While you can specify one after another in a list, there is a more powerful way to select multiple files at one: **wildcards**. Wildcards are special symbols that the shell will interpret as meaning more than one option. The most common wildcard character is the asterisk `*`. In most shells, the asterisk represents "one or more characters", not including `/` or directory separators. This allows you to quickly perform the same task on many, many files at once, something often difficult, but not impossible, to do with traditional GUI software.

When we previously printed the contents of multiple files with `cat /shared/module1/people/jgoodson.txt /shared/module1/people/mmodak.txt`, we had to specify both files. If instead we wanted to print out the contents of *all of the files* in that folder, even if there were dozens, we could simply run:

```bash
$ cat /shared/module1/people/*
```

The asterisk here means that the command will be given arguments matching all files of any name in the folder. If we wanted to limit it to only filenames ending in `.txt`, we could do the following:

```bash
$ cat /shared/module1/people/*.txt
```

<details>
 <summary><i>How could you print only the first line of each of the two txt files?</i> </summary>
 
```bash
$ head -n 1 /shared/module1/people*.txt
```

</details>

Other common wildcard characters include 

- `?` matches a single character, so `202?.txt` will match `2020.txt` or `2020.txt`, but not `2021-01.txt`.
- `[...]` matches any one of the characters inside the square brackets, so `202[01].txt` matches `2020.txt` or `2021.txt`, but not `2022.txt`.
- `{...}` matches any of the comma-separated patterns inside the curly brackets, so `{*.txt, *.csv}` matches any file whose name ends with `.txt` or `.csv`, but not files whose names end with `.pdf`.

### Downloading files

While you can upload files using Cyberduck or other SFTP programs, sometimes you may want to download large files to a remote server that you don't have the space on your local computer for. Other times, you may be on slow Wi-Fi, and uploading would take forever. Our compute server has extremely fast internet, so being able to directly download files to the server will frequently be useful. There are two commands frequently used for downloading files on the command-line: `curl` and `wget`. We will primarily use `wget`, although you should be aware of `curl` in case you come across it.

`wget` has many options, but its simplest usage is when you just provide `wget` with a URL link to the file you want to download. `wget` will download the file and save it to the current directory, with its original file name. 

```bash
$ wget https://github.com/jgoodson/tape/archive/master.zip
```

Other useful options for `wget` include:

- `-P` allows you to download a file to a specific folder: `wget -P output_folder [URL]`
- `-O` allows you to specify a particular file name to save the file to: `wget -O new_filename.zip [URL]`.
- `-O` can also be used with a very special filename, `-`, to output the contents of the downloaded file to **standard output**: `wget -O - [URL] | head` will download the file and print the first ten lines without actually saving the file!