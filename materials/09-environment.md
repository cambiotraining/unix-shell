# Environment

::: {.callout-tip}
## Learning Objectives

- TODO
:::

## Environment variables

In the [arguments and variables chapter](07-variables.md), we introduced **environment variables**: variables that the shell loads automatically when it starts.
System or user configuration files define these variables, and they can affect how the operating system behaves.
For example, programs may use environment variables to find files or directories that they need.

Use `printenv` to display the variables defined in your current environment:

```bash
printenv
```

Here are some common environment variables:

- `$HOME` stores your home directory.
- `$USER` stores your username.
- `$SHELL` indicates which interpreter the current shell uses.
  This is usually `/bin/bash`, but `/bin/zsh` is also common, especially on macOS.
- `$PATH` stores a list of directories where the shell looks for executable programs.
  We will discuss this variable in detail below.
- `$PWD` stores your current working directory.
  This dynamic variable changes each time you change directory.

Use the `echo` command to access the value of an environment variable, just as you would access any other shell variable.
For example:

```bash
echo "Hello $USER!"
echo "Your home directory is located in: $HOME"
echo "Currently you're located in: $PWD"
```

### Local vs global variables

A shell variable is local to the shell by default.
Child processes, such as a shell script that you run from the terminal, cannot access local variables unless you export them.

For example, define the following variable in your shell:

```bash
hello_message="Hello $USER!"
```

You can use the variable in the current shell:

```bash
echo $hello_message
```

```output
Hello participant!
```

However, if you include the same variable in a shell script (for example, `print_hello.sh`):

```bash
#!/usr/bin/env bash

echo "Greeting message:"
echo $hello_message
```

Then execute the script from the terminal:

```bash
bash print_hello.sh
```

```output
Greeting message:

```

The script prints an empty value because `hello_message` is a local variable in the active shell.
The script runs in a child process, which does not inherit local variables.

Use the `export` command to make a variable available to child processes:

```bash
export hello_message="Hello $USER!"
```

Run the script again:

```bash
bash print_hello.sh
```

```output
Greeting message:
Hello participant!
```

The exported variable also appears in the output from `printenv`.

::: {.callout-important}
#### Exported variables last only for the current session

Exporting a variable makes it available to child processes, but it does not make the variable permanent.
If you close your terminal and start a new session, the variable will no longer be available.

To load variables automatically in future sessions, add their definitions to a configuration file such as `.bashrc`/`.zshrc`, which we discuss below.
:::

## Finding software with `PATH`

When you type a command, the shell uses the `PATH` variable to find the corresponding executable program.
For example, when you type `ls`, `cat`, or `grep`, the shell searches a set of predefined directories.

Use the `which` command to see which executable the shell finds for a program:

```bash
which grep
```

```output
/usr/bin/grep
```

The `PATH` variable includes `/usr/bin`, so the shell can find `grep` there:

```bash
echo $PATH
```

```output
/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin:/usr/games:/usr/local/games:/snap/bin:/snap/bin
```

Your `PATH` will probably differ from this example.
Each directory appears in a colon-separated list.
When you type a command, the shell searches these directories in order and runs the first matching executable.
If the shell finds no match, it throws and error: `command not found`.

### Adding a custom directory to `PATH`

You can add directories to `PATH` when you want to run personal scripts or locally installed software as regular commands.

The `my_programs` directory contains three example scripts:

```bash
cd ~/Desktop/data-shell
ls my_programs
```

```output
countfiles  cow  sysinfo
```

These files have no extension, but they are shell scripts.
You can edit them with `nano` or display their contents with `cat`.
Run one of the scripts with `bash`:

```bash
bash my_programs/countfiles
```

```output
Files in /home/participant/Desktop/data-shell/:
2
```

This script counts the regular files (i.e. it excludes directories) in the current directory.

To run these scripts as regular commands, first give the user execute permission.
Without execute permission, you must run each script through the `bash` program.
Use the `chmod` command we learned about in the [permissions chapter](08-permissions.md):

```bash
chmod u+x my_programs/*
ls -l my_programs
```

