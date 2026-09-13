import Quickshell
import Quickshell.Widgets
import QtQuick

// One icon + label cell. Used by both the drawer grid and the all-apps grid.
Item {
  id: root

  // A DesktopEntry, or null when a pinned id could not be resolved.
  required property var entry
  // Shown as the label when `entry` is null, so a bad pin is visible.
  property string fallbackLabel: ""

  readonly property bool valid: root.entry !== null && root.entry !== undefined

  implicitWidth: Config.tileWidth
  implicitHeight: Config.tileHeight

  Rectangle {
    anchors.fill: parent
    radius: Config.tileRadius
    color: mouse.containsMouse ? Config.hover : "transparent"

    Behavior on color {
      ColorAnimation {
        duration: 100
      }
    }
  }

  Column {
    anchors.centerIn: parent
    spacing: Config.spacing

    IconImage {
      anchors.horizontalCenter: parent.horizontalCenter
      implicitSize: Config.iconSize
      asynchronous: true
      visible: root.valid
      source: root.valid ? Quickshell.iconPath(root.entry.icon, true) : ""
    }

    // Placeholder for an unresolvable pin.
    Text {
      anchors.horizontalCenter: parent.horizontalCenter
      visible: !root.valid
      width: Config.iconSize
      height: Config.iconSize
      horizontalAlignment: Text.AlignHCenter
      verticalAlignment: Text.AlignVCenter
      text: "?"
      color: Config.subtext0
      font.family: Config.fontFamily
      font.pixelSize: Config.iconSize * 0.6
    }

    Text {
      anchors.horizontalCenter: parent.horizontalCenter
      width: root.width - Config.spacing * 2
      horizontalAlignment: Text.AlignHCenter
      elide: Text.ElideRight
      maximumLineCount: 1
      text: root.valid ? root.entry.name : root.fallbackLabel
      color: root.valid ? Config.text : Config.subtext0
      font.family: Config.fontFamily
      font.pixelSize: Config.labelSize
    }
  }

  MouseArea {
    id: mouse
    anchors.fill: parent
    hoverEnabled: true
    cursorShape: root.valid ? Qt.PointingHandCursor : Qt.ArrowCursor
    enabled: root.valid

    onClicked: {
      root.entry.execute();
      ShellState.closeAll();
    }
  }
}
