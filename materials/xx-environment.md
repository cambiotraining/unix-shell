# Environment

::: {.callout-tip}
## Learning Objectives

- TODO
:::

## Environment variables

In the [arguments and variables chapter](07-variables.md), we briefly discussed **environment variables**: variables that load automatically when we start our shell.
These variables are defined based on system or user-provided configuration files and may affect how the operating system behaves.
For example, some programs may rely on environment variables to find critical files or directories needed for their function.

You can see global variables defined in your current environment with:

```bash
printenv
```

Here's some common variables:

- `$HOME` → stores your home directory
- `$USER` → stores your username
- `$SHELL` → indicates which interpreter the current shell is using.
  This is usually `/bin/bash`, but also common is `/bin/zsh` (e.g. on macOS)
- `$PATH` → stores a list of directory paths where the shell looks for executable programs (we will discuss this in detail below)
- `$PWD` → this is a dynamic variable, which stores your current working directory; every time you change directory, the value of this variable also changes

You can access the values of these variables using the `echo` command, just as you would any other shell variable.
For example, try running these:

```bash
echo "Hello $USER!"
echo "Your home directory is located in: $HOME"
echo "Currently you're located in: $PWD"
```

### Local vs global variables

An important distinction is that between local and global variables.

**Local variables** are only accessible to your shell, but not any child processes.
For example, say you define the following variable in your shell:

```bash
hello_message="Hello $USER!"
```

If you run this on the terminal, you will get the expected output:

```bash
echo $hello_message
```

```output
Hello participant!
```

However, if you include this code in a shell script (e.g. `print_hello.sh`):

```bash
#!/usr/env bash

echo "Greeting message:"
echo $hello_message
```

And then execute the shell script:

```bash
bash print_hello.sh
```

```output
Greeting message:

```

You will notice the output from `$hello_message` is empty.
That's because `hello_message` was a **local variable** defined on the active environment, but is not inherited by the environment where the script is executed.

If you want a variable to be defined globally (i.e. it will be inherited by child processes), then you can use the `export` command:

```bash
export hello_message="Hello $USER!"
```

And now:

```bash
bash print_hello.sh
```

```output
Greeting message:
Hello participant!
```

Also note that `hello_message` now appears as a global environment variable if you use the `printenv` command.

::: {.callout-important}
#### Global variables set with `export` do not persist between sessions

One thing to note is that even when set with `export`, environment variables don't persist between sessions.
If you kill your terminal and start a new one, any variables defined in the previous session are no longer available.

If you want global variables to persist across sessions, you should use a configuration file such as `.bashrc`, which we discuss below.
:::

## Finding software: the `PATH` variable

The `PATH` variable is what the shell uses to find executable programs whenever you type a command.
For example, when you type a command such as `ls`/`cat`/`grep`/etc., the shell looks for that program's name in a set of predefined directories.

We can see what executable a certain program uses using the `which` command:

```bash
which grep
```

```output
/usr/bin/grep
```

If we look at the `PATH` variable, we will notice that `/usr/bin` is one of the directories used to find executables:

```bash
echo $PATH
```

```output
/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin:/usr/games:/usr/local/games:/snap/bin:/snap/bin
```

Your `PATH` will likely look different from ours, however it should follow the convention of having each path separated by a `:` colon.
When you type a command the shell will look in those directories *in order*, until it finds the executable referring to the command you typed.
If it doesn't find it, it throws an error: "command not found".

### Custom `PATH`

It is not uncommon to edit your `PATH` by adding new directories with custom software.
This may include your own personal scripts, as well as software you install locally, for example in your home directory.

Let's take an example by looking at the scripts stored in `my_programs`:

```bash
cd ~/Desktop/data-shell
ls my_programs
```

```output
countfiles  cow  sysinfo
```

Although we didn't use a file extension, these are all shell scripts, which you can edit with `nano` or print the content with `cat`.
Let's run one of them:

```bash
bash my_programs/countfiles
```

```output
Files in /home/participant/Desktop/data-shell/:
2
```

This counts the number of regular files in the current directory - nice!

Let's say we wanted to be able to call these scripts as regular commands.
The first thing we need to do is ensure the files have **execute** permission, otherwise they would always need to be called using the `bash` program.
We use the `chmod` command we learned about earlier:

```bash
chmod u+x my_programs/*
ls -l my_programs
```

```output
-rwxrw-r-- 1 participant participant  80 Aug 25 11:38 countfiles
-rwxrw-r-- 1 participant participant 219 Aug 25 11:37 cow
-rwxrw-r-- 1 participant participant 158 Aug 25 11:37 sysinfo
```

