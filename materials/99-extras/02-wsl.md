---
title: "Unix on Windows"
---

In [Data & Setup](../../setup.md) we recommended installing _MobaXterm_ as a way to have a Linux-like terminal on Windows. 
While easy to install, _MobaXterm_ is not a fully-featured Linux environment. 
This means that if you want to run specialised software which only runs on Linux (e.g. in the field of bioinformatics or machine learning), then _MobaXterm_ is quite limited.

The recommended alternative is to install the **Windows Subsystem for Linux (WSL2)**, available for Windows 11 (and recent versions of Windows 10). 
WSL2 is a compatibility layer within Windows that enables users to run a Linux "core" alongside the Windows operating system. 
It provides a seamless integration between Windows and Linux environments, allowing users to execute native Linux commands and run Linux applications directly on a Windows machine. 
WSL2 is designed to be compatible with the Windows filesystem, allowing you to seamlessly interact with your Windows files.


## Installing WSL2

There are detailed instructions on how to install WSL on the [Microsoft documentation page](https://learn.microsoft.com/en-us/windows/wsl/install). 
But briefly:

- Click the Windows key and search for  _Windows PowerShell_, right-click on the app and choose **Run as administrator**. 
- Answer "Yes" when it asks if you want the App to make changes on your computer. 
- A terminal will open; run the command: `wsl --install`.  
  Progress bars will show while installing "Virtual Machine Platform", "Windows Subsystem for Linux" and finally "Ubuntu" (this process can take a long time).
    - **Note:** it has happened to us in the past that the terminal freezes at the step of installing "Ubuntu". If it is frozen for ~1h at that step, press <kbd>Ctrl + C</kdb> and hopefully you will get a message saying "Ubuntu installed successfully".
- After installation completes, restart your computer.
- After restart, a terminal window will open asking you to create a username and password.  
  If it doesn't, click the Windows key and search for _Ubuntu_, click on the App and it should open a new terminal. 
  - You can use the same username and password that you have on Windows, or a different one - it's your choice. Spaces and other special characters are not allowed for your Ubuntu username.
  - **Note:** when you type your password nothing seems to be happening as the cursor doesn't move. However, the terminal is recording your password as you type. You will be asked to type the new password again to confirm it, so you can always try again if you get it wrong the first time.

You should now have access to a Ubuntu Linux terminal. 
This behaves very much like a regular Ubuntu server. 


### Configuring WSL2

After installation, it is useful to **create shortcuts to your files on Windows**. 
Your main `C:\` drive is located in `/mnt/c/` and other drives will be equally available based on their letter. 
To create shortcuts to commonly-used directories you use _symbolic links_. 
Here are some commands to automatically create shortcuts to your Windows "Documents",  "Desktop" and "Downloads" folders (copy/paste these commands on the terminal):

```bash
ln -s $(wslpath $(powershell.exe '[environment]::getfolderpath("mydocuments")' | tr -d '\r')) ~/Documents
ln -s $(wslpath $(powershell.exe '[environment]::getfolderpath("desktop")' | tr -d '\r')) ~/Desktop
ln -s $(wslpath $(powershell.exe '[environment]::getfolderpath("downloads")' | tr -d '\r')) ~/Downloads
```

You may also want to **configure the Windows terminal to automatically open _WSL2_** (instead of the default Windows Command Prompt or Powershell):

- Search for and open the "<i class="fa-solid fa-terminal"></i> Terminal" application.
- Click on the down arrow <i class="fa-solid fa-chevron-down"></i> in the toolbar.
- Click on "<i class="fa-solid fa-gear"></i> Settings".
- Under "Default Profile" select "<i class="fa-brands fa-linux"></i> Ubuntu".


## Visual Studio Code

This is an additional software recommendation for a text editor. 
Strictly speaking, you do not need this software for working on _WSL2_, but we recommend it because of how well it integrates with it. 
Although you can use `nano` to edit your scripts, _Visual Studio Code_ offers a more user-friendly and fully-featured alternative to it. 

To install _Visual Studio Code_:

- Go to the [Visual Studio Code download page](https://code.visualstudio.com/Download) and download the installer for your operating system. 
  Double-click the downloaded file to install the software, accepting all the default options. 
- After completing the installation, search for "Visual Studio Code" and launch the application. 
- Go to "_File > Preferences > Settings_", then select "_Text Editor > Files_" on the drop-down menu on the left. Scroll down to the section named "_EOL_" and choose "_\\n_" (this will ensure that the files you edit on Windows are compatible with the Linux operating system).
- You can now close _VS Code_.

Now, when you are working on _WSL2_, you can open _VS Code_ from the directory you are working from by typing the command `code .`.
_VS Code_ provides a file explorer panel on the left, from where you can conveniently open any scripts you are working on. 
You can also open a terminal from within _VS Code_ by going to "Terminal > New Terminal".