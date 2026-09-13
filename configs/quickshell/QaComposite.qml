import QtQuick

// 1x2 split pill: the left part toggles, the right part opens something
// (e.g. a TUI for the same feature).
Rectangle {
  id: root

  property string icon: ""
  property string label: ""
  property bool active: false
  property string openIcon: "󰁔"

  signal toggled
  signal opened

  readonly property color fg: root.active ? Config.crust : Config.text
  readonly property color bg: root.active ? Config.accent : Config.surface0

  implicitWidth: Config.qaWide
  implicitHeight: Config.qaRowHeight
  radius: height / 2
  color: root.bg
  clip: true

  Behavior on color {
    ColorAnimation {
      duration: 100
    }
  }

  // Toggle half.
  Rectangle {
    id: toggleArea
    anchors.left: parent.left
    anchors.top: parent.top
    anchors.bottom: parent.bottom
    width: parent.width - openArea.width
    color: toggleMouse.containsMouse ? Qt.rgba(1, 1, 1, 0.08) : "transparent"

    Row {
      anchors.verticalCenter: parent.verticalCenter
      anchors.left: parent.left
      anchors.leftMargin: Config.padding
      spacing: Config.spacing

      Text {
        anchors.verticalCenter: parent.verticalCenter
        text: root.icon
        color: root.fg
        font.family: Config.fontFamily
        font.pixelSize: 16
      }

      Text {
        anchors.verticalCenter: parent.verticalCenter
        text: root.label
        color: root.fg
        font.family: Config.fontFamily
        font.pixelSize: Config.labelSize
      }
    }

    MouseArea {
      id: toggleMouse
      anchors.fill: parent
      hoverEnabled: true
      cursorShape: Qt.PointingHandCursor
      onClicked: root.toggled()
    }
  }

  // Divider.
  Rectangle {
    anchors.right: openArea.left
    anchors.verticalCenter: parent.verticalCenter
    width: 1
    height: parent.height * 0.5
    color: root.fg
    opacity: 0.3
  }

  // Open half.
  Rectangle {
    id: openArea
    anchors.right: parent.right
    anchors.top: parent.top
    anchors.bottom: parent.bottom
    width: Config.qaRowHeight + Config.padding
    color: openMouse.containsMouse ? Qt.rgba(1, 1, 1, 0.08) : "transparent"

    Text {
      anchors.centerIn: parent
      text: root.openIcon
      color: root.fg
      font.family: Config.fontFamily
      font.pixelSize: 16
    }

    MouseArea {
      id: openMouse
      anchors.fill: parent
      hoverEnabled: true
      cursorShape: Qt.PointingHandCursor
      onClicked: root.opened()
    }
  }
}
