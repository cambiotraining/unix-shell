---
title: "Text Processing: SED"
---

::: {.callout-tip}
## Learning Objectives

- Explain the basic usage of the `sed` program for text replacement.
- Understand what the `\` "escape character" does and why it is needed.

:::


## Text Replacement 

One of the most prominent text-processing utilities is the `sed` command, which is short for "stream editor".
A stream editor is used to perform basic text transformations on an input stream (a file or input from a pipeline). 

`sed` contains several sub-commands, but the main one we will cover is the _substitute_ or `s` command. 
The syntax is:

```bash
sed 's/pattern/replacement/options'
```

Where `pattern` is the word we want to substitute and `replacement` is the new word we want to use instead. 
There are also other "options" added at the end of the command, which change the default behaviour of the text substitution. 
Some of the common options are:

- `g`: by default `sed` will only substitute the first match of the pattern. If we use the `g` option ("**g**lobal"), then `sed` will substitute all matching text.
- `i`:  by default `sed` matches the pattern in a case-sensitive manner. For example 'A' and 'a' are treated as different. 
  If we use the `i` option ("case-**i**nsensitive") then `sed` will treat 'A' and 'a' as the same.

For example, let's create a file with some text inside it:

```bash
echo "Hello world. How are you world?" > hello.txt
```

If we do:

```bash
sed 's/world/participant/' hello.txt
```

This is the result

```
Hello participant. How are you world?
```

We can see that the first "world" word was replaced with "participant". 
This is the default behaviour of `sed`: only the first pattern it finds in a line of text is replaced with the new word. 
We can modify this by using the `g` option after the last `/`:

```bash
sed 's/world/participant/g' hello.txt
```

```
Hello participant. How are you participant?
```

::: {.callout-note}
#### Regular Expressions

Finding patterns in text can be a very powerful skill to master. 
In our examples we have been finding a literal word and replacing it with another word. 
However, we can do more complex text substitutions by using special keywords that define a more general pattern. 
These are known as **regular expressions**. 

For example, in regular expression syntax, the character `.` stands for "any character". 
So, for example, the pattern `H.` would match a "H" followed by any character, and the expression: 

```bash
sed 's/H./X/g' hello.txt
```

Results in:

```
Xllo world. Xw are you world?
```

Notice how both "He" (at the start of the word "Hello") and "Ho" (at the start of the word "How") are replaced with the letter "X".
Because both of them match the pattern "H followed by any character" (`H.`).

To learn more see this [Regular Expression Cheatsheet](https://www.keycdn.com/support/regex-cheatsheet).
:::


## The `\` Escape Character

You may have asked yourself, if `/` is used to separate parts of the `sed` substitute command, then how would we replace the "/" character itself in a piece of text?
For example, let's add a new line of text to our file:

```bash
echo "Welcome to this workshop/course." >> hello.txt
```

Let's say we wanted to replace "workshop/course" with "tutorial" in this text. 
If we did:

```bash
sed 's/workshop/course/tutorial/' hello.txt
```

We would get an error: 

```
sed: -e expression #1, char 5: unknown option to `s'
```

This is because we ended up with too many `/` in the command, and `sed` uses that to separate its different parts of the command. 
In this situation we need to tell `sed` to ignore that `/` as being a special character but instead treat it as the literal "/" character. 
To to this, we need to use `\` before `/`, which is called the "escape" character. 
That will tell `sed` to treat the `/` as a normal character rather than a separator of its commands.
So:

```bash
sed 's/workshop\/course/tutorial/' hello.txt
                ↑
            This / is "escaped" with \ beforehand
