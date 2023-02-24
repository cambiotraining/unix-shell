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

::: {.callout-tip}
#### Workshop Attendees

If you are attending one of our workshops, we will provide a training environment with all of the required software and data.  
If you want to setup your own computer to run the analysis demonstrated on this course, you can follow the instructions below.
:::

## Data

The data used in these materials is provided as a zip file. 
Download and unzip the folder to your Desktop to follow along with the materials.

<!-- Note for Training Developers: adjust the link as relevant -->
<a href="https://www.dropbox.com/sh/d9kjkq0053uyxxc/AAAzFpD0NfUmxvoQxeZRpMw8a?dl=1">
  <button class="btn"><i class="fa fa-download"></i> Download</button>
</a>

## Setup

### Unix Terminal

::: {.panel-tabset group="os"}
#### Windows 10/11

If you are comfortable with installing software on your computer, we highly recommend installing the **Windows Subsystem for Linux** (WSL2), which provides native _Linux_ functionality from within Windows.  
Alternatively, you can install **MobaXterm**, which provides a Unix-like terminal on _Windows_.  
We provide instructions for both.

----

##### MobaXterm (easier)

- Go the the [MobaXterm download page](https://mobaxterm.mobatek.net/download-home-edition.html).
- If you have permissions to install software on your computer, download the "_Installer edition_" (green button). 
  - Unzip the downloaded file and double-click the `MobaXterm_installer_23.0` installer (note: the latest version number might be slightly different). 
  - Accept default options during installation.
  - After completing the installation, press the Windows key and search for "MobaXterm" to launch the application and check that it was installed successfully. 
- If you do not have admin rights on your computer, download the "_Portable edition_" (blue button). 
  - Unzip the downloaded file and copy the folder to a convenient location, such as your Desktop.
  - You can directly run the program (without need for installation) from the executable in this folder. 

::: {.callout-note appearance="minimal"}
#### Accessing Windows files from MobaXterm

Your `C:\` drive is located in `/drives/C/` (equally, other drives will be available based on their letter). 
For example, your documents will be located in: `/drives/C/Users/<WINDOWS USERNAME>/Documents/`. 
By default, MobaXterm creates shortcuts for your Windows Documents and Desktop.  
It may be convenient to set shortcuts to other commonly-used directories, which you can do using _symbolic links_.
For example, to create a shortcut to Downloads: `ln -s /drives/C/Users/<WINDOWS USERNAME>/Downloads/ ~/Downloads`

:::

----

##### WSL (intermediate)

There are detailed instructions on how to install WSL on the [Microsoft documentation page](https://learn.microsoft.com/en-us/windows/wsl/install). 
But briefly:

- Click the Windows key and search for  _Windows PowerShell_, open it and run the command: `wsl --install`.
- Restart your computer. 
- Click the Windows key and search for _Ubuntu_, which should open a new terminal. 
- Follow the instructions to create a username and password (you can use the same username and password that you have on Windows, or a different one - it's your choice). 
- You should now have access to a Ubuntu Linux terminal. 
  This (mostly) behaves like a regular Ubuntu terminal, and you can install apps using the `sudo apt install` command as usual. 

::: {.callout-note appearance="minimal"}
#### Accessing Windows files from WSL

Your `C:\` drive is located in `/mnt/c/` (equally, other drives will be available based on their letter). 
For example, your documents will be located in: `/mnt/c/Users/<WINDOWS USERNAME>/Documents/`. 
It may be convenient to set shortcuts to commonly-used directories, which you can do using _symbolic links_, for example: 

- `ln -s /mnt/c/Users/<WINDOWS USERNAME>/Documents/ ~/Documents`
- `ln -s /mnt/c/Users/<WINDOWS USERNAME>/Desktop/ ~/Desktop`
- `ln -s /mnt/c/Users/<WINDOWS USERNAME>/Downloads/ ~/Downloads`

:::


#### Mac

Mac OS already has a terminal available.  
Press <kbd><kbd>&#8984;</kbd> + <kbd>space</kbd></kbd> to open _spotlight search_ and type "terminal".

Optionally, if you would like a terminal with more modern features, we recommend installing [_iTerm2_](https://iterm2.com).

#### Linux

Linux distributions already have a terminal available.  
On _Ubuntu_ you can press <kbd><kbd>Ctrl</kbd> + <kbd>Alt</kbd> + <kbd>T</kbd></kbd> to open it.

:::

<!--
## R and RStudio

::: {.panel-tabset group="os"}

### Windows

Download and install all these using default options:

- [R](https://cran.r-project.org/bin/windows/base/release.html)
- [RTools](https://cran.r-project.org/bin/windows/Rtools/)
- [RStudio](https://www.rstudio.com/products/rstudio/download/#download)

### Mac OS

Download and install all these using default options:

- [R](https://cran.r-project.org/bin/macosx/)
- [RStudio](https://www.rstudio.com/products/rstudio/download/#download)

### Linux

- Go to the [R installation](https://cran.r-project.org/bin/linux/) folder and look at the instructions for your distribution.
- Download the [RStudio](https://www.rstudio.com/products/rstudio/download/#download) installer for your distribution and install it using your package manager.

:::
-->


<!--
## Conda

Open a terminal and run:

```bash
wget -q -O - https://repo.anaconda.com/miniconda/Miniconda3-latest-Linux-x86_64.sh
bash Miniconda3-latest-Linux-x86_64.sh -b
rm Miniconda3-latest-Linux-x86_64.sh
conda init
conda config --add channels defaults; conda config --add channels bioconda; conda config --add channels conda-forge; conda config --set channel_priority strict
conda install -y mamba
```

Note: Windows users can use WSL2 (see @wsl).
-->

<!--
## Singularity

::: {.panel-tabset group="os"}

### Windows

You can use _Singularity_ from the _Windows Subsystem for Linux_ (see @wsl).  
Once you setup WSL, you can follow the instructions for Linux.

### Mac OS

Singularity is [not available for Mac OS](https://docs.sylabs.io/guides/3.0/user-guide/installation.html#install-on-windows-or-mac).

### Linux

These instructions are for _Ubuntu_ or _Debian_-based distributions[^1].

[^1]: See the [Singularity documentation page](https://docs.sylabs.io/guides/3.0/user-guide/installation.html#install-on-linux) for other distributions.

```bash
sudo apt update && sudo apt upgrade && sudo apt install runc
CODENAME=$(lsb_release -c | sed 's/Codename:\t//')
wget -O singularity.deb https://github.com/sylabs/singularity/releases/download/v3.10.2/singularity-ce_3.10.2-${CODENAME}_amd64.deb
sudo dpkg -i singularity.deb
rm singularity.deb
```

:::
-->


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

