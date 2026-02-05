---
pagetitle: "Unix course"
---

# Combining commands

::: {.callout-tip}
## Learning Objectives

- Construct command pipelines with two or more stages.

:::

## The `|` Pipe

In the [previous section](04-text_manipulation.md#exercises) we ended with an exercise where we counted the number of lines matching the word "Alpha" in several CSV files containing variant classification of _coronavirus_ virus samples from several countries.  
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
cat *_variants.csv | grep "Alpha" | wc -l
```

Notice how we now don't specify an input to either `grep` nor `wc`. 
The input is streamed automatically from one tool to another through the pipe. 
So, the output of `cat` is sent to `grep` and the output from `grep` is then sent to `wc`. 


## Cut, Sort, Unique & Count

Let's now explore a few more useful commands to manipulate text that can be combined to quickly answer useful questions about our data. 

Let's start with the command `cut`, which is used to extract sections from each line of its input. 
For example, let's say we wanted to retrieve only the second _field_ (or column) of our CSV file, which contains the clade classification of each of our omicron samples:

```bash
cat *_variants.csv | cut -d "," -f 2
```

```output
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
cat *_variants.csv | cut -d "," -f 2 | sort
```

```output
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
cat *_variants.csv | cut -d "," -f 2 | sort | uniq
```

```output
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

::: {.callout-note collapse=true}
#### Alphabetic or numeric sort?

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

Here's the main message: **always use the `-n` option if you want things that look like numbers to be sorted numerically** (if the input doesn't look like a number, then `sort` will just order them alphabetically instead).

:::

