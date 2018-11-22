# vimsa

The [VIM](https://www.vim.org/)-based [multiple sequence alignment (MSA)](https://en.wikipedia.org/wiki/Multiple_sequence_alignment) editor.

## Installation

Obtain the script file `vimsa` from this repository, make it executable and put in any of the directories from your `$PATH` (e.g. `/usr/local/bin`). E.g.:

```
sudo curl -o /usr/local/bin/vimsa https://raw.githubusercontent.com/sgtpep/vimsa/master/vimsa
sudo chmod +x /usr/local/bin/vimsa
```

This script requires [VIM](https://www.vim.org/) or [Neovim](https://neovim.io/) to be installed and available as `vim` or `nvim` in your shell.

## Usage

Just open the file in [FASTA format](https://en.wikipedia.org/wiki/FASTA_format):

```
vimsa /path/file.fasta
```

`vimsa` also accepts input from standard input and writes the result to standard output, so it can be used in shell pipes:

```
cat /path/file.fasta | vimsa
vimsa < /path/file.fasta
```

To edit a comment to the sequence move the cursor to its line and press `gc`, edit the text in an opened split view and press `ZZ`.

## Features

- Reads and writes files in [FASTA format](https://en.wikipedia.org/wiki/FASTA_format).
- Reads input in [FASTA format](https://en.wikipedia.org/wiki/FASTA_format) from standard input and writes the result to standard output to be used in shell pipes.

## License and copyright

The project is released under the General Public License (GPL), version 3.

Copyright © 2018, Danil Semelenov, Stas Malavin.
