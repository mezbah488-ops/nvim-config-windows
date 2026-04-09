# install.ps1
# Installer for nvim-config-windows + inkscape-figures-windows
# Run this from PowerShell as Administrator:
#   Set-ExecutionPolicy Bypass -Scope Process -Force
#   .\install.ps1

$ErrorActionPreference = "Stop"

# ─────────────────────────────────────────────
#  Helpers
# ─────────────────────────────────────────────
function Write-Header {
    param($Text)
    Write-Host ""
    Write-Host "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━" -ForegroundColor Cyan
    Write-Host "  $Text" -ForegroundColor Cyan
    Write-Host "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━" -ForegroundColor Cyan
    Write-Host ""
}

function Write-Step {
    param($Text)
    Write-Host "[>] $Text" -ForegroundColor Yellow
}

function Write-Ok {
    param($Text)
    Write-Host "[✓] $Text" -ForegroundColor Green
}

function Write-Info {
    param($Text)
    Write-Host "    $Text" -ForegroundColor Gray
}

function Refresh-Path {
    $env:PATH = [System.Environment]::GetEnvironmentVariable("Path", "Machine") + ";" +
                [System.Environment]::GetEnvironmentVariable("Path", "User")
}

function Is-Installed {
    param($Command)
    return $null -ne (Get-Command $Command -ErrorAction SilentlyContinue)
}

function Install-WithWinget {
    param($PackageName, $WingetId, $Command)
    if (Is-Installed $Command) {
        Write-Ok "$PackageName is already installed"
        return
    }
    Write-Step "Installing $PackageName via winget..."
    winget install --id $WingetId --silent --accept-package-agreements --accept-source-agreements
    Refresh-Path
    if (Is-Installed $Command) {
        Write-Ok "$PackageName installed successfully"
    } else {
        Write-Host "[!] $PackageName installed but not yet on PATH. You may need to restart PowerShell." -ForegroundColor Magenta
    }
}

# ─────────────────────────────────────────────
#  Banner
# ─────────────────────────────────────────────
Clear-Host
Write-Host ""
Write-Host "  ███╗   ██╗██╗   ██╗██╗███╗   ███╗" -ForegroundColor Magenta
Write-Host "  ████╗  ██║██║   ██║██║████╗ ████║" -ForegroundColor Magenta
Write-Host "  ██╔██╗ ██║██║   ██║██║██╔████╔██║" -ForegroundColor Magenta
Write-Host "  ██║╚██╗██║╚██╗ ██╔╝██║██║╚██╔╝██║" -ForegroundColor Magenta
Write-Host "  ██║ ╚████║ ╚████╔╝ ██║██║ ╚═╝ ██║" -ForegroundColor Magenta
Write-Host "  ╚═╝  ╚═══╝  ╚═══╝  ╚═╝╚═╝     ╚═╝" -ForegroundColor Magenta
Write-Host ""
Write-Host "  nvim-config-windows installer" -ForegroundColor White
Write-Host "  github.com/mezbah488-ops/nvim-config-windows" -ForegroundColor DarkGray
Write-Host ""

# ─────────────────────────────────────────────
#  Check winget
# ─────────────────────────────────────────────
Write-Header "Checking winget"
if (-not (Is-Installed "winget")) {
    Write-Host "[!] winget is not available on this system." -ForegroundColor Red
    Write-Host "    Install it from the Microsoft Store (App Installer) and re-run this script." -ForegroundColor Red
    exit 1
}
Write-Ok "winget is available"

# ─────────────────────────────────────────────
#  Install dependencies
# ─────────────────────────────────────────────
Write-Header "Installing dependencies"

Install-WithWinget "Git"      "Git.Git"                    "git"
Install-WithWinget "Neovim"   "Neovim.Neovim"              "nvim"
Install-WithWinget "Python 3" "Python.Python.3"            "python"
Install-WithWinget "Inkscape" "Inkscape.Inkscape"          "inkscape"
Install-WithWinget "MiKTeX"   "MiKTeX.MiKTeX"              "pdflatex"

# Install watchdog for Python
Write-Step "Installing Python dependency: watchdog..."
pip install watchdog --quiet
Write-Ok "watchdog installed"

# ─────────────────────────────────────────────
#  Clone nvim config
# ─────────────────────────────────────────────
Write-Header "Setting up Neovim config"

$nvimConfigPath = "$env:LOCALAPPDATA\nvim"

if (Test-Path $nvimConfigPath) {
    Write-Host "[!] Existing Neovim config found at: $nvimConfigPath" -ForegroundColor Yellow
    $backup = Read-Host "    Back it up and continue? (y/n)"
    if ($backup -eq "y") {
        $backupPath = "$nvimConfigPath.bak_$(Get-Date -Format 'yyyyMMdd_HHmmss')"
        Move-Item $nvimConfigPath $backupPath
        Write-Ok "Backed up to: $backupPath"
    } else {
        Write-Host "[!] Skipping nvim config clone — existing config left untouched." -ForegroundColor Magenta
        goto inkscape_section
    }
}

Write-Step "Cloning nvim-config-windows..."
git clone https://github.com/mezbah488-ops/nvim-config-windows.git $nvimConfigPath
Write-Ok "Neovim config cloned to: $nvimConfigPath"

# ─────────────────────────────────────────────
#  Clone inkscape-figures-windows
# ─────────────────────────────────────────────
:inkscape_section
Write-Header "Setting up inkscape-figures-windows"

