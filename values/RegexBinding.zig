//! A `regex-launch` or `regex-copy` binding, written `[name] keys`: regex mode for the
//! `[regex:name]` section, from the app's `regex` or foot.ini.

/// The name of the regex section, without `regex:`.
regex: []const u8,
/// Key combinations in XKB names (`Control+Shift+q`). Empty: none.
keys: []const []const u8 = &.{},
