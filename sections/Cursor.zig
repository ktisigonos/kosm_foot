//! foot's `[cursor]` options. Programs can change these while running.

const values = @import("../values.zig");

/// The cursor's shape. null: foot's default, block.
style: ?Style = null,
/// How the cursor looks while the window is unfocused. null: foot's default, a hollow block.
unfocused_style: ?UnfocusedStyle = null,
/// Blinks the cursor. null: foot's default, no.
blink: ?bool = null,
/// Milliseconds between blinks. null: foot's default, 500.
blink_rate: ?u32 = null,
/// The beam's width. null: foot's default, 1.5 points.
beam_thickness: ?values.Length = null,
/// The underline cursor's height; set, it no longer scales with the font. null: the font's underline thickness.
underline_thickness: ?values.Length = null,

pub const Style = enum { block, beam, underline, hollow };

pub const UnfocusedStyle = enum {
    /// As when focused.
    unchanged,
    /// A hollow block.
    hollow,
    /// No cursor.
    none,
};