```output
-rwxrw-r-- 1 participant participant  80 Aug 25 11:38 countfiles
-rwxrw-r-- 1 participant participant 219 Aug 25 11:37 cow
-rwxrw-r-- 1 participant participant 158 Aug 25 11:37 sysinfo
```

The first three permission characters after the file type are now `rwx`, so the user can read, write, and execute these files.
When you run an executable script, the `#!` shebang at the start of the file tells the operating system which interpreter to use.
In this example, the scripts use `bash`.

Add the directory containing these scripts to the front of `PATH`:

```bash
PATH="$HOME/Desktop/data-shell/my_programs/:$PATH"
```

This assignment combines the new directory with the existing value of `PATH`:

- `PATH=` assigns a new value to the variable.
- `$HOME/Desktop/data-shell/my_programs/` is the directory to add.
  Using `$HOME` makes the path relative to your home directory.
- `:` separates directories in the `PATH` list.
- `$PATH` preserves the directories that were already in `PATH`.
  Placing the new directory first means the shell searches it before the existing directories.

Print `PATH` to confirm that the new directory appears at the front:

```bash
echo $PATH
```

```output
/home/participant/Desktop/data-shell/my_programs:/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin:/usr/games:/usr/local/games:/snap/bin
```

You can now run any of the scripts by typing its name:

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
#### Custom scripts can use different interpreters

The `#!` shebang from the [shell scripts chapter](06-scripts.md) specifies which program should execute a script.
We used `#!/usr/bin/env bash` for the shell scripts in this chapter, but a shebang can specify another interpreter, such as:

- `#!/usr/bin/env python3` uses Python to execute the script.
- `#!/usr/bin/env Rscript` uses R to execute the script.

Any interpreter that can execute scripts can appear in a shebang.
:::

## Aliases

Adding a directory to `PATH` makes its scripts available as regular commands.
An **alias** provides another way to simplify commands by assigning a short name to a command and its options.

For example, you might often use these `ls` options:

- `-l` lists files in long format.
- `-h` displays file sizes in a human-readable format.
- `-S` sorts files by size.
- `--color=always` always uses colours in the output.

Typing `ls -l -h -S --color=always` each time is repetitive.
Let's create an alias named `lss` (for "`ls` sorted by `s`ize) for this command:

```bash
alias lss="ls -l -h -S --color=always"
```

You can now type `lss` to list the contents of `molecules` with these options:

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

## Configuration files

The variable, `PATH`, and alias changes in the previous sections affect only the active shell.
When you close the terminal and start a new session, the shell returns to its default environment.

**Configuration files let you load changes whenever you start a new shell.**
The shell itself is a program, and different shells have different configuration files and behaviours.
You can check which shell you're using with:

```bash
echo $SHELL
```

For most Linux users their default shell is `bash`, but for macOS users it is `zsh`.
Depending on which of these two you have, the most common configuration files are:

- `.bashrc` for a `bash` shell
- `.zshrc` for a `zsh` shell

::: {.callout-important}
#### Select your shell

For your convenience, select your shell so the text below shows you the right configuration file:

{{< shell-selector center >}}

All this does is use either `.bashrc` or `.zshrc` in the text that follows.
But the explanations are identical otherwise.
:::

You can inspect the contents of your configuration file with:

```bash
cat ~/{{< shell-file >}}
```

The contents of `{{< shell-file >}}` vary between operating systems and users.
Some programs also modify this file during installation, for example by adding their executable directories to `PATH`.

The shell treats `{{< shell-file >}}` as a script, so you can place valid Bash commands in it.
Before editing the file, create a backup so that you can restore the original if necessary:

```bash
cp ~/{{< shell-file >}} ~/{{< shell-file >}}_unix_course_bkp
```

::: {.callout-warning}
Back up `{{< shell-file >}}` before you edit it.
This configuration file may contain settings that your environment needs, and an incorrect change can prevent commands or other configuration from working.

You can safely experiment if you keep the backup and restore it when necessary.
:::

Open the file with a text editor.
This example uses `nano`, but you can use any text editor:

```bash
nano ~/{{< shell-file >}}
```

