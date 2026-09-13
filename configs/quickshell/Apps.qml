pragma Singleton

import Quickshell

// Desktop entry lookup.
//
// DesktopEntries.applications populates asynchronously after startup, so both
// properties below read `.values` to register a reactive dependency on it —
// an imperative byId() call at startup returns null.
Singleton {
  id: root

  // Config.pinned resolved to DesktopEntry objects, in the configured order.
  // Entries are wrapped so an unresolvable id still occupies its grid slot
  // (rendered as a placeholder) instead of silently vanishing.
  readonly property var pinned: {
    DesktopEntries.applications.values; // dependency, see above
    return Config.pinned.map(id => ({
          id: id,
          entry: DesktopEntries.byId(id)
        }));
  }

  // Every visible application, sorted by name — the all-apps grid model.
  readonly property var all: {
    const entries = DesktopEntries.applications.values.filter(e => !e.noDisplay);
    return entries.sort((a, b) => a.name.localeCompare(b.name));
  }
}
