---
pagetitle: "Unix course"
---

# File operations

::: {.callout-tip}
## Learning Objectives

- Distinguish between copying and moving files.
- Recognise how accidental and irreversible data loss may occur when moving or copying files.
- Create, move, copy and remove files and directories using the commands `mkdir`, `rmdir`, `rm`, `cp` and `mv`.

:::

## Creating directories

We now know how to explore files and directories, but how do we create them in the first place?  
First, we should see where we are and what we already have.
Let's go back to our `data-shell` directory and use `ls` to see what it contains:

```bash
cd ~/Desktop/data-shell
ls
```

```output
README.txt  coronavirus  molecules  sequencing
```

Now, let's **create a new directory** called `thesis_notes` using the command `mkdir` ("make directory"):

```bash
mkdir thesis_notes
```

The new directory is created in the current working directory:

```bash
ls
```

```output
README.txt  coronavirus  molecules  sequencing  thesis_notes  things.txt
```

Note that using the shell to create a directory is no different than using a file explorer.
If you open the current directory using your operating system's graphical file explorer <i class="fa-solid fa-folder"></i>, the `results` directory will appear there too.  
While the shell and the file explorer are two different ways of interacting with the files, the files and directories themselves are the same.

::: {.callout-note collapse=true}

#### Good naming conventions - click here for some tips

Complicated names of files and directories can make your life painful when working on the command line.  
Here are some useful tips for naming your files:

1. Don't use spaces.  
   Spaces can make a name more meaningful, but since spaces are used to separate arguments on the command line it is better to avoid them in names of files and directories.
   You can use `-` or `_` instead (e.g. `thesis_notes/` rather than `thesis notes/`).
2. Don't begin the name with `-` (dash).  
   Commands treat names starting with `-` as options.
3. Only use letters, numbers, `.` period, `-` hyphen and `_` underscore.  
   Many other characters (such as `!`, `@`, `$`, `"`, etc.) have special meanings on the command line and can cause your command to not work as expected or even lead to data loss.

If you need to refer to names of files or directories that have spaces or other special characters, you should surround the name in quotes (`""`).

:::

## Moving & renaming

In our `data-shell` directory we have a file called `things.txt`, which contains a note of books to read for our thesis.
Let's move this file to the `thesis_notes` directory we created earlier, using the command `mv` ("move"):

```bash
mv things.txt thesis_notes/
```

The first argument tells `mv` what we're "moving", while the second is where it's to go.
In this case, we're moving `things.txt` to `thesis_notes/`.
We can check the file has moved there:

```bash
ls thesis_notes
```

```output
things.txt
```

This isn't a particularly informative name for our file, so let's change it!
Interestingly, we also use the `mv` command to change a file's name.  
Here's how we would do it:

```bash
mv thesis_notes/things.txt thesis_notes/books.txt
```

In this case, we are "moving" the file to the same place but with a different name.
Be careful when specifying the target file name, since `mv` will silently overwrite any existing file with the same name, which could lead to data loss.

The command `mv` also works with directories, and you can use it to move/rename an entire directory just as you use it to move an individual file.

:::{.callout-note}

#### Exercise

