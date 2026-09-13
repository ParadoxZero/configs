import Quickshell
import Quickshell.Wayland
import Quickshell.Widgets
import QtQuick

// Quick actions panel, anchored to the top-right corner below waybar.
// Toggled with `qs ipc call quick-actions toggle`.
//
// All state and actions come from QuickActionsState (currently stubs).
PanelWindow {
  id: quick_actions_win

  required property var modelData
  screen: modelData

  visible: ShellState.quickActionsOpen && ShellState.onFocusedScreen(modelData)

  WlrLayershell.namespace: "qs-shortcuts"
  WlrLayershell.layer: WlrLayer.Overlay
  WlrLayershell.keyboardFocus: WlrKeyboardFocus.OnDemand
  focusable: true

  // A launcher must never reserve screen space.
  exclusionMode: ExclusionMode.Ignore

  anchors {
    top: true
    right: true
  }
  margins {
    top: Config.topMargin
    right: Config.edgeMargin
  }

  color: "transparent"
  implicitWidth: card.implicitWidth
  implicitHeight: card.implicitHeight

  WrapperRectangle {
    id: card

    color: Config.panelBg
    radius: Config.radius
    margin: Config.padding

    Column {
      spacing: Config.spacing
      focus: true
      Keys.onEscapePressed: ShellState.closeQuickActions()

      Text {
        width: Config.qaWide
        height: 32
        horizontalAlignment: Text.AlignHCenter
        verticalAlignment: Text.AlignVCenter
        text: "Quick Actions"
        color: Config.text
        font.family: Config.fontFamily
        font.pixelSize: 14
      }

      QaComposite {
        icon: QuickActionsState.bluetoothOn ? "󰂯" : "󰂲"
        label: "Bluetooth"
        active: QuickActionsState.bluetoothOn
        onToggled: QuickActionsState.toggleBluetooth()
        onOpened: QuickActionsState.openBluetui()
      }

      Row {
        spacing: Config.spacing

        QaPill {
          icon: QuickActionsState.wifiOn ? "󰖩" : "󰖪"
          label: "Wi-Fi"
          active: QuickActionsState.wifiOn
          onClicked: QuickActionsState.toggleWifi()
        }

        QaPill {
          icon: "󰀂"
          label: QuickActionsState.wifiOn ? QuickActionsState.networkName : "Offline"
          clickable: false
        }
      }

      Row {
        spacing: Config.spacing

        QaPill {
          icon: QuickActionsState.muted ? "󰖁" : "󰕾"
          label: QuickActionsState.muted ? "Muted" : "Sound"
          active: QuickActionsState.muted
          onClicked: QuickActionsState.toggleMute()
        }

        QaPill {
          icon: "󰓃"
          label: "WireMix"
          onClicked: QuickActionsState.openWiremix()
        }
      }

      QaSlider {
        icon: QuickActionsState.muted ? "󰖁" : "󰕾"
        value: QuickActionsState.volume
        onMoved: v => QuickActionsState.setVolume(v)
      }

      QaDropdown {
        icon: "󰓃"
        caption: "Output"
        current: QuickActionsState.defaultSink
        options: QuickActionsState.sinks
        onSelected: option => QuickActionsState.setSink(option)
      }

      QaDropdown {
        icon: "󰓅"
        caption: "Power profile"
        current: QuickActionsState.profile
        options: QuickActionsState.profiles
        onSelected: option => QuickActionsState.setProfile(option)
      }

      Rectangle {
        width: Config.qaWide
        height: 1
        color: Config.surface1
      }

      Row {
        spacing: Config.spacing

        QaPowerButton {
          icon: "󰌾"
          label: "Lock"
          onClicked: QuickActionsState.lock()
        }

        QaPowerButton {
          icon: "󰍃"
          label: "Logout"
          onClicked: QuickActionsState.logout()
        }

        QaPowerButton {
          icon: "󰐥"
          label: "Power off"
          hoverColor: Config.red
          onClicked: QuickActionsState.poweroff()
        }
      }
    }
  }
}
