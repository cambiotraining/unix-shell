---
title: "Combining Commands"
---

::: {.callout-tip}
## Learning Objectives

- Construct command pipelines with two or more stages.

:::

## The `|` Pipe

In the previous section we ended with an exercise where we counted the number of lines matching the word "Alpha" in several CSV files containing variant classification of _coronavirus_ virus samples from several countries.  
We achieved this in three steps: 

1. Combine all CSV files into one: `cat *_variants.csv > all_countries.csv`.
2. Create a new file containing only the lines that match our pattern: `grep "Alpha" all_countries.csv > alpha.csv`
3. Count the number of lines in this new file: `wc -l alpha.csv`

But what if we now wanted to search for a different pattern, for example "Delta"? 
It seems unpractical to keep creating new files every time we want to ask such a question from our data.  
This is where one of the shell's most powerful feature becomes handy: the ease with which it lets us combine existing programs in new ways.

The way we can combine commands together is using a **pipe**, which uses the special operator `|`. 
Here is our example using a pipe:

```bash
$ cat *_variants.csv | grep "Alpha" | wc -l
```

Notice how we now don't specify an input to either `grep` nor `wc`. 
The input is streamed automatically from one tool to another through the pipe. 
So, the output of `cat` is sent to `grep` and the output from `grep` is then sent to `wc`. 

### Exercise: Pipe Comprehension

If you had the following two text files:

```bash
cat animals_1.txt
```

```
deer
rabbit
raccoon
rabbit
```

```bash
cat animals_2.txt
```

```
deer
fox
rabbit
bear
```

What would be the result of the following command?

```bash
cat animals*.txt | head -n 6 | tail -n 1
```

::: {.callout-tip collapse=true}
#### Answer 

The result would be "fox". 
Here is a diagram illustrating what happens in each of the three steps:

```
                    deer
                    rabbit                  deer
cat animals*.txt    raccoon    head -n 6    rabbit     tail -n 1
----------------->  rabbit    ----------->  raccoon   ----------->  fox
                    deer                    rabbit
                    fox                     deer
                    rabbit                  fox
                    bear
```

- `cat animals*.txt` would combine the content of both files, and then
- `head -n 6` would print the first six lines of the combined file, and then
- `tail -n 1` would return the last line of this output.
:::


### Exercise: `zcat` and `grep`

In the `coronavirus` folder, you will find a file named `proteins.fa.gz`. 
This is a file that contains the amino acid sequences of the proteins in the SARS-CoV-2 coronavirus in a text-based format known as FASTA. 
However, this file is _compressed_ using an algorithm known as _GZip_, which is indicated by the file extension `.gz`.  
To look inside compressed files, you can use an alternative to `cat` called `zcat` (the 'z' at the beggining indicates it will work on _zipped_ files). 

1. Use `zcat` together with `less` to look inside this file. 
  <details><summary>Hint</summary>
  Remember you can press <kbd>Q</kbd> to exit the `less` program.
  </details>
2. The content of this file may look a little strange, if you're not familiar with the FASTA file format. 
  But basically, each protein sequence name starts with the `>` symbol. 
  Combine `zcat` with `grep` to extract the sequence names only. 
  How many proteins does SARS-CoV-2 have?

::: {.callout-tip collapse=true}
#### Answer

**Task 1**

The following command allows us to "browse" through the content of this file: 

```bash
$ zcat proteins.fa.gz | less
```

We can use <kbd>↑</kbd> and <kbd>↓</kbd> to move line-by-line or the <kbd>Page Up</kbd> and <kbd>Page Down</kbd> keys to move page-by-page. 
You can exit `less` by pressing <kbd>Q</kbd> (for "quit"). 
This will bring you back to the console. 

**Task 2**

We can look at the sequences' names by running: 

```bash
$ zcat proteins.fa.gz | grep ">"
```

```
>ORF1ab protein=ORF1ab polyprotein
>ORF1ab protein=ORF1a polyprotein
>S protein=surface glycoprotein
>ORF3a protein=ORF3a protein
>E protein=envelope protein
>M protein=membrane glycoprotein
>ORF6 protein=ORF6 protein
>ORF7a protein=ORF7a protein
>ORF7b protein=ORF7b
>ORF8 protein=ORF8 protein
>N protein=nucleocapsid phosphoprotein
>ORF10 protein=ORF10 protein
```

We could further count how many sequences, by piping this output to `wc`:

```bash
$ zcat proteins.fa.gz | grep ">" | wc -l
```

```
12
```
:::


## Cut, Sort, Unique & Count