See the [renaming files exercise](#rename-exr) to test your knowledge.

:::

## Copying Files and Directories

The `cp` command works very much like `mv`, except it copies a file instead of moving it.
For example, let's make a copy of our `books.txt` file:

```bash
cp thesis_notes/books.txt books_copy.txt
ls
```

```output
README.txt  books_copy.txt  coronavirus  molecules  sequencing  thesis_notes
```

Unlike the `mv` command, in this case the original file remains in the original directory:

```bash
ls thesis_notes/
```

```output
books.txt
```

:::{.callout-note}

#### Exercise

See the [copying directories](#copy-exr) and [copying multiple files](#cp-multiple-exr) exercises to test your knowledge.

:::

## Removing Files and Directories

The Unix command used to remove or delete files is `rm` ("remove").
For example, let's remove one of the files we copied earlier:

```bash
rm backup/cubane.pdb
```

We can confirm the file is gone using `ls backup/`.

What if we try to remove the whole `backup` directory we created in the previous exercise?

```bash
rm backup
```

```output
rm: cannot remove `backup': Is a directory
```

We get an error.
This happens, because `rm` _by default_ only works on files, not directories.

`rm` can remove a directory _and all its contents_ if we use the recursive option `-r`, and it will do so **without any confirmation prompts**:

```bash
rm -r backup
```

Given that there is no way to retrieve files deleted using the shell, **`rm -r` should be used with great caution** (you might consider adding the interactive option `rm -r -i`).

To remove _empty_ directories, we can also use the `rmdir` command.
This is a safer option than `rm -r`, because it will never delete the directory if it contains files, giving us a chance to check whether we really want to delete all its contents.

::: {.callout-warning}
#### Deleting Is Forever

The Unix shell doesn't have a trash bin that we can recover deleted files from (though most graphical interfaces to Unix do).  
Instead, when we delete files, they are unlinked from the filesystem so that their storage space on disk can be recycled. 
Tools for finding and recovering deleted files do exist, but there's no guarantee they'll work in any particular situation, since the computer may recycle the file's disk space right away.

:::

## Exercises

:::{.callout-exercise #rename-exr}
#### Renaming files
{{< level 1 >}}

(**Note:** this is a conceptual exercise, you don't need to use your own terminal.)

Suppose that you created a plain-text file in your current directory to contain a list of the statistical tests you will need to do to analyze your data, and named it `statstics.txt`.

After creating and saving this file you realize you misspelled the filename!
You want to correct the mistake, which command could you use to do so?

1. `cp statstics.txt statistics.txt`
2. `mv statstics.txt statistics.txt`
3. `mv statstics.txt .`
4. `cp statstics.txt .`

::: {.callout-answer collapse=true}

1. No.  While this would create a file with the correct name, the incorrectly named file still exists in the directory
and would need to be deleted.
2. **Yes**, this would work to rename the file.
3. No, the period(.) indicates where to move the file, but does not provide a new file name; identical file names
cannot be created.
4. No, the period(.) indicates where to copy the file, but does not provide a new file name; identical file names
cannot be created.
:::
:::

:::{.callout-exercise #copy-exr}
#### Copy directories
{{< level 1 >}}

For this exercise, make sure you are in the course materials directory: `cd ~/Desktop/data-shell`

Make a copy of the `sequencing` directory named `backup`.
When copying an entire directory, you will need to use the option `-r` with the `cp` command (`-r` means "recursive").

::: {.callout-answer collapse=true}

If we run the command without the `-r` option, this is what happens:

```bash
cp sequencing backup
```

```output
cp: -r not specified; omitting directory 'sequencing'
```

This message is already indicating what the problem is.
By default, directories (and their contents) are not copied unless we specify the option `-r`.

This would work:

```bash
cp -r sequencing backup
```

Running `ls` we can see a new folder called `backup`:

```bash
ls
```

```output
README.txt  backup  books_copy.txt  coronavirus  molecules  sequencing  thesis_notes
```
:::
:::

:::{.callout-exercise #cp-multiple-exr}
#### Copy with multiple filenames
{{< level 2 >}}

For this exercise, make sure you are in the course materials directory: `cd ~/Desktop/data-shell`

What does `cp` do when given several filenames and a directory name?

```bash
mkdir -p backup
cp molecules/cubane.pdb molecules/ethane.pdb backup/
```

In the example below, what does `cp` do when given three or more file names?

```bash
cp molecules/cubane.pdb molecules/ethane.pdb molecules/methane.pdb
```

::: {.callout-answer collapse=true}

If given more than one file name followed by a directory name (i.e. the destination directory must be the last argument), `cp` copies the files to the named directory.

If given three file names, `cp` throws an error such as the one below, because when copying multiple files simultaneously, it expects a directory as the last argument.

```output
cp: target 'molecules/methane.pdb' is not a directory
```

:::
:::

## Summary

::: {.callout-tip}
#### Key points

- Directories can be created with the `mkdir` command.
- Files can be moved and/or renamed using the `mv` command.
  - **{{< iconify fluent-emoji-high-contrast:warning >}} Data loss warning**: If files of the same name exist in the destination, they will be overwritten.
- Files can be copied with the `cp` command.
  - To copy an entire directory (and its contents) we need to use `cp -r` (the `-r` option will copy files **r**ecursively).
  - **{{< iconify fluent-emoji-high-contrast:warning >}} Data loss warning**: If files of the same name exist in the destination, they will be overwritten.
- Files can be removed with the `rm` command. To remove an entire directory (and its contents) we need to use `rm -r`  (the `-r` option will remove files **r**ecursively).
  - **{{< iconify fluent-emoji-high-contrast:warning >}} Data loss warning**: Deleting files from the command line is _permanent_.
:::
