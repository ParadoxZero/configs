pragma Singleton

import Quickshell
import QtQuick

// Theme + tunables for the shortcuts panel.
// Colors are Catppuccin Mocha, matching configs/waybar/style.css.
Singleton {
  // --- Pinned shortcuts -------------------------------------------------
  // Desktop entry ids (the .desktop filename without the extension).
  // Name, icon and launch command all come from the entry itself.
  // The drawer lays these out as 6 rows x 2 columns, so keep 12 of them.
  // `ls /usr/share/applications /var/lib/flatpak/exports/share/applications`
  // lists what is available.
  readonly property list<string> pinned: [
    "chromium_chromium",
    "dev.zed.Zed",
    "code",
    "com.slack.Slack",
    "discord",
    "md.obsidian.Obsidian",
    "org.qbittorrent.qBittorrent",
    "com.ktechpit.whatsie",
    "com.bitwarden.desktop",
    "net.nokyan.Resources",
    "vlc",
    "org.gnome.Software"
  ]

  // --- Palette ----------------------------------------------------------
  readonly property color base: "#1e1e2e"
  readonly property color mantle: "#181825"
  readonly property color crust: "#11111b"
  readonly property color surface0: "#313244"
  readonly property color surface1: "#45475a"
  readonly property color text: "#cdd6f4"
  readonly property color subtext0: "#a6adc8"
  readonly property color mauve: "#cba6f7"
  readonly property color green: "#a6e3a1"
  readonly property color red: "#f38ba8"

  // Panel backgrounds are translucent so the swayfx layer blur shows through.
  readonly property color panelBg: Qt.rgba(base.r, base.g, base.b, 0.2)
  readonly property color scrim: Qt.rgba(0, 0, 0, 0.1)
  readonly property color hover: Qt.rgba(surface0.r, surface0.g, surface0.b, 0.9)

  // --- Metrics ----------------------------------------------------------
  readonly property string fontFamily: "0xProto Nerd Font Mono"
  readonly property int tileWidth: 104
  readonly property int tileHeight: 94
  readonly property int iconSize: 40
  readonly property int labelSize: 11
  readonly property int spacing: 6
  readonly property int padding: 12
  readonly property int radius: 50
  readonly property int tileRadius: 12


  // Quick actions grid: 1x1 cells are qaCell wide, 1x2 cells span two cells
  // plus the gap between them.
  readonly property int qaCell: 104
  readonly property int qaWide: qaCell * 2 + spacing
  readonly property int qaRowHeight: 48
  readonly property color accent: green
  readonly property int qaMargin: 25

  // Distance from the screen edges. topMargin clears waybar (~35px) plus the
  // 5px sway inner gap; edgeMargin matches `gaps inner 5`.
  readonly property int topMargin: 40
  readonly property int edgeMargin: 5
}
