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
drosophila_genome.fa                          100%  139MB 311.7MB/s   00:00    
SRR307030_1.fastq.gz                          100%  441KB 177.3MB/s   00:00    
SRR307026_2.fastq.gz                          100%  323KB 215.2MB/s   00:00    
SRR307029_1.fastq.gz                          100%  444KB 199.4MB/s   00:00    
SRR307027_1.fastq.gz                          100%  413KB 204.2MB/s   00:00    
SRR307025_1.fastq.gz                          100%  414KB 219.9MB/s   00:00    
SRR307027_2.fastq.gz                          100%  426KB 186.3MB/s   00:00    
SRR307024_1.fastq.gz                          100%  389KB 162.0MB/s   00:00    
SRR307025_2.fastq.gz                          100%  323KB 173.5MB/s   00:00    
SRR307028_2.fastq.gz                          100%  419KB 204.1MB/s   00:00    
SRR307030_2.fastq.gz                          100%  453KB 225.2MB/s   00:00    
SRR307023_2.fastq.gz                          100%  328KB 199.3MB/s   00:00    
SRR307028_1.fastq.gz                          100%  399KB 193.1MB/s   00:00    
SRR307029_2.fastq.gz                          100%  461KB 229.3MB/s   00:00    
SRR307024_2.fastq.gz                          100%  323KB 219.9MB/s   00:00    
SRR307026_1.fastq.gz                          100%  408KB 197.7MB/s   00:00    
SRR307023_1.fastq.gz                          100%  408KB 228.2MB/s   00:00 
```

However `scp` isn't always the best tool to use for managing this kind of operation. 
When you run `scp` it copies the entirety of every single file you specify _even if it already exists_ in the destination. 
For an initial copy this is probably what you want, but if you change only a few files and want to synchronize the server copy to keep up with your changes it wouldn't make sense to copy the entire directory structure again.

For this scenario **`rsync`** can be an excellent tool. 

First, we will add some new files to our remote `drosophila` directory using the `touch` command. 
This command does nothing but create an empty file or update the timestamp of an existing file.

```bash
$ ssh training@remote-machine "touch ~/drosophila/new_file1.txt ~/drosophila/new_file2.txt ~/drosophila/new_file3.txt"
```

Now we have everything set up, we can issue the `rsync` command to sync our two directories:

```bash
$ rsync -a -u -v -h -z training@remote-machine:drosophila/ drosophila/
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

::: {.callout-warning}
When you specify the _source_ directory as `path/to/source/` (with `/` at the end) or `path/to/source` (without `/` at the end), `rsync` will do different things:

- `path/to/source_folder/` will copy the files *within* `source_folder` but not the folder itself
- `path/to/source_folder` will copy the actual `source_folder` as well as all the files within it
:::

Whilst we've used `rsync` in mostly the same way as we did `scp`, it has many more customisation options as we can observe on the manual page `man rsync`. 
For example, the options `--exclude` and `--include` can be used to more granularly control which files are copied. 
Another option, `--delete`, is useful when you want to maintain an exact copy of the source including the deletion of files only present in the destination. 

One important option that we can use is `--dry-run`, which performs a **dry run** indicating what would have been transferred or deleted by `rsync`, but without actually doing it. 
This can be extremely useful to check that we have specified our command correctly, before actually running it (and accidentally sync the wrong files!).


## Exercise: `rsync --delete`

Let's tidy up our local `drosophila` directory by deleting the empty files we created earlier:

```bash
$ rm drosophila/new_file*
```

Now, let's synchronise this copy of the folder with the copy on the remote machine, including the removal of these files. 
We can use the `--delete` flag to do this.  
Try and build the `rsync` command to perform this operation. 
Keep in mind that for rsync a path with a `/` at the end means the _contents_ of a directory rather than the directory itself.
Also, make sure to use `--dry-run` first to check what your command would do, before actually running it.

::: {.callout-tip collapse=true}
#### Answer

For checking whether we are specifying our command with the `--delete` flag correctly, we can first do a dry-run (which will indicate what `rsync` would do, but without actually doing it): 

```bash
$ rsync --dry-run -auvz --delete drosophila/ training@remote-machine:drosophila/
```

```
sending incremental file list
deleting new_file2.txt
deleting new_file1.txt
./

sent 453 bytes  received 55 bytes  203.20 bytes/sec
total size is 152,792,450  speedup is 300,772.54 (DRY RUN)
```

From this output we can see that this command would delete the new files, since they now don't exist in our local folder anymore. 
Once we're happy with the list of files that are transferred or deleted, we can then run our command without the `--dry-run` option:

```bash
$ rsync -auvz --delete drosophila/ training@remote-machine:drosophila/
```

And we could check back on our remote server that those files are now gone and the two folders are synced with each other. 

:::


## SSHFS

SSHFS is another way of using the same SSH protocol to share files in a slightly different way. 
This software allows us to connect the file system of one machine with the file system of another using a "mount point". 
Let's start by making a directory in `~/Desktop/data-shell` to act as this mount point. 
Convention tells us to call it `mnt`:

