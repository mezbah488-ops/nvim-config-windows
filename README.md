# nvim-config-windows

A personal Neovim configuration for Windows, based on [kickstart.nvim](https://github.com/nvim-lua/kickstart.nvim). Built for academic and technical writing with LaTeX, vector figure editing, and general development.

---

## Features

- **Catppuccin** colorscheme (Frappe/Mocha)
- **VimTeX** for LaTeX editing and live compilation
- **Inkscape figure workflow** — draw figures and embed them in LaTeX without leaving Neovim (see [inkscape-figures-windows](https://github.com/mezbah488-ops/inkscape-figures-windows))
- **Neo-tree** file explorer
- **Telescope** fuzzy finder
- **LuaSnip** snippets
- **nvim-cmp** autocompletion
- **Aerial** code outline
- **Flash** for fast navigation
- **Zen mode / Twilight** for distraction-free writing
- **Toggleterm** for integrated terminal
- **Orgmode** for note-taking

---

## Prerequisites

| Tool | Purpose | Download |
|------|---------|----------|
| Neovim 0.9+ | Editor | https://neovim.io |
| Git | Plugin management | https://git-scm.com |
| Node.js | Some LSP servers require it | https://nodejs.org |
| A Nerd Font | Icons in the UI | https://www.nerdfonts.com |
| Windows Terminal | Recommended terminal | Microsoft Store |

This config uses **JetBrainsMonoNL Nerd Font**. Install it from https://www.nerdfonts.com and set it in Windows Terminal.

---

## Installation

### Step 1 — Back up any existing config

```powershell
mv $env:LOCALAPPDATA\nvim $env:LOCALAPPDATA\nvim.bak
```

### Step 2 — Clone this repo

```powershell
git clone https://github.com/mezbah488-ops/nvim-config-windows.git $env:LOCALAPPDATA\nvim
```

### Step 3 — Open Neovim

```powershell
nvim
```

[lazy.nvim](https://github.com/folke/lazy.nvim) will automatically install all plugins on first launch. Wait for it to finish, then restart Neovim.

---

## Colorscheme

This config uses [Catppuccin](https://github.com/catppuccin/catppuccin) with:

- **Light mode** → Mocha
- **Dark mode** → Frappe

For the best experience, also install the Catppuccin theme in **Windows Terminal** so the terminal background matches Neovim. Add this to the `"schemes"` array in your Windows Terminal `settings.json`:

```json
{
    "name": "Catppuccin Frappe",
    "background": "#303446",
    "foreground": "#C6D0F5",
    "black": "#51576D",
    "red": "#E78284",
    "green": "#A6D189",
    "yellow": "#E5C890",
    "blue": "#8CAAEE",
    "purple": "#F4B8E4",
    "cyan": "#81C8BE",
    "white": "#B5BFE2",
    "brightBlack": "#626880",
    "brightRed": "#E78284",
    "brightGreen": "#A6D189",
    "brightYellow": "#E5C890",
    "brightBlue": "#8CAAEE",
    "brightPurple": "#F4B8E4",
    "brightCyan": "#81C8BE",
    "brightWhite": "#A5ADCE",
    "cursorColor": "#F2D5CF",
    "selectionBackground": "#626880"
}
```

Then set `"colorScheme": "Catppuccin Frappe"` in your PowerShell profile entry.

---

## Inkscape Figure Workflow

This config includes an autocmd that automatically starts the Inkscape figure watchers whenever you open a `.tex` file. It depends on a companion tool:

👉 **[inkscape-figures-windows](https://github.com/mezbah488-ops/inkscape-figures-windows)**

Follow the setup guide there first, then update the path in `init.lua`:

```lua
local fig_path = "C:\\Users\\YourName\\inkscape-figures\\fig.bat"
```

Replace `YourName` with your actual Windows username.

---

## Structure

```
nvim/
├── init.lua                        # Entry point
└── lua/
    ├── custom/
    │   └── plugins/
    │       └── init.lua            # Your personal plugin additions
    └── kickstart/
        └── plugins/
            ├── catppuccin.lua      # Colorscheme
            ├── nvim-cmp.lua        # Autocompletion
            ├── neo-tree.lua        # File explorer
            ├── toggleterm.lua      # Terminal
            ├── vimtex.lua          # LaTeX
            ├── zen-mode.lua        # Distraction-free writing
            └── ...                 # Other plugins
```

---

## Related

- [inkscape-figures-windows](https://github.com/mezbah488-ops/inkscape-figures-windows) — Companion tool for Inkscape + LaTeX figure automation
- [kickstart.nvim](https://github.com/nvim-lua/kickstart.nvim) — The base config this is built on
- [Catppuccin for Windows Terminal](https://github.com/catppuccin/windows-terminal) — Terminal colorscheme to match

---

## License

MIT
