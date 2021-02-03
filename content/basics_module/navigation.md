---
title: Filesystem Navigation
date: "2021-01-28"
---

Although I'm sure most of you have some idea about the concepts of "files" or "folders" when it comes to computers, working with command-line programs will probably stretch anyone's intuition about how to talk about, describe, or use files and folders unless they have previously done CLI work.

<iframe src="https://umd.hosted.panopto.com/Panopto/Pages/Embed.aspx?id=198cf321-f6f4-4f88-bc00-acc200e84ea6&autoplay=false&offerviewer=true&showtitle=true&showbrand=false&start=0&interactivity=all" height="405" width="720" style="border: 1px solid #464646;" allowfullscreen allow="autoplay"></iframe>

[Watch the video "Filesystem Basics"](https://umd.hosted.panopto.com/Panopto/Pages/Viewer.aspx?id=198cf321-f6f4-4f88-bc00-acc200e84ea6)

## Thinking about files and paths
#### Paths

CLI programs, like we will use, extensively use **paths** pointing to specific files or folders on the computer. A **file** is simply a chunk of data stored as a unit on the computer. The **filesystem** describes the software and information that organizes data on the computer into files stored in a particular way. For the most part, computers organize data files using a tree-like structure of nested **folders** or **directories**. This is where the analogy of files as pieces of paper stored in folders breaks down a little bit, as there is no limit to how "deeply nested" folders can be. You can have folders inside folders inside folders inside...

![Nested Folders][nested_folders]

[nested_folders]: /images/0NestedFolders.webp "Nested Folders"

Since we frequently need to tell a program to work with a particular file, we need a system or convention for describing where to find a particular file or folder. Since we don't have pop up windows that let us select a particular file and we work primarily with text, this will be a string of text! Think of a street address telling a postal worker how to find a particular house. This address needs to unambiguously describe the particular location as well as increasingly broader general locations.

The solution to pointing to a particular file is what are called **paths**. These are appropriately named, because they describe the path to follow from a particular reference point through nested folders to get to the intended location. You have (probably) seen paths used on computers before even if you haven't particular thought about it. If you've used Windows you've almost certainly seen strings of text starting with `c:\` or similar. This is the start of a path!

### Absolute Paths

A path like `c:\Program Files\Google\Google Chrome.exe` describes the path to take from the root of the filesystem on the "C drive" through a folder called "Program Files", into a second folder called "Google", and finally to a file called "Google Chrome.exe". This is what is known as an absolute path. Think of absolute paths as like complete addresses, even including the country! They specify exactly and unambiguously where to find a file. The address:

```
4094 Campus Dr
College Park, MD 20742
United States
```

unambigiously describes the Bio-Psych building on the UMD campus. You could give that address to anyone in the world with a map, and they should be able to find that building! On the other hand, if I was in College Park right now, talking to someone else in College Park, I might just tell them "4094 Campus Dr" and let them assume this refers to an address near our current location. They would probably have no trouble finding the Bio-Psych building.

### Relative Paths

Now imagine we don't go far, just a few miles to the other side of Washington DC near Sterling, VA. If I told someone to go to "4094 Campus Dr" and they were in Sterling, they would probably end up at Northern Virginia Community College! This is because that incomplete address will probably be interpreted relative to the location of the reader. A second, frequently used type of path works this way called **relative paths**. Relative paths are relative to the so-called **working directory**.

At any point, when we are working with the command line, I want you to think of yourself in cyberspace. You are in the computer! And you aren't just anywhere in the computer, you are in a very specific place in the computer, inside of one specific folder or directory in the tree of folders that is the filesystem. You are in a particular directory and around you are all the files or folders that are in that directory with you. Since you are in a folder there are more folders that exist further "up" in the direction of the folder that "contains" your current folder and there are more files and folders "down" "inside" the folders that are beside you. 

If you simply write the name of a file while you are in a particular folder, the computer will interpret this as a path relative to your working directory where you "are". If you make a file in your current directory, you can refer to it just by name, but if you "move" somewhere else, you'll need to be more specific to refer to that file! 

 Let's revisit that photo from earlier:

![Nested Folders][nested_folders]

If we consider that we are "in" the `Books` folder as our current working directory, there are four folders in there with us, `The Phantom Tollbooth`, `Kite Runner`, `Hamlet` and `And Still I Rise`. We can refer to the Hamlet directory simply by writing `Hamlet`. Imagine however that you are working with someone else, and they aren't in the `Books` folder. Unless they go through the effort of looking and searching through this directory tree, they won't see a `Hamlet` folder. If you weren't sure where they were, you could specify `Things I Love` - `Books` - `Hamlet` and they would have no problem!

### Actually writing paths down

Previously I mentioned c:\ as a special **path** pointing to the "root" of the C drive. This format is how Windows works, but not how anything else does! We will be using Linux, which like macOS, is based on Unix, and uses "Unix-style paths". In Unix paths, folders are separated by forward-slashes `/`. Instead of having a separate root for each drive (main drive, USB drive, network drives, etc), Unix systems have a single root directory for the entire computer, simply named `/`. For this reason, if you "start a path" with `/` you are starting at the root of the filesystem, making it an absolute path. If you start a path with (almost) anything else, it is *relative* to your current working directory. 

- Absolute paths: start with / and must trace the entire path from the root directory to the desired file or folder
- Relative paths: start with a name that is in the current working directory and must trace a path from the current directory to the desired file or folder

There are three special symbols that you will need to know about besides `/.` These are `.`, `..`, and `~`.

- A `.` (one period) is a placeholder for the current directory. It can be used at the beginning or in the middle of a path and represents basically the status-quo, it doesn't move you anywhere. There are actually relatively few places we will want to use this symbol.
- A `..` (two periods) represents the parent directory. This is how you go "upward" in the file tree. It can also be used anywhere in a path and represents the folder one step upwards from the current position in a path.
- A `~` (a tilde, at the top-left of your keyboard) represents your home directory. This is a very special character since it is the only other way to create an absolute path. If you use the tilde at the beginning of a path, instead of starting in the root folder, it starts the path in your home directory. 
  - Regardless of where you are, a path starting with `~` will always point to the same folder.
  - Warning: The `~` represents the home folder, which is different for every user on a system. If you give a path to a teammate starting with `~`, this will represent a different location for them! For this reason when working in teams we will usually use a special shared directory outside of our home directories.

If we assume that `Things I Love` is in the root directory of our hypothetical system, all of the following are true:

- If we are currently in the Books folder:
  - The path to the Kite Runner folder is simply `Kite Runner` (relative) but could be `/Things I Love/Books/Kite Runner` (absolute)
  - We could also refer to the `Kite Runner` folder as `./Kite Runner` (relative)
  - The path to the Things I Love folder could be written as `/Things I Love` (absolute) or `..` (relative)
  - The path to the Cats folder could be written as `/Things I Love/Cats` (absolute) or `../Cats` (relative)
- If we were currently in the Food folder:
  - The path to the Kite Runner folder could be `../Books/Kite Runner` (relative) or `/Things I Love/Books/Kite Runner` (absolute, notice this is the same as before, because it is absolute!)
  - The path to the Things I Love folder could be written as `/Things I Love` (absolute) or `..` (relative, Food and Books are "siblings" so they have the same parent!)
  - The path to the Cats folder could be written as `/Things I Love/Cats` (absolute) or `../Cats` (relative, Food and Books are "siblings" so they have the same parent which contains Cats)
- If we were in the Hamlet folder:
  - The path to the Kite Runner folder could be `../Kite Runner` (relative) or `/Things I Love/Books/Kite Runner` (absolute, notice this is the same as before, because it is absolute!)
  - The path to the Things I Love folder could be written as `/Things I Love` (absolute) or `../..` (relative, you need to move "up" twice!)
  - The path to the Cats folder could be written as `/Things I Love/Cats` (absolute) or `../../Cats` (relative)

You can see how both types of path might be more convenient in different circumstances. Relative paths are often shorter and easier when you are "close" to the intended target, while the further away you get the more complicated they become and the reliability and specificity of absolute paths becomes more useful!

## Navigating a Filesystem with the CLI

At this point, I recommend you complete the first Chapter of the Introduction to [Shell Datacamp Module](https://campus.datacamp.com/courses/introduction-to-shell/manipulating-files-and-directories?ex=1). You must be registered for our DataCamp class for full access to these modules. I strongly recommend the DataCamps for their interactivity. You may do this instead of or in addition to reading the information in this section. To follow along with the commands in this section you should connect to compute-1.fire.tryps.in through SSH or another app like Termius or RStudio Server as described in [Getting Connected](https://umd.instructure.com/courses/1299512/pages/getting-connected-guide).

<iframe src="https://umd.hosted.panopto.com/Panopto/Pages/Embed.aspx?id=6878ab5e-70b1-4afa-a958-acc200ec37e7&autoplay=false&offerviewer=true&showtitle=true&showbrand=false&start=0&interactivity=all" height="405" width="720" style="border: 1px solid #464646;" allowfullscreen allow="autoplay"></iframe>

[Watch the video "Initial CLI"](https://umd.hosted.panopto.com/Panopto/Pages/Viewer.aspx?id=6878ab5e-70b1-4afa-a958-acc200ec37e7)


### Entering commands and basic navigation

When you are logged into a shell, you should have a prompt. This is a line of text ending with a dollar symbol and a space $ . Many systems are configured to present more information on this prompt line for convenience. Our compute server by default shows the current user, the name of the system, and the current working directory! When you log in, you will see something like this on the last line:

```bash
jgoodson@compute-1:~$ 
```

This first tells you what use you are, in this case "jgoodson". This use is at/on/`@` a particular computer, in this case the server named "compute-1". The `:` separates this information from the **path** to the current working directory, which in this case is `~`, which you learned earlier is shorthand for your home directory.

As a convention, throughout the rest of this training and future modules, I will tell you to run certain commands. I will format them like so:

```bash
$ pwd
```

This first $ indicates that this is at a shell prompt. You should not enter the `$ ` symbol, it will cause an error! 

Go ahead and enter the `pwd` command. This stands for **p**rint **w**orking **d**irectory and will do what the name advertises, print your current position in the filesystem to the screen. In my case, it prints `/home/jgoodson`. This is my home folder and is what `~` represents for me. If at any point things aren't working like you expect, especially when providing paths to files you know exist, use `pwd` to find out if you are where you think you are.

Since we've talked so much about being in a particular place, there must be a way to move around, to change where you are. The primary command for moving around on Unix systems is `cd` or change directory. This is a simple command that usually takes a single argument, a path where we want to move to. In this case, we should run the following command to move to a prepared toy directory that will be used for the rest of this section

```bash
$ cd /shared/module1
```

<details>
 <summary><i>Question: What kind of path is this?</i> </summary><p>
 
 absolute
 
</p></details>

At this point we are no longer in your home directory, and are instead in a shared directory with some toy files. So far we are moving blind, you had to take it on faith that this folder exists. If you try to move to a folder that doesn't exist, there will be an error. I encourage you to try to move to a random folder name now with `cd` and see what happens.

To look around and see what files and folders are in a location, we use a command mentioned earlier: `ls`. Enter this command now to list the files and folders in your current directory.


<details>
 <summary><i>Question: What files or folders were listed? What folder are these contained in?</i> </summary>
 
 
`/shared/module1/`
 
</details>

You should see a few folders. `ls` is not limited to just showing you what is in your current folder, it can also accept arguments of one or more paths to list the contents of. Try running the following command:

```bash
$ ls assignments
```

<details>
 <summary><i>Question: What is the absolute path to the assignments folder you just listed the contents of? How many files are there in this folder?</i> </summary>
 
`/shared/module1/assignments/`
 
</details>

### Manipulating files

<iframe src="https://umd.hosted.panopto.com/Panopto/Pages/Embed.aspx?id=b962a720-31c4-4904-a7b5-acc201220351&autoplay=false&offerviewer=true&showtitle=true&showbrand=false&start=0&interactivity=all" height="405" width="720" style="border: 1px solid #464646;" allowfullscreen allow="autoplay"></iframe>

[Watch the video "Manipulating Files"](https://umd.hosted.panopto.com/Panopto/Pages/Viewer.aspx?id=b962a720-31c4-4904-a7b5-acc201220351)

Everything we have done so far is passive, we haven't made any permanent changes to the system. Obviously to obtain data, save results, or generally accomplish anything, we need to make some changes. The shared folder you are in now is read-only, so that we can't break anything. You should run any example code in the following code blocks. Let's move back to your home folder:

```bash
$ cd ~
```

The simplest ways of creating files or folders are two commands which create empty files or empty folders, respetively: `touch` and `mkdir`. 
 
- `touch` creates an empty file at the specified path. Think of this like putting an empty piece of paper into a folder.
- `mkdir` creates a new empty folder at the specified path.

With either touch or mkdir we need to provide a path as the argument. As always, this can be either an absolute or relative path. If you want to create a file or folder in the current directory, you simply give it the name you want!

```bash
$ mkdir module1
```

Whereas if you want to create a file inside a folder that you are not in, say, the module1 folder you just made, you provide a relative or absolute path:

```bash
$ touch module1/test_file1
$ touch ~/module1/test_file2
```

<details>
 <summary><i>Question: What command would you use to list the files you just made?</i> </summary>
 
 ```bash
 $ ls module1
 ```
 
</details>

We may also want to **copy** or **move** files around. We can do so with two commands: `cp` or `mv` respectively. (Are you getting an idea that old Unix authors were big fans of abbreviating words or phrases?)

- `cp` requires at least two arguments. The first argument (or arguments) is a path (or paths) for the "source file(s)" which is/are to be copied. The second/last argument is the "destination" which can either be a path to a filename (if copying a file) or a folder. After running `cp` there will be a copy of the file in both locations.
- `mv` works essentially the same way as `cp`, except that the file is moved and there will no longer be a copy in the original source location.

Maybe we accidentally make a file in the current directory:

```bash
$ touch test_file3
```

but we really wanted it to be in the module1 folder. We could move this file to that folder with:

```bash
$ mv test_file3 module1
```

<details>
 <summary><i>Question: What commands could you run to verify the file is now in the desired folder?</i> </summary>
 
 ```bash
 $ ls 
 $ ls module1
 ```
 
 The first command would list files in the current folder, which should not contain `test_file3`. The second lists files in `module1`, which should now contain all three test files.
 
</details>

Imagine we did want to work with one of these files in our current folder, but didn't want to disrupt our organization. We actually do want `test_file2` in the current folder. We want to move a file into a current folder. We could provide a full absolute path to our current folder, perhaps with `~`, but we can also use the `.` placeholder to use our current working directory as the destination:

```bash
$ cp module1/test_file2 ./
```

Another common file manipulation you are probably familiar with with renaming files. We do not actually need a new command for this, one of our existing commands can do this job!

<details>
 <summary><i>Question: Which of the commands we've already learned could be used to rename files?</i> </summary>
 
Using `mv` to move a file into the same folder it already is in, but with a different name, will accomplish renaming the file:

```bash
$ mv test_file2 renamed_test_file
```

</details>

<iframe src="https://umd.hosted.panopto.com/Panopto/Pages/Embed.aspx?id=b962a720-31c4-4904-a7b5-acc201220351&autoplay=false&offerviewer=true&showtitle=true&showbrand=false&start=0&interactivity=all" height="405" width="720" style="border: 1px solid #464646;" allowfullscreen allow="autoplay"></iframe>

[Watch the video "Deleting Files"](https://umd.hosted.panopto.com/Panopto/Pages/Viewer.aspx?id=b962a720-31c4-4904-a7b5-acc201220351)

Finally, once we are done working with this file (assuming you renamed it to `renamed_test_file`, we can **delete** or "remove" it using another command: `rm`:

```bash
$ rm renamed_test_file
```

Be careful using `rm`, it does not have a recycle bin feature, once a file is deleted it is *gone*. For this reason, `rm` is especially wary of deleting folders. To delete a folder *and its contents* you need to add a parameter: `-r` for **r**ecursive:

```bash
$ rm -r module1
```

<details>
 <summary><i>Question: How do you check whether you've successfully deleted the folder?</i> </summary>
 
Use `ls` in the current folder and see if there is still a `module1` folder listed.

</details>

At this point, your home directory *should* be clean of all the files we created so far. If you had any trouble with this, please reach out to Dr. Goodson or one of your PRMs via Slack or email.
