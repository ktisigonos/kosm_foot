//! foot's `[desktop-notifications]` options.

/// The command showing a notification, with `${title}`, `${body}`, `${app-id}` and the other
/// templates foot.ini(5) lists. null: foot's `notify-send` command.
command: ?[]const u8 = null,
/// What `${action-argument}` expands to per action, from `${action-name}` and
/// `${action-label}`; empty passes no actions. null: foot's default, `--action ${action-name}=${action-label}`.
command_action_argument: ?[]const u8 = null,
/// The command closing a notification, `${id}` its ID. null: foot sends the helper SIGINT.
close: ?[]const u8 = null,
/// Shows no notifications while the window is focused. null: foot's default, yes.
inhibit_when_focused: ?bool = null,
