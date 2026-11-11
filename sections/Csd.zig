//! foot's `[csd]` options: client-side decorations. Unlike the themes' colors, these keep their
//! alpha and are written `AARRGGBB`.

const kosm = @import("kosm");
const values = @import("../values.zig");

/// Which decorations foot asks the compositor for. null: foot's default, server.
preferred: ?Preferred = null,
/// The titlebar's height in pixels; 0 hides it but keeps the border. null: foot's default, 26.
size: ?u32 = null,
/// The titlebar's fonts; sizes are ignored, the titlebar sets them. null: the primary font.
font: ?[]const values.Font = null,
/// The titlebar. null: the theme's foreground.
color: ?kosm.Color = null,
/// Hides the titlebar while maximized. null: foot's default, no.
hide_when_maximized: ?bool = null,
/// Double-clicking the titlebar maximizes or restores. null: foot's default, yes.
double_click_to_maximize: ?bool = null,
/// The border around the whole window, in pixels. null: foot's default, 0.
border_width: ?u32 = null,
/// The border. null: the titlebar's color.
border_color: ?kosm.Color = null,
/// The width of each button, in pixels. null: foot's default, 26.
button_width: ?u32 = null,
/// The buttons' icons and the title text. null: the theme's background.
button_color: ?kosm.Color = null,
/// The minimize button's background. null: the theme's regular4.
button_minimize_color: ?kosm.Color = null,
/// The maximize button's background. null: the theme's regular2.
button_maximize_color: ?kosm.Color = null,
/// The close button's background. null: the theme's regular1.
button_close_color: ?kosm.Color = null,

pub const Preferred = enum {
    /// foot draws them.
    client,
    /// The compositor draws them.
    server,
    none,
};
