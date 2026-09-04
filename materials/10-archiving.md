# Archiving

::: {.callout-tip}
### Learning Objectives

- Distinguish between archive formats and compression formats and choose the appropriate one for your goals.
- Create and extract `.zip`, `.tar`, and `.tar.gz` archives with the correct command-line options.
- Use `gzip` and cryptographic hashes to compress files and verify that data has not changed.
:::

## Archiving and compression

An **archive file** bundles multiple files and directories into one file.
You may already have used directory archives in the popular ZIP format.
Archives make it easier to distribute and share many files, and they are common in computational work.

Some archive formats, such as ZIP, also support **data compression**.
A compression algorithm reduces the size of the resulting file.
Compression and decompression require additional computation, but the smaller file needs less storage and may transfer more quickly.

These are the formats you are most likely to encounter in computational research:

- `.zip` is an archive format that also supports compression.
- `.tar` is an archive format without compression.
- `.gz` is the format produced by the **gzip** compression algorithm.
- `.tar.gz` combines a `tar` archive with gzip compression to produce a compressed archive, similar to a ZIP file.

## Creating and extracting ZIP archives

Use this syntax to package files and directories in a ZIP archive:

```bash
zip your_archive.zip file1 file2 folder1/ folder2/
```

The `zip` command supports several useful options:

- `-r` archives files recursively, including files in directories and their subdirectories.
  Without `-r`, `zip` includes the directory entries but not their contents.
- Numbers from `-0` to `-9` set the compression level.
  `-0` skips compression, which can create the archive quickly.
  `-9` applies the highest compression level, which usually saves the most space but takes longer.
  The default level is `-6`.

Extract a ZIP archive with `unzip`:

```bash
unzip your_archive.zip
```

