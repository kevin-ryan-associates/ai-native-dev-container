# CLI Reference

## Commands

| Command | Description |
|---------|-------------|
| `ainative` | Launch an interactive zsh shell in the current directory |
| `ainative nvim .` | Open the current directory in Neovim |
| `ainative build` | Build (or rebuild) the Docker image explicitly |
| `ainative update` | Rebuild with refreshed base images |

## Flags and Environment Variables

| Flag / variable | Description |
|-----------------|-------------|
| `.ai-native` keys | `port_range=RANGE` / `ports=SPEC1,SPEC2` — project-local defaults. |
| `-p`, `--port SPEC` | Publish one port (`3000`, `8080:8080`, `127.0.0.1:5432:5432`). Repeatable. |
| `--port-range RANGE` | Override the configured/default range. |
| `AINATIVE_IMAGE` | `ainative:latest` — Docker image name/tag to use |
| `AINATIVE_HOME` | `~/.local/share/ainative` — Directory where ainative stores its files |
| `AINATIVE_NO_BANNER` | Set to any value to suppress the startup banner |
| `AINATIVE_PORT_RANGE` | Default from config or none; set to `none` to disable |
| `AINATIVE_PORTS` | Comma-separated explicit ports, e.g. `3000,8080:8080` |
| `AINATIVE_NO_PORTS` | Set to `1` to disable the automatic range (explicit ports still work) |