Let's now explore a few more useful commands to manipulate text that can be combined to quickly answer useful questions about our data. 

Let's start with the command `cut`, which is used to extract sections from each line of its input. 
For example, let's say we wanted to retrieve only the second _field_ (or column) of our CSV file, which contains the clade classification of each of our omicron samples:

```bash
$ cat *_variants.csv | cut -d "," -f 2
```

```
clade
20I (Alpha; V1)
20A
20I (Alpha; V1)
20A

... (more output omitted) ...
```

The two options used with this command are: 

- `-d` defines the _delimiter_ used to separate different parts of the line. 
  Because this is a CSV file, we use the comma as our delimiter. 
  The _tab_ is used as the default delimiter. 
- `-f` defines the _field_ or part of the line we want to extract. 
  In our case, we want the second _field_ (or column) of our CSV file. 
  It's worth knowing that you can specify more than one _field_, so for example if you had a CSV file with more columns and wanted columns 3 and 7 you could set `-f 3,7`.

The next command we will explore is called `sort`, which sorts the lines of its input _alphabetically_ (default) or _numerically_ (if using the `-n` option). 
Let's combine it with our previous command to see the result:

```bash
$ cat *_variants.csv | cut -d "," -f 2 | sort
```

```
19B
19B
20A
20A
20A
20A
20A
20A
20A
20A

... (more output omitted) ...
```

You can see that the output is now sorted alphabetically. 

The `sort` command is often used in conjunction with another command: `uniq`. 
This command returns the unique lines in its input. 
Importantly, _it only works as intended if the input is sorted_. 
That's why it's often used together with `sort`.  
Let's see it in action, by continuing building our command: 

```bash
$ cat *_variants.csv | cut -d "," -f 2 | sort | uniq
```

```
19B
20A
20B
20C
20E (EU1)
20I (Alpha; V1)
21A (Delta)
21I (Delta)
21J (Delta)
21K (Omicron)
21L (Omicron)
21M (Omicron)
NA
clade
```

We can see that now the output is de-duplicated, so only unique values are returned. 
And so, with a few simple commands, we've answered a very useful question from our data: what are the unique variants in our collection of samples?