We can see the user now has `rwx` permissions to these files, meaning they are set as executable files.
The shell will now use the `#!` shebang within the scripts to determine the program used to launch them (in this case, all of them use `bash`).

Now, we edit our `PATH` variable:

```bash
PATH="$HOME/Desktop/data-shell/my_programs/:$PATH"
```

Let's break down the syntax:

- `PATH=` → redefines the variable by assigning it a new value
- `$HOME/Desktop/data-shell/my_programs/` → adds the new directory to the `PATH`; note that we use `$HOME` to ensure this is defined relative to our user's home directoy
- `:` → this is the separator used to add other directories to the `PATH` list
- `$PATH` → we add the current values already present in `PATH`, so that we effectively paste our new directory in front of the previous directories

If you now print the value of the variable, you should see the new directory listed:

```bash
echo $PATH
```

```output
/home/participant/Desktop/data-shell/my_programs:/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin:/usr/games:/usr/local/games:/snap/bin:/snap/bin
```

Now, you can type any of those program names, and they will run just as any other command, for example:

```bash
sysinfo
```

```
User:     participant
Hostname: training-pc
Kernel:   Linux
Machine:  x86_64
Uptime:   up 2 hours, 17 minutes
```

::: {.callout-tip}
#### Custom scripts can be in any language

Remember the `#!` shebang we covered in the [shell scripts chapter](06-scripts.md)?
This was used to specify which program should be used to execute the script.
We've used `#!/usr/bin/env bash` to use `bash` for our programs.
However, this could be any other interpreter of your choice, for example:

- `#!/usr/bin/env python3` → use Python to execute the script
- `#!/usr/bin/env Rscript` → use R to execute the script

And so on... Any program you have to execute scripts can be included in your shebang!
:::

## Aliases

In the previous section we've seen how you can add custom scripts or programs to your `PATH`, so that they become available as regular programs.
Another related concept is that of an `alias`, which you can think of as a shortcut to another command.

For example, let's say that you often type the `ls` command with the following options:

- `-l` to list in long format
- `-h` to display file sizes in human-readable format
- `-S` to sort files by size
- `--color=always` to always use colours in the output

However, typing `ls -l -h -S --color=always` will quickly become tiresome.
Instead, we can create an alias to this command with a name of our choice.
For example, let's call it `lss` (for "`ls` sorted by `s`ize"):

```bash
alias lss="ls -l -h -S --color=always"
```

Now, we can type `lss` and get the desired outcome:

```bash
lss molecules
```

```output
-rwxr--r-- 1 participant participant 1.8K Jun  6  2025 octane.pdb
-rwxr--r-- 1 participant participant 1.2K Jun  6  2025 pentane.pdb
-rwxr--r-- 1 participant participant 1.2K Jun  6  2025 cubane.pdb
-rwxr--r-- 1 participant participant  825 Jun  6  2025 propane.pdb
-rwxr--r-- 1 participant participant  622 Jun  6  2025 ethane.pdb
-rwxr--r-- 1 participant participant  422 Jun  6  2025 methane.pdb
```

## Configuration files: `.bashrc`

Everything we've done so far only applies to the active shell.
As soon as you close your terminal and start a new session, your environment will be back to its default state.
Custom environment variables, `PATH` edits and aliases will all diseappear.

If you want to make those changes more persistent, you can use configuration files that are loaded when the user starts a new shell.
The most common of these configuration files is called `.bashrc` and is located in the user's home:

```bash
head ~/.bashrc
```

The contents of the `.bashrc` vary between operating systems and users.
Some programs will also modify this file upon installation, e.g. by editing the `PATH` variable with their executables.

The important thing to know is that this file effectively **behaves as a shell script**, so any bash commands are valid within it.
We will edit this file to see its behaviour, but before doing so, we'll **create a backup** in case we make any mistakes:

```bash
cp ~/.bashrc ~/.bashrc_unix_course_bkp
```

::: {.callout-warning}
We're interrupting the flow of the text here to **make sure you really do backup your `.bashrc`**.
This is an important configuration file, and changing it may break some of your environment setup.

Don't be scared to make changes to it, but do be extra careful in backing it up before changes!
:::

Now, we can open the file with any text editor (we will use `nano`, but any text editor is fine):

```bash
nano ~/.bashrc
```

Most of the time it's a good idea to do your edits right at the bottom and leave the rest of the file untouched.
You can even add a comment to indicate these were changes made by you.
Let's do a simple edit, by adding a welcome message that prints every time we start a session:

```bash
# User edit: add a welcome message
echo "Hello $USER - welcome back!"
```

After saving the `.bashrc`, start a new terminal - you should now see this message being printed on the screen.
This is because, as you start a new shell, it reads the `.bashrc` and executes all the commands found within it.

