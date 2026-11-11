//! A `[regex:name]` section: matches that `regex-launch` and `regex-copy` bindings tag with
//! jump labels, like URL mode.

/// The section's name, which bindings refer to.
name: []const u8,
/// A POSIX extended regular expression; its first marked subexpression is the match.
regex: []const u8,
/// The command run on a launched match; `${match}` is replaced with it. null: none.
launch: ?[]const u8 = null,
