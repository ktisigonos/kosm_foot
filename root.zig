//! foot: every option of foot.ini, in a file foot.ini includes.

const std = @import("std");
const kosm_ini = @import("kosm_ini");

/// foot's settings; build one with `from`.
pub const App = @import("App.zig");
/// Colors from the theme.
pub const from = App.from;
/// foot.ini's INI: `key=value`, `#` comments (also after a value, past whitespace), `RRGGBB`
/// colors and `yes`/`no`.
pub const adapter = kosm_ini.dialect(.{
    .name = "foot",
    .default_format = .{ .color = .init("{}", &.{.hex}), .boolean = .yes_no },
    .comments = &.{"#"},
    .inline_comments = true,
    .nested_headers = false,
    .separator = "=",
});

test {
    std.testing.refAllDecls(@This());
    std.testing.refAllDecls(App);
    std.testing.refAllDecls(@import("settings.zig"));
}
