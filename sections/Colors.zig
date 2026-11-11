//! A `[colors-dark]` or `[colors-light]` theme. Colors are opaque; the background's
//! translucency is `alpha`. Programs can change them while running.

const kosm = @import("kosm");
const values = @import("../values.zig");

/// Background translucency, 0 (transparent) to 1 (opaque). null: foot's default, 1.
alpha: ?f64 = null,
/// Which cells `alpha` applies to. null: foot's default, default.
alpha_mode: ?AlphaMode = null,
/// Blurs a translucent background; needs compositor support. null: foot's default, no.
blur: ?bool = null,
/// Text in the default color. null: foot's default, `839496`.
foreground: ?kosm.Color = null,
/// The default background. null: foot's default, `002b36`.
background: ?kosm.Color = null,
/// The cursor (`background`) and the text under it. null: foreground and background reversed.
cursor: ?values.ColorPair = null,
/// ANSI black. null: foot's default.
regular0: ?kosm.Color = null,
/// ANSI red. null: foot's default.
regular1: ?kosm.Color = null,
/// ANSI green. null: foot's default.
regular2: ?kosm.Color = null,
/// ANSI yellow. null: foot's default.
regular3: ?kosm.Color = null,
/// ANSI blue. null: foot's default.
regular4: ?kosm.Color = null,
/// ANSI magenta. null: foot's default.
regular5: ?kosm.Color = null,
/// ANSI cyan. null: foot's default.
regular6: ?kosm.Color = null,
/// ANSI white. null: foot's default.
regular7: ?kosm.Color = null,
/// Bright black. null: foot's default.
bright0: ?kosm.Color = null,
/// Bright red. null: foot's default.
bright1: ?kosm.Color = null,
/// Bright green. null: foot's default.
bright2: ?kosm.Color = null,
/// Bright yellow. null: foot's default.
bright3: ?kosm.Color = null,
/// Bright blue. null: foot's default.
bright4: ?kosm.Color = null,
/// Bright magenta. null: foot's default.
bright5: ?kosm.Color = null,
/// Bright cyan. null: foot's default.
bright6: ?kosm.Color = null,
/// Bright white. null: foot's default.
bright7: ?kosm.Color = null,
/// Dimmed black, used for text in `regular0` (and `regular0` for `bright0`). null: blended by `dim_blend_towards`.
dim0: ?kosm.Color = null,
/// Dimmed red, used for text in `regular1` (and `regular1` for `bright1`). null: blended by `dim_blend_towards`.
dim1: ?kosm.Color = null,
/// Dimmed green, used for text in `regular2` (and `regular2` for `bright2`). null: blended by `dim_blend_towards`.
dim2: ?kosm.Color = null,
/// Dimmed yellow, used for text in `regular3` (and `regular3` for `bright3`). null: blended by `dim_blend_towards`.
dim3: ?kosm.Color = null,
/// Dimmed blue, used for text in `regular4` (and `regular4` for `bright4`). null: blended by `dim_blend_towards`.
dim4: ?kosm.Color = null,
/// Dimmed magenta, used for text in `regular5` (and `regular5` for `bright5`). null: blended by `dim_blend_towards`.
dim5: ?kosm.Color = null,
/// Dimmed cyan, used for text in `regular6` (and `regular6` for `bright6`). null: blended by `dim_blend_towards`.
dim6: ?kosm.Color = null,
/// Dimmed white, used for text in `regular7` (and `regular7` for `bright7`). null: blended by `dim_blend_towards`.
dim7: ?kosm.Color = null,
/// What dimmed colors without a `dimN` blend towards. null: black in colors-dark, white in colors-light.
dim_blend_towards: ?DimBlendTowards = null,
/// Colors 16 to 255 of the 256-color palette, each index at most once. Default: none, foot's own.
palette: []const values.PaletteColor = &.{},
/// Sixel palette color 0. null: foot's default.
sixel0: ?kosm.Color = null,
/// Sixel palette color 1. null: foot's default.
sixel1: ?kosm.Color = null,
/// Sixel palette color 2. null: foot's default.
sixel2: ?kosm.Color = null,
/// Sixel palette color 3. null: foot's default.
sixel3: ?kosm.Color = null,
/// Sixel palette color 4. null: foot's default.
sixel4: ?kosm.Color = null,
/// Sixel palette color 5. null: foot's default.
sixel5: ?kosm.Color = null,
/// Sixel palette color 6. null: foot's default.
sixel6: ?kosm.Color = null,
/// Sixel palette color 7. null: foot's default.
sixel7: ?kosm.Color = null,
/// Sixel palette color 8. null: foot's default.
sixel8: ?kosm.Color = null,
/// Sixel palette color 9. null: foot's default.
sixel9: ?kosm.Color = null,
/// Sixel palette color 10. null: foot's default.
sixel10: ?kosm.Color = null,
/// Sixel palette color 11. null: foot's default.
sixel11: ?kosm.Color = null,
/// Sixel palette color 12. null: foot's default.
sixel12: ?kosm.Color = null,
/// Sixel palette color 13. null: foot's default.
sixel13: ?kosm.Color = null,
/// Sixel palette color 14. null: foot's default.
sixel14: ?kosm.Color = null,
/// Sixel palette color 15. null: foot's default.
sixel15: ?kosm.Color = null,
/// Selected text. null: the cell's colors reversed.
selection_foreground: ?kosm.Color = null,
/// The selection's background. null: the cell's colors reversed.
selection_background: ?kosm.Color = null,
/// Jump labels in URL mode. null: regular0 on regular3.
jump_labels: ?values.ColorPair = null,
/// The scrollback position indicator. null: regular0 on bright4.
scrollback_indicator: ?values.ColorPair = null,
/// The search box with no matches. null: regular0 on regular1.
search_box_no_match: ?values.ColorPair = null,
/// The search box while empty or with matches. null: regular0 on regular3.
search_box_match: ?values.ColorPair = null,
/// URL underlines in URL mode. null: regular3.
urls: ?kosm.Color = null,
/// The window flash of a visual bell. null: foot's default, `7f7f00`.
flash: ?kosm.Color = null,
/// The flash's translucency, 0 (transparent) to 1 (opaque). null: foot's default, 0.5.
flash_alpha: ?f64 = null,

pub const AlphaMode = enum {
    /// Cells in the default background, but not others of the same color.
    default,
    /// Cells in the default background's color too.
    matching,
    /// Every cell.
    all,
};

pub const DimBlendTowards = enum { black, white };
