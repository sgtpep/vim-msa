# vim-msa

The VIM-based multiple sequence alignment (MSA) editor.

## Installation

Obtain the script file `vim-msa` from this repository, make it executable and put in any of the directories from your `$PATH` (e.g. `/usr/local/bin`). E.g.:

```
sudo curl -o /usr/local/bin/vim-msa https://raw.githubusercontent.com/sgtpep/vim-msa/master/vim-msa
sudo chmod +x /usr/local/bin/vim-msa
```

This script requires VIM to be installed and available as `vim` in your shell.

## Usage

Just open the file in FASTA format:

```
vim-msa /path/file.fasta
```

`vim-msa` also accepts input from standard input and writes the result to standard output, so it can be used in shell pipes:

```
cat /path/file.fasta | vim-msa
vim-msa < /path/file.fasta
```

To edit a comment to the sequence move the cursor to its line and press `gc`, edit the text in an opened split view and press `ZZ`.

## Features

- Reads and writes files in [FASTA format](https://en.wikipedia.org/wiki/FASTA_format).
- Reads input in FASTA format from standard input and writes the result to standard output to be used in shell pipes.

## License and copyright

The project is released under the General Public License (GPL), version 3.

Copyright © 2018, Danil Semelenov, Stas Malavin.

```

```
