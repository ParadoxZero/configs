import Quickshell
import Quickshell.Io

// Shortcuts panel.
//
// Toggled from waybar's Arch icon, from $mod+a in sway, or directly with
//   qs ipc call shortcuts toggle
Scope {
  IpcHandler {
    target: "shortcuts"

    function toggle(): void {
      ShellState.toggleDrawer();
    }
    function open(): void {
      ShellState.openDrawer();
    }
    function close(): void {
      ShellState.closeAll();
    }
    function allApps(): void {
      ShellState.openAllApps();
    }
  }

  IpcHandler {
    target: "quick-actions"

    function toggle(): void {
      ShellState.toggleQuickActions();
    }
    function open(): void {
      ShellState.openQuickActions();
    }
    function close(): void {
      ShellState.closeQuickActions();
    }
  }

  // Each of these declares `required property var modelData` in its own file;
  // Variants injects the ShellScreen into it.
  //
  // The dismiss layer is declared before the drawer so the drawer stacks above
  // it — within one layer-shell layer, later surfaces are on top.
  Variants {
    model: Quickshell.screens
    DismissLayer {}
  }

  Variants {
    model: Quickshell.screens
    ShortcutsDrawer {}
  }

  Variants {
    model: Quickshell.screens
    AllAppsOverlay {}
  }

  Variants {
    model: Quickshell.screens
    QuickActions {}
  }
}
