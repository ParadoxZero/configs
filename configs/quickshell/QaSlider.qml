import QtQuick

// 1x2 slider: leading icon, a pill-shaped track filled up to `value` (0-1),
// and a percentage readout. Click/drag to set, scroll to nudge by 5%.
Rectangle {
  id: root

  property string icon: ""
  property real value: 0

  signal moved(real value)

  implicitWidth: Config.qaWide
  implicitHeight: Config.qaRowHeight
  radius: height / 2
  color: Config.surface0

  Text {
    id: iconText
    anchors.left: parent.left
    anchors.leftMargin: Config.padding + 2
    anchors.verticalCenter: parent.verticalCenter
    width: 18
    text: root.icon
    color: Config.text
    font.family: Config.fontFamily
    font.pixelSize: 16
  }

  Text {
    id: pct
    anchors.right: parent.right
    anchors.rightMargin: Config.padding + 2
    anchors.verticalCenter: parent.verticalCenter
    width: 30
    horizontalAlignment: Text.AlignRight
    text: Math.round(root.value * 100) + "%"
    color: Config.subtext0
    font.family: Config.fontFamily
    font.pixelSize: Config.labelSize
  }

  Rectangle {
    id: track
    anchors.left: iconText.right
    anchors.leftMargin: Config.spacing
    anchors.right: pct.left
    anchors.rightMargin: Config.spacing
    anchors.verticalCenter: parent.verticalCenter
    height: 8
    radius: height / 2
    color: Config.surface1

    Rectangle {
      width: Math.max(track.height, track.width * root.value)
      height: parent.height
      radius: parent.radius
      color: Config.accent
    }

    Rectangle {
      x: Math.max(0, Math.min(track.width - width, track.width * root.value - width / 2))
      anchors.verticalCenter: parent.verticalCenter
      width: 14
      height: 14
      radius: 7
      color: Config.text
    }

    MouseArea {
      anchors.fill: parent
      // Taller hit area than the thin track.
      anchors.topMargin: -12
      anchors.bottomMargin: -12
      cursorShape: Qt.PointingHandCursor

      function setFrom(x: real): void {
        root.moved(Math.max(0, Math.min(1, x / track.width)));
      }

      onPressed: mouse => setFrom(mouse.x)
      onPositionChanged: mouse => {
        if (pressed)
          setFrom(mouse.x);
      }
      onWheel: wheel => root.moved(Math.max(0, Math.min(1, root.value + (wheel.angleDelta.y > 0 ? 0.05 : -0.05))))
    }
  }
}
