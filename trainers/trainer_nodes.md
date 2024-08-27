# Trainer notes

In general there are two main resources: 

- A [slide deck](https://docs.google.com/presentation/d/1q9Wy77wg_QrN5iP_wYD_TpX7iurs2eFYliOId1owj1A/edit?usp=sharing), containing supporting slides for various sections of the course (detailed below).
- [Course materials page](https://cambiotraining.github.io/unix-shell/), containing detailed explanations of the course content. These materials serve a few purposes:
  - For participants: it's a reference to use after the course (course notes).
  - For trainers: useful to prepare the delivery of materials, i.e. knowing what you should be demonstrating interactively during the course.
  - For exercises during the course - at the relevant point of the course you can point participants to section X for the exercise. 

Below, we give details to help you prepare each section of the materials.


## General notes: 

- The workshop is mostly live-coded (i.e. the trainer is  coding along with the participants), with some [supporting slides](https://docs.google.com/presentation/d/1q9Wy77wg_QrN5iP_wYD_TpX7iurs2eFYliOId1owj1A/edit?usp=sharing) also.
- The slides have speaker notes and several tips to pace the class - make sure to read those notes as you prepare to teach it.
- You can use the written materials as a guide to prepare the delivery (basically going through the same commands and explanations given in the materials).
- If you want to make small changes in your teaching, that's fine - the materials are a guide, but you can decide to tweak things for your own style of delivery. 
- Information boxes (grey with the ⓘ symbol) contain extra information, which can be skipped in the live workshop.
- Give participants a set time for exercises (e.g. 10 minutes) but ask them to press the green button (online) or use the green sticky note (in-person) to signal they have completed the exercises - this will help you determine that the class is ready to move on. 
- After giving time for the exercise, go through the solution - this is useful for those that didn't manage to complete the exercise, or to reinforce their learning. 
- Level 3 exercises (marked with triple star 🟊🟊🟊) are _not covered_ in the live workshops (they are extra exercises for faster participants).
- If you feel like you are falling behind on schedule you can either skip some exercises or solve them together with the participants rather than giving them time to try themselves. 
- Remember to increase the font size on your terminal.
- For in-person courses, make sure your terminal occupies the top-half of the screen, for those sitting at the back. 
- It's preferable to slow down the pace of the workshop if you notice participants are having difficulties, and cut material at the end, rather than rush things and risk loosing a large proportion of the audience. (e.g. feel free to skip for loops).
- macOS using using Guacamole (online courses): when using our virtual desktops there's often issues using keyboard shortcuts on macOS. Unfortunately this is quite hard for us to debug as the behaviour is not consistent across versions of macOS or language regions, however we're compiling some [information on this issue](https://github.com/cambiotraining/unix-shell/issues/19), which you can use during the course to help you. 


## Section notes

### Introduction

- The slides contain speaker notes, which should help you deliver the session. 
- The introduction section of the slides covers [section 3](https://cambiotraining.github.io/unix-shell/materials/01-basics/01-unix_overview.html) of the materials, i.e. a general introduction to Unix, paths, terminal layout, basic command structure, manual page - there is no need to "live code" any of section 3 of the materials.
- People may use different terminals (MobaXterm on Windows, macOS, Linux). These are equivalent for the most part, but with slight differences. We highlight some of these in the intro slides, but here's a few more things to keep in mind: 
  - Linux uses GNU tools, macOS uses BSD-derived utilities and MobaXterm uses BusyBox - this means the documentation and option names for standard commands are often a bit different. 
  - Copy/paste on MobaXterm and Linux can be achieved with right-mouse click. On macOS the standard keyboard shortcuts work. 

### Files and folders

[Section 4](https://cambiotraining.github.io/unix-shell/materials/01-basics/02-files_directories.html)

- After the intro slides, open the terminal and together with the participants live demo the code in this section.
- For this section it can help to have the file browser open alongside the terminal and switch back between them to show people it's the same filesystem. E.g. when you create or remove something, go back between the terminal and file browser to show the files appear/disappear.
- You can intersperse with exercises as you go along this section. The exercises are all at the bottom of the page for ease of navigation during the course; but notice in each section there are boxes linking to the relevant exercise - as you are live coding, you can stop at different points and suggest that they try the relevant exercise. 
- Be careful in this session not going too much into detail about the tools. As this is the first time people are exposed to the command line. 

### Text manipulation

- [Text manipulation](https://cambiotraining.github.io/unix-shell/materials/01-basics/03-text_manipulation.html)
- This section is all live-coded and we suggest covering all of it and doing the exercises at the end. 

### Combining commands

[Combining commands](https://cambiotraining.github.io/unix-shell/materials/01-basics/04-combining_commands.html)

- This naturally flows from the previous section and is also live-coded (often the same trainer does both). 
- Do the exercises after the live coding.
- Summary (slides): 
  - After finishing the above, go through the slides in the section entitled "Basics of Unix - Summary"

### Shell scripts

[Shell scripts](https://cambiotraining.github.io/unix-shell/materials/02-programming/01-scripts.html) and [Arguments & variables](https://cambiotraining.github.io/unix-shell/materials/02-programming/02-variables.html)

- These two sections are live-coded, they naturally follow each other and from the previous live-coded section.
- Note that there are two level 3 exercises in the variables section - we have found these to be difficult for participants, thus we have made them optional - you do not have to cover these in a live workshop. 
- **MobaXterm note**: `nano` is no longer available by default on MobaXterm. We give participants instructions to run the command `apt install nano` before attending the workshop, but in case they forget, that's all that is needed.

### Loops

[Loops](https://cambiotraining.github.io/unix-shell/materials/02-programming/03-loops.html)

- There are some slides for this section, to help explain the concept of a loop and the general syntax. 
- You can then do a live demo of the content in section 9.1 - let them know that they don't need to follow you, they will have time to practice in the exercise. 
- After this, let them do the exercises - give plenty of time for these first two exercises, as it can be challenging for participants to get their head around the syntax. 
- Only come back to the following sections (9.2 and 9.3) if there's time to spare. Otherwise, just finish the day with those first two exercises. If some people are more advanced you can encourage them to read through those two sections and try the exercises. 
- This section is often challenging (and it's the end, so tiredness sets in), so make sure to walk around the room to check if people need help or clarifications.