# Standard streams

::: {.callout-tip}
## Learning Objectives

- TODO
:::

## Inputs and outputs

Every time a program runs it receives an input and generates an output.
For example:

```bash
ls molecules
```

```output
cubane.pdb  ethane.pdb  md5.txt  methane.pdb  octane.pdb  pentane.pdb  propane.pdb
```

- The path `molecules` is the input to `ls`
- Its output is a list of files in that directory

Sometimes, the output consists of an error, for example:

```bash
ls doesnotexist
```

```output
"doesnotexist": No such file or directory (os error 2)
```

These inputs and outputs are known as **standard streams** and there's three of them, which we've just illustrated:

- **Standard input (stdin)**: the input to the command
- **Standard output (stdout)**: the output when the command runs successfully
- **Standard error (stderr)**: the output when the command issues and error or warning

Schematically, this is what we have:

![Image source: [Wikipedia](https://commons.wikimedia.org/wiki/File:Stdstreams-notitle.svg)](https://thumb.wikimedia.org/wikipedia/commons/thumb/7/70/Stdstreams-notitle.svg/960px-Stdstreams-notitle.svg.png?utm_source=commons.wikimedia.org&utm_campaign=index&utm_content=thumbnail)

It's worth emphasising the distinction between `stdout` and `stderr` as these are often invisible to the user.
Although the output for both is printed on the terminal console, behind the scenes the shell manages these two types of output in different streams.

We can illustrate this by using the redirection `>` operator we've already learned about.
For example:

```bash
ls molecules > molecules_ls.txt
```

creates the file `molecules_ls.txt` with the file list, and no other output printed on the terminal.
However, this:

```bash
ls doesnotexist > doesnotexist_ls.txt
```

```output
"doesnotexist": No such file or directory (os error 2)
```

Prints the error to the terminal, while the file `doesnotexist_ls.txt` is empty (as there was no standard output to print).
This is because `>` redirects standard output (stdout) only.

There are in fact two types of output redirection operators:

- `>` for standard output (you can also use `1>` for its verbose form)
- `2>` for standard error

So, now this command:

```bash
ls doesnotexist > doesnotexist_ls.txt 2> doesnotexist_ls_stderr.txt
```

Will print no output to the terminal: now the error is stored in the second file.

**The distinction between the two output streams may seem like a technical detail, but it is useful when using specialised programs (e.g. in bioinformatics) or when writing your own scripts or debugging.**

## Redirecting stderr to stdout

Sometimes you may want to redirect the `stderr` to `stdout`, such that both output to the same file.
You can achieve this by using a combined operator:

- `2>&1` → redirect the standard error stream (`2>`) and combined it with (`&`) the standard output stream (`1`)

So, this example:

```bash
ls molecules doesnotexist > molecules_ls_output.txt 2>&1
```

Would print no output to the terminal, and the file would contain both `stdout` and `stderr`:

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

::: {.callout-note collapse=true}
#### Discarding outputs with `/dev/null`

Sometimes you may want to ignore a particular output.
For example, a tool may print a lot of verbose information to `stderr` that you are not interested in keeping.
For these cases, you can redirect to a special file called `/dev/null`, which discards anything that is sent to it.

For example, say we wanted to list files in a collection of directories, but we're not worried about the directories that do not exist.

```bash
ls molecules fake1 fake2 sequencing fake3 fake4 2> /dev/null
```

```output
molecules:
count_atoms.sh  cubane.pdb  ethane.pdb  md5.txt  methane.pdb  octane.pdb  pentane.pdb  propane.pdb

sequencing:
run1  run2  gene_annotation.gtf.gz  sample_metadata.csv
```

Here, we get the output of both `molecules` and `sequencing` (which exist), but we ignore the errors that `ls` would have thrown for all the others that do not exist.
:::

