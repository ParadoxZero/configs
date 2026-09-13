import QtQuick

// 1x2 pill: icon, a small caption above the main label, and an optional
// trailing glyph (a chevron when used as a dropdown header).
Rectangle {
  id: root

  property string icon: ""
  property string caption: ""
  property string label: ""
  property string trailing: ""

  signal clicked

  implicitWidth: Config.qaWide
  implicitHeight: Config.qaRowHeight
  radius: height / 2
  color: mouse.containsMouse ? Config.hover : Config.surface0

  Behavior on color {
    ColorAnimation {
      duration: 100
    }
  }

  Text {
    id: iconText
    anchors.left: parent.left
    anchors.leftMargin: Config.padding + 2
    anchors.verticalCenter: parent.verticalCenter
    text: root.icon
    color: Config.accent
    font.family: Config.fontFamily
    font.pixelSize: 18
  }

  Column {
    anchors.left: iconText.right
    anchors.leftMargin: Config.padding
    anchors.right: trailingText.left
    anchors.rightMargin: Config.spacing
    anchors.verticalCenter: parent.verticalCenter

    Text {
      width: parent.width
      visible: root.caption !== ""
      text: root.caption
      color: Config.subtext0
      font.family: Config.fontFamily
      font.pixelSize: 9
    }

    Text {
      width: parent.width
      elide: Text.ElideRight
      maximumLineCount: 1
      text: root.label
      color: Config.text
      font.family: Config.fontFamily
      font.pixelSize: Config.labelSize
    }
  }

  Text {
    id: trailingText
    anchors.right: parent.right
    anchors.rightMargin: Config.padding + 2
    anchors.verticalCenter: parent.verticalCenter
    text: root.trailing
    color: Config.subtext0
    font.family: Config.fontFamily
    font.pixelSize: 14
  }

  MouseArea {
    id: mouse
    anchors.fill: parent
    hoverEnabled: true
    cursorShape: Qt.PointingHandCursor
    onClicked: root.clicked()
  }
}
