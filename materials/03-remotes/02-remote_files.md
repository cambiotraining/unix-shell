---
title: "Remote Files"
---

::: {.callout-tip}
## Learning Objectives

- Synchronise files to/from a remote computer. 
- Mount a directory from another computer onto the local filesystem.
- Download web resources from the command line.
- Distinguish when different remote access tools should be used for different tasks.
:::


## File Sync

In the previous section we've seen how we can copy entire directories from the remote server using `scp -r`. 
For example:

```bash
$ scp -r training@remote-machine:drosophila ~/Desktop/data-shell
```

```
TODO
```

However `scp` isn't always the best tool to use for managing this kind of operation. 
When you run `scp` it copies the entirety of every single file you specify. 
For an initial copy this is probably what you want, but if you change only a few files and want to synchronize the server copy to keep up with your changes it wouldn't make sense to copy the entire directory structure again.

For this scenario **`rsync`** can be an excellent tool. 

First, we will add some new files to our `drosophila` directory using the `touch` command. 
This command does nothing but create an empty file or update the timestamp of an existing file.

```bash
$ touch drosophila/new_file1.txt drosophila/new_file2.txt drosophila/new_file3.txt
```

Now we have everything set up, we can issue the `rsync` command to sync our two directories:

```bash
$ rsync -a -u -v -h -z drosophila/ training@remote-machine:drosophila/
```

The options used with `rsync` in this case mean:

- `-a` (or `--archive`) sets `rsync` to synchronise only the files that changed (have a different timestamp) between the two locations, and it also preserves filesystem metadata (which is useful if you want to sync a copy back to the original location later). 
- `-u` (or `--update`) makes sure only files that are _newer_ in the source directory are transferred. 
  This may be desirable to set in case you have newer versions in the destination folder that you don't want to overwrite with older versions locally. 
- `-v` (or `--verbose`) outputs status information during the transfer. 
  This is helpful when running the command interactively but should generally be removed when writing scripts.
- `-h` (or `--human-readable`) prints file sizes in human readable format.
- `-z` (or `--compress`) will compress the data in transit. 
  This is good practice depending on the speed of your connection (although in our case it is a little unecessary).

Whilst we've used `rsync` in mostly the same way as we did `scp`, it has many more customisation options as we can observe on the manual page `man rsync`. 
For example, the options `--exclude` and `--include` can be used to more granularly control which files are copied. 
Finally `--delete` is very useful when you want to maintain an exact copy of the source including the deletion of files only present in the destination. 
Let's tidy up our `drosophila` directory with this option.

> ## How to remove files using rsync --delete
>
> First we should manually delete our local copies of the empty files we created.
>
> ```
> $ rm salmon/newfile*
> ```
>{: .language-bash}
>
> consulting the output of `man rsync` synchronize the local folder with the remote folder again. This time causing the remote copies of newfile* to be deleted.
>
> keep in mind that for rsync a path with a trailing `/` means the contents of a directory rather than the directory itself.
> Think about how using the `--delete` flag could make it very dangerous to make this mistake.
>
> Don't worry too much though, you can always upload a new copy of the data.
>
> > ## Solution
> > ```
> > rsync -avz --delete salmon training@remote-machine:/home/ubuntu/salmon
> > ```
> {: .solution}
{: .challenge}

## SshFs

Sshfs is another way of using the same ssh protocol to share files in a slightly different way. This software allows us to connect the file system of one machine with the file system of another using a "mount point". Let's start by making a directory in `/home/ubuntu/Desktop/data-shell` to act as this mount point. Convention tells us to call it `mnt`.

```
$ mkdir /home/ubuntu/Desktop/data-shell/mnt
```
{: .language-bash}

Now we can run the `sshfs` command

```
$ sshfs training@remote-machine:/home/ubuntu /home/ubuntu/Desktop/data-shell/mnt/
```
{: .language-bash}

It looks fairly similar to the previous copying commands. The first argument is a remote source, the second argument is a local destination. The difference is that now whenever we interact with our local mount point it will be as if we were interacting with the remote filesystem starting at the directory we specified `/home/sshuser`.

```
$ cd /home/ubuntu/Desktop/data-shell/mnt/ 
$ ls -l
```
{: .language-bash}