For more ZIP examples, see the [GeeksforGeeks tutorial](https://www.geeksforgeeks.org/linux-unix/zip-command-in-linux-with-examples/).

## Creating and extracting tar archives

The other common archiving program is `tar`.
Create an uncompressed archive with:

```bash
tar -cvf your_archive.tar file1 file2 folder1/ folder2/
```

The options mean:

- `-c` creates an archive.
- `-v` enables verbose output, which lists each file as `tar` adds it.
- `-f` specifies the archive file name.

You can also add gzip compression with the `-z` option:

```bash
tar -czvf your_archive.tar.gz file1 file2 folder1/ folder2/
```

- The `-z` option tells `tar` to use gzip compression.
- The `.tar.gz` extension indicates that the file is a gzip-compressed tar archive.

Use the `-x` option to extract files from an archive:

```bash
# without compression
tar -xvf your_archive.tar

# with compression include -z option
tar -xzvf your_archive.tar.gz
```

### Compressing individual files with gzip

You can also use gzip to compress an individual file rather than creating an archive.

Compress a file with `gzip`:

```bash
gzip file.txt
```

This command creates `file.txt.gz` and removes the original `file.txt`.
Use the `-k` option if you want to keep the original file.

Decompress a gzip file with:

```bash
gzip -d file.txt.gz
```

Some Unix distributions also provide `gunzip`, which has the same effect.
The decompression command removes the compressed file after it creates the original file.
Use `-k` to keep the compressed file as well.

::: {.callout-tip}
#### Inspecting the contents of `.gz` files

You can inspect text-based gzip files without decompressing them first:

- `zcat` (or `gzcat` on macOS) displays the contents like the standard `cat` command.
- `less` (or `zless` on macOS) can open gzip-compressed files directly for viewing.
:::

## Checking file integrity with hashes

Ensuring file integrity is essential after downloading data from a public server or transferring data between filesystems.
We can ensure integrity by using a **cryptographic hash**, which acts as a fingerprint for a file.
Comparing the hash of a copied or downloaded file with the original hash shows whether the file changed during transfer.

Two commonly used hash algorithms are:

- **MD5**, generated with `md5sum`.
  MD5 is an older algorithm and is unsafe for security-sensitive uses because different files can produce the same hash.
  However, it's fast and still popular for checking files from relatively trusted sources.
- **SHA-256**, generated with `sha256sum`.
  SHA-256 provides stronger protection against collisions than MD5, but takes longer to calculate.

Both commands can create a hash for a file and check a file against a recorded hash.

For example, from the `data-shell` folder, create an MD5 hash for `README.txt`:

```bash
md5sum README.txt
```

```output
500a44678a779f6ca171f960c4eb1c8e  README.txt
```

The characters before the file name form the MD5 hash.
Save the command's output to a file with the `>` redirection operator so that you can check the file later:

```bash
md5sum README.txt > md5.txt
```

Use the `-c` ("check") option with the recorded hash file to check the file's integrity:

```bash
md5sum -c md5.txt
```

```
README.txt: OK
```

To test the check, change the contents of `README.txt` and run the check again:

```bash
echo "testing MD5" >> README.txt

md5sum -c md5.txt
```

```output
README.txt: FAILED
md5sum: WARNING: 1 computed checksum did NOT match
```

The check fails because the modified file no longer matches the file used to create the recorded MD5 hash.
The `sha256sum` command works in the same way.
You can also create hashes for several files at once by listing their names or using the `*` wildcard.

::: {.callout-tip collapse=true}
#### For bioinformatics users: check the integrity of sequencing files

When a sequencing company supplies FASTQ files, it often also provides a file named `md5.txt` or something similar.
Use this file to check that your downloaded files match the files supplied by the company.

Run the check after downloading your data so that you can detect an incomplete or corrupted transfer before analysing the files.
:::

## Exercises

::: {.callout-exercise}
{{< level 1 >}}

Working from `~/Desktop/data-shell`, do the following for the `hospital_records` directory:

1. Create an uncompressed tar archive called `hospital_records.tar`
2. Create a gzip-compressed tar archive called `hospital_records.tar.gz`
3. Create a zip archive called `hospital_records.zip`
4. Use the command `du -h hospital_records*` to compare the archive sizes with the original directory.
   (Note: `du` is the disk usage command)

::::: {.callout-answer}
1. Create an uncompressed `tar` archive:

```bash
tar -cvf hospital_records.tar hospital_records/
```

2. Create a gzip-compressed `tar.gz` archive:

```bash
tar -czvf hospital_records.tar.gz hospital_records/
```

3. Create a zip archive (compresses by default):

```bash
zip hospital_records.zip hospital_records/
```

4. Compare the sizes of the original directory and the archives:

```bash
du -h hospital_records*
```

```output
51M hospital_records
51M hospital_records.tar
4.6M  hospital_records.tar.gz
4.7M  hospital_records.zip
```

The uncompressed `.tar` archive is the same size as the original directory because `tar` only bundles the files.
Both Gzip and Zip compression reduce the archive size substantially in this example.
:::::
:::

## Summary

::: {.callout-tip}
### Key Points

- Archive files bundle multiple files into a single file.
  These files can be compressed to reduce their size.

- `zip`, `tar`, and `gzip` are the most common tools used, summarised in the table below.

  | Command     | Purpose                              | File extension | Extract / Decompress command |
  | ----------- | ------------------------------------ | -------------- | ---------------------------- |
  | `zip`       | Compress files into a ZIP archive    | `.zip`         | `unzip`                      |
  | `tar -cvf`  | Create an uncompressed tar archive   | `.tar`         | `tar -xvf`                   |
  | `tar -czvf` | Create a gzip-compressed tar archive | `.tar.gz`      | `tar -xzvf`                  |
  | `gzip`      | Compress an individual file          | `.gz`          | `gzip -d`                    |

- Hash checks let you verify that files are unchanged after download or transfer.
  - `md5sum` and `sha256sum` generate fingerprints for files.
  - `md5sum -c` and `sha256sum -c` check a recorded hash file against the current file.
:::
