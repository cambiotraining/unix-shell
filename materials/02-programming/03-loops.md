---
title: "Loops"
---

::: {.callout-tip}
## Learning Objectives

- Understand the logic and applications of a _for loop_ in programming.
- Write a loop that applies one or more commands separately to each file in a set of files.
- Trace the values taken on by a loop variable during execution of the loop.
- Explain what a _dry-run_ is and how to implement it.
:::

## The `for` Loop

**Loops** are a programming construct which allow us to repeat a command or set of commands for each item in a list.
As such they are key to productivity improvements through automation. 
Similar to wildcards and tab completion, using loops also reduces the amount of typing required (and hence reduces the number of typing mistakes).

Going back to our `molecules` directory, suppose we wanted to use our `count_atoms.sh` script to get the number of atoms in each of our molecules' PDB files. 
We know how to run the script for a single file: 

```bash
bash   count_atoms.sh   cubane.pdb
```

Of course, we could manually then repeat this for each of our molecule files: `cubane.pdb`, `ethane.pdb`, `methane.pdb`, `octane.pdb`, `pentane.pdb`, `propane.pdb`.  
But what if we had hundreds (or thousands!) of these files? 
We’ll use a loop to solve this problem, but first let’s look at the general form of a loop:

```bash
for thing in list_of_things
do
  operation_using $thing  # Indentation within the loop is not required, but aids legibility
done
```

Let's create a new script called `count_loop.sh` (using `nano` or `gedit`), where we apply this idea to our example: 

```bash
#!/bin/bash

for filename in cubane.pdb ethane.pdb methane.pdb
do
  bash count_atoms.sh $filename
done
```

If we run this script (`bash count_loop.sh`), we get the expected output: 

```
Processing file: cubane.pdb
16
Processing file: ethane.pdb
8
Processing file: methane.pdb
5
```

When the shell sees the keyword `for`, it knows to repeat a command (or group of commands) once for each item in a list. 
Each time the loop runs (called an iteration), an item in the list is assigned in sequence to the **variable** we specify (in this case `filename`).
Then, the commands inside the loop are executed, before moving on to the next item in the list.
Inside the loop, we call for the variable's value `$filename`.

In our example, at each iteration of the _for loop_, the variable `$filename` stored a different value, cycling through `cubane.pdb`, `ethane.pdb` and finally `methane.pdb`. 


::: {.callout-note}
- Do not use spaces, quotes, or wildcard characters such as '*' or '?' in filenames, as it complicates variable expansion.
- Give files consistent names that are easy to match with wildcard patterns to make it easy to select them for looping.
:::


## Doing a Dry Run

A loop is a way to do many things at once -- or to make many mistakes at once if it does the wrong thing! 
One way to check what a loop *would* do is to `echo` the commands it would run instead of actually running them -- this is known as a _dry-run_.

Suppose we want to preview the commands of our `count_loop.sh` script, but without actually executing the command within the loop.
Here is our original code:

```bash
for filename in cubane.pdb ethane.pdb methane.pdb
do
  bash count_atoms.sh $filename
done
```

To preview what commands would be run, we can double-quote the whole command and `echo` it:

```bash
for filename in cubane.pdb ethane.pdb methane.pdb
do
  echo "bash count_atoms.sh $filename"
done
```

If we run this modified code, the output is: 

```
bash count_atoms.sh cubane.pdb
bash count_atoms.sh ethane.pdb
bash count_atoms.sh methane.pdb
```

So, it wouldn't actually run the command within the loop, but rather tell us what would have been run. 
This is a good practice when building scripts that include a _for loop_, because it lets us check that our code is all correct. 


## Exercises

:::{.callout-exercise}
#### For loops
{{< level 1 >}}

Can you think of a way to improve our `count_loop.sh` script, so that every file gets processed, but without having to type all the individual files' names?

::: {.callout-answer collapse=true}
We can use the `*` wildcard in the for loop: 

```bash
for filename in *.pdb
do
  bash count_atoms.sh $filename
done
```
:::
:::


:::{.callout-exercise}
#### Dry run
{{< level 1 >}}

Suppose we want to set up up a directory structure to organize some experiments measuring reaction rate constants with different compounds and different temperatures.  
Modify the following code to run as a _dry-run_ (i.e. not actually execute the command inside the loop) and try to understand what would happen:

```bash
for molecule in cubane ethane methane
do
  for temp in 25 30 37 40
  do
    mkdir $molecule-$temp
  done
done
```

::: {.callout-answer collapse=true}
We can modify the code so that our command is quoted in an `echo` command: `echo "mkdir $molecule-$temp"`.  
This would be the output:

```
mkdir cubane-25
mkdir cubane-30
mkdir cubane-37
mkdir cubane-40
mkdir ethane-25
mkdir ethane-30
mkdir ethane-37
mkdir ethane-40
mkdir methane-25
mkdir methane-30
mkdir methane-37
mkdir methane-40
```

What we have done here is known as a _nested loop_, i.e. a loop contained within another loop.
So, for each molecule in the first loop, the second loop (the nested loop) iterates over the list of temperatures, and creates a new directory for each combination.
:::
:::


:::{.callout-exercise}
#### Nested loops
{{< level 2 >}}