```

This looks a little strange, but the main thing to remember is that `\/` will be interpreted as the character "/" rather than the separator of `sed`'s substitute command. 

The output now would be what we wanted: 

```
Hello world. How are you world?
Welcome to this tutorial.
```


## Alternative separator: `|`

Instead of using the escape character, like we did above, `sed` can also use the character `|` to separate the two parts of the expression.
Our command could have instead been written as: 

```bash
sed 's|workshop/course|tutorial|' hello.txt
```

```
Hello world. How are you world?
Welcome to this tutorial.
```

This is a little easier to read, as we avoid using the `\` escape character in our pattern to be replaced.


## Removing text

The `sed` command can be used to remove text from an input. 
The way to do it is to use nothing as the text to be replaced with.
For example, if we wanted to remove the word "world" from our example file, we could do: 

```bash
sed 's/ world//g' hello.txt
```

Or, equivalently, using the `|` vertical separator: 

```bash
sed 's| world||g' hello.txt
```

```
Hello. How are you?
Welcome to this workshop/course.
```

A few things to note in our command above: 

- We included the " " space before "world", to make sure we also remove it from the text.
- The second part of the `sed` substitution we left blank, that's why we have two consecutive `//` (or `||`), to indicate we are replacing " world" with nothing. 
- We made sure to include the `g` modifier, so that we replace both occurrences of the world "world".


## Exercises

:::{.callout-exercise}
#### Text replacement
{{< level 2 >}}

Working from the `coronavirus/variants` directory, when we run this command: 

```bash
cat *_variants.csv | grep "Alpha"
```

We obtain the following:

```
IN01,20I (Alpha; V1)
IN03,20I (Alpha; V1)
IN22,20I (Alpha; V1)
IN23,20I (Alpha; V1)
IN26,20I (Alpha; V1)
IN27,20I (Alpha; V1)

... more output omitted...
```

Modify the command so that our ouput looks like this: 

```
IN01,Alpha (version 1)
IN03,Alpha (version 1)
IN22,Alpha (version 1)
IN23,Alpha (version 1)
IN26,Alpha (version 1)
IN27,Alpha (version 1)

... more output omitted...
```

::: {.callout-answer collapse=true}

We could use the command:

```bash
cat *_variants.csv | grep "Alpha" | sed 's/20I (//' | sed 's/; V1)/ (version 1)/'
```

We substitute the text in two steps:

- The first `sed` is used to replace the text "20I (" with _nothing_ (effectively removing that text from the output).
- The second `sed` is used to replace the text "; V1)" with " (version 1)".

Note that the two `sed` steps could also have been done in the opposite order (in this case the order was not important). 
:::
:::


:::{.callout-exercise}
#### Searching for `sed` solutions
{{< level 3 >}}

