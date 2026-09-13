# CLAUDE.md — Quickshell

Guidance for working on the Quickshell config in this directory.

Facts below were extracted from the Quickshell **v0.3.0** source (`git.outfoxxed.me/quickshell/quickshell`)
and the docs repo (`git.outfoxxed.me/quickshell/quickshell-docs`). Locally installed: **0.3.1**
(`qs --version`). The published guide at <https://quickshell.org/docs/> lags the source in places —
where they disagree, the source wins (see [Corrections](#corrections-to-the-published-guide)).

## This directory

`configs/quickshell/` is symlinked to `~/.config/quickshell` by `configure.py`
(`recursive_link` at [configure.py:139](../../configure.py#L139), path from
`get_quickshell_path()` in [core/linux.py:30](../../core/linux.py#L30)).

**Edits here take effect immediately** — the symlink is live and Quickshell hot-reloads QML on
save. No need to re-run `configure.py` or restart `qs` after editing a `.qml` file.

`shell.qml` is the entry point. Any `.qml` file in this directory whose name starts with an
uppercase letter is automatically importable as a type from neighboring files (no import
statement needed).

## Running and debugging

```sh
qs                      # run ~/.config/quickshell/shell.qml (the 'default' config)
qs -p ./shell.qml       # run a specific file or folder
qs -c myconfig          # run ~/.config/quickshell/myconfig/shell.qml
qs -d                   # daemonize (detach from terminal)
qs -n                   # exit if another instance of this config is already running
qs -v / -vv             # INFO / DEBUG internal logs
qs list                 # list running instances
qs log                  # print logs of a running instance
qs kill                 # kill instances
qs ipc call ...         # talk to a running instance (see IpcHandler below)
```

Config resolution: a config is a named directory at `<xdg config dir>/quickshell/<name>/shell.qml`.
If `<xdg config dir>/quickshell/shell.qml` exists it becomes the `default` config and
subdirectories are *not* scanned — which is the case here.

`--manifest` / `manifest.conf` and `qs msg` are **deprecated** (use `qs ipc call`).

Debugging aids: `--debug <port>` opens a QML debugger port, `--waitfordebug` blocks until it
connects. `console.log()` output shows up in `qs log`.

## QML essentials

Quickshell is configured in QML (Qt 6). The parts that matter most:

- **Property bindings are reactive.** `text: someObj.value` re-evaluates whenever `value` changes.
  Assigning a plain value in a handler (`text = "x"`) *breaks* the binding; `Qt.binding(() => ...)`
  creates one at runtime.
- **Property definitions:** `[required] [readonly] [default] property <type> <name>[: binding]`.
  Prefer explicit types over `var`.
- **Default property:** objects written bare inside another object go into its default property.
  `Variants { PanelWindow {} }` is `Variants { delegate: Component { PanelWindow {} } }`.
- **Scoping:** a property is in scope only if defined on the *current* object or on the *file root*
  object. Anything else needs an `id` (or `parent`). An `id` is file-local — it is **not** visible
  to the file that instantiates the type.
- **Signal handlers:** signal `foo` gets an implicit `onFoo` property. Property `bar` gets a
  `barChanged` signal and thus `onBarChanged`. Use a `Connections { target: x }` object when a
  direct handler isn't possible (common for singletons).
- **Singletons:** `pragma Singleton` at the top of the file, with `Singleton` (from `Quickshell`)
  as the root object. Members are then accessible by filename from anywhere.

Positioning: use `implicitWidth` / `implicitHeight` when authoring a component (that is the base
size layouts read), and `width` / `height` only for things that will never go in a layout.
Size and position relative to the nearest parent, never relative to screen dimensions.
`QtQuick.Layouts` have nonzero default `spacing`.

## Modules

Import the parent module — modules prefixed with `_` are internal build units that the parent
re-exports (`Quickshell` default-imports `Quickshell._Window`; `Quickshell.Wayland`,
`Quickshell.Hyprland` and `Quickshell.I3` import their `_` submodules). Never write
`import Quickshell._Window`.

| Import | Contents |
| --- | --- |
| `Quickshell` | core: windows, `Variants`, `Scope`, `Singleton`, `LazyLoader`, screens, menus, desktop entries |
| `Quickshell.Io` | `Process`, `FileView`, `Socket`, `IpcHandler`, stream parsers, JSON |
| `Quickshell.Widgets` | `IconImage`, `ClippingRectangle`, `Wrapper*` layout helpers |
| `Quickshell.Wayland` | `WlrLayershell`, `WlSessionLock`, `Toplevel`/`ToplevelManager`, `IdleInhibitor`, `IdleMonitor`, `ScreencopyView`, `ShortcutInhibitor`, `BackgroundEffect` |
| `Quickshell.Hyprland` | `Hyprland` singleton, `HyprlandMonitor`, `HyprlandWorkspace`, `HyprlandToplevel`, `HyprlandWindow`, `HyprlandFocusGrab`, `GlobalShortcut` |
| `Quickshell.I3` | `I3` singleton, `I3Monitor`, `I3Workspace`, `I3IpcListener`, `I3Event` |
| `Quickshell.X11` | `XPanelWindow` (X11 panel backend) |
| `Quickshell.WindowManager` | `WindowManager` singleton, `Windowset`, `ScreenProjection` |
| `Quickshell.Networking` | `Networking` singleton, `NetworkDevice`, `WifiDevice`, `WifiNetwork`, `WiredDevice`, NM enums |
| `Quickshell.Bluetooth` | `Bluetooth` singleton, `BluetoothAdapter`, `BluetoothDevice` |
| `Quickshell.DBusMenu` | `DBusMenuHandle`, `DBusMenuItem` |
| `Quickshell.Services.SystemTray` | `SystemTray` singleton, `SystemTrayItem` |
| `Quickshell.Services.Mpris` | `Mpris` singleton, `MprisPlayer`, playback/loop enums |
| `Quickshell.Services.Notifications` | `NotificationServer`, `Notification`, `NotificationAction`, urgency/close-reason enums |
| `Quickshell.Services.Pipewire` | `Pipewire` singleton, `PwNode`, `PwNodeAudio`, `PwLink`, `PwObjectTracker`, `PwNodePeakMonitor` |
| `Quickshell.Services.UPower` | `UPower` singleton, `UPowerDevice`, `PowerProfiles` |
| `Quickshell.Services.Pam` | `PamContext`, `PamError`, `PamResult` |
| `Quickshell.Services.Polkit` | `PolkitAgent`, `AuthFlow` |
| `Quickshell.Services.Greetd` | `Greetd` singleton, `GreetdState` |

`Quickshell.Wayland` / `Hyprland` / `I3` / `Networking` / service modules are built conditionally —
a type can be missing if the local build disabled that feature. `Quickshell.hasVersion(major,
minor, features)` can gate on this.

Specify a version on Quickshell imports (`import Quickshell 0.1`) to reduce breakage across
updates; Quickshell's APIs change faster than Qt's.

## Windows

### `PanelWindow` — bars, docks, widgets (use this for panels)

Decorationless window anchored to screen edges. Platform-independent: backed by
`WlrLayershell` on Wayland and `XPanelWindow` on X11.

```qml
import Quickshell
import QtQuick

PanelWindow {
  anchors { top: true; left: true; right: true }
  implicitHeight: 30
  color: "#1e1e2e"

  Text {
    anchors.centerIn: parent
    text: "hello"
  }
}
```

Properties (beyond the common window properties below):

| Property | Notes |
| --- | --- |
| `anchors` | `{ left, right, top, bottom }` booleans. All default **false**. Anchoring two opposite sides forces that dimension to the screen's. |
| `margins` | `{ left, right, top, bottom }` offsets from the screen edges. **Only applies to anchored edges.** |
| `exclusiveZone` | Space reserved for the panel, relative to its anchors. Setting it forces `exclusionMode: ExclusionMode.Normal`. Needs exactly 1 or 3 anchors to take effect. |
| `exclusionMode` | `ExclusionMode.Auto` (default — reserves exactly the window size + margins when 3 anchors are set), `.Normal` (respect others, set your own zone), `.Ignore` (ignore other layers' zones; cannot set a zone). |
| `aboveWindows` | Render above normal windows. Default `true`. Maps to `WlrLayershell.layer`. |
| `focusable` | Accept keyboard focus. Default `false`. Maps to `WlrLayershell.keyboardFocus`. |

Set `implicitHeight` (for a horizontal bar) or `implicitWidth` (vertical) — the anchored axis is
sized by the anchors.

#### `WlrLayershell` — Wayland-specific panel control

Works as an **attached object** on `PanelWindow`. Prefer plain `PanelWindow` properties when they
suffice; reach for this for the Wayland-only bits:

```qml
import Quickshell
import Quickshell.Wayland

PanelWindow {
  WlrLayershell.layer: WlrLayer.Top
  WlrLayershell.namespace: "my-bar"        // surface namespace, for compositor rules
  WlrLayershell.keyboardFocus: WlrKeyboardFocus.OnDemand
  // ...
}
```

- `WlrLayer`: `Background`, `Bottom`, `Top` (usual choice for panels/docks/launchers),
  `Overlay` (over fullscreen windows).
- `WlrKeyboardFocus`: `None`, `OnDemand` (OS decides; can unexpectedly retain focus on some
  compositors — try `None` if that happens), `Exclusive` (locks out other windows —
  **not** a secure lock screen; use `WlSessionLock` for that).
- `namespace` must be set before the window is created to take effect.

### `PopupWindow`

Popup positioned relative to a parent window or item. Properties: `parentWindow`, `relativeX`,
`relativeY`, `anchor` (a `PopupAnchor` with `window`, `item`, `rect`, `margins`, `edges`,
`gravity`, `adjustment`), `grabFocus`.

### `FloatingWindow`

Ordinary desktop window with decorations. Adds `title`, `minimumSize`, `maximumSize`.
Useful for debug/settings windows.

### Common window properties

Shared by all of the above (from `WindowInterface`): `visible`, `screen` (a `ShellScreen`),
`color`, `width`/`height`, `implicitWidth`/`implicitHeight`, `contentItem`, `mask` (input region —
a `Region`), `opaque`, `devicePixelRatio`, `surfaceFormat`, `updatesEnabled`,
`backingWindowVisible`, `data` (default property).

Use `mask` to make parts of a panel click-through:

```qml
PanelWindow {
  mask: Region { item: onlyThisPartIsClickable }
}
```

### One panel per monitor

`Variants` instantiates non-`Item` objects (windows) from a model — the `Repeater` equivalent for
non-visual objects. It also acts as a reload scope. Each distinct model value is injected as
`modelData`.

```qml
import Quickshell

Variants {
  model: Quickshell.screens

  PanelWindow {
    required property var modelData
    screen: modelData

    anchors { top: true; left: true; right: true }
    implicitHeight: 30
  }
}
```

Because `Quickshell.screens` is reactive, panels are created and destroyed as monitors are plugged
and unplugged. **Always do this** — a panel bound to a single screen disappears permanently when
that monitor disconnects.

Shared state (timers, processes) belongs *outside* the delegate — the delegate is instantiated
zero or more times, and its `id`s are not reachable from outside. Put the state in a file-root
property or a singleton and bind to it.

## Core types (`Quickshell`)

- **`Quickshell`** (singleton) — `screens`, `shellDir`, `configDir`, `dataDir`, `stateDir`,
  `cacheDir`, `shellRoot`, `workingDirectory`, `watchFiles`, `clipboardText`, `processId`,
  `instanceId`, `shellId`, `launchTime`.
  Functions: `reload(hard)`, `env(name)`, `execDetached(cmd)`, `iconPath(icon[, fallback|check])`,
  `hasThemeIcon(icon)`, `shellPath/configPath/dataPath/statePath/cachePath(rel)`,
  `inhibitReloadPopup()`, `hasVersion(maj, min[, features])`, `hasQtVersion(maj, min)`.
- **`ShellRoot`** — *optional* root element; exists only to set `settings` inline. Not required.
- **`Scope`** — non-visual grouping object + reload scope. The usual root for a multi-object
  `.qml` file that isn't a window.
- **`Singleton`** — root object for `pragma Singleton` files.
- **`LazyLoader`** — asynchronous/deferred loading of parts of the UI that need not exist at
  startup. Worth using for popups and menus.
- **`PersistentProperties`** — properties that survive a config reload.
- **`Variants`** — see above. `delegate` (default property), `model`, `instances`.
- **`ScriptModel`** — a list model driven by a JS expression; use it to feed `Repeater`/`ListView`
  from computed arrays with proper add/remove transitions.
- **`ShellScreen`** — per-monitor info (from `Quickshell.screens`).
- **`SystemClock`** — a clock that ticks at a chosen `precision`, exposing `date`, `hours`,
  `minutes`, `seconds` and an `enabled` toggle. Prefer it over a `Timer` + `new Date()`.
- **`ElapsedTimer`**, **`EasingCurve`**, **`TransformWatcher`**, **`ColorQuantizer`**,
  **`BoundComponent`**, **`ObjectModel`**, **`Region`**, **`Retainable`**/`RetainableLock`.
- **`DesktopEntries`** (singleton) / **`DesktopEntry`** / **`DesktopAction`** — `.desktop` files,
  for launchers.
- **`QsMenuOpener`** / `QsMenuAnchor` / `QsMenuEntry` / `QsMenuHandle` — consume menus
  (e.g. tray menus) and render them yourself.

## IO (`Quickshell.Io`)

**`Process`** — `command` (array; each argument its own string), `running`, `processId`,
`workingDirectory`, `environment`, `clearEnvironment`, `stdout`, `stderr`, `stdinEnabled`.
Set `running: true` to (re)start.

```qml
import Quickshell.Io

Process {
  id: proc
  command: ["sh", "-c", "some | pipeline"]
  running: true
  stdout: StdioCollector {
    onStreamFinished: root.value = this.text
  }
}
```

Stream parsers assigned to `stdout`/`stderr`:

- **`SplitParser`** — emits `read(data)` per delimiter-separated chunk (line-based output).
- **`StdioCollector`** — buffers everything, emits `streamFinished()` and exposes `text`/`data`.
  With the default `waitForEnd: true`, `text`/`data` only populate at the end of the stream.

For a long-running process, prefer `SplitParser` + a handler; for a one-shot command, prefer
`StdioCollector`. For polling, drive `running = true` from a `Timer` — but check whether a service
module (UPower, Pipewire, Mpris, Networking, Bluetooth) already provides the data before shelling
out.

**`FileView`** — read/write files. `path`, `preload`, `blockLoading`, `blockAllReads`,
`printErrors`, `watchChanges`, `blockWrites`, `atomicWrites`, `adapter`, `loaded`;
functions `text()`, `data()`. Pair with **`JsonAdapter`** for typed JSON config files that write
back automatically.

**`Socket`** / **`SocketServer`** — unix socket client/server (both are `DataStream`s).

**`IpcHandler`** — expose named functions to `qs ipc call <target> <function> [args]`, the clean
way to bind a compositor key to a shell action:

```qml
IpcHandler {
  target: "bar"
  function toggle(): void { root.visible = !root.visible }
}
```

## Widgets (`Quickshell.Widgets`)

- **`IconImage`** — icon rendering done right (sizing, mipmaps, async). `source` (pair with
  `Quickshell.iconPath(...)`), `implicitSize`, `asynchronous`, `status`, `backer`.
- **`ClippingRectangle`** / **`ClippingWrapperRectangle`** — a `Rectangle` that actually clips
  children to its rounded corners.
- **`WrapperItem`** / **`WrapperRectangle`** / **`WrapperMouseArea`** — wrap a single child and
  size to it with margins, propagating implicit size. The idiomatic way to add padding or a
  background to one widget without writing implicit-size arithmetic by hand.

## Services quick reference

All of these are singletons unless noted; each exposes reactive models you can bind straight into
a `Repeater`.

- **`SystemTray`** — `items` (`SystemTrayItem`: `id`, `title`, `icon`, `status`, `category`,
  `tooltipTitle`/`tooltipDescription`, `hasMenu`/`onlyMenu`, `menu` (a `DBusMenuHandle`, render it
  via `QsMenuOpener`); functions `activate()`, `secondaryActivate()`, `scroll(delta, horizontal)`,
  `display(parentWindow, relativeX, relativeY)`).
- **`Mpris`** — `players` (`MprisPlayer`: metadata, `playbackState`, `loopState`, position,
  volume, transport controls).
- **`Pipewire`** — `nodes`, `links`, `defaultAudioSink`/`Source`. Bind `PwObjectTracker` to the
  nodes you read, or their properties stay unpopulated. `PwNodeAudio` for volume/mute,
  `PwNodePeakMonitor` for level meters.
- **`UPower`** — `devices`, `displayDevice` (battery percentage, state, time-to-empty);
  `PowerProfiles` for power-profiles-daemon.
- **`NotificationServer`** (not a singleton — instantiate one) — becomes the DBus notification
  daemon and emits `notification(Notification)`. `Notification` is `Retainable`, so you control
  when it is destroyed (for close animations).
- **`Bluetooth`** — `adapters`, `devices`, `defaultAdapter`.
- **`Networking`** — `devices` / wifi networks via NetworkManager.
- **`Hyprland`** — `workspaces`, `monitors`, `toplevels`, `focusedWorkspace`, `dispatch(...)`,
  `rawEvent` / `HyprlandEvent`. Use this rather than shelling out to `hyprctl`.
- **`I3`** — the equivalent for i3/sway: `workspaces`, `monitors`, `dispatch(...)`, `I3IpcListener`.
  **Relevant here** — this repo configures Sway.
- **`Pam`** (`PamContext`) — authentication, for lock screens. Combine with `WlSessionLock`.
- **`Polkit`** (`PolkitAgent`) — act as the polkit agent.

## Gotchas

- All `PanelWindow` anchors default to `false`. With no anchors the panel is not attached to any
  edge and its exclusive zone will not apply.
- `margins` are ignored on edges that aren't anchored.
- `exclusiveZone` needs 1 or 3 anchors; with 3 anchors `ExclusionMode.Auto` already does the right
  thing, so setting it explicitly is usually unnecessary.
- An `id` defined inside a `Variants` delegate (or any component) cannot be referenced from
  outside it — lift the state to the file root or a singleton.
- `time: time` in a component silently binds a property to itself. Qualify with the root's `id`
  (`time: root.time`).
- Setting a property from a signal handler destroys any binding on it.
- `Variants` has a known bug: it fails to reload children if the variant set changes *during*
  instantiation.
- `WlrKeyboardFocus.Exclusive` is not a security boundary. Lock screens need `WlSessionLock`.
- Pipewire node properties are empty unless a `PwObjectTracker` references the node.
- Use `implicitWidth`/`implicitHeight`, not `width`/`height`, in reusable components.

## Corrections to the published guide

The v0.3.0 guide pages at quickshell.org are partly out of date relative to the source:

- **`ShellRoot` is optional**, documented in the source as "Optional root config element, allowing
  some settings to be specified inline". The guide's intro wraps every example in one. A
  `PanelWindow` (or `Scope`) as the file root works fine — as in the existing `shell.qml` here.
- The guide builds its clock with `Process { command: ["date"] }` + `Timer`. Prefer
  **`SystemClock`**, or a `Timer` with the JS `Date` API; don't spawn a process per second.
- `Variants` delegates in the guide use `property var modelData`; prefer
  `required property var modelData` so a missing injection is an error.
