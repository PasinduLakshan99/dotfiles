# Dotfiles

This repository contains my personal dotfiles, managed using a Git bare repository approach without symlinks.

## Setup Instructions

### Initial Setup (On Your Main Machine)

1. Create a bare Git repository:
   ```bash
   git init --bare $HOME/.dotfiles
   ```

2. Create an alias for easier management:
   ```bash
   alias dotfiles='git --git-dir=$HOME/.dotfiles --work-tree=$HOME'
   ```

3. Add the alias to your shell configuration file:
   ```bash
   echo "alias dotfiles='git --git-dir=$HOME/.dotfiles --work-tree=$HOME'" >> $HOME/.bashrc
   # or for zsh
   # echo "alias dotfiles='git --git-dir=$HOME/.dotfiles --work-tree=$HOME'" >> $HOME/.zshrc
   ```

4. Configure Git to hide untracked files (essential for this setup):
   ```bash
   dotfiles config --local status.showUntrackedFiles no
   ```

5. Add your dotfiles:
   ```bash
   dotfiles add ~/.vimrc ~/.bashrc ~/.tmux.conf # etc.
   dotfiles commit -m "Initial dotfiles commit"
   ```

6. Add a remote repository:
   ```bash
   dotfiles remote add origin git@github.com:yourusername/dotfiles.git
   dotfiles push -u origin main
   ```

### Installation (On a New Machine)

1. Clone the bare repository:
   ```bash
   git clone --bare git@github.com:yourusername/dotfiles.git $HOME/.dotfiles
   ```

2. Create the alias:
   ```bash
   alias dotfiles='git --git-dir=$HOME/.dotfiles --work-tree=$HOME'
   ```

3. Hide untracked files:
   ```bash
   dotfiles config --local status.showUntrackedFiles no
   ```

4. Checkout the dotfiles:
   ```bash
   dotfiles checkout
   ```
   
   If this fails due to existing files, you can either:
   - Back up the conflicting files:
     ```bash
     mkdir -p ~/.dotfiles-backup
     dotfiles checkout 2>&1 | grep -E "\s+\." | awk {'print $1'} | xargs -I{} mv {} ~/.dotfiles-backup/{}
     dotfiles checkout
     ```
   - Or manually resolve each conflict

5. Source your shell configuration file:
   ```bash
   source ~/.bashrc  # or source ~/.zshrc
   ```

## Usage

- Add a file: `dotfiles add ~/.some-config`
- Commit changes: `dotfiles commit -m "Add/update some-config"`
- Push changes: `dotfiles push`
- Pull changes: `dotfiles pull`
- Check status: `dotfiles status`

## Notes

- Custom Terminal Startup command : 

      `zsh -c '/home/lucky/applications/custom-terminal-startup.sh "$PWD"'`

## Tips

- Only explicitly added files are tracked
- You can add individual files from directories without tracking the entire directory
- When adding new dotfiles, remember to add them to the repository explicitly
- Keep sensitive information in separate files that are not tracked by Git
