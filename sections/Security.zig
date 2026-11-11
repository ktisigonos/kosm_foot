//! foot's `[security]` options.

/// What programs may do with the clipboard through OSC-52. null: foot's default, enabled.
osc52: ?Osc52 = null,

pub const Osc52 = enum {
    disabled,
    /// Programs may write the clipboard but not read it.
    copy_enabled,
    /// Programs may read the clipboard but not write it.
    paste_enabled,
    enabled,
};
