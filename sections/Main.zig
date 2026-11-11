//! foot's `[main]` options.

const values = @import("../values.zig");

/// The program foot runs, with arguments (`/bin/bash --norc`). null: `$SHELL`, else the
/// user's shell from /etc/passwd.
shell: ?[]const u8 = null,
/// Runs the shell as a login shell. null: foot's default, no.
login_shell: ?bool = null,
/// `TERM` for the program. null: foot's default, `foot`.
term: ?[]const u8 = null,
/// Absolute (or `~/`) paths of more config files to read, each its own `include` line. Default: none.
include: []const []const u8 = &.{},
/// `font`: the regular font and its fallbacks, in order. null: foot's default, `monospace:size=8`.
font: ?[]const values.Font = null,
/// `font-bold`. null: the regular font in bold.
font_bold: ?[]const values.Font = null,
/// `font-italic`. null: the regular font in italic.
font_italic: ?[]const values.Font = null,
/// `font-bold-italic`. null: the regular font in bold italic.
font_bold_italic: ?[]const values.Font = null,
/// How much one zoom step changes the font size. null: foot's default, 0.5 points.
font_size_adjustment: ?values.FontSizeAdjustment = null,
/// Line height, replacing the font's. null: the font's own.
line_height: ?values.Length = null,
/// Extra space between letters; negative shrinks cells. null: foot's default, 0.
letter_spacing: ?values.Length = null,
/// Moves glyphs right within their cells. null: foot's default, 0.
horizontal_letter_offset: ?values.Length = null,
/// Moves glyphs down within their cells. null: foot's default, 0.
vertical_letter_offset: ?values.Length = null,
/// Underline position below the baseline; negative is above. null: the font's own.
underline_offset: ?values.Length = null,
/// Underline thickness. null: the font's own.
underline_thickness: ?values.Length = null,
/// Strikeout thickness. null: the font's own.
strikeout_thickness: ?values.Length = null,
/// Blends glyphs in linear color space: bright text on dark looks thicker. null: foot's default, no.
gamma_correct_blending: ?bool = null,
/// Pastes the text of an uppercase hint in `show-urls-copy` or `regex-copy` mode as well as copying it. null: foot's default, yes.
uppercase_regex_insert: ?bool = null,
/// Draws box and line characters with the font instead of foot's own. null: foot's default, no.
box_drawings_uses_font_glyphs: ?bool = null,
/// Sizes fonts by the monitor's DPI instead of its scaling factor. null: foot's default, no.
dpi_aware: ?bool = null,
/// The space between the border and the text. null: foot's default, none, centered when
/// maximized or fullscreen.
pad: ?values.Pad = null,
/// Idle milliseconds before foot reflows the text while resizing; 0 reflows at once. null: foot's default, 100.
resize_delay_ms: ?u32 = null,
/// Keeps floating windows a whole number of cells in size. null: foot's default, yes.
resize_by_cells: ?bool = null,
/// Resizes floating windows when the font size changes, to keep the grid. null: foot's default, yes.
resize_keep_grid: ?bool = null,
/// The color theme foot starts with. null: foot's default, dark.
initial_color_theme: ?ColorTheme = null,
/// The first window's size in pixels; titlebar included with CSDs. Not with `initial_window_size_chars`. null: foot's default, 700x500.
initial_window_size_pixels: ?values.WindowSize = null,
/// The first window's size in characters. Not with `initial_window_size_pixels`. null: not set.
initial_window_size_chars: ?values.WindowSize = null,
/// How new windows open. null: foot's default, windowed.
initial_window_mode: ?WindowMode = null,
/// The first window title. null: foot's default, `foot`.
title: ?[]const u8 = null,
/// Keeps programs from changing the title. null: foot's default, no.
locked_title: ?bool = null,
/// The Wayland app-id, for window rules. null: `foot`, or `footclient` in server mode.
app_id: ?[]const u8 = null,
/// The Wayland toplevel tag, for session management and window rules. null: not set.
toplevel_tag: ?[]const u8 = null,
/// Draws bold text in brighter colors too. null: foot's default, no.
bold_text_in_bright: ?BoldTextInBright = null,
/// Characters ending a word when selecting; whitespace always does. null: foot's default.
word_delimiters: ?[]const u8 = null,
/// Where selected text is copied. null: foot's default, primary.
selection_target: ?SelectionTarget = null,
/// Rendering threads; 0 renders on one. null: the number of logical CPUs.
workers: ?u32 = null,
/// The utmp helper binary, or `none` for no utmp records. null: foot's default, `/usr/lib/utempter/utempter`.
utmp_helper: ?[]const u8 = null,

/// `[colors-dark]` or `[colors-light]`.
pub const ColorTheme = enum { dark, light };

pub const WindowMode = enum { windowed, maximized, fullscreen };

pub const BoldTextInBright = enum {
    no,
    /// Blends bold text's color with white.
    yes,
    /// Bold text in one of the regular colors takes its bright color; other colors stay.
    palette_based,
};

pub const SelectionTarget = enum { none, primary, clipboard, both };