Add your own changes at the bottom of the file and leave the existing configuration unchanged.
A comment can identify the lines that you added.
For example, add a welcome message that prints each time you start a session:

```bash
# User edit: add a welcome message
echo "Hello $USER - welcome back!"
```

Save `{{< shell-file >}}`, then start a new terminal.
The new shell reads `{{< shell-file >}}` and executes its commands, so it prints the welcome message.

You can use the same file to define persistent environment variables, update `PATH`, and create aliases.
The exercises below let you practise these changes.

::: {.callout-note}
#### Hidden files

`ls` hides files and directories whose names start with `.` by default.
Use `ls -a` to list **a**ll files, including hidden files.

Configuration files and directories often start with `.` to keep them out of the usual filesystem listing.
:::

## Exercises

Before starting these exercises, check which shell you're using with:

```bash
echo $SHELL
```

And make your selection accordingly:

{{< shell-selector center >}}

::: {.callout-warning}
Before you edit `{{< shell-file >}}`, create a backup so that you can undo an accidental change that disrupts your environment.
:::

::: {.callout-exercise}
{{< level 1 >}}

Earlier, we used the `alias` command to create an alias for `ls` with several options:

```bash
alias lss='ls -l -h -S --color=always'
```

- Add this alias to your `~/{{< shell-file >}}`.
- Confirm that it persists across sessions by starting a new terminal and running `lss ~/Desktop/data-shell`.

::::: {.callout-answer}
Open `{{< shell-file >}}` with a text editor such as `nano`:

```bash
nano ~/{{< shell-file >}}
```

Paste the `alias` command at the bottom of the file.
Save and close the file with <kbd>Ctrl + X</kbd> → <kbd>Y</kbd> → <kbd>Enter</kbd>.

Start a new terminal and run the alias:

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

As you gain experience with the command line, you may want to create scripts or utilities of your own.
Earlier, we used scripts from the `my_programs` directory and added that directory to `PATH`, which made the scripts available as regular commands.

A common practice is to create a directory in your home directory for personal utilities and add it to `PATH`.

- Create a directory in your home directory for personal scripts.
  Choose an informative name such as `utilities` or `personal-scripts`.
- Add a test script to the directory.
  You can copy one of the scripts from `my_programs`.
- Add the directory to `PATH` persistently by editing `~/{{< shell-file >}}`.
- Start a new terminal and confirm that you can run the script as a command.

This directory gives you a place to keep custom scripts and utilities.
When you repeat a task, consider whether a small script could save you time.

::::: {.callout-answer}
1. Create a directory called `utilities` in your home directory:

```bash
mkdir ~/utilities
```

2. Copy an example script into it:

```bash
cp ~/Desktop/data-shell/my_programs/countfiles ~/utilities/
```

3. Open `{{< shell-file >}}` with `nano ~/{{< shell-file >}}` and add:

```bash
export PATH="$HOME/utilities/:$PATH"
```

4. Start a new terminal and test that the `countfiles` command is available.
:::::
:::

::: {.callout-exercise}
{{< level 3 >}}

Modifying `{{< shell-file >}}` can have unintended consequences if you accidentally remove or change a setting that your environment needs.

You can reduce this risk by storing your custom configuration in a separate file and asking `{{< shell-file >}}` to load it.
For example, add this line to `{{< shell-file >}}`:

```bash
source $HOME/{{< shell-file >}}_custom
```

This command tells `{{< shell-file >}}` to read `~/{{< shell-file >}}_custom` and apply the configurations in that file.

You can then make your custom changes in `~/{{< shell-file >}}_custom` instead of editing `{{< shell-file >}}` repeatedly.

Try it for yourself:

- Create a file for your custom configurations with `nano ~/{{< shell-file >}}_custom`.
- Add customisations such as `export PATH` changes and aliases.
- Add `source $HOME/{{< shell-file >}}_custom` at the end of `{{< shell-file >}}`.
  Move any previous custom configurations to the new file.
- Start a new terminal and confirm that your changes have taken effect.

:::

## Summary

::: {.callout-tip}
#### Key points

- TODO
:::
