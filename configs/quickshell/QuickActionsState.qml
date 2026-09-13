pragma Singleton

import Quickshell
import QtQuick

// State + actions behind the quick actions panel.
//
// Everything here is a STUB: values are mock data and actions only log
// (`qs log` shows them). Replace this file's internals with the real services
// (Bluetooth, Networking, Pipewire, PowerProfiles, swaylock) — the panel only
// binds to these properties and calls these functions.
Singleton {
  id: root

  property bool bluetoothOn: true
  property bool wifiOn: true
  property string networkName: "Home-5G"
  property bool muted: false
  property real volume: 0.6

  property list<string> sinks: ["Built-in Speakers", "HDMI Output", "Headphones"]
  property string defaultSink: "Built-in Speakers"

  readonly property list<string> profiles: ["power-saver", "balanced", "performance"]
  property string profile: "balanced"

  function stub(what: string): void {
    console.log("[qa stub] " + what);
  }

  function toggleBluetooth(): void {
    root.bluetoothOn = !root.bluetoothOn;
    root.stub("bluetooth -> " + root.bluetoothOn);
  }

  function openBluetui(): void {
    root.stub("open bluetui");
  }

  function toggleWifi(): void {
    root.wifiOn = !root.wifiOn;
    root.stub("wifi -> " + root.wifiOn);
  }

  function toggleMute(): void {
    root.muted = !root.muted;
    root.stub("muted -> " + root.muted);
  }

  function openWiremix(): void {
    root.stub("open wiremix");
  }

  function setVolume(v: real): void {
    root.volume = Math.max(0, Math.min(1, v));
    root.stub("volume -> " + Math.round(root.volume * 100));
  }

  function setSink(name: string): void {
    root.defaultSink = name;
    root.stub("default sink -> " + name);
  }

  function setProfile(p: string): void {
    root.profile = p;
    root.stub("profile -> " + p);
  }

  function lock(): void {
    root.stub("lock");
  }

  function logout(): void {
    root.stub("logout");
  }

  function poweroff(): void {
    root.stub("poweroff");
  }
}
