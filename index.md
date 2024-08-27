---
title: "Introduction to the Unix Command Line"
date: today
number-sections: false
---

## Overview 

The **Unix shell** (aka command line) is a powerful and essential tool for researchers, in particular those working in computational disciplines such as bioinformatics and large-scale data analysis. In this course we will explore the basic structure of the Unix operating system and how we can interact with it using a basic set of commands. You will learn how to navigate the filesystem, manipulate text-based data and combine multiple commands to quickly extract information from large data files. You will also learn how to write scripts, use programmatic techniques to automate task repetition, and communicate with remote servers (such as High Performance Computing servers).

::: {.callout-tip}
### Learning Objectives

- Recognise the uses of the command line for computational work.
- Become comfortable in using the command line, understanding how commands are structured and how to access their documentation.
- Navigate the filesystem from the command line and understand how to specify the location of files and directories.
- Perform basic file manipulations in _Bash_: combine multiple files together; count number of lines, words and characters in a file; extract text matching a pattern; counting unique values in a file.
- Combine multiple commands to solve more complex tasks. 
- Write _Bash_ scripts to record and make your analysis reproducible.
- Understand what a _for loop_ is an how it can be used to automate repetitive tasks.
- Access remote servers and move data to/from them.
:::


### Target Audience

This course is targeted at participants with no prior experience of working on the command line.  


### Prerequisites

None.


### Exercises

Exercises in these materials are labelled according to their level of difficulty:

| Level | Description |
| ----: | :---------- |
| {{< fa solid star >}} {{< fa regular star >}} {{< fa regular star >}} | Exercises in level 1 are simpler and designed to get you familiar with the concepts and syntax covered in the course. |
| {{< fa solid star >}} {{< fa solid star >}} {{< fa regular star >}} | Exercises in level 2 combine different concepts together and apply it to a given task. |
| {{< fa solid star >}} {{< fa solid star >}} {{< fa solid star >}} | Exercises in level 3 require going beyond the concepts and syntax introduced to solve new problems. |


## Citation & Authors

:::{.callout-important}
These materials are a fork of the [Carpentries Shell Lesson](https://swcarpentry.github.io/shell-novice/).  
As such, please make sure to cite both works if you use these materials (see [Acknowledgements]).
:::

Please cite these materials if:

- You adapted or used any of them in your own teaching.
- These materials were useful for your research work. For example, you can cite us in the methods section of your paper: "We carried our analyses based on the recommendations in _YourReferenceHere_".

<!-- 
This is generated automatically from the CITATION.cff file. 
If you think you should be added as an author, please get in touch with us.
-->

{{< citation CITATION.cff >}}


## Acknowledgements

These materials are based on the [**Carpentries Shell Lesson**](https://swcarpentry.github.io/shell-novice/) (Copyright (c) The Carpentries) with credit to their authors and contributors.  
We have adapted these materials to fit with our training environment, rearranged some of the sections and data used and added new sections not on the original materials. 
The original authors and publishers of the work have not endorsed the adaptation of this work.

Please make sure to also cite the original work (licensed under the Creative Commons Attribution 4.0 International, [CC-BY 4.0](https://creativecommons.org/licenses/by/4.0/)) if you use these materials:

> Gabriel A. Devenyi (Ed.), Gerard Capes (Ed.), Colin Morris (Ed.), Will Pitchers (Ed.),
Greg Wilson, Gerard Capes, Gabriel A. Devenyi, Christina Koch, Raniere Silva, Ashwin Srinath, … Vikram Chhatre.
> (2019, July). swcarpentry/shell-novice: Software Carpentry: the UNIX shell, June 2019 (Version v2019.06.1).
> Zenodo. http://doi.org/10.5281/zenodo.3266823


----

We also thank **Julia Evans** for their [fantastic illustrations](https://wizardzines.com/) of Bash (and other!) programming concepts. 
