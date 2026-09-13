import Quickshell
import Quickshell.Wayland
import QtQuick

// Fullscreen grid of every installed application, over a blurred scrim.
// The blur itself comes from the compositor — see the layer_effects block for
// "qs-allapps" in configs/sway/config.
PanelWindow {
  id: win

  required property var modelData
  screen: modelData

  visible: ShellState.allAppsOpen && ShellState.onFocusedScreen(modelData)

  WlrLayershell.namespace: "qs-allapps"
  WlrLayershell.layer: WlrLayer.Overlay
  WlrLayershell.keyboardFocus: WlrKeyboardFocus.OnDemand
  exclusionMode: ExclusionMode.Ignore
  focusable: true

  anchors {
    top: true
    bottom: true
    left: true
    right: true
  }

  color: "transparent"

  // Click anywhere outside the grid to dismiss.
  MouseArea {
    anchors.fill: parent
    onClicked: ShellState.closeAll()
  }

  Item {
    anchors.fill: parent
    focus: true
    Keys.onEscapePressed: ShellState.closeAll()
  }

  Rectangle {
    anchors.centerIn: parent
    width: Math.min(parent.width - 160, grid.cellWidth * 8 + Config.padding * 2)
    height: Math.min(parent.height - 160, grid.cellHeight * 6 + Config.padding * 2)

    color: Config.panelBg
    radius: Config.radius

    // Swallow clicks on the panel itself so they don't hit the dismiss area.
    MouseArea {
      anchors.fill: parent
    }

    GridView {
      id: grid

      anchors.fill: parent
      anchors.margins: Config.padding
      clip: true
      cellWidth: Config.tileWidth + Config.spacing
      cellHeight: Config.tileHeight + Config.spacing
      model: Apps.all
      boundsBehavior: Flickable.StopAtBounds

      delegate: ShortcutTile {
        required property var modelData
        entry: modelData
        width: grid.cellWidth
        height: grid.cellHeight
      }
    }
  }
}
