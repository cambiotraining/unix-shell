---
title: "Data & Setup"
number-sections: false
---

<!-- 
Note for Training Developers:
We provide instructions for commonly-used software as commented sections below.
Uncomment the sections relevant for your materials, and add additional instructions where needed (e.g. specific packages used).
Note that we use tabsets to provide instructions for all three major operating systems.
-->

<!-- ::: {.callout-tip}
#### Workshop Attendees

If you are attending one of our workshops, we will provide a training environment with all of the required software and data.  
If you want to setup your own computer to run the analysis demonstrated on this course, you can follow the instructions below.
::: -->

## Data

The data used in these materials is provided as a zip file. 
Download and unzip the folder to your Desktop to follow along with the materials.

<!-- Note for Training Developers: adjust the link as relevant -->
<a href="https://www.dropbox.com/sh/d9kjkq0053uyxxc/AAAzFpD0NfUmxvoQxeZRpMw8a?dl=1">
  <button class="btn"><i class="fa fa-download"></i> Download</button>
</a>

## Software

### Unix Terminal

::: {.panel-tabset group="os"}
#### Windows 10/11

To get ready for our workshop please download the **MobaXterm** application, as instructed below. 

- Go the the [MobaXterm download page](https://mobaxterm.mobatek.net/download-home-edition.html).
- Download the "_Portable edition_" (blue button). 
  - Unzip the downloaded file and copy the folder to a convenient location, such as your Desktop.
  - You can directly run the program (without need for installation) from the executable in this folder. 

However, for more advanced usage see the "[Unix on Windows](materials/99-extras/02-wsl.md)" appendix.

#### Mac

Mac OS already has a terminal available.  
Press <kbd><kbd>&#8984;</kbd> + <kbd>space</kbd></kbd> to open _spotlight search_ and type "terminal".

Optionally, if you would like a terminal with more modern features, we recommend installing [_iTerm2_](https://iterm2.com).ss

:::{.callout-warning}
#### macOS permissions

If you get the following error when you run the command `ls` from the terminal: 

```
ls: .: operation not permitted
```

Then, follow [these instructions](https://cleanmymac.com/blog/operation-not-permitted-terminal) to enable access to your filesystem.
:::

#### Linux

Linux distributions already have a terminal available.  
On _Ubuntu_ you can press <kbd><kbd>Ctrl</kbd> + <kbd>Alt</kbd> + <kbd>T</kbd></kbd> to open it.

:::

<!-- 
## Visual Studio Code

::: {.panel-tabset group="os"}

### Windows

- Go to the [Visual Studio Code download page](https://code.visualstudio.com/Download) and download the installer for your operating system. 
  Double-click the downloaded file to install the software, accepting all the default options. 
- After completing the installation, go to your Windows Menu, search for "Visual Studio Code" and launch the application. 
- Go to "_File > Preferences > Settings_", then select "_Text Editor > Files_" on the drop-down menu on the left. Scroll down to the section named "_EOL_" and choose "_\\n_" (this will ensure that the files you edit on Windows are compatible with the Linux operating system).

### Mac OS

- Go to the [Visual Studio Code download page](https://code.visualstudio.com/Download) and download the installer for Mac.
- Go to the Downloads folder and double-click the file you just downloaded to extract the application. Drag-and-drop the "Visual Studio Code" file to your "Applications" folder. 
- You can now open the installed application to check that it was installed successfully (the first time you launch the application you will get a warning that this is an application downloaded from the internet - you can go ahead and click "Open").

### Linux (Ubuntu)

- Go to the [Visual Studio Code download page](https://code.visualstudio.com/Download) and download the installer for your Linux distribution. Install the package using your system's installer.

::: 
-->

