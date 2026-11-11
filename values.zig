//! The values foot's options take beyond plain numbers, text and colors.

pub const Font = @import("values/Font.zig");
pub const ColorPair = @import("values/ColorPair.zig");
pub const Pad = @import("values/Pad.zig");
pub const WindowSize = @import("values/WindowSize.zig");
pub const Pipe = @import("values/Pipe.zig");
pub const RegexBinding = @import("values/RegexBinding.zig");
pub const Regex = @import("values/Regex.zig");
pub const EnvironmentVariable = @import("values/EnvironmentVariable.zig");
pub const TextBinding = @import("values/TextBinding.zig");
pub const PaletteColor = @import("values/PaletteColor.zig");

/// A length in points (scaled with the monitor's DPI) or pixels: `.{ .pixels = 2 }` is `2px`.
pub const Length = union(enum) {
    points: f64,
    pixels: f64,
};

/// How much one zoom step changes the font size: points, pixels (`10px`) or percent (`7.5%`).
pub const FontSizeAdjustment = union(enum) {
    points: f64,
    pixels: f64,
    percent: f64,
};
