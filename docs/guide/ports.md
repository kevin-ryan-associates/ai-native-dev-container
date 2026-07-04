# Port Forwarding

By default, `ainative` publishes **no ports**. Forwarding is opt-in via a project `.ai-native` file, environment variables, or CLI flags.

Create a `.ai-native` file in your project root (or any parent directory — the launcher walks up from `$PWD`):

```bash
# .ai-native (key=value format)
port_range=3000-3005
ports=5000,8080:8080
```

```bash
# Inside the container:
python3 -m http.server 3005
# On the host (another terminal):
curl localhost:3005   # works because 3005 is in the configured range
```

## Docker-in-Docker chaining

The inner `dockerd` runs in the container's network namespace, so a service started with inner `docker compose` (or `docker run -p`) that publishes a port inside a configured range is *also* forwarded to the host automatically. Ports outside the range are only forwarded if published explicitly.

```bash
# Inside the container — forwarded because 3000 is in the range:
docker run --rm -p 3000:3000 nginx
# On the host:
curl localhost:3000   # works
```

## Override or disable forwarding

```bash
# Forward a different range via CLI
ainative --port-range 5000-5999
# Or via env var
AINATIVE_PORT_RANGE=5000-5999 ainative

# Add an explicit port (additive; repeatable)
ainative -p 5432:5432
ainative -p 5432:5432 -p 8080 nvim .

# Disable the automatic range (explicit -p still works)
AINATIVE_NO_PORTS=1 ainative
AINATIVE_PORT_RANGE=none ainative

# Bind a single port to localhost only
ainative -p 127.0.0.1:5432:5432
```

## Reference table

| Flag / variable | Effect |
|-----------------|--------|
| `.ai-native` keys | `port_range=RANGE` / `ports=SPEC1,SPEC2` — project-local defaults. |
| `-p`, `--port SPEC` | Publish one port (`3000`, `8080:8080`, `127.0.0.1:5432:5432`). Repeatable. |
| `--port-range RANGE` | Override the configured/default range. |
| `AINATIVE_PORT_RANGE` | Default from config or none; set to `none` to disable. |
| `AINATIVE_PORTS` | Comma-separated explicit ports, e.g. `3000,8080:8080`. |
| `AINATIVE_NO_PORTS` | Set to `1` to disable the automatic range (explicit ports still work). |

::: warning
Publishing a very large range (e.g. `3000-3999` = 1000 ports) can make the container appear to hang on startup because Docker binds every port and spawns a proxy process for each one before the entrypoint runs. Keep ranges small.
:::

::: info Why not `--network host`?
On Linux it would forward *every* port automatically, but on Docker Desktop for macOS/Windows the container runs in a Linux VM, so `--network host` binds to the VM — ports are **not** reachable on the Mac. Publishing a range is the reliable cross-platform approach.
:::
