//! A `pipe-*` binding: text piped to a command, written `[command] keys`. foot takes several
//! per action as long as their commands differ and their keys are unique.

/// The command and its arguments, as foot splits them; it runs without a shell, so use
/// `sh -c "..."` for one.
command: []const u8,
/// Key combinations in XKB names (`Control+Shift+p`). Empty: none, the command is only listed.
keys: []const []const u8 = &.{},
