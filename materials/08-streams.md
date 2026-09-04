# Standard streams

::: {.callout-tip}
### Learning Objectives

- Define the three standard streams and explain how they are used in shell commands.
- Use redirection operators to send `stdout` and `stderr` to files.
- Combine `stdout` and `stderr` in a single stream and discard unwanted output with `/dev/null`.
:::

## Inputs and outputs

Every time a program runs, it receives an input and generates an output.
For example:

```bash
ls molecules
```

```output
cubane.pdb  ethane.pdb  md5.txt  methane.pdb  octane.pdb  pentane.pdb  propane.pdb
```

- The path `molecules` is the input to `ls`.
- The output is a list of the files in that directory.

Sometimes the output is an error, for example:

```bash
ls doesnotexist
```

```output
"doesnotexist": No such file or directory (os error 2)
```

These inputs and outputs are called **standard streams**.
There are three of them:

- **Standard input (stdin)**: the input to a command
- **Standard output (stdout)**: the output when a command runs successfully
- **Standard error (stderr)**: the output when a command reports an error or warning

This is a schematic representation of these streams:

![Image source: [Wikipedia](https://commons.wikimedia.org/wiki/File:Stdstreams-notitle.svg)](https://thumb.wikimedia.org/wikipedia/commons/thumb/7/70/Stdstreams-notitle.svg/960px-Stdstreams-notitle.svg.png?utm_source=commons.wikimedia.org&utm_campaign=index&utm_content=thumbnail)

It is worth emphasising the distinction between `stdout` and `stderr`.
Both types of output appear in the terminal, but the shell manages them separately behind the scenes.

## Redirecting output streams

We can illustrate the distinction between `stdout` and `stderr` by using the redirection operator `>`, which we have already met.
For example:

```bash
ls molecules > molecules_ls.txt
```

This creates the file `molecules_ls.txt` with the list of files and prints no extra output to the terminal.

Now consider this command:

```bash
ls doesnotexist > doesnotexist_ls.txt
```

```output
"doesnotexist": No such file or directory (os error 2)
```

This prints the error to the terminal, while `doesnotexist_ls.txt` stays empty because there was no standard output to redirect.
The reason is that `>` redirects only standard output (`stdout`).

There are therefore two types of output redirection operators:

- `>` redirects standard output (you can also use `1>` for the explicit version)
- `2>` redirects standard error

So this command:

```bash
ls doesnotexist > doesnotexist_ls.txt 2> doesnotexist_ls_stderr.txt
```

prints no output to the terminal because the error is redirected to the second file instead.

The distinction between the two output streams may seem like a technical detail, but it is very useful when you use specialised software, such as tools in bioinformatics, or when you write your own scripts and debug them.

## Redirecting stderr to stdout

Sometimes you may want to redirect `stderr` to `stdout`, so that both outputs go to the same file.
You can do this with the combined operator:

- `2>&1` redirects standard error (`2>`) and sends it to the same place as standard output (`1`)

For example:

```bash
ls molecules doesnotexist > molecules_ls_output.txt 2>&1
```

This prints no output to the terminal, and the file contains both `stdout` and `stderr`:

```bash
cat molecules_ls_output.txt
```

```output
"doesnotexist": No such file or directory (os error 2)
count_atoms.sh
cubane.pdb
ethane.pdb
md5.txt
methane.pdb
octane.pdb
pentane.pdb
propane.pdb
```

::: {.callout-note}
#### Discarding outputs with `/dev/null`

Sometimes you may want to ignore a particular output.
For example, a tool may print a lot of information to `stderr` that you do not want to keep.
In these cases, you can redirect the output to `/dev/null`, a special file that discards anything sent to it.

For example, suppose we want to list files in a set of directories but ignore the errors for the directories that do not exist:

```bash
ls molecules fake1 fake2 sequencing fake3 fake4 2> /dev/null
```

```output
molecules:
count_atoms.sh  cubane.pdb  ethane.pdb  md5.txt  methane.pdb  octane.pdb  pentane.pdb  propane.pdb

sequencing:
run1  run2  gene_annotation.gtf.gz  sample_metadata.csv
```

Here, we see the output for the directories that exist, but we ignore the errors from the directories that do not exist.
:::

## Summary

::: {.callout-tip}
### Key Points

- The shell manages three standard streams for each command:
  - `stdin` contains the input sent to a command.
  - `stdout` contains normal output.
  - `stderr` contains errors and warnings.

- Redirection controls where command output goes.
  - `>` sends `stdout` to a file.
  - `2>` sends `stderr` to a file.
  - `2>&1` combines `stderr` with `stdout`.

- You can discard unwanted output with `/dev/null`.
  This is useful when a command prints warnings or missing-file errors that you do not want to keep.
:::