```
total 8
-rw-r--r-- 1 brewmaster brewmaster    0 Sep 30 07:07 file1
-rw-r--r-- 1 brewmaster brewmaster   95 Sep 30 05:36 notes.txt
-rw-r--r-- 1 brewmaster brewmaster    0 Sep 30 08:05 test
drwxr-xr-x 1 brewmaster brewmaster 4096 Sep 30 07:30 salmon
```


The files shown are not on the local machine at all but we can still access and edit them. Much like the concept of a shared network drive in Windows.

This approach is particularly useful when you need to use a program which isn't available on the remote server to edit or visualize files stored remotely. Keep in mind however, that every action taken on these files is being encrypted and sent over the network. Using this approach for computationally intense tasks could substantially slow down the time to completion.

It's also worth noting that this isn't the only way to mount remote directories in linux. Protocols such as [nfs](https://en.wikipedia.org/wiki/Network_File_System) and [samba](https://en.wikipedia.org/wiki/Samba_(software)) are actually more common and may be more appropriate for a given use case. Sshfs has the advantage of running over ssh so it require very little set up on the remote computer.

## Wget - Accessing web resources

Wget is in a different category of command compared to the others in this section. It is mainly for accessing resources that can be downloaded over http(s) and doesn't have a mechanism for uploading/pushing files.

Whilst this tool can be customised to do a wide range of tasks at its simplest it can be used to download datasets for processing at the start of a processing pipeline.

The data for this course can be downloaded as follows

```
$ wget https://github.com/cambiotraining/UnixIntro/raw/master/data/data-shell.zip -O course_data.zip
```
{: .language-bash}

```
--2019-09-30 08:28:50--  https://github.com/cambiotraining/UnixIntro/raw/master/data/data-shell.zip
Resolving github.com (github.com)... 140.82.118.3
Connecting to github.com (github.com)|140.82.118.3|:443... connected.
HTTP request sent, awaiting response... 302 Found
Location: https://raw.githubusercontent.com/cambiotraining/UnixIntro/master/data/data-shell.zip [following]
--2019-09-30 08:28:50--  https://raw.githubusercontent.com/cambiotraining/UnixIntro/master/data/data-shell.zip
Resolving raw.githubusercontent.com (raw.githubusercontent.com)... 151.101.16.133
Connecting to raw.githubusercontent.com (raw.githubusercontent.com)|151.101.16.133|:443... connected.
HTTP request sent, awaiting response... 200 OK
Length: 580102 (567K) [application/zip]
Saving to: ‘data-shell.zip’
data-shell.zip      100%[===================>] 566.51K  --.-KB/s    in 0.05s   
2019-09-30 08:28:51 (11.8 MB/s) - ‘data-shell.zip’ saved [580102/580102]
```


For large files or sets of files there are also a few useful flags

`-b` Places the task in the background and writes all output into a log file 

`-c` can be used to resume a download that has failed mid-way

`-i` can take a file with a list of URLs for downloading

Where tools like `wget` shine in particular is in using URLs generated by web-based REST APIs like the one offered by [Ensembl](https://rest.ensembl.org/) .

We can use bash to combine strings and form a valid query URL that meets our requirements.

```
$ wget https://rest.ensembl.org/genetree/member/symbol/homo_sapiens/BRCA2?prune_taxon=9526;content-type=text/x-orthoxml%2Bxml;prune_species=cow
```

> ## When should we use which tool?
>
> Ultimately there is no hard right answer to this and any tool that works, works. That said, can you think of a scenario where you think each of the following might be the best choice.
>
>scp
>rsync
>wget
>
>
> > ## Solution
> > scp - Any time you're copying a file or set of files once and in one direction scp makes sense
> > 
> > rsync - This is a good choice when you need to have a local copy of the whole dataset but there is also relatively frequent communication to update the source/destination. It also makes sense when the dataset gets too large to transfer regularly as a whole. If your rsync use is getting complex consider seperating the more dynamic files for sophisticated version control with something like [git](https://www.git-scm.com/)
> > 
> > wget - Whenever there is a single, canonical, mostly unchanging, web-based source for a piece of data wget is a good choice. Downloading all the data required for a script at the top with a series of wget commands can be good practice to organise your process. If you find wget limiting for this purpose a similar command called `curl` can be slightly more customisable for use in programming
> >
> {: .solution}
{: .challenge}


## Summary

:::highlight

**Key Points**

- 

:::
