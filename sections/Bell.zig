//! foot's `[bell]` options: what a BEL does.

/// Rings the system bell. null: foot's default, yes.
system: ?bool = null,
/// Marks an unfocused window urgent (or paints its margins red). null: foot's default, no.
urgent: ?bool = null,
/// Shows a desktop notification, by `desktop_notifications.command`. null: foot's default, no.
notify: ?bool = null,
/// Flashes the window. null: foot's default, no.
visual: ?bool = null,
/// A command to run. null: none.
command: ?[]const u8 = null,
/// Runs `command` even while the window is focused. null: foot's default, no.
command_focused: ?bool = null,
