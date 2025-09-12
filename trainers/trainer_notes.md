# Trainer notes

In general, there are two main resources:

- A [slide deck](https://docs.google.com/presentation/d/1sUo7DSkJORSyTvcznMsM54S2oZDJC8H7falolCrqiUA/edit?usp=sharing), containing supporting slides for various sections of the course (detailed below).
- [Course materials page](https://cambiotraining.github.io/unix-shell/), containing detailed explanations of the course content. These materials serve a few purposes:
  - For participants: it's a reference to use after the course (course notes).
  - For trainers: useful to prepare the delivery of materials, i.e. knowing what you should be demonstrating interactively during the course.
  - For exercises during the course – at the relevant point of the course you can point participants to section X for the exercise.

Below, we give details to help you prepare each section of the materials.

## General notes

- A large fraction of the course is live-coded (i.e. the trainer is coding along with the participants).
- The slides have speaker notes and several tips to pace the class – make sure to read those notes as you prepare to teach it.
- You can use the written materials as a guide to prepare the delivery (basically going through the same commands and explanations given in the materials).
- If you want to make small changes in your teaching, that's fine – the materials are a guide, but you can decide to tweak things for your own style of delivery.
- Information boxes (grey with the ⓘ symbol) contain extra information, which can be skipped in the live workshop.
- Give participants a set time for exercises (e.g. 10 minutes) but ask them to press the green button (online) or use the green sticky note (in-person) to signal they have completed the exercises – this will help you determine that the class is ready to move on.
- After giving time for the exercise, go through the solution – this is useful for those that didn't manage to complete the exercise, or to reinforce their learning.
- Level 3 exercises (marked with triple star 🟊🟊🟊) are _not covered_ in the live workshops (they are extra exercises for faster participants).
- If you feel like you are falling behind on schedule you can either skip some exercises or solve them together with the participants rather than giving them time to try themselves.
- Remember to increase the font size on your terminal.
- For in-person courses, make sure your terminal occupies the top half of the screen, for those sitting at the back.
- It's preferable to slow down the pace of the workshop if you notice participants are having difficulties, and cut material at the end, rather than rush things and risk losing a large proportion of the audience.

## Section notes

### The Unix shell

[Slides section](https://docs.google.com/presentation/d/1sUo7DSkJORSyTvcznMsM54S2oZDJC8H7falolCrqiUA/edit?slide=id.g37d7a051cc1_0_689#slide=id.g37d7a051cc1_0_689) | [Materials chapter](https://cambiotraining.github.io/unix-shell/materials/01-unix_overview.html)

- The slides contain speaker notes, which should help you deliver the session.
- The introduction section of the slides covers [Chapter 1](https://cambiotraining.github.io/unix-shell/materials/01-unix_overview.html) of the materials, i.e. a general introduction to Unix, terminal layout, basic command structure, manual page.
- You don't need to "live code" any of this section, but if participants want to open their terminal and try some of the commands shown on the terminal layout slides, that's fine.
- Note that the terminal layout slides already mention `pwd`, `ls` and `cd` – but make sure to keep things light at this stage, don't go into too much detail about file paths, which are covered in the next section. Make sure to highlight this to the participants, so they know more details will follow.
- People may use different terminals (MobaXterm on Windows, macOS, Linux). These are equivalent for the most part, but with slight differences. We highlight some of these in the intro slides, but here are a few more things to keep in mind:
  - Linux uses GNU tools, macOS uses BSD-derived utilities and MobaXterm uses BusyBox – this means the documentation and option names for standard commands are often a bit different.
  - Copy/paste on MobaXterm and Linux can be achieved with right-mouse click. On macOS the standard keyboard shortcuts work.

### Navigating the filesystem

[Slides section](https://docs.google.com/presentation/d/1sUo7DSkJORSyTvcznMsM54S2oZDJC8H7falolCrqiUA/edit?slide=id.g37d7a051cc1_0_273#slide=id.g37d7a051cc1_0_273) | [Materials chapter](https://cambiotraining.github.io/unix-shell/materials/02-file_navigation.html)

- After the slides, open the terminal and together with the participants live demo the code in this section.
- `find` is included in the materials as bonus – you can highlight its existence in the materials, but don't cover it to save time.
- Be careful in this session not to go too much into detail about the tools, as this is the first time people are exposed to the command line.

### File operations

[Slides section](https://docs.google.com/presentation/d/1sUo7DSkJORSyTvcznMsM54S2oZDJC8H7falolCrqiUA/edit?slide=id.g37d7a051cc1_0_767#slide=id.g37d7a051cc1_0_767) | [Materials chapter](https://cambiotraining.github.io/unix-shell/materials/03-file_operations.html)

- The slides have detailed explanations of the `cp` and `mv` syntax, therefore you don't need to live code this section.
  - Instead, participants can work through the online materials and exercises by themselves.
  - You can go through the exercise solutions together to clarify questions that may have arisen.

### Working with text

[Slides section](https://docs.google.com/presentation/d/1sUo7DSkJORSyTvcznMsM54S2oZDJC8H7falolCrqiUA/edit?slide=id.g37d7a051cc1_0_696#slide=id.g37d7a051cc1_0_696) | [Materials chapter](https://cambiotraining.github.io/unix-shell/materials/04-text_manipulation.html)

- There are only a couple of slides for this section to set the scene.
- Otherwise, this section is live-coded and we suggest covering all of it and doing the exercises at the end.

### Combining commands

[Slides section](https://docs.google.com/presentation/d/1sUo7DSkJORSyTvcznMsM54S2oZDJC8H7falolCrqiUA/edit?slide=id.g37d7a051cc1_0_724#slide=id.g37d7a051cc1_0_724) | [Materials chapter](https://cambiotraining.github.io/unix-shell/materials/05-combining_commands.html)

- There are only a couple of slides for this section to set the scene.
- This section naturally flows from the previous section and is also live-coded (usually the same trainer does both).
- Participants can do the exercises after the live coding.
  - If tight for time, only do exercises 1 and 2.
  - If really tight for time, go through exercise 2 together with the participants (rather than giving them time to solve it themselves).

### Shell scripts

[Slides section](https://docs.google.com/presentation/d/1sUo7DSkJORSyTvcznMsM54S2oZDJC8H7falolCrqiUA/edit?slide=id.g37d7a051cc1_0_567#slide=id.g37d7a051cc1_0_567) | [Materials chapter](https://cambiotraining.github.io/unix-shell/materials/06-scripts.html)

- There are a few slides to start this section for a few key concepts.
- You can then live code the use of nano – the script naturally follows from the previous section.
- This section is intentionally kept simple; the main purpose is to get novice users comfortable with using shell scripts.
- **MobaXterm note**: `nano` is no longer available by default on MobaXterm. We give participants instructions to run the command `apt install nano` before attending the workshop, but in case they forget, that's all that is needed.

----

**Note:** the sections below are no longer covered in the half-day "Essentials" workshop.
However, they can still be used if teaching a full-day course.
We're keeping the notes here during this transition period.

### Arguments & variables

[Slides](https://docs.google.com/presentation/d/1I65aVp9dFpL1So5r9mtLVO33biUb2iqbU5f-7tP5cyA/edit?slide=id.g37d7a051cc1_0_689#slide=id.g37d7a051cc1_0_689) | [Materials chapter](https://cambiotraining.github.io/unix-shell/materials/07-variables.html)

- Go through the slides that explain the key concepts – these follow on from the previous section.
- Then you can live code the content in the materials – again, this follows from the previous section.
- Note that there are two level 3 exercises in this section – we have found these to be difficult for participants, thus we have made them optional – you do not have to cover these in a live workshop.

### For loops

[Slides](https://docs.google.com/presentation/d/1I65aVp9dFpL1So5r9mtLVO33biUb2iqbU5f-7tP5cyA/edit?slide=id.g37de6b9dece_0_165#slide=id.g37de6b9dece_0_165) | [Loops](https://cambiotraining.github.io/unix-shell/materials/08-loops.html)

- There are some slides for this section, to help explain the concept of a loop and the general syntax.
- You can then do a live demo of the content in section 8.1 – let them know that they don't need to follow you, they will have time to practise in the exercise.
- After this, let them do the exercises – give plenty of time for these first two exercises, as it can be challenging for participants to get their heads around the syntax.
- Only come back to the following sections (8.2 and 8.3) if there's time to spare. Otherwise, just finish the day with those first two exercises. If some people are more advanced, you can encourage them to read through those two sections and try the exercises.
- This section is often challenging (and it's the end, so tiredness sets in), so make sure to walk around the room to check if people need help or clarifications.

**Wrap-up**

- You're the last to present, so make sure to wrap up the course and remind participants to fill in the feedback survey (last slide).
