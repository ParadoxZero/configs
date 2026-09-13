import QtQuick

// 1x2 dropdown: a large-pill header showing the current value; clicking it
// expands an inline option list below (the panel grows to fit).
Column {
  id: root

  property string icon: ""
  property string caption: ""
  property string current: ""
  property list<string> options: []
  property bool expanded: false

  signal selected(string option)

  width: Config.qaWide
  spacing: 4

  QaLargePill {
    icon: root.icon
    caption: root.caption
    label: root.current
    trailing: root.expanded ? "󰅃" : "󰅀"
    onClicked: root.expanded = !root.expanded
  }

  Rectangle {
    visible: root.expanded
    width: root.width
    implicitHeight: list.implicitHeight + 8
    radius: Config.tileRadius
    color: Config.mantle

    Column {
      id: list
      anchors.fill: parent
      anchors.margins: 4

      Repeater {
        model: root.options

        Rectangle {
          id: row
          required property string modelData
          readonly property bool isCurrent: row.modelData === root.current

          width: list.width
          height: 32
          radius: Config.tileRadius - 4
          color: rowMouse.containsMouse ? Config.hover : "transparent"

          Text {
            anchors.left: parent.left
            anchors.leftMargin: Config.padding
            anchors.right: check.left
            anchors.verticalCenter: parent.verticalCenter
            elide: Text.ElideRight
            text: row.modelData
            color: row.isCurrent ? Config.accent : Config.text
            font.family: Config.fontFamily
            font.pixelSize: Config.labelSize
          }

          Text {
            id: check
            anchors.right: parent.right
            anchors.rightMargin: Config.padding
            anchors.verticalCenter: parent.verticalCenter
            visible: row.isCurrent
            text: "󰄬"
            color: Config.accent
            font.family: Config.fontFamily
            font.pixelSize: 13
          }

          MouseArea {
            id: rowMouse
            anchors.fill: parent
            hoverEnabled: true
            cursorShape: Qt.PointingHandCursor
            onClicked: {
              root.selected(row.modelData);
              root.expanded = false;
            }
          }
        }
      }
    }
  }
}