In a [previous exercise](02-variables.md#exercises) we created the script `count_atom_type.sh`, which counts specific atom types in our PDB files. 
Here is the code from that script:

```bash
# print a message
echo "The number of $2 atoms in $1 is:"

# count carbon "C" atoms
cat "$1" | grep "ATOM" | grep "$2" | wc -l
```

(Note: if you haven't done the previous exercise, please create a script named `count_atom_type.sh` and copy/paste this code into it.)

Create a new script called `atom_type_loop.sh`, which counts the number of Hydrogen ("H") and Carbon ("C") atoms in every `.pdb` file.

:::{.callout-hint collapse=true}
You will have to use a _nested for loop_, i.e. a loop within another loop. 
Look at the previous exercise to see the syntax for a nested loop. 
In this case, you want to loop through the files and loop through the two atom types.
:::

:::{.callout-answer collapse=true}
We achieve this with two nested for loops:

- the first loop goes through the files
- the second loop goes through each of the types of atom that we are interested in

```bash
#!/bin/bash

# first for loop
for filename in *.pdb
do
  # second (nested) for loop
  for atom in C H
  do
    # run the script on the current filename and atom
    bash count_atom_type.sh $filename $atom
  done
done
```

Running our script with `bash atom_type_loop.sh`, we get the following output:

```
The number of C atoms in cubane.pdb is:
8
The number of H atoms in cubane.pdb is:
8
The number of C atoms in ethane.pdb is:
2
The number of H atoms in ethane.pdb is:
6
The number of C atoms in methane.pdb is:
1
The number of H atoms in methane.pdb is:
4
The number of C atoms in octane.pdb is:
8
The number of H atoms in octane.pdb is:
18
The number of C atoms in pentane.pdb is:
5
The number of H atoms in pentane.pdb is:
12
The number of C atoms in propane.pdb is:
3
The number of H atoms in propane.pdb is:
8
```

With only a few lines of code, we managed to perform this operation across all our files at once.

Note that, in this case, the order of the two loops was not important, it would have also worked to loop through the atom types first and then loop through the files. 
This may not always be the case, however, it depends on the task at hand. 

:::
:::


:::{.callout-exercise}
#### Preparing pipeline input files
{{< level 3 >}}

Let's consider the files in the `data-shell/sequencing` directory (note: it's not important to know what sequencing is). 
This directory contains the results of an experiment where several samples were processed in two runs of the sequencing machine (`run1/` and `run2/`). 
For each sample, there are two input files, which have suffix `_1.fq.gz` and `_2.fq.gz`. 

The researcher analysing these files needs to produce a CSV file, which will be used as input to a pipeline, and the format of this file should be: 

```
sample,input1,input2
sampleA,run1/sampleA_1.fq.gz,run1/sampleA_2.fq.gz
sampleB,run1/sampleB_1.fq.gz,run1/sampleB_2.fq.gz
sampleC,run1/sampleC_1.fq.gz,run1/sampleC_2.fq.gz
sampleD,run1/sampleD_1.fq.gz,run1/sampleD_2.fq.gz
sampleE,run2/sampleE_1.fq.gz,run2/sampleE_2.fq.gz
sampleF,run2/sampleF_1.fq.gz,run2/sampleF_2.fq.gz
```

Write a script that produces this file.  

:::{.callout-hint collapse=true}
#### Hint - don't hesitate to look at these tips, it's a challenging exercise!

- Use a for loop to iterate through each sample (remember that each sample has two input files).
- You can combine multiple wildcards in a path, for example `ls run*/*_1.fq.gz` would list all files in folders starting with the word "run" and all files within those folders ending in "_1.fq.gz". 
- The command `dirname` can be used to extract the directory name from a path. For example: `dirname run1/sampleA_1.fq.gz` would return "run1" as the result.
- Conversely, the command `basename` can be used to extract the name of a file from a path. For example: `basename run1/sampleA_1.fq.gz` would return "sampleA_1.fq.gz". 
  Further, you can also remove a suffix at the end of the name by passing it as a second argument to basename: `basename  run1/sampleA_1.fq.gz  "_1.fq.gz"` would only return "sampleA". 
- You can store the result of a command in a variable with the syntax `name=$(command)`. For example, `dir=$(dirname run1/sampleA_1.fq.gz)` would create a variable called `$dir` storing the result of the command, i.e. "run1". 
:::

::: {.callout-answer collapse=true}

Based on all the hints given, here is a script that would achieve the desired result:

```bash
#!/bin/bash

# first create a file with the CSV header (column names)
echo "sample,input1,input2" > samplesheet.csv

# for each file ending with `_1.fq.gz` (so we only process each sample once)
for file in run*/*_1.fq.gz
do
  # extract the directory name of the file
  dir=$(dirname $file)

  # extract the prefix basename of the file
  base=$(basename $file "_1.fq.gz")

  # append the name of the sample, and each input file path
  echo "${base},${dir}/${base}_1.fq.gz,${dir}/${base}_2.fq.gz" >> samplesheet.csv
done
```

This can be incredibly useful, especially for bioinformatic applications, when you may have to process hundreds of samples using standard pipelines.
:::
:::


## Summary

::: {.callout-tip}
#### Key Points

- A `for` loop repeats commands once for every item in a list.
- Every `for` loop needs a variable to refer to the item it is currently operating on.
- Use `$NAME` to use the variable within the loop. `${NAME}` can also be used.
- You can use the `echo` command to do a _dry-run_ of the commands in the loop to check what they would do, but without actually running them.
- Two other commands that can be useful when looping through files are: 
  - `dirname` to extract the directory name from a path.
  - `basename` to extract the file name from a path. 
    Using `basename  <path>  <suffix>` will return the file name _without the specified suffix_ (this is useful to extract the file name without the extension).
:::