```bash
$ mkdir mnt
```

Now we can run the `sshfs` command like this:

```bash
$ sshfs training@remote-machine:/home/training /home/ubuntu/Desktop/data-shell/mnt/
```

It looks fairly similar to the previous copying commands. 
The first argument is a remote source, the second argument is a local destination. 
The difference is that now whenever we interact with our local mount point it will be as if we were interacting with the remote filesystem starting at the directory we specified.

```bash
$ cd /home/ubuntu/Desktop/data-shell/mnt/ 
$ ls -l
```

```
total 12K
-rwxr-xr-x 1 1001 1001  563 Oct 18 10:14 README.txt
drwxr-xr-x 1 1001 1001 4.0K Oct 18 13:47 drosophila
-rwxr-xr-x 1 1001 1001  611 Oct 17 14:30 drosophila_samples.csv
```

The files shown are not on the local machine at all but we can still access and edit them. Much like the concept of a shared network drive in Windows.

This approach is particularly useful when you need to use a program which isn't available on the remote server to edit or visualize files stored remotely. 
Keep in mind however, that every action taken on these files is being encrypted and sent over the network. 
Using this approach for computationally intense tasks could substantially slow down the time to completion.

It's also worth noting that this isn't the only way to mount remote directories in linux. 
Protocols such as [nfs](https://en.wikipedia.org/wiki/Network_File_System) and [samba](https://en.wikipedia.org/wiki/Samba_(software)) are actually more common and may be more appropriate for a given use case. 
SSHFS has the advantage of running over SSH so it requires very little set up on the remote computer.


## Downloading Web Resources

Oftentimes we may want to download data from a web resource. 
For this, we can use the software `wget`, which is mainly used for accessing resources that can be downloaded over http(s) and doesn't have a mechanism for uploading/pushing files.

Whilst this tool can be customised to do a wide range of tasks at its simplest it can be used to download datasets for processing at the start of an analysisi pipeline.

For example, the data for this course can be downloaded as follows:

```bash
$ wget -O course_data.zip https://www.dropbox.com/sh/d9kjkq0053uyxxc/AAAzFpD0NfUmxvoQxeZRpMw8a?dl=1
```

```
--2022-10-18 14:13:22--  https://www.dropbox.com/sh/d9kjkq0053uyxxc/AAAzFpD0NfUmxvoQxeZRpMw8a?dl=1
Resolving www.dropbox.com (www.dropbox.com)... 162.125.64.18, 2620:100:6020:18::a27d:4012
Connecting to www.dropbox.com (www.dropbox.com)|162.125.64.18|:443... connected.
HTTP request sent, awaiting response... 302 Found
Location: /sh/dl/d9kjkq0053uyxxc/AAAzFpD0NfUmxvoQxeZRpMw8a [following]
Resolving uc1bdbe8464e973f3d5adb36ffdb.dl-eu.dropboxusercontent.com (uc1bdbe8464e973f3d5adb36ffdb.dl-eu.dropboxusercontent.com)... 162.125.64.15, 2620:100:6020:15::a27d:400f
Connecting to uc1bdbe8464e973f3d5adb36ffdb.dl-eu.dropboxusercontent.com (uc1bdbe8464e973f3d5adb36ffdb.dl-eu.dropboxusercontent.com)|162.125.64.15|:443... connected.
HTTP request sent, awaiting response... 200 OK
Length: 60215338 (57M) [application/zip]
Saving to: course_data.zip

course_data.zip                   100%[===========================================================>]  57.43M  60.5MB/s    in 0.9s    

2022-10-18 14:13:25 (60.5 MB/s) - course_data.zip saved [60215338/60215338]
```

This downloads the zip file from Dropbox and saves it with the name `course_data.zip` (which we set with the `-O` option). 
For large files or sets of files there are also a few useful flags:

- `-b` runs the task in the background and writes all output into a log file 
- `-c` can be used to resume a download that has failed mid-way
- `-i` can take a file with a list of URLs for downloading

Where tools like `wget` shine in particular is in using URLs generated by web-based REST APIs like the one offered by [Ensembl](https://rest.ensembl.org/).

If you find `wget` limiting for this purpose, a similar command called `curl` can be slightly more customisable for use in programming. 
Here is the `curl` command used to simply download a file:

```bash
$ curl -o course_data.zip -L https://www.dropbox.com/sh/d9kjkq0053uyxxc/AAAzFpD0NfUmxvoQxeZRpMw8a?dl=1
```


## Summary

::: {.callout-tip}
#### Key Points

- `rsync` can be used to _synchronise_ files between a local directory and a remote server. 
  This is a flexible tool, allowing for more customisation compared to a simpler command such as `scp`. 
- `sshfs` can be used to _mount_ a remote directory directly on the local computer, allowing us to interact with the files in the remote server as if they were a new drive on your computer.  
  `sshfs` should not be used for compute-heavy operations, as the data is being communicated over the network, making it slower for heavier work.
- `wget` and `curl` can be used to download static content from web-based resources. 

:::
