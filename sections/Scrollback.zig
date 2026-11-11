//! foot's `[scrollback]` options.

/// Lines kept. null: foot's default, 1000.
lines: ?u32 = null,
/// How many lines one mouse scroll step moves. null: foot's default, 3.
multiplier: ?f64 = null,
/// Where the position indicator is drawn. null: foot's default, relative.
indicator_position: ?IndicatorPosition = null,
/// The indicator's text: `percentage`, `line`, or fixed text. null: foot's default, empty.
indicator_format: ?[]const u8 = null,

pub const IndicatorPosition = enum {
    none,
    /// Near the top of the window.
    fixed,
    /// At the scrollback position.
    relative,
};
