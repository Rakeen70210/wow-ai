# Pi integration

This fork adds Pi as a supported agent, including JSON progress, a separate persistent session per chat, and Windows-to-WSL launching. It was tested with Pi 1.5.0.

## Setup

Install and authenticate Pi first, then run the normal wow-ai setup. Edit the generated `bridge/config.json` to set `"agent": "pi"` and add a block under `agents`.

For a native Pi installation:

```json
"pi": {
  "path": "",
  "model": "",
  "extraArgs": ["--thinking", "medium"]
}
```

An empty path searches PATH for Pi. You may instead supply the CLI JavaScript path or the Windows npm `pi.cmd` launcher. An empty model uses Pi's configured default. Set `model` to a provider/model ID to override it. Omit `--thinking` to inherit Pi's settings (or the resumed session's effort).

For a Windows game and bridge with Pi installed in WSL:

```json
"pi": {
  "path": "C:\\Windows\\System32\\wsl.exe",
  "model": "",
  "wsl": {
    "distribution": "Ubuntu",
    "user": "YOUR_LINUX_USER",
    "piPath": "/home/YOUR_LINUX_USER/.pi/agent/bin/pi"
  },
  "extraArgs": ["--thinking", "medium"]
}
```

Replace the distribution, user, and Pi executable path with your installation. Pi authentication must be available to that WSL user. Keep the capture bridge running with Windows Node.js; WSL is used only for Pi. Chat folders remain Windows paths, which WSL translates for the Pi process. The map-file path is passed through WSLENV for translation as well.

Start `bridge\start-window.cmd`, fully restart WoW after addon installation, enable WoW AI and its slot addons, and use `/wow-ai`. An existing chat that selected another agent can use `/wow-ai agent pi` after connecting, or `/wow-ai agent default`.

## Security

Pi's default tools can run shell commands and modify files without an approval prompt. This integration does **not** implement wow-ai's Claude/Grok permission allowlists or sandbox. Only send trusted instructions. Use a dedicated non-root user where possible. WSL access includes Windows files mounted in WSL; configured Pi extensions and MCP servers may add further tools.

## Windows capture troubleshooting

`capture.ps1` supports fractional `capture.cellPx` values and tries the configured size, 4, and 3.8 pixels, preferring the last size that passed the full checksum. The 3.8-pixel size was observed on a live windowed client; other display configurations may need a different configured value.

The game must stay visible and unobscured at its top-left corner while connecting or sending: capture reads the desktop, not an occluded window. `bridge/probe-windows.ps1` saves a screenshot of that corner to `bridge/probe-windows.png` for diagnostics. That screenshot is excluded from Git.

Machine-specific configuration, credentials, runtime logs, and chat transcripts are not included in this fork.
