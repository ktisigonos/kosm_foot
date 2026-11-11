//! One `[text-bindings]` entry: what foot sends to the program when one of `keys` is pressed.

/// Printable characters as they are, bytes as `\x1b` (two hex digits).
text: []const u8,
/// Key combinations in XKB names (`Mod4+k`); at least one.
keys: []const []const u8,