Hopefully, it is clear how you can therefore use this file to edit your `PATH` or create aliases that persist across sessions.
You can put this in practice in the exercises that follow.

::: {.callout-note}
#### Hidden files

Files or directories starting with a `.` are hidden by default when using `ls`.
To see them you can use `ls -a` (list **a**ll files).

Configuration files and directories are often named with a `.` so that they are hidden from the user, avoiding cluttering their view of the filesystem.
:::

## Exercises

::: {.callout-warning}
We've said it before, we'll say it again:

- Before making changes to `.bashrc`, make sure to **create a backup** so you can revert accidental changes that break your environment.
:::

::: {.callout-exercise}
{{< level 1 >}}

Ealier, we used the `alias` command to create an alias for the `ls` command with certain options turned on:

```bash
alias lss='ls -l -h -S --color=always'
```

- Add this alias to your `~/.bashrc`
- Confirm that it persists across sessions by starting a new terminal and running `lss ~/Desktop/data-shell`

::::: {.callout-answer}
To add this alias to our `.bashrc` we open it with a text editor (we use `nano`):

```bash
nano ~/.bashrc
```

We then paste the `alias` command given at the bottom of the file.
We close and save the file: <kbd>Ctrl + X</kbd> → <kbd>Y</kbd> → <kbd>Enter</kbd>.

Finally, after starting a new terminal, we can see that the alias is working:

```bash
lss ~/Desktop/data-shell
```

```
drwxr--r-- 2 participant participant  12K Feb  5  2026 hospital_records
drwxr--r-- 4 participant participant 4.0K Jun  6  2025 coronavirus
drwxr--r-- 2 participant participant 4.0K Jun  6  2025 molecules
drwxrwxr-x 2 participant participant 4.0K Aug 25 12:05 my_programs
drwxr--r-- 4 participant participant 4.0K Jun  6  2025 sequencing
-rwxr--r-- 1 participant participant  563 Jun  6  2025 README.txt
-rwxr--r-- 1 participant participant  301 Jun  6  2025 things.txt
```
:::::
:::

::: {.callout-exercise}
{{< level 2 >}}

As you get more experienced with the command line, you may want to create small scripts or utilities of your own.
Earlier we used some examples found in the `my_programs` directory, which we then added to the `PATH` so they would become available in our environment as regular programs.

A practice often recommended is to create a folder in your home directory for these personal utilities, and then add that folder to your `PATH`.

- Create a new directory in your home for personal scripts.
  How you name this directory is up to you, but make sure it is informative (e.g. `utilities`, `personal-scripts`, or something along those lines).
- Add a test script to this directory (e.g. you can copy one of the scripts we provide in the directory `my_programs`).
- Then persistently add this directory to your `PATH` by editing the `~/.bashrc` configuration file.
- Start a new terminal and confirm that the program is now available to be used.

The advantage of doing this is that you now have a folder that you can use as a place for custom scripts and utilities.
Any time you find yourself doing the same kind of task, think: could I write a small script to save me time in the future?

::::: {.callout-answer}
1. We create a directory in our home called `utilities`:

```bash
mkdir ~/utilities
```

2. We copy one of the example scripts into it as a test:

```bash
cp ~/Desktop/data-shell/my_programs/countfiles ~/utilities/
```

3. We edit our configuration file (`nano ~/.bashrc`) by adding the following:

```bash
export PATH="$HOME/utilities/:$PATH"
```

4. We start a new terminal and test that the `countfiles` command is now available.
:::::
:::

::: {.callout-exercise}
{{< level 3 >}}

As we've mentioned several times, modifying your `.bashrc` can sometimes have unintended consequences, e.g. if you accidentally remove something you shouldn't.

To avoid constantly editing `.bashrc` itself, you can instead have it load custom configurations from a separate file.
For example, you could add this single line to your `.bashrc`:

```bash
source $HOME/.bashrc_custom
```

This will make `~/.bashrc` read the file called `~/.bashrc_custom` and load up any configurations saved in there.

Then, you can make all your custom changes to that file instead, without ever touching `.bashrc`.
Because your custom configurations live in a separate file, you reduce the risk of accidentally changing things you shouldn't.

Try it for yourself:

- Create a new file for your custom configurations: `nano ~/.bashrc_custom`
- Add any customisations you'd like to it (e.g. `export PATH` changes, custom `alias`, etc.)
- Add the following line at the end of your `.bashrc`: `source $HOME/.bashrc_custom`
  - You can also remove any previous configurations you did - they should now live in the new custom file
- Start a new terminal to confirm your changes have taken effect

:::

## Summary

::: {.callout-tip}
#### Key points

- TODO
:::
