//! foot: its fonts and color themes, in a file foot.ini includes.

const std = @import("std");
const kosm_ini = @import("kosm_ini");

/// foot's fonts and colors; build one with `from`.
pub const App = @import("App.zig");
/// Colors from the theme.
pub const from = App.from;
/// foot.ini's INI: `key=value`, `#` comments, `RRGGBB` colors and `yes`/`no`.
pub const adapter = kosm_ini.dialect(.{
    .name = "foot",
    .default_format = .{ .color = .init("{}", &.{.hex}), .boolean = .yes_no },
    .comments = &.{"#"},
    .nested_headers = false,
    .separator = "=",
});

test {
    std.testing.refAllDecls(@This());
    std.testing.refAllDecls(App);
}