Write-Host "  Where would you like to install inkscape-figures-windows?" -ForegroundColor White
Write-Host "  Press Enter to use the default, or type a custom path." -ForegroundColor DarkGray
Write-Host ""
$defaultFigPath = "$env:USERPROFILE\inkscape-figures"
$userFigPath = Read-Host "  Install path [$defaultFigPath]"
if ([string]::IsNullOrWhiteSpace($userFigPath)) {
    $figPath = $defaultFigPath
} else {
    $figPath = $userFigPath.Trim()
}

if (Test-Path $figPath) {
    Write-Ok "inkscape-figures already exists at: $figPath — skipping clone"
} else {
    Write-Step "Cloning inkscape-figures-windows to: $figPath"
    git clone https://github.com/mezbah488-ops/inkscape-figures-windows.git $figPath
    Write-Ok "Cloned to: $figPath"
}

# ─────────────────────────────────────────────
#  Patch init.lua with correct fig_path
# ─────────────────────────────────────────────
Write-Header "Patching init.lua"

$initLua = "$nvimConfigPath\init.lua"
if (Test-Path $initLua) {
    $figBat = "$figPath\fig.bat" -replace "\\", "\\\\"
    $content = Get-Content $initLua -Raw
    # Replace any existing fig_path line with the correct one
    $content = $content -replace 'local fig_path\s*=\s*"[^"]*"', "local fig_path = `"$figBat`""
    Set-Content $initLua $content -Encoding UTF8
    Write-Ok "init.lua patched with fig_path = $figPath\fig.bat"
} else {
    Write-Host "[!] init.lua not found at $initLua — skipping patch." -ForegroundColor Magenta
    Write-Info "You will need to manually set fig_path in init.lua."
}

# ─────────────────────────────────────────────
#  Install Nerd Font
# ─────────────────────────────────────────────
Write-Header "Installing JetBrainsMonoNL Nerd Font"

$fontName = "JetBrainsMonoNLNerdFont-Regular.ttf"
$fontUrl  = "https://github.com/ryanoasis/nerd-fonts/releases/latest/download/JetBrainsMono.zip"
$fontZip  = "$env:TEMP\JetBrainsMono.zip"
$fontDir  = "$env:TEMP\JetBrainsMono"

Write-Step "Downloading JetBrainsMono Nerd Font..."
try {
    Invoke-WebRequest -Uri $fontUrl -OutFile $fontZip -UseBasicParsing
    Expand-Archive -Path $fontZip -DestinationPath $fontDir -Force
    $fontFile = Get-ChildItem $fontDir -Filter "JetBrainsMonoNLNerdFont-Regular.ttf" | Select-Object -First 1
    if ($fontFile) {
        $fontsFolder = "$env:WINDIR\Fonts"
        Copy-Item $fontFile.FullName $fontsFolder -Force
        # Register font in registry
        $regPath = "HKLM:\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Fonts"
        Set-ItemProperty -Path $regPath -Name "JetBrainsMonoNL Nerd Font Regular (TrueType)" -Value $fontFile.Name
        Write-Ok "JetBrainsMonoNL Nerd Font installed"
    } else {
        Write-Host "[!] Font file not found in archive — skipping." -ForegroundColor Magenta
    }
} catch {
    Write-Host "[!] Font download failed — install manually from https://www.nerdfonts.com" -ForegroundColor Magenta
}

# ─────────────────────────────────────────────
#  PowerShell save alias
# ─────────────────────────────────────────────
Write-Header "Setting up PowerShell profile"

$profileDir = Split-Path $PROFILE
if (-not (Test-Path $profileDir)) {
    New-Item -ItemType Directory -Path $profileDir -Force | Out-Null
}
if (-not (Test-Path $PROFILE)) {
    New-Item -ItemType File -Path $PROFILE -Force | Out-Null
}

$profileContent = Get-Content $PROFILE -Raw -ErrorAction SilentlyContinue
$aliasLine = 'function save { param($m = "Save"); git add .; git commit -m $m; git push }'

if ($profileContent -notmatch "function save") {
    Add-Content $PROFILE "`n$aliasLine"
    Write-Ok "Added 'save' alias to PowerShell profile"
} else {
    Write-Ok "'save' alias already present in PowerShell profile"
}

# ─────────────────────────────────────────────
#  Done
# ─────────────────────────────────────────────
Write-Header "Installation complete!"

Write-Host "  Next steps:" -ForegroundColor White
Write-Host ""
Write-Host "  1. Open Windows Terminal and set the font to:" -ForegroundColor Gray
Write-Host "     JetBrainsMonoNL Nerd Font" -ForegroundColor White
Write-Host ""
Write-Host "  2. (Optional) Add Catppuccin Frappe to Windows Terminal." -ForegroundColor Gray
Write-Host "     See the README for the color values." -ForegroundColor Gray
Write-Host ""
Write-Host "  3. Open Neovim — plugins will install automatically:" -ForegroundColor Gray
Write-Host "     nvim" -ForegroundColor White
Write-Host ""
Write-Host "  4. In any LaTeX project folder, run:" -ForegroundColor Gray
Write-Host "     fig init" -ForegroundColor White
Write-Host "     fig start" -ForegroundColor White
Write-Host ""
Write-Host "  5. Restart PowerShell to activate the 'save' alias." -ForegroundColor Gray
Write-Host ""
Write-Ok "All done. Happy writing!"
Write-Host ""
