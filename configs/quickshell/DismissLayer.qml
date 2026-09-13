import Quickshell
import Quickshell.Wayland
import QtQuick

// Invisible fullscreen catcher that sits directly beneath the drawer, so a
// click anywhere outside it dismisses the drawer.
//
// Declared before ShortcutsDrawer in shell.qml: within the same layer-shell
// layer, surfaces created later stack on top.
PanelWindow {
  id: win

  required property var modelData
  screen: modelData

  visible: ShellState.drawerOpen && !ShellState.allAppsOpen && ShellState.onFocusedScreen(modelData)

  WlrLayershell.namespace: "qs-dismiss"
  WlrLayershell.layer: WlrLayer.Top
  exclusionMode: ExclusionMode.Ignore

  anchors {
    top: true
    bottom: true
    left: true
    right: true
  }

  color: "transparent"

  MouseArea {
    anchors.fill: parent
    onClicked: ShellState.closeAll()
  }
}
