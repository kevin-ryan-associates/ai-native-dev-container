# Project Structure

```
.
├── ainative            # Launcher script
├── install.sh          # Host installation script
├── bin/
│   └── ainative.js     # npm launcher shim (sets AINATIVE_HOME, execs the bash script)
├── package.json        # npm package manifest
└── docker/
    ├── Dockerfile          # Container definition
    ├── entrypoint.sh       # UID/GID remapping entrypoint
    └── home/
        ├── .zshrc          # Zsh configuration
        ├── .config/
        │   ├── starship.toml
        │   ├── bat/
        │   ├── lazygit/
        │   └── ainative/
        └── nvim-overlay/   # AstroNvim plugin customisations
```
