import QtQuick

// 1x1 pill: icon + label. `active` fills it with the accent color.
// With `clickable: false` it is a read-only info pill.
Rectangle {
  id: root

  property string icon: ""
  property string label: ""
  property bool active: false
  property bool clickable: true

  signal clicked

  readonly property color fg: root.active ? Config.crust : Config.text

  implicitWidth: Config.qaCell
  implicitHeight: Config.qaRowHeight
  radius: height / 2
  color: root.active ? Config.accent : (mouse.containsMouse ? Config.hover : Config.surface0)

  Behavior on color {
    ColorAnimation {
      duration: 100
    }
  }

  Row {
    anchors.fill: parent
    anchors.leftMargin: Config.padding
    anchors.rightMargin: Config.padding
    spacing: Config.spacing

    Text {
      id: iconText
      anchors.verticalCenter: parent.verticalCenter
      visible: root.icon !== ""
      text: root.icon
      color: root.fg
      font.family: Config.fontFamily
      font.pixelSize: 16
    }

    Text {
      anchors.verticalCenter: parent.verticalCenter
      width: parent.width - (iconText.visible ? iconText.width + parent.spacing : 0)
      elide: Text.ElideRight
      maximumLineCount: 1
      text: root.label
      color: root.fg
      font.family: Config.fontFamily
      font.pixelSize: Config.labelSize
    }
  }

  MouseArea {
    id: mouse
    anchors.fill: parent
    enabled: root.clickable
    hoverEnabled: true
    cursorShape: Qt.PointingHandCursor
    onClicked: root.clicked()
  }
}
