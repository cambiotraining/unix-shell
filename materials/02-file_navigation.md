---
pagetitle: "Unix course"
---

# Navigating the filesystem

::: {.callout-tip}

#### Learning Objectives

- Understand the hierarchical structure of filesystems and how the location of files and directories is specified.
- Distinguish between absolute and relative paths.
- Recognise when `/` is used to specify the root directory or to separate directories.
- Navigate the filesystem using the commands `pwd`, `ls` and `cd`.
- Make use of the `*` wildcard to match files by patterns.
- Use the `find` command to effectively search for files or directories.

:::

## The Unix filesystem

The part of the operating system responsible for managing files and directories is called the **filesystem**.
It organizes our data into **files** and **directories** (also called **folders**), which hold files or other directories.
These directories are organised in a hierarchical way, which we can represent as a tree.
Take the following image as an example:

<p align="center">
  <img src="images/filesystem_home_directories.svg" alt="Diagram of a filesystem representing three users' home folders as a tree-like diagram starting from the root `/` of the filesystem, then to a folder called `home` and finally three folders called `robin`, `wren` and `tux`." />
</p>

This is illustrating the location of the home directories for three users called "robin", "wren" and "tux" (the <a href="https://en.wikipedia.org/wiki/Tux_(mascot)" target="_blank">Linux mascot</a> {{< iconify fa7-brands:linux >}}).
We can see that each of their home directories is within another directory called `home`.
And finally, the `home` directory is located in the so-called _root of the filesystem_, represented by a `/` slash.
The root is the top-most directory where everything for our operating system is stored in (it's not possible to go "above" this special root directory).

When we use the shell, we need to specify the location of files and directories using an "address" (similarly to how you specify an internet address to reach a given website).
Let's explore this from our shell terminal.  
First let's find out where we are by running a command called `pwd` (which stands for "print working directory").
Directories are like _places_ - at any time while we are using the shell we are in exactly one place, called our **current working directory**.
Commands mostly read and write files in the current working directory, so knowing where you are before running a command is important.

```bash
pwd
```

```output
/home/tux
```

Here, the computer's response is `/home/tux`, which is our **home directory**, the default when opening a new shell terminal.
The name "tux" is our _username_.  
If the user "wren" was logged in, they would see `/home/wren` as their default working directory.

Notice how the location of this folder is specified:

- `/` at the start specifies the **root of the filesystem**.
- `home` specifies the folder "home" within the root.
- `/` is a **separator** between the "home" folder and the next folder.
- `ubuntu` is the final folder specifying this location.

This way of representing file or directory locations is called a **path**.

::: {.callout-important}

#### The `/` slash

Notice that there are two meanings for the `/` character. 
When it appears at the beginning of a file or directory name, it refers to the root directory. 
When it appears _inside_ a name, it's a separator.

:::

::: {.callout-note}

#### Home directory variation

The home directory path will look different on different operating systems.
For a user named "wren", on a Mac it would look like `/Users/wren`, and on Windows `C:\Users\wren`.

:::

## Listing Files

We can see the content of our current directory by running `ls`, which stands for "listing":

```bash
ls
```

```output
Documents    Downloads    Music        Public
Desktop      Movies       Pictures     Templates
```

The `/home/tux/` directory contains many familiar folders that are typical of a user's home.

The data for this workshop is located in our Desktop, within a directory called `data-shell`.
We can look at its contents passing a directory name as an argument to ls:

```bash
ls -F /home/tux/Desktop/data-shell
```

```output
README.txt  coronavirus/  molecules/  sequencing/  things.txt
```

:::{.callout-note}

#### Exercise

See the [filesystem exercise](#filesystem-exr) to test your knowledge.

:::

## Changing Directory

So far, we have been working from `/home/tux/`.
However, we can change our location to the `Desktop/data-shell` directory to do our work.

The command to change locations is `cd` ("change directory") followed by a directory name to change our working directory.

```bash
cd /home/tux/Desktop/data-shell/
```

We can check with `pwd` that we are in the correct directory.
We can also run `ls` again to see the files within our current directory.

What if we now wanted to go to the `molecules` directory?
We could do:

```bash
cd /home/tux/Desktop/data-shell/molecules/
```

However, that's a lot of typing!
Instead, we can move to that directory by specifying its location _relative_ to our current directory.
So, if our current directory was `/home/tux/Desktop/data-shell/` we could just do:

```bash
cd molecules
```

In conclusion, there are two ways to specify directory names:

- An **absolute path** includes the entire path (or location) from the root directory, which is indicated by a leading slash.
  The leading `/` tells the computer to follow the path from the root of the filesystem, so it always refers to exactly one directory, no matter where we are when we run the command.
- A **relative path** tries to find that location from where we are (our current directory), rather than from the root of the filesystem.

We now know how to go _down_ the directory tree, but how do we go _up_? 
We might try the following:

```bash
cd data-shell
```

```text
-bash: cd: data-shell: No such file or directory
```

But we get an error! Why is this?
With our methods so far, `cd` can only see sub-directories _inside_ your current directory.
To move up one directory we need to use the special shortcut `..` like this:

```bash
cd ..
```

`..` is a special directory name meaning "the directory containing this one", or more succinctly, the **parent** of the current directory.
Sure enough, if we run `pwd` after running `cd ..`, we're back in `/home/tux/Desktop/data-shell`.

::: {.callout-note}

#### The `~` home shortcut

The shell interprets the character `~` (tilde) at the start of a path to mean "the user's home directory".
In our example the `~` is equivalent to `/home/tux`.

:::

::: {.callout-note}

#### Tab completion

Sometimes file and directory names get too long and it's tedious to have to type the full name, for example when moving with `cd`.  
We can let the shell do most of the work through what is called **tab completion**.
Let's say we are in the `/home/tux/Desktop/data-shell` and we type:

```bash
ls mol
```

and then press the <kbd>Tab ↹</kbd> key on the keyboard, the shell automatically completes the directory name:

```bash
ls molecules/
```

If we press <kbd>Tab ↹</kbd> again it does nothing, since there are now multiple possibilities.
In this case, quickly pressing <kbd>Tab ↹</kbd> twice brings up a list of all the files.

Alternatively, some people prefer that repeatedly pressing <kbd>Tab ↹</kbd> cycles through the different file options.
To set this up, see this StackExchange post: [Terminal autocomplete: cycle through suggestions](https://unix.stackexchange.com/questions/24419/terminal-autocomplete-cycle-through-suggestions)

:::

:::{.callout-note}

#### Exercise

See the [file paths exercise](#paths-exr) to test your knowledge.

:::

::: {.callout-note}

#### What's in a file name?

You may have noticed that all of the files in our data directory are named "something dot something". 
For example `README.txt`, which indicates this is a plain text file. 

The second part of such a name is called the **filename extension**, and indicates what type of data the file holds. 
Here are some common examples:

- `.txt` is a plain text file.
- `.csv` is a text file with tabular data where each column is separated by a comma. 
- `.tsv` is like a CSV but values are separated by a tab.
- `.log` is a text file containing messages produced by a software while it runs.
- `.pdf` indicates a PDF document.
- `.png` is a PNG image.

This is just a convention: we can call a file `mydocument` or almost anything else we want. 
However, most people use two-part names most of the time to help them (and their programs) tell different kinds of files apart. 

This is just a convention, albeit an important one. 
Files contain bytes: it's up to us and our programs to interpret those bytes according to the rules for plain text files, PDF documents, configuration
files, images, and so on.

Naming a PNG image of a whale as `whale.mp3` doesn't somehow magically turn it into a recording of whalesong, though it *might* cause the operating system to try to open it with a music player when someone double-clicks it.

:::

## Wildcards

Wildcards are special characters that can be used to access multiple files at once.
The most commonly-used wildcard is `*`, which is used to match zero or more characters.

Consider these examples referring to files in the `molecules` directory:

- `*.pdb` matches every file that ends with '.pdb' extension.
- `p*.pdb` only matches `pentane.pdb` and `propane.pdb`, because the 'p' at the front only matches filenames that begin with the letter 'p'.

Another common wildcard is `?`, which matches **any character exactly once**.
For example:

- `?ethane.pdb` would only match `methane.pdb` (whereas `*ethane.pdb` matches both `ethane.pdb`, and `methane.pdb`).
- `???ane.pdb` matches three characters followed by `ane.pdb`, giving `cubane.pdb  ethane.pdb  octane.pdb`.

When the shell sees a wildcard, it expands the wildcard to create a list of matching filenames _before_ running the command that was asked for.
As an exception, if a wildcard expression does not match any file, _Bash_ will pass the expression as an argument to the command as it is.  
For example typing `ls *.pdf` in the `molecules` directory (which does not contain any PDF files) results in an error message that there is no file called `*.pdf`.

:::{.callout-note}

#### Bash wildcards

The `*` wildcard is by far the most commonly used.
However, there are other wildcards available, and you can find more information about them on the [GNU Wildcard documentation page](https://tldp.org/LDP/GNU-Linux-Tools-Summary/html/x11655.htm).

:::

:::{.callout-note}

#### Exercise

See the [wildcards exercise](#wildcards-exr) to test your knowledge.

:::

## Finding Files

Often, it's useful to be able to find files that have a particular pattern in their name. 
We can use the `find` command to achive this. 
Here is an example, where we try to find all the CSV files that exist under our `data-shell` folder: 

```bash
find . -type f -name "*.csv"
```

```
./coronavirus/variants/india_variants.csv
./coronavirus/variants/ireland_variants.csv
./coronavirus/variants/southafrica_variants.csv
./coronavirus/variants/switzerland_variants.csv
./coronavirus/variants/uk_variants.csv
./sequencing/sample_metadata.csv
```

In this case, we used the option `-type f` to only find **f**iles with the given name.
We could use the option `-type d` if we wanted to instead find **d**irectories only.
If we wanted to find both files and directories, then we can omit this option.

We used `-name` to specify the name of the file we wanted to search for.
Similarly to `ls`, you can use the `*` wildcard to match _any number of characters_.
In our example, we used `*.csv` to find all files with the _.csv_ file extension.

Finally, we searched for files from the current location we were in.
That's what the `.` in the command above means: search for files _from the current directory_.
If we wanted to find files in a different directory without having to `cd` into it first, we could replace `.` with the name of the directory we want to search from.
For example, if you only wanted to search for CSV files in the `coronavirus` folder:

```bash
find coronavirus -type f -name "*.csv"
```

```output
coronavirus/variants/india_variants.csv
coronavirus/variants/ireland_variants.csv
coronavirus/variants/southafrica_variants.csv
coronavirus/variants/switzerland_variants.csv
coronavirus/variants/uk_variants.csv
```

Notice how the `sequencing/sample_metadata.csv` file is not returned in this case.

The `find` command has many more options to configure the search results (you can check these with `man find`). 
One option that can sometimes be useful is to find AND delete all the files.
For example the following command would delete all files with `.txt` extension: 

```bash
find . -type f -name "*.txt" -delete
```

As you can imagine, this feature is **very useful but also potentially dangerous** as you may accidentally delete files you didn't intend to ("with great power comes great responsibility", as they say <i class="fa-solid fa-spider"></i>).
So, always make sure to run the command _without the `-delete` option first_ to check that only the files you really want to delete are being matched.

## Exercises

:::{.callout-exercise #filesystem-exr}

#### Navigating the filesystem
{{< level 1 >}}

(**Note:** this is a conceptual exercise, you don't need to use your own terminal.)

Using the hypothetical filesystem diagram below, if `pwd` displays `/Users/Robin/Documents/`, what will `ls ../backup` display?

1. `../backup: No such file or directory`
2. `2012-12-01 2013-01-08 2013-01-27`
3. `original pnas_final pnas_sub`

![](images/filesystem_exercise.svg)

::: {.callout-answer collapse=true}

1. No: from the diagram, we can see that there *is* a directory `backup` in `/Users/Robin/`.
2. No: this is the content of `Users/Robin/Documents/backup/`, but with `..` we asked for one level _up_.
3. **Yes:** `../backup/` refers to `/Users/Robin/backup`.

:::
:::

:::{.callout-exercise #paths-exr}
#### File paths
{{< level 1 >}}

(**Note:** this is a conceptual exercise, you don't need to use your own terminal.)

Starting from `/home/amanda/data`, which of the following commands could Amanda use to navigate to her home directory (`/home/amanda`)?

1. `cd .`
2. `cd /`
3. `cd /home/amanda`
4. `cd ../..`
5. `cd ~`
6. `cd home`
7. `cd ~/data/..`
8. `cd`
9. `cd ..`

::: {.callout-answer collapse=true}

1. No: `.` stands for the current directory.
2. No: `/` stands for the root directory.
3. **Yes**: This is an example of using the full absolute path.
4. No: this goes up two levels, i.e. ends in `/home`.
5. **Yes**: `~` stands for the user's home directory, in this case `/home/amanda`.
6. No: this would navigate into a directory `home` in the current directory if it exists.
7. **Yes**: unnecessarily complicated, but correct.
8. **Yes**: shortcut to go back to the user's home directory.
9. **Yes**: goes up one level.
:::
:::

:::{.callout-exercise #wildcards-exr}
#### Wildcards
{{< level 1 >}}

Change into the `molecules` directory.
Which `ls` command(s) will produce this output?

```
ethane.pdb   methane.pdb
```

1. `ls *t*ane.pdb`
2. `ls *t?ne.*`
3. `ls *t??ne.pdb`
4. `ls ethane.*`

::: {.callout-answer collapse=true}

1. No. This shows all files whose names contain zero or more characters (`*`) followed by the letter `t`, then zero or more characters (`*`) followed by `ane.pdb`.  
   This gives `ethane.pdb  methane.pdb  octane.pdb  pentane.pdb`. 
2. No. This shows all files whose names start with zero or more characters (`*`) followed by the letter `t`, then a single character (`?`), then `ne.` followed by zero or more characters (`*`).  
   This will give us `octane.pdb` and `pentane.pdb` but doesn't match anything which ends in `thane.pdb`.
3. **Yes**. This fixes the problems of option 2 by matching two characters (`??`) between `t` and `ne`. 
4. No. This only shows files starting with `ethane.`.
:::
:::

## Summary

::: {.callout-tip}
#### Key points

- The filesystem is organised in a hierarchical way.
- Every user has a home directory, which on Linux is `/home/username/`.
- Locations in the filesystem are represented by a **path**:
  - The `/` used at the _start_ of a path means the "root" directory (the start of the filesystem). 
  - `/` used in the _middle_ of the path separates different directories. 
- Some of the commands used to navigate the filesystem are:
  - `pwd` to print the working directory (or the current directory)
  - `ls` to list files and directories
  - `cd` to change directory
- Directories can be created with the `mkdir` command.
- Files can be moved and/or renamed using the `mv` command.
- Files can be copied with the `cp` command. To copy an entire directory (and its contents) we need to use `cp -r` (the `-r` option will copy files **r**ecursively).
- Files can be removed with the `rm` command. To remove an entire directory (and its contents) we need to use `rm -r`  (the `-r` option will remove files **r**ecursively).
  - Deleting files from the command line is _permanent_.
- We can operate on multiple files using the `*` wildcard, which matches "zero or more characters". For example `ls *.txt` would list all files that have a `.txt` file extension.
- The `find` command can be used to find the location of files matching a specific name pattern.
:::
