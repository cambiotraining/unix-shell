---
title: "Arguments & Variables"
---

::: {.callout-tip}
## Learning Objectives

- Customise shell scripts to work with inputs defined by the user. 
- Define _Bash_ variables based on commands. 

:::


## Customising Scripts

When we discussed [Shell scripts](../01-basics/05-scripts.md), we wrote a script that counted the number of atoms on a specific PDB file (in our example `cubane.pdb`). 
But what if we wanted to give it as input a file of our choice? 
We can make our script more versatile by using a special _shell variable_ that means "the first argument on the command line".
Here is our new script, modified from the previous section:

```bash
#!/bin/bash

# print a message to the user
echo "Processing file: $1"

# count the number of lines containing the word "ATOM"
cat "$1" | grep "ATOM" | wc -l
```

There are several ways in which we have modified our script: 

- We started the script with a special `#!/bin/bash` line, which is known as a [**shebang**](https://en.wikipedia.org/wiki/Shebang_(Unix)). 
  The _shebang_ is optional, but in some cases is used to inform that this script should use the program `bash` to be executed.
- We have other lines starting with the `#` hash character. 
  These are known as **comments** and are not executed by `bash` (they are ignored). 
  Comments are extremely useful because they allow us to annotate our code with information about the commands we're executing. 
- We used a special variable called `$1` to indicate the file that we want to process will be given from the command line. 
  This variable means "the first argument passed to the shell script". 
  You can use any number of these, for example `$2` would mean "the _second_ argument passed to the shell script". 
  These are known as **positional argument variables**.
- We used the `echo` command to print an informative message to the user.

If we run our new script, this is the result: 

```bash
$ bash   scripts/count_atoms.sh   ethane.pdb
```

```default
Processing file: ethane.pdb
8
```

This is a much more flexible script, as the input can now be specified by the user. 


### Exercise: Customising Scripts

(Go back to the `data-unix` folder for this exercise.)

Write a shell script called `longest.sh` that takes two inputs: the name of a directory and a file extension.  
The script should then return the name of the file with the most lines in that directory with that extension. For example:

```bash
$ bash  longest.sh  molecules  pdb
```

would print the name of the `.pdb` file in `molecules` that has the most lines.  
Using your script determine what is the longest PDB file in `molecules` and the longest CSV file in `coronavirus/variants`. 

<details><summary>Hint</summary>
First test how you would achieve this on a single file. 
Once you know what commands you could use to do this on a file, you can generalise your script to take user inputs. 
</details>

::: {.callout-tip collapse=true}
#### Answer

Here is a script that would do what is requested: 

```bash
#!/bin/bash

# This script takes two arguments:
#    1. a directory name
#    2. a file extension
# and prints the name of the file in that directory 
# with the most lines which matches the file extension

wc -l $1/*.$2 | sort -n | tail -n 2 | head -n 1
```

We could then run this script on both of those directories: 

```bash
$ bash longest.sh molecules pdb
```

```default
 30 molecules/octane.pdb
```

And:

```bash
$ bash longest.sh coronavirus/variants csv
```

```default
256 coronavirus/variants/all_countries.csv
```

:::


## Bash Variables

We have seen the special variables called `$1`, `$2`, etc., which are known as _positional argument_ variables. 
Variables in _Bash_ always start with the `$` symbol. 
There are many default variables, for example the variable `$HOME` stores the user's home directory.  
Try running: 

```bash
$ echo $HOME
```

We can also create variables ourselves, with the following syntax:

```bash
NAME="value"
```

This would create a variable containing the text "value". 
Notice that there should be **no space between the variable name and its value**. 

If you want to create a variable with the result of _evaluating a command_, then the syntax is:

```bash
NAME=$(command)
```

Here are some simple examples to illustrate this:

```bash
# Make a variable with a path starting from the user's home
DATADIR="${HOME}/Desktop/data-shell"
# list files in that directory
ls ${DATADIR}
# create a variable with the output of a sub-directory
DATAFILES=$(ls ${DATADIR}/molecules)
# print the results
echo "${DATAFILES}"
```

In the examples above, you will notice that we included the variable names within `{}`. 
The reason is that this allows us to combine the value of a variable with other text.  
Take this example: 

```bash
# create a variable storing the original name of a molecule
$ORIGINAL="ethane"
# add a suffix to this name
echo "$ORIGINAL_copy.pdb"
```

In this case, we would get an error because _Bash_ would think there is a variable called "ORIGINAL_copy", but such a variable does not exist. 
Instead, if we include the variable name in `{}`, then this is not a problem: 

```bash
echo "${ORIGINAL}_copy.pdb"
```

In conclusion: **always include `{}` when using your variables in scripts**. 

![Illustration of Bash variables by [Julia Evans](https://wizardzines.com/comics/variables/)](https://wizardzines.com/comics/variables/variables.png)


## Summary 

::: {.callout-tip}
#### Key Points

- Variables in _Bash_ start with the `$` character. 
- Positional variables such as `$1`, `$2`, `$3`, etc., can be used to store input values specified by the user when running the script.
- Custom variables can be defined with the syntax:
  - `NAME="value"` if we want the variable to contain a fixed value.
  - `NAME=$(command)` if we want the variable to contain the result of running a command.
:::