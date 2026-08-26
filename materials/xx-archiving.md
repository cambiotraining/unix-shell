# Archiving

::: {.callout-tip}
## Learning Objectives

- TODO
:::

## Archiving and compression

An **archive file** is essentially a single file that bundles multiple files and directories within it.
You will have previously encountered directory archives, for example in the popular ZIP format.
Archive files are useful to distribute and share large numbers of (sometimes large) files, and are a commonplace in computational work.

Some archive file formats - such as ZIP - also support **data compression**, using an algorithm that reduces the total size of the final archive.
Although this adds a computational cost in compressing/decompressing the file (which takes time), it can reduce the total size substantially and thus reduce the amount of storage needed for the file.

In computational research, these are the most popular file formats you will encounter:

- `.zip` → an archive format which also supports data compression.
- `.tar` → an archive format only.
- `.gz` → the file format for the **gzip** compression algorithm.
- `.tar.gz` → the combination of the **tar** archive with **gzip** compression, effectively resulting in a compressed archive (much like ZIP)

## ZIP commands

The syntax to package and (optionally) compress a file with the ZIP algorithm is:

```bash
zip your_archive.zip file1 file2 folder1/ folder2/
```

The command also supports several options, of which we highlight:

- `-r` to archive files recursively including directory and subdirectory within any input folders.
  In the example above, `zip` would not archive the contents of `folder1/` and `folder2/` - it would simply include them as empty directories in the archive.
  The `-r` option ensures everything within those folders is included.
- Numbers `-0` to `-9` determine the compression level that ZIP uses.
  `-0` means no compression is applied, which can be useful if all you want is to archive the files quickly.
  `-9` is the highest compression level, leading to most space saved, but also longer compute time to compress (and decompress) the file.
  The default is `-6`, which means a medium compression is applied.

Once you have an archive, you can unpack it using `unzip`:

```bash
unzip your_archive.zip
```

To learn more about ZIP look at the excellent [tutorial on the GeeksforGeeks page](https://www.geeksforgeeks.org/linux-unix/zip-command-in-linux-with-examples/).

## Tar commands

The other popular archiving program is `tar`.
Its basic syntax is:

```bash
tar -cvf your_archive.tar file1 file2 folder1/ folder2/
```

The options here mean:

- `-c` create an archive
- `-v` use verbose output, which lists all the files that are included in the archive
- `-f` name for the archive file

The `tar` command also supports adding a compression with Gzip, using the option `-x`.
So, the equivalent command would be:

```bash
tar -czvf your_archive.tar.gz file1 file2 folder1/ folder2/
```

- `-z` option indicates we want compression with Gzip.
- We also use `.tar.gz` file extension to indicate this is now a compressed tar archive.

To extract the files from the archive you use the `-x` (e**x**tract) option:

```bash
# without compression
tar -xvf your_archive.tar

# with compression include -z option
tar -xzvf your_archive.tar.gz
```

### Gzip commands

Above, we've seen how to create an archive that is also compressed using the Gzip algorithm.
However, you may sometimes want to compress or decompressed single files.

To compress a single file, use `gzip`:

```bash
gzip file.txt
```

This will automatically create a file named `file.txt.gz`.
Note that the original is not kept.
If you want to keep the original file, use the `-k` option.

To decompress a file you can use:

```bash
gzip -d file.txt.gz
```

Some Unix distributions also provide the shortcut `gunzip` command, which has the same effect as above.

As with the `unzip` command, this will not keep the original file.
If you want to keep the original, add the `-k` option to the command.

::: {.callout-tip}
#### Inspecting the content of `.gz` files

You can inspect the content of text-based gzip-compressed files without actually decompressing them:

- The `zcat` (or `gzcat` on macOS) command behaves as the standard `cat`.
- The `less` command supports gzip-compressed files, opening them for view without the need to decompress them first.
:::

## File integrity

Ensuring file integrity is essential when you download data from public servers, or when you transfer data between filesystems.
There are several algorithms designed to create a file "fingerprint" (known as a cryptographic hash), which enables you to check if the file you copied or downloaded corresponds to the original file.

There are two commonly-used hash algorithms:

- MD5, with the command `md5sum`.
  This is an older fingerprinting algorithm and nowadays considered unsafe for sensitive files (for example, two files may have the same fingerprint, which poses a security issue).
  However, it is fast and so very popular when the sole objective is to ensure the integrity of a file from relatively trusted sources.
- SHA-256, with the command `sha256sum`.
  This is a more secure algorithm, but slower to run and so only used for more sensitive files.

Both commands allow you to do two things:

- Create a fingerprint for a file
- Check if a fingerprint matches a given file

Let's take as an example the file `README.txt` our `data-shell` folder.
To create a MD5 hash for this file:

```bash
md5sum README.txt
```

```output
500a44678a779f6ca171f960c4eb1c8e  README.txt
```

The characters you see before the file name are the MD5 hash (its fingerprint).
We can save this output to a file using the `>` redirect operator, so that we can check its integrity later:

```bash
md5sum README.txt >md5.txt
```

Now, to check the file integrity, you can use the `-c` ("check") option with the text file we just created:

```bash
md5sum -c md5.txt
```

```
README.txt: OK
```

Now, let's change the content of the file as a test for the integrity:

```bash
echo "testing MD5" >>README.txt

md5sum -c md5.txt
```

```output
README.txt: FAILED
md5sum: WARNING: 1 computed checksum did NOT match
```

As you can see, the check now failed, because the modified file no longer matches the original file from which we created the MD5 hash.

The `sha256sum` command works in very much the same way.
You can also create a fingerprint for multiple files at once, by giving them as an input to the commands (or using the `*` wildcard).

::: {.callout-tip collapse=true}
#### For bioinformatics users: check the integerity of your sequencing files

For those doing bioinformatics, and in particular sequencing using a company, you may have noticed that often a file named `md5.txt` (or something similar) is provided with your FASTQ files.
The file can be used to check the integrity of your downloaded files using the command we just shown.

Always do this check - you've paid for your expensive data, so make sure that it is intact after you get it from the company!
:::

## Exercises

::: {.callout-exercise}
{{< level 1 >}}

Working from the `~/Desktop/data-shell` directory:

1. Create a tar archive of the `hospital_records` directory without compression.
2. Create a tar gzip-compressed archive of the same directory.
3. Use the `du` (disk usage) command to compare the sizes of the archive files compared to the original folder

::::: {.callout-answer}
1. We create a `tar` archive with:

```bash
tar -cvf hospital_records.tar hospital_records/
```

2. We create a `tar.gz` archive with:

```bash
tar -czvf hospital_records.tar.gz hospital_records/
```

3. We compare their sizes and the size of the original directory

```bash
du -h hospital_records*
```

```output
51M   hospital_records
51M   hospital_records.tar
4.6M  hospital_records.tar.gz
```

We can see that the simple `.tar` archive is essentially the same size as the original folder - this is because all `tar` is doing is bundling those files into a single file.
When compressed with `gzip` we reduce the size by at least an order of magnitude.
:::::
:::

## Summary

::: {.callout-tip}
#### Key points

- TODO
:::
