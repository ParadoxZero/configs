import Quickshell
import Quickshell.Wayland
import Quickshell.Widgets
import QtQuick

// The pinned-shortcuts drawer: 6 rows x 2 columns of tiles plus a full-width
// "All apps" button, anchored to the top-left corner below waybar.
PanelWindow {
  id: win

  required property var modelData
  screen: modelData

  visible: ShellState.drawerOpen && ShellState.onFocusedScreen(modelData)

  WlrLayershell.namespace: "qs-shortcuts"
  WlrLayershell.layer: WlrLayer.Overlay
  WlrLayershell.keyboardFocus: WlrKeyboardFocus.OnDemand
  focusable: true

  // A launcher must never reserve screen space.
  exclusionMode: ExclusionMode.Ignore

  anchors {
    top: true
    left: true
  }
  margins {
    top: Config.topMargin
    left: 0
  }

  color: "transparent"
  implicitWidth: card.implicitWidth
  implicitHeight: card.implicitHeight


  WrapperRectangle {
    id: card

    color: Config.panelBg
    topLeftRadius: 0
    bottomLeftRadius:0
    topRightRadius: Config.radius
    bottomRightRadius: Config.radius
    x: parent.visible ? 0 : -100
    opacity: parent.visible? 1.0: 0.0
    margin: Config.padding

    Behavior on x {
      NumberAnimation {
        duration: 200
        easing.type: Easing.OutSine
      }
    }

    // Plain QtQuick positioners: QtQuick.Layouts is not part of the QML module
    // set bundled with the quickshell binary on this machine.
    Column {
      spacing: Config.spacing
      opacity: win.visible? 1.0: 0.0
      Behavior on opacity {
          NumberAnimation {
              duration: 300
              easing.type: Easing.InQuint
          }
      }

      Grid {
        id: grid

        columns: 2
        columnSpacing: Config.spacing
        rowSpacing: Config.spacing

        Repeater {
          model: Apps.pinned

          ShortcutTile {
            required property var modelData
            entry: modelData.entry
            fallbackLabel: modelData.id
          }
        }
      }

      Rectangle {
        width: grid.width
        height: 1
        color: Config.surface1
      }

      Rectangle {
        width: grid.width
        height: 38
        radius: Config.tileRadius
        color: mouse.containsMouse ? Config.hover : "transparent"
        Behavior on color {
          ColorAnimation {
            duration: 100
          }
        }

        Text {
          anchors.centerIn: parent
          text: "󰀻  All apps"
          color: Config.accent
          font.family: Config.fontFamily
          font.pixelSize: 13
        }

        MouseArea {
          id: mouse
          anchors.fill: parent
          hoverEnabled: true
          cursorShape: Qt.PointingHandCursor 

          onClicked: {
            ShellState.openAllApps()
          }
        }
      }
    }
  }
}