Many (if not most!) users of the command line don't actually know how to program with `sed`. 
But they can be very good a searching for solutions to their questions, using resources such as [Stack Overflow](https://stackoverflow.com/). 
So, let's practice some web searching skills!

In the directory `coronavirus/` you will find the file `proteins.fa.gz`, which contains the sequences of proteins in the SARS-CoV-2 genome. 
This file is in a text-based format called _FASTA_, where each sequence name starts with `>`, followed by one or more lines containing the actual sequence. 
For example: 

```
>sequence 1
GCTACGTACGTGCTG
GCTAGCTAGGTACGC
>sequence 2
GCCGTACGGAGCTAC
GCACGTACGATGGTA
```

From the `coronavirus/proteins.fa.gz` extract the sequence containing the "S" protein only, so your output should be: 

```
>S protein=surface glycoprotein
MFVFLVLLPLVSSQCVNLTTRTQLPPAYTNSFTRGVYYPDKVFRSSVLHSTQDLFLPFFSNVTWFHAIHV
SGTNGTKRFDNPVLPFNDGVYFASTEKSNIIRGWIFGTTLDSKTQSLLIVNNATNVVIKVCEFQFCNDPF
LGVYYHKNNKSWMESEFRVYSSANNCTFEYVSQPFLMDLEGKQGNFKNLREFVFKNIDGYFKIYSKHTPI
NLVRDLPQGFSALEPLVDLPIGINITRFQTLLALHRSYLTPGDSSSGWTAGAAAYYVGYLQPRTFLLKYN
ENGTITDAVDCALDPLSETKCTLKSFTVEKGIYQTSNFRVQPTESIVRFPNITNLCPFGEVFNATRFASV
YAWNRKRISNCVADYSVLYNSASFSTFKCYGVSPTKLNDLCFTNVYADSFVIRGDEVRQIAPGQTGKIAD
YNYKLPDDFTGCVIAWNSNNLDSKVGGNYNYLYRLFRKSNLKPFERDISTEIYQAGSTPCNGVEGFNCYF
PLQSYGFQPTNGVGYQPYRVVVLSFELLHAPATVCGPKKSTNLVKNKCVNFNFNGLTGTGVLTESNKKFL
PFQQFGRDIADTTDAVRDPQTLEILDITPCSFGGVSVITPGTNTSNQVAVLYQDVNCTEVPVAIHADQLT
PTWRVYSTGSNVFQTRAGCLIGAEHVNNSYECDIPIGAGICASYQTQTNSPRRARSVASQSIIAYTMSLG
AENSVAYSNNSIAIPTNFTISVTTEILPVSMTKTSVDCTMYICGDSTECSNLLLQYGSFCTQLNRALTGI
AVEQDKNTQEVFAQVKQIYKTPPIKDFGGFNFSQILPDPSKPSKRSFIEDLLFNKVTLADAGFIKQYGDC
LGDIAARDLICAQKFNGLTVLPPLLTDEMIAQYTSALLAGTITSGWTFGAGAALQIPFAMQMAYRFNGIG
VTQNVLYENQKLIANQFNSAIGKIQDSLSSTASALGKLQDVVNQNAQALNTLVKQLSSNFGAISSVLNDI
LSRLDKVEAEVQIDRLITGRLQSLQTYVTQQLIRAAEIRASANLAATKMSECVLGQSKRVDFCGKGYHLM
SFPQSAPHGVVFLHVTYVPAQEKNFTTAPAICHDGKAHFPREGVFVSNGTHWFVTQRNFYEPQIITTDNT
FVSGNCDVVIGIVNNTVYDPLQPELDSFKEELDKYFKNHTSPDVDLGDISGINASVVNIQKEIDRLNEVA
KNLNESLIDLQELGKYEQYIKWPWYIWLGFIAGLIAIVMVTIMLCCMTSCCSCLKGCCSCGSCCKFDEDD
SEPVLKGVKLHYT
```

::: {.callout-hint collapse=true}
- First investigate the content of the file with `zcat proteins.fa.gz | less` to find what the protein you are looking for is called, as well as the protein that comes after it. 
- Try a web search for "sed extract lines between two patterns". 
- If your search is not leading you anywhere, then try [this link](https://stackoverflow.com/a/64970718/5023162).
:::

::: {.callout-answer collapse=true}
Like the hint suggested, a web search for "sed extract lines between two patterns" will bring this [Stack Overflow answer](https://stackoverflow.com/a/64970718/5023162) as one of the first hits.  
The person answering suggests that to search for two patterns (PAT1 and PAT2) but without returning PAT2 in the output, we can do: `sed -n '/PAT1/{:a;N;/PAT2/!ba;s/\n[^\n]*$//p}' file`. 
So, we can adjust this code for our case: 

```bash
zcat proteins.fa.gz | sed -n '/>S/{:a;N;/>ORF3a/!ba;s/\n[^\n]*$//p}'
```

In our case, the first pattern is `>S` (the name of the protein we are interested in) and the second pattern is `>ORF3a` (which is the protein following that one). 

Do we have to understand what just happened? 
In some situations, maybe... but for most applications it's enough to know how to look for the answer! 
:::
:::


## Summary 

::: {.callout-tip}
#### Key Points

- The `sed` tool can be used for advanced text manipulation. The "substitute" command can be used to text replacement: `sed 's/pattern/replacement/options'`.
- Common options that can be used with `sed` include:
  - `g` for **g**lobal substitution, rather than just the first match.
  - `i` for case-**i**nsensitive substitution, rather than being case-sensitive.
- To _remove_ part of a text we can leave the "replacement" part of the command empty: `sed 's/pattern//g'` (this would replace "pattern" with _nothing_, i.e. removing it).
- While `sed` is extremely versatile, learning and remembering all of its operations can be challenging. 
  Instead, effective web-searching can often lead us to solutions for not-so-trivial text manipulation problems, without the need to learn all the workings of the tool. 
:::