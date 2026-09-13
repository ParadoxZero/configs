pragma Singleton

import Quickshell
import Quickshell.I3

// Open/closed state for the shortcuts panel.
//
// This lives in a singleton rather than in a Variants delegate: delegates are
// instantiated once per screen and their ids are not reachable from outside.
Singleton {
  id: root

  property bool drawerOpen: false
  property bool allAppsOpen: false
  property bool quickActionsOpen: false
  // Name of the sway output that currently has focus, so panels only appear
  // on the screen the user is looking at. Empty when sway has not reported a
  // focused monitor yet, in which case the panels fall back to every screen.
  readonly property string focusedScreen: I3.focusedMonitor?.name ?? ""

  function onFocusedScreen(screen: ShellScreen): bool {
    return root.focusedScreen === "" || screen.name === root.focusedScreen;
  }

  function toggleDrawer(): void {
    if (root.drawerOpen || root.allAppsOpen)
      root.closeAll();
    else
      root.drawerOpen = true;
  }

  function openDrawer(): void {
    root.allAppsOpen = false;
    root.drawerOpen = true;
  }

  function openAllApps(): void {
    root.drawerOpen = false;
    root.allAppsOpen = true;
  }

  function closeAll(): void {
    root.drawerOpen = false;
    root.allAppsOpen = false;
  }

  function toggleQuickActions(): void {
    root.quickActionsOpen = !root.quickActionsOpen;
  }

  function openQuickActions(): void {
    root.quickActionsOpen = true;
  }

  function closeQuickActions(): void {
    root.quickActionsOpen = false;
  }
}
