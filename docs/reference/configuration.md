# Configuration

## Environment Variables

| Variable | Default | Description |
|----------------------|---------|-------------|
| `AINATIVE_IMAGE` | `ainative:latest` | Docker image name/tag to use |
| `AINATIVE_HOME` | `~/.local/share/ainative` | Directory where ainative stores its files |
| `AINATIVE_NO_BANNER` | unset | Set to any value to suppress the startup banner |
| `AINATIVE_PORT_RANGE` | none (or `.ai-native` value) | Host-published port range; set to `none` to disable |
| `AINATIVE_PORTS` | unset | Comma-separated explicit ports to publish, e.g. `3000,8080:8080` |
| `AINATIVE_NO_PORTS` | unset | Set to `1` to disable the automatic range (explicit ports still work) |

## Project-level `.ai-native` file

Create a `.ai-native` file in your project root (or any parent directory — the launcher walks up from `$PWD`):

```bash
# .ai-native (key=value format)
port_range=3000-3005
ports=5000,8080:8080
```

## Custom credentials template

Override the path with the `CREDS_TEMPLATE` environment variable if your 1Password vault or item names differ from the default template at `~/.config/ainative/credentials.env`.
