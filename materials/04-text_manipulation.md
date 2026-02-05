---
pagetitle: "Unix course"
---

# Working with text

::: {.callout-tip}
## Learning Objectives

- Inspect the content of text files (`head`, `tail`, `cat`, `zcat`, `less`).
- Use the `*` wildcard to work with multiple files at once.
- Redirect the output of a command to a file (`>`, `>>`).
- Find a pattern in a text file (`grep`).

:::

## Looking Inside Files

Often we want to investigate the content of a file, without having to open it in a text editor. 
This is especially useful if the file is very large (as is often the case in bioinformatic applications). 

For example, let's take a look at the `cubane.pdb` file in the `molecules` directory. 
We will start by printing the whole content of the file with the `cat` command, which stands for "concatenate" (we will see why it's called this way in a little while):

```bash
cd molecules
cat cubane.pdb
```

```output
COMPND      CUBANE
AUTHOR      DAVE WOODCOCK  95 12 06
ATOM      1  C           1       0.789  -0.852   0.504  1.00  0.00
ATOM      2  C           1      -0.161  -1.104  -0.624  1.00  0.00
ATOM      3  C           1      -1.262  -0.440   0.160  1.00  0.00
ATOM      4  C           1      -0.289  -0.202   1.284  1.00  0.00
ATOM      5  C           1       1.203   0.513  -0.094  1.00  0.00
ATOM      6  C           1       0.099   1.184   0.694  1.00  0.00
ATOM      7  C           1      -0.885   0.959  -0.460  1.00  0.00
ATOM      8  C           1       0.236   0.283  -1.269  1.00  0.00
ATOM      9  H           1       1.410  -1.631   0.942  1.00  0.00
ATOM     10  H           1      -0.262  -2.112  -1.024  1.00  0.00
ATOM     11  H           1      -2.224  -0.925   0.328  1.00  0.00
ATOM     12  H           1      -0.468  -0.501   2.315  1.00  0.00
ATOM     13  H           1       2.224   0.892  -0.134  1.00  0.00
ATOM     14  H           1       0.240   2.112   1.251  1.00  0.00
ATOM     15  H           1      -1.565   1.730  -0.831  1.00  0.00
ATOM     16  H           1       0.472   0.494  -2.315  1.00  0.00
TER      17              1
END
```

Sometimes it is useful to look only at only the top few lines of a file (especially for very large files). 
We can do this with the `head` command:

```bash
head cubane.pdb
```

```output
COMPND      CUBANE
AUTHOR      DAVE WOODCOCK  95 12 06
ATOM      1  C           1       0.789  -0.852   0.504  1.00  0.00
ATOM      2  C           1      -0.161  -1.104  -0.624  1.00  0.00
ATOM      3  C           1      -1.262  -0.440   0.160  1.00  0.00
ATOM      4  C           1      -0.289  -0.202   1.284  1.00  0.00
ATOM      5  C           1       1.203   0.513  -0.094  1.00  0.00
ATOM      6  C           1       0.099   1.184   0.694  1.00  0.00
ATOM      7  C           1      -0.885   0.959  -0.460  1.00  0.00
ATOM      8  C           1       0.236   0.283  -1.269  1.00  0.00
```

By default, `head` prints the first 10 lines of the file. 
We can change this using the `-n` option, followed by a number, for example: 

```bash
head -n 2 cubane.pdb
```

```output
COMPND      CUBANE
AUTHOR      DAVE WOODCOCK  95 12 06
```

Similarly, we can look at the _bottom_ few lines of a file with the `tail` command:

```bash
tail -n 2 cubane.pdb
```

```output
TER      17              1
END
```

Finally, if we want to open the file and browse through it, we can use the `less` command: 

```bash
less cubane.pdb
```

`less` will open the file and you can use <kbd>↑</kbd> and <kbd>↓</kbd> to move line-by-line or the <kbd>Page Up</kbd> and <kbd>Page Down</kbd> keys to move page-by-page. 
You can exit `less` by pressing <kbd>Q</kbd> (for "quit"). 
This will bring you back to the console. 

::: {.callout-note}
#### Searching Text with `less`

When you open a file with the `less` program, you can also search for text within the file. 
To do this, press `/` and you will notice the bottom of the terminal changes to `/`. 
Now, type the word (or part of a word) that you want to search for and press <kbd>Enter ↵</kbd>.  
Less will search of the word in the file and highlight it for you. 
If you want to move to the next match press <kbd>n</kbd> and to move to the previous match press <kbd><kbd>Shift</kbd> + <kbd>n</kbd></kbd>.
:::


## Count Words/Lines/Characters

Often it can be useful to _count_ how many lines, words and characters a file has.
We can use the `wc` command for this:

```bash
wc *.pdb
```

```output
  20  156 1158 cubane.pdb
  12   84  622 ethane.pdb
   9   57  422 methane.pdb
  30  246 1828 octane.pdb
  21  165 1226 pentane.pdb
  15  111  825 propane.pdb
 107  819 6081 total
```

In this case, we used the `*` wildcard to count lines, words and characters (in that order, left-to-right) of all our PDB files. 
Often, we only want to count one of these things, and `wc` has options for all of them:

- `-l` counts lines only.
- `-w` counts words only.
- `-c` counts characters only.

For example, the following counts only the number of lines in each file:

```bash
wc -l *.pdb
```

```output
  20 cubane.pdb
  12 ethane.pdb
   9 methane.pdb
  30 octane.pdb
  21 pentane.pdb
  15 propane.pdb
 107 total
```


## Combining several files

Earlier, we said that the `cat` command stands for "concatenate". 
This is because this command can be used to _concatenate_ (combine) several files together. 
For example, if we wanted to combine all PDB files into one: 

```bash
cat *.pdb
```


## Redirecting Output

The commands we've been using so far, print their output to the terminal. 
But what if we wanted to save it into a file? 
We can achieve this by **redirecting** the output of the command to a file using the `>` operator. 

```bash
wc -l *.pdb > number_lines.txt
```

Now, the output is not printed to the console, but instead sent to a new file. 
We can check that the file was created with `ls`. 

If we use `>` and the output file already exists, its content will be replaced. 
If what we want to do is _append_ the result of the command to the existing file, we can use `>>` instead. 
Let's see this in practice in the next exercise. 


## Finding Patterns

Something it can be very useful to find lines of a file that match a particular text pattern. 
We can use the tool `grep` ("global regular expression print") to achieve this.  
Going back to our molecules directory (`cd ../molecules`), let's find the word "ATOM" in our `cubane.pdb` molecule file:

```bash
grep "ATOM" cubane.pdb
```

```output
ATOM      1  C           1       0.789  -0.852   0.504  1.00  0.00
ATOM      2  C           1      -0.161  -1.104  -0.624  1.00  0.00
ATOM      3  C           1      -1.262  -0.440   0.160  1.00  0.00
ATOM      4  C           1      -0.289  -0.202   1.284  1.00  0.00
ATOM      5  C           1       1.203   0.513  -0.094  1.00  0.00
ATOM      6  C           1       0.099   1.184   0.694  1.00  0.00
ATOM      7  C           1      -0.885   0.959  -0.460  1.00  0.00
ATOM      8  C           1       0.236   0.283  -1.269  1.00  0.00
ATOM      9  H           1       1.410  -1.631   0.942  1.00  0.00
ATOM     10  H           1      -0.262  -2.112  -1.024  1.00  0.00
ATOM     11  H           1      -2.224  -0.925   0.328  1.00  0.00
ATOM     12  H           1      -0.468  -0.501   2.315  1.00  0.00
ATOM     13  H           1       2.224   0.892  -0.134  1.00  0.00
ATOM     14  H           1       0.240   2.112   1.251  1.00  0.00
ATOM     15  H           1      -1.565   1.730  -0.831  1.00  0.00
ATOM     16  H           1       0.472   0.494  -2.315  1.00  0.00
```

We can see the result is all the lines that matched this word pattern. 

`grep` has many other options available, which can be useful depending on the result you want to get. 
Some of the more useful ones are illustrated below. 

![Illustration of the `grep` command by [Julia Evans](https://wizardzines.com/comics/grep/)](https://wizardzines.com/comics/grep/grep.png)


## Exercises

:::{.callout-exercise}
#### Redirection
{{< level 1 >}}

Move to the directory `sequencing` and do the following:

1. List the files in the `run1/` directory. Save the output in a file called `sequencing_files.txt`.
2. Inspect the content of the file, e.g. using `cat`.
3. What happens to the content of that file after you run the command `ls run2 > sequencing_files.txt`?
4. The operator `>>` can be used to _append_ the output of a command to an existing file. Run the following code and inspect the file content again. What happens now?

    ```bash
    ls run1/ > sequencing_files.txt
    ls run2/ >> sequencing_files.txt
    ```

::: {.callout-answer collapse=true}

**Task 1**

To list the files in the directory we use `ls`, followed by `>` to save the output in a file:

```bash
ls run1 > sequencing_files.txt
```

----

**Task 2**

We can check the content of the file:

```bash
cat sequencing_files.txt
```

```output
sampleA_1.fq.gz
sampleA_2.fq.gz
sampleB_1.fq.gz
sampleB_2.fq.gz
sampleC_1.fq.gz
sampleC_2.fq.gz
sampleD_1.fq.gz
sampleD_2.fq.gz
```

----

**Task 3**

If we run `ls run2/ > sequencing_files.txt`, we will replace the content of the file:

```bash
cat sequencing_files.txt
```

```output
sampleE_1.fq.gz
sampleE_2.fq.gz
sampleF_1.fq.gz
sampleF_2.fq.gz
```

----

**Task 4**

If we start again from the beginning, but instead use the `>>` operator the second time we run the command, we will append the output to the file instead of replacing it:

```bash
ls run1/ > sequencing_files.txt
ls run2/ >> sequencing_files.txt
cat sequencing_files.txt
```

```output
sampleA_1.fq.gz
sampleA_2.fq.gz
sampleB_1.fq.gz
sampleB_2.fq.gz
sampleC_1.fq.gz
sampleC_2.fq.gz
sampleD_1.fq.gz
sampleD_2.fq.gz
sampleE_1.fq.gz
sampleE_2.fq.gz
sampleF_1.fq.gz
sampleF_2.fq.gz
```

:::
:::

:::{.callout-exercise}
#### Counting lines
{{< level 1 >}}

In the directory `coronavirus/variants/`, there are several CSV files with information about Coronavirus samples that were classified according to _variants_ (e.g. "Alpha", "Delta", "Omicron").

1. Inspect the top and bottom few lines of one of the files.
2. Each sample is represented by one line in the file. How many samples are there in each file?

:::{.callout-answer}

**Task 1**

We can use `head` and `tail` to inspect the top and bottom few lines of one of the files, e.g.:

```bash
head -n 3 uk_variants.csv
```

```output
Sample,clade
GB01,20I (Alpha; V1)
GB02,20I (Alpha; V1)
```

```bash
tail -n 3 uk_variants.csv
```

```output
GB46,21J (Delta)
GB47,21J (Delta)
GB48,21J (Delta)
```

**Task 2**

We can use `wc -l` to count the number of lines in a single file:

```bash
wc -l uk_variants.csv
```

```output
49 uk_variants.csv
```

To count the number of lines in all files at once, we can use the `*` wildcard:

```bash
wc -l *_variants.csv
```

```output
  49 india_variants.csv
  49 ireland_variants.csv
  49 southafrica_variants.csv
  60 switzerland_variants.csv
  49 uk_variants.csv
 256 total
```

:::
:::

:::{.callout-exercise}
#### Combining files and pattern matching
{{< level 2 >}}

In the directory `coronavirus/variants/`, there are several CSV files with information about SARS-CoV-2 virus samples that were classified according to clades (these are also commonly known as _coronavirus variants_). 

1. Combine all files into a new file called `all_countries.csv`.  
  <details><summary>Hint</summary>You can use `cat` to combine multiple text files. You can use `>` to _redirect_ the output of a command to a new file.</details>
3. Create another file called `alpha.csv` that contains only the Alpha variant samples.  
  <details><summary>Hint</summary>You can use `grep` to find a pattern in a file. You can use `>` to _redirect_ the output of a command to a new file.</details>
1. How many Alpha samples are there in total?

::: {.callout-answer collapse=true}

**Task 1**

We can use `cat` to combine all the files into a single file:

```bash
cat *_variants.csv > all_countries.csv
```

**Task 2**

We can use `grep` to find a pattern in our text file and use `>` to save the output in a new file:

```bash
grep "Alpha" all_countries.csv > alpha.csv
```

We could investigate the output of our command using `less alpha.csv`.

----

**Task 3**

We can use `wc` to count the lines of the newly created file:

```bash
wc -l alpha.csv
```

Giving us 38 as the result.

:::
:::

## Summary

::: {.callout-tip}
#### Key points

- The `head` and `tail` commands can be used to look at the top or bottom of a file, respectively.
- The `less` command can be used to interactively investigate the content of a file. Use <kbd>↑</kbd> and <kbd>↓</kbd> to browse the file and <kbd>Q</kbd> to quit and return to the console.
- The `cat` command can be used to combine multiple files together. The `zcat` command can be used instead if the files are compressed.
- The `>` operator redirects the output of a command into a file. If the file already exists, it's content will be overwritten.
- The `>>` operator also redictects the output of a command into a file, but _appends_ it to any content that already exists. 
- The `grep` command can be used to find the lines in a text file that match a text pattern.
:::
