# EasyTodo

A lightweight, native macOS todo app. Press **Control** to instantly capture a todo from anywhere — no window switching needed.

## Features

- **Global Quick Add** — Single press `Control` to summon a floating input bar, type and hit `Enter`. Done.
- **Minimal UI** — Clean white interface, no clutter. Just your todos.
- **Full CRUD** — Add, complete, edit (hover → pencil icon), and delete from the main window.
- **Menu Bar** — Always accessible from your menu bar with a quick preview of pending todos.
- **Dock + Menu Bar** — Lives in both. Click the Dock icon to open the main window.
- **Persistent** — Todos saved as JSON, survives restarts.
- **Zero dependencies** — Pure Swift + SwiftUI + AppKit. No third-party libraries.

## Requirements

- macOS 14.0+
- Accessibility permission (for global `Control` key shortcut)

## Install

```bash
git clone https://github.com/your-username/EasyTodo.git
cd EasyTodo
open EasyTodo.xcodeproj
```

Build and run with `⌘R` in Xcode.

> On first launch, macOS will prompt you to grant Accessibility permission in **System Settings → Privacy & Security → Accessibility**. This is required for the global shortcut to work.

## Usage

| Action | How |
|---|---|
| Quick add todo | Press `Control` → type → `Enter` |
| Dismiss quick input | `Escape` or press `Control` again |
| Add from main window | Type in the top input bar → `Enter` |
| Complete a todo | Click the circle checkbox |
| Edit a todo | Hover → click pencil icon |
| Delete a todo | Hover → click `×` button |

## Tech Stack

- **SwiftUI** — Main window, menu bar, floating input view
- **AppKit** — `NSPanel` for the floating HUD, `NSEvent` for global key monitoring
- **JSON file** — `~/Library/Application Support/EasyTodo/todos.json`

## License

MIT