![Illustration of the `sort` + `uniq` commands by [Julia Evans](https://wizardzines.com/comics/sort-uniq/)](https://wizardzines.com/comics/sort-uniq/sort-uniq.png)

### Exercise: Sort & Count

Let's continue working on our command: 

```bash
$ cat *_variants.csv | cut -d "," -f 2 | sort | uniq
```

As you saw, this output also returns a line called "clade". 
This was part of the header (or column name) of our CSV file, which is not really useful to have in our output.  
Let's try and solve that problem, and also ask the question of how frequent each of these variants are in our data. 

1. Looking at the help page for `grep` (`grep --help` or `man grep`), see if you can find an option to invert a match, i.e. to return the lines that _do not match_ a pattern. 
  Can you think of how to include this in our pipeline to remove that line from our output?
  <details><summary>Hint</summary>
  The option to invert a match with `grep` is `-v`. Using one of our previous examples, `grep -v "Alpha"` would return the lines that _do not match_ the word "Alpha".
  </details>
2. The `uniq` command has an option called `-c`. 
  Try adding that option to the command and infer what it does (or look at `uniq --help`).
3. Finally, produce a sorted table of counts for each of our variants in _descending order_ (the most common variant at the top). 
  <details><summary>Hint</summary>
  The `sort` command has an option to order the output in _reverse order_: `-r`.
  </details>

::: {.callout-tip collapse=true}
#### Answer

**Task 1**

Looking at the help of this function with `grep --help`, we can find the following option: 

```
 -v, --invert-match        select non-matching lines
```

So, we can continue working on our pipeline by adding another step at the end: 

```bash
$ cat *_variants.csv | cut -d "," -f 2 | sort | uniq | grep -v "clade"
```

```
19B
20A
20B
20C
20E (EU1)
20I (Alpha; V1)
21A (Delta)
21I (Delta)
21J (Delta)
21K (Omicron)
21L (Omicron)
21M (Omicron)
NA
```

This now removes the line that matched the word "clade". 

**Task 2**

Looking at the help for `uniq --help`, we can see that:

```
 -c, --count           prefix lines by the number of occurrences
```

So, if we add this option, we will get the count of how many times each unique line appears in our data: 

```bash
$ cat *_variants.csv | cut -d "," -f 2 | sort | uniq -c | grep -v "clade"
```

```
 2 19B
30 20A
 8 20B
 1 20C
 1 20E (EU1)
38 20I (Alpha; V1)
 8 21A (Delta)
 1 21I (Delta)
66 21J (Delta)
87 21K (Omicron)
 4 21L (Omicron)
 2 21M (Omicron)
 3 NA
```

**Task 3**

Now that we've counted each of our variants, we can again sort this result, this time by the counts value, by adding another `sort` step at the end: 

```bash
$ cat *_variants.csv | cut -d "," -f 2 | sort | uniq -c | grep -v "clade" | sort -r
```

```
87 21K (Omicron)
66 21J (Delta)
38 20I (Alpha; V1)
30 20A
 8 21A (Delta)
 8 20B
 4 21L (Omicron)
 3 NA
 2 21M (Omicron)
 2 19B
 1 21I (Delta)
 1 20E (EU1)
 1 20C
```

We used the option `-r`, which from the help page `sort --help`, says: 

```
  -r, --reverse               reverse the result of comparisons
```
:::


### Exercise: Sort & Count II

**This is an (optional) advanced exercise.**

In the `sequencing/` directory, you will find a file named `gene_annotation.gtf.gz`. 
This is a file containing the names and locations of genes in the Human genome in a standard text-based format called GTF.  
This is a tab-delimited file, where the 3rd column contains information about the kind of annotated feature (e.g. a gene, an exon, start codon, etc.). 

Using a combination of the commands we've seen so far:

1. Count how many occurrences of each feature (3rd column) there is in this file. 
2. How many transcripts does the gene "ENSG00000113643" have?

<details><summary>Hint</summary>

- Start by investigating the content of the file with `zcat gene_annotation.gtf.gz | less -S`. 
  You will notice the first few lines of the file contain comments starting with `#` symbol. 
  You should remove these lines before continuing. 
- Check the help for `grep` to remind yourself what the option is to return lines _not_ matching a pattern.
- Remember that the `cut` program uses tab as its default delimiter. 

</details>

::: {.callout-tip collapse=true}
#### Answer

**Task 1**

We could use:

```bash
zcat gene_annotation.gtf.gz | grep -v "#" | cut -f 3 | sort | uniq -c
```

```
 871196 CDS
    119 Selenocysteine
1624585 exon
 171504 five_prime_utr
  61860 gene
  96934 start_codon
  90724 stop_codon
 203201 three_prime_utr
 251121 transcript
```

- We use `zcat` because the file is compressed (we can tell from its extension ending with `.gz`). 
- We use `grep` to remove the first few lines of the file that start with `#` character. 
- We use `cut` to extract the third "field" (column) of the file. Because it's a tab-delimited file, we don't need to specify a delimiter with `cut`, as that is the default.
- We use `sort` to order the features in alphabetical order.
- Finally, `uniq` is used to return the unique values as well as count their occurrence (with the `-c` option). 

----

**Task 2**

The answer is 10. We could use the following command:

```bash
zcat gene_annotation.gtf.gz | grep "ENSG00000113643" | cut -f 3 | grep "transcript" | wc -l
```

:::

::: {.callout-note collapse=true}
#### `sort`: Alphabetically or Numerically?

Note that, by default the `sort` command will order input lines _alphabetically_. 
So, for example, if it received this as input: 

```
10
2
1
20
```

The result of sorting would be:

```
1
10
2
20
```

Because that's the alphabetical order of those characters. 
We can use the option `sort -n` to make sure it sorts these as numbers, in which case the output would be as expected: 

```
1
2
10
20
```

But, you may be asking yourself: why did it work with the output of `uniq` without specifying `-n`?  
This is because the output of `uniq` left-aligns all the numbers by prefixing the smaller numbers with a space, such as this:

```
10
 2
 1
20
```

And because the _space_ character comes first in the computer's "alphabet", we don't actually need to use the `-n` option.  

Here's the main message: **always use the `-n` option if you want things that look like numbers to be sorted numerically** (if the input doesn't look like a number, then `sort` will just order them alphabetically instead).

:::


## Summary

::: {.callout-tip}
#### Key Points

- The `|` pipe allows to chain several commands together. 
  The output of the command on the left of the pipe is sent as input to the command on the right.
- Other useful commands to manipulate text and which are often used together in pipes include: 
  - `cut` to extract parts of a file that are separated by a delimiter. 
  - `sort` to order the input lines _alphabetically_ (default) or _numerically_ (`-n` option).
  - `uniq` to obtain only unique lines from its input. 
    The `-c` option can also be used to count how often each of those unique lines occur. 
:::