![Illustration of the `sort` + `uniq` commands by [Julia Evans](https://wizardzines.com/comics/sort-uniq/)](https://wizardzines.com/comics/sort-uniq/sort-uniq.png)


## Exercises

:::{.callout-exercise #pipes-exr}
#### Pipe comprehension
{{< level 1 >}}

(**Note:** this is a conceptual exercise, you don't need to use your own terminal.)

If you had the following two text files:

```bash
cat animals_1.txt
```

```output
deer
rabbit
raccoon
rabbit
```

```bash
cat animals_2.txt
```

```output
deer
fox
rabbit
bear
```

What would be the result of the following command?

```bash
cat animals*.txt | head -n 6 | tail -n 1
```

::: {.callout-answer}

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
:::


:::{.callout-exercise #sort-exr}
#### Sort & count
{{< level 2 >}}

From the `coronavirus/variants` folder, let's continue working on the command we looked at earlier to get the unique values in the variants column of our CSV files: 

```bash
cat *_variants.csv | cut -d "," -f 2 | sort | uniq
```

As you saw, this output also returns a line called "clade". 
This was part of the header (column name) of our CSV file, which is not really useful to have in our output.  
Let's try and solve that problem, and also ask the question of how frequent each of these variants are in our data. 

1. Looking at the help page for `grep` (`man grep`), see if you can find an option to invert a match, i.e. to return the lines that _do not match_ a pattern. 
  Can you think of how to include this in our pipeline to remove that line from our output?
  <details><summary>Hint</summary>
  The option to invert a match with `grep` is `-v`. Using one of our previous examples, `grep -v "Alpha"` would return the lines that _do not match_ the word "Alpha".
  </details>
2. The `uniq` command has an option called `-c`. 
  Try adding that option to the command and infer what it does (or look at `man uniq`).
3. Finally, produce a sorted table of counts for each of our variants in _descending order_ (the most common variant at the top). 
  <details><summary>Hint</summary>
  Look at the manual page for the `sort` command to find the option to order the output in _reverse order_ (or do a quick web search).
  You may also want to use the `-n` option to sort _numerically_.
  </details>

::: {.callout-answer}

**Task 1**

Looking at the help of this function with `man grep`, we can find the following option: 

```
 -v, --invert-match        select non-matching lines
```

So, we can continue working on our pipeline by adding another step at the end: 

```bash
cat *_variants.csv | cut -d "," -f 2 | sort | uniq | grep -v "clade"
```

```output
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

Looking at the help page `man uniq`, we can see that:

```
 -c, --count           prefix lines by the number of occurrences
```

So, if we add this option, we will get the count of how many times each unique line appears in our data: 

```bash
cat *_variants.csv | cut -d "," -f 2 | sort | uniq -c | grep -v "clade"
```

```output
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
cat *_variants.csv | cut -d "," -f 2 | sort | uniq -c | grep -v "clade" | sort -r -n
```

```output
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

We used the option `-r`, which from the help page `man sort`, says: 

```
  -r, --reverse               reverse the result of comparisons
```

We also used the `-n` option to ensure the result is sorted numerically.
From the help page it says: 

```
-n, --numeric-sort      compare according to string numerical value
```
:::
:::


:::{.callout-exercise #hospital-exr}
#### Exploring hospital A&E incidents
{{< level 3 >}}

In the `hospital_records` folder you will find several tab-delimited files containing (simulated) records of A&E admissions in England. 
The files are named by year and NHS England region code. 
Each line of the TSV files corresponds to one recorded admission in A&E.

Using the commands covered so far, answer the following questions: 

1. How many files are there in total? 
2. What is the maximum and minimum number of admissions observed across the data?
3. How many A&E admissions are there for 2020? Remember that there is a header with column names in each file.
4. How many diagnosis of each type are there? And how many accidents per location?
5. What was the maximum time in A&E recorded for London (region code Y56)?

:::{.callout-answer}

**Task 1.**

We can find how many files we have by combining `ls` and `wc -l`:

```bash
ls *.tsv | wc -l
```

```output
147
```

**Task 2.**

Find the maximum and minimum number of admissions by combing `wc -l` with `sort`: 

```bash
wc -l *.tsv | sort
```

The output is quite long, but at the top and bottom of the output we can see:

- `5027 sim_ae_data_2021_Y59.tsv` corresponding to 5026 incidents (we subtract 1 to account for the column name header)
- `9965 sim_ae_data_2024_Y60.tsv` corresponding to 9964 indicents (again subtracting 1)

**Task 3.**

We can find the number of admissions in 2020 by combining three steps: 

- Combine the files using `cat`, and making use of the `*` wildcard. 
- Do a reverse `grep` for one of the column names (e.g. "location_type"), to remove the column name header from the output.
- Use `wc` to count the lines, which should correspond to the total number of records in the data. 

```bash
cat sim_ae_data*2020*.tsv | grep -v "location_type" | wc -l
```

```output
54064
```

**Task 4.**

We can count the number of diagnosis and locations with a combination of: 

- `cat` to combine the files into one stream of text
- A reverse `grep` to remove column names header
- `cut` to extract one of the columns
- `sort` and `uniq -c` to count the unique values in that column
- optionally we `sort` the final output again, to get the results in ascending order from least to most common type

For location, in column 3:

```bash
cat *.tsv | grep -v "location_type" | cut -f 3 |  sort | uniq -c | sort
```

```output
  21757 Home
  32454 Not known
  86773 Other
 217888 Public place
 349436 Educational establishment
 381688 Work
```

And for diagnosis, in column 4:

```bash
cat *.tsv | grep -v "location_type" | cut -f 4 |  sort | uniq -c | sort
```

```output
  10717 Soft tissue inflammation
  10752 Sprain/ligament injury
  10840 Urological conditions (inc cystitis)
  10866 Poisoning (inc overdose)
  10898 Facio-maxillary conditions
  10908 Burns and scalds
  10922 Foreign body
  10929 Diagnosis not classifiable
  10941 Contusion/abrasion
  10979 Haematological conditions
  11007 Respiratory conditions
  11037 Psychiatric conditions
  21619 Social problems (inc chronic alcoholism and homelessness)
  21784 Central nervous system conditions (exc stroke)
  21821 Ophthalmological conditions
  21876 Nothing abnormal detected
  21901 Local infection
  21903 Head injury
  32458 Other vascular conditions
  32595 Gastrointestinal conditions
  32698 Muscle/tendon injury
  32950 Gynaecological conditions
  43493 Vascular injury
  43590 ENT conditions
  54650 Bites/stings
  64962 Visceral injury
  65546 Dermatological conditions
  86723 Cerebro-vascular conditions
  87809 Septicaemia
 250822 Obstetric conditions
```

**Task 5.**

To find the maximum time in A&E in Londong, we use a combination of:

- `cat` with a wildcard to combine all records from "Y56" region code
- `cut` to extract the 5th column in the TSV file
- A reverse `grep` to exclude the column name "duration_min"
- `sort` with the `-n` option to sort the values numerically (otherwise they will be alphabetical!)
- `uniq` to get the unique values
- `tail -n 1` to get the last value, which should be the maximum observed

```bash
cat *Y56.tsv | cut -f 5 | grep -v "duration_min" | sort -n | uniq | tail -n 1
```

```output
4899
```

:::

:::

:::{.callout-exercise #zcat-exr}
#### Looking at compressed files with `zcat`
{{< level 3 >}}

In the `coronavirus` folder, you will find a file named `proteins.fa.gz`. 
This is a file that contains the amino acid sequences of the proteins in the SARS-CoV-2 coronavirus in a text-based format known as FASTA. 
However, this file is _compressed_ using an algorithm known as _GZip_, which is indicated by the file extension `.gz`.  
To look inside compressed files, you can use an alternative to `cat` called `zcat` (if you are using the _macOS_ terminal use `gzcat` instead).
The 'z' at the beggining indicates it will work on _zipped_ files. 


1. Use `zcat` (`gzcat` on macOS) together with `less` to look inside this file. 
  Remember that you can press <kbd>Q</kbd> to exit the `less` program.
2. The content of this file may look a little strange, if you're not familiar with the FASTA file format. 
  Put simply, each protein sequence name starts with the `>` symbol. 
  Combine `zcat` with `grep` to extract the sequence names only. 
3. How many proteins does SARS-CoV-2 have?

::: {.callout-answer}

**Task 1**

The following command allows us to "browse" through the content of this file: 

```bash
zcat proteins.fa.gz | less
```

We can use <kbd>↑</kbd> and <kbd>↓</kbd> to move line-by-line or the <kbd>Page Up</kbd> and <kbd>Page Down</kbd> keys to move page-by-page. 
You can exit `less` by pressing <kbd>Q</kbd> (for "quit"). 
This will bring you back to the console. 

**Task 2**

We can look at the sequences' names by running: 

```bash
zcat proteins.fa.gz | grep ">"
```

```output
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

**Task 3**

We can count how many sequences, by piping the output of the previous task to `wc`:

```bash
zcat proteins.fa.gz | grep ">" | wc -l
```

```output
12
```

:::
:::


:::{.callout-exercise #count-exr}
#### Counting values in columns
{{< level 3 >}}

In the `sequencing/` directory, you will find a file named `gene_annotation.gtf.gz`. 
This is a file containing the names and locations of genes in the Human genome in a standard text-based format called GTF.  
This is a tab-delimited file, where the 3rd column contains information about the kind of annotated feature (e.g. a gene, an exon, start codon, etc.). 

Using a combination of the commands we've seen so far:

1. Count how many occurrences of each feature (3rd column) there is in this file. 
2. How many transcripts does the gene "ENSG00000113643" have?

:::{.callout-hint collapse=true}
- Start by investigating the content of the file with `zcat gene_annotation.gtf.gz | less -S`. 
  You will notice the first few lines of the file contain comments starting with `#` symbol. 
  You should remove these lines before continuing. 
- Check the help for `grep` to remind yourself what the option is to return lines _not_ matching a pattern.
- Remember that the `cut` program uses tab as its default delimiter. 
:::

::: {.callout-answer}

**Task 1**

We could use:

```bash
zcat gene_annotation.gtf.gz | grep -v "#" | cut -f 3 | sort | uniq -c
```

```output
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
:::


## Summary

::: {.callout-tip}
#### Key points

- The `|` pipe allows to chain several commands together. 
  The output of the command on the left of the pipe is sent as input to the command on the right.
- Other useful commands to manipulate text and which are often used together in pipes include: 
  - `cut` to extract parts of a file that are separated by a delimiter. 
  - `sort` to order the input lines _alphabetically_ (default) or _numerically_ (`-n` option).
  - `uniq` to obtain only unique lines from its input. 
    The `-c` option can also be used to count how often each of those unique lines occur. 
:::