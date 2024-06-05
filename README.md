# hnfong's dotfiles

Just some dotfiles, utilities and setup scripts for my personal use.

Feel free to adopt them.

If anyone is concerned about license, this is public domain, except the stuff
that are parts of other OSS projects.

## Highlights

- Generally lightweight and efficient configuration. No heavy use of fancy fonts, overcompensating `PS1`, overengineered nvim plugins, etc.
- Fast git repo name extraction into `$PS1` by avoiding the use of (slow) `git status`
- Automatically try to tell user about completion of long running command (see `beep_in_background` - note: misnomer by now, only works in macOS)
- `magic_open`, which does a bit of magic with opening files in nvim (see comments in the script)
- Lovingly curated (n)vim configuration of 20+ years vintage.
