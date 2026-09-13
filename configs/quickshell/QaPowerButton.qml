import QtQuick

// Session button (lock / logout / power off): icon over a small label.
Rectangle {
  id: root

  property string icon: ""
  property string label: ""
  // Hover tint; red for destructive actions.
  property color hoverColor: Config.accent

  signal clicked

  implicitWidth: (Config.qaWide - 2 * Config.spacing) / 3
  implicitHeight: 60
  radius: Config.tileRadius
  color: mouse.containsMouse ? Config.hover : Config.surface0

  Behavior on color {
    ColorAnimation {
      duration: 100
    }
  }

  Column {
    anchors.centerIn: parent
    spacing: 2

    Text {
      anchors.horizontalCenter: parent.horizontalCenter
      text: root.icon
      color: mouse.containsMouse ? root.hoverColor : Config.text
      font.family: Config.fontFamily
      font.pixelSize: 20
    }

    Text {
      anchors.horizontalCenter: parent.horizontalCenter
      text: root.label
      color: Config.subtext0
      font.family: Config.fontFamily
      font.pixelSize: 10
    }
  }

  MouseArea {
    id: mouse
    anchors.fill: parent
    hoverEnabled: true
    cursorShape: Qt.PointingHandCursor
    onClicked: root.clicked()
  }
}
