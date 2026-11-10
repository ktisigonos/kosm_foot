//! foot's fonts and color themes. `generate` writes the set ones to `file`, which foot.ini
//! includes (`include=~/.config/foot/kosm.ini`); null options are left to foot.ini and foot's
//! defaults. Field names are foot's option names in Zig casing (`font_bold` for `font-bold`).

const App = @This();

const std = @import("std");
const kosm = @import("kosm");

/// The file kosm owns; foot.ini includes it. Default: `~/.config/foot/kosm.ini`.
file: []const u8 = "~/.config/foot/kosm.ini",
/// How values are spelled. Null fields take the foot adapter's: `RRGGBB` lowercase, `yes`/`no`.
format: kosm.Format = .{},
/// foot's `[main]` options.
main: Main = .{},
/// `[colors-dark]`: the theme foot starts with, unless foot.ini sets `initial-color-theme=light`.
colors_dark: Colors = .{},
/// `[colors-light]`: the theme foot switches to on SIGUSR2 or its theme-switch bindings.
colors_light: Colors = .{},
/// Options the app doesn't cover, by `section.option` with foot's own names:
/// `.{ .path = "main.pad", .value = .{ .raw = "10x10" } }`. One that repeats a set option or
/// another extra fails the apply. Default: none.
extra: []const kosm.Setting = &.{},

/// foot's `[main]` fonts. Each is a list in fallback order: `&.{ .{ .family = "Iosevka",
/// .size = 13 }, .{ .family = "Noto Color Emoji" } }`. null: foot's own.
pub const Main = struct {
    /// `font`: the regular font and its fallbacks. null: foot's default, `monospace:size=8`.
    font: ?[]const Font = null,
    /// `font-bold`. null: the regular font in bold.
    font_bold: ?[]const Font = null,
    /// `font-italic`. null: the regular font in italic.
    font_italic: ?[]const Font = null,
    /// `font-bold-italic`. null: the regular font in bold italic.
    font_bold_italic: ?[]const Font = null,
};

/// One font of a list, written `Family:size=13`.
pub const Font = struct {
    /// The fontconfig family name. It may not hold `,` or `:`, which separate fonts and options.
    family: []const u8,
    /// The size in points. null: foot's.
    size: ?f64 = null,
};

/// A `[colors-dark]` or `[colors-light]` theme. Colors are opaque; the background's
/// translucency is `alpha`.
pub const Colors = struct {
    /// Background translucency, 0 (transparent) to 1 (opaque). null: foot's default, 1.
    alpha: ?f64 = null,
    /// Text in the default color. null: foot's default, `839496`.
    foreground: ?kosm.Color = null,
    /// The default background. null: foot's default, `002b36`.
    background: ?kosm.Color = null,
    /// The cursor and the text under it. null: foreground and background reversed.
    cursor: ?Cursor = null,
    /// Selected text. null: the cell's background color.
    selection_foreground: ?kosm.Color = null,
    /// The selection's background. null: the cell's foreground color.
    selection_background: ?kosm.Color = null,
    /// URL underlines and jump labels in URL mode. null: foot's default.
    urls: ?kosm.Color = null,
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
};

/// The cursor's two colors, written `text cursor`.
pub const Cursor = struct {
    /// The character under the cursor.
    text: kosm.Color,
    /// The cursor block itself.
    cursor: kosm.Color,
};

/// Colors from the theme into `colors_dark`, foot's starting theme, whatever the mode:
/// foreground and background from white and black (swapped in light mode), the background's
/// translucency from the theme's `background_alpha`, regular colors from the wheel and bright
/// ones from the theme's `lightness.bright`. Fonts are left alone.
pub fn from(theme: kosm.Theme) App {
    const palette = theme.palette;
    const variations = theme.variations;
    const foreground = if (theme.mode == .dark) palette.white else palette.black;
    const background = if (theme.mode == .dark) palette.black else palette.white;
    const regular = [_]kosm.Color{ palette.black, palette.red, palette.green, palette.yellow, palette.blue, palette.magenta, palette.cyan, palette.white };
    var colors: Colors = .{
        .alpha = theme.background_alpha,
        .foreground = foreground,
        .background = background,
        .cursor = .{ .text = background, .cursor = foreground },
        .selection_foreground = variations.emphasis.strong.apply(foreground),
        .selection_background = variations.state.selected.apply(background),
        .urls = palette.cyan,
    };
    inline for (regular, 0..) |color, index| {
        @field(colors, std.fmt.comptimePrint("regular{d}", .{index})) = color;
        @field(colors, std.fmt.comptimePrint("bright{d}", .{index})) = variations.lightness.bright.apply(color);
    }
    return .{ .colors_dark = colors };
}

/// Writes every set option to `file`, then the extras. foot reads its config only at start,
/// so running terminals keep their colors until restarted.
pub fn apply(self: App, output: *kosm.Output) !void {
    var sections: std.ArrayList(kosm.Value.Entry) = .empty;
    inline for (.{ "main", "colors_dark", "colors_light" }) |name| {
        const entries = try section(output, self.file, @field(self, name));
        if (entries.len != 0) try sections.append(output.allocator, .{ .key = comptime optionName(name), .value = .{ .table = entries } });
    }
    const own = try kosm.Setting.leaves(output.allocator, .{ .table = sections.items });
    const all = try kosm.Setting.withExtras(output, self.file, own, self.extra, .{});
    try output.generate(.{ .file = self.file, .lang = "foot", .format = self.format }, try kosm.Setting.tree(output.allocator, all));
}

/// The set options of one section, under foot's names.
fn section(output: *kosm.Output, file: []const u8, options: anytype) ![]const kosm.Value.Entry {
    var entries: std.ArrayList(kosm.Value.Entry) = .empty;
    const fields = @typeInfo(@TypeOf(options)).@"struct";
    inline for (fields.field_names) |name| {
        if (@field(options, name)) |option| {
            const value: kosm.Value = switch (@TypeOf(option)) {
                kosm.Color => .{ .color = option },
                f64 => .{ .float = option },
                Cursor => .{ .joined = try output.allocator.dupe(kosm.Value, &.{ .{ .color = option.text }, .{ .raw = " " }, .{ .color = option.cursor } }) },
                []const Font => .{ .string = try fontList(output, file, comptime optionName(name), option) },
                else => comptime unreachable,
            };
            try entries.append(output.allocator, .{ .key = comptime optionName(name), .value = value });
        }
    }
    return entries.items;
}

/// `Family:size=13, Fallback:size=13`, failing on an empty list or a family foot would split.
fn fontList(output: *kosm.Output, file: []const u8, option: []const u8, fonts: []const Font) ![]const u8 {
    if (fonts.len == 0) return output.fail(file, "'{s}' lists no fonts; leave it null to keep foot's own", .{option});
    var text: std.Io.Writer.Allocating = .init(output.allocator);
    for (fonts, 0..) |font, index| {
        if (font.family.len == 0 or std.mem.indexOfAny(u8, font.family, ",:") != null)
            return output.fail(file, "'{s}': font family '{s}' is empty or holds ',' or ':', which foot reads as separators", .{ option, font.family });
        if (index != 0) try text.writer.writeAll(", ");
        try text.writer.writeAll(font.family);
        if (font.size) |size| try text.writer.print(":size={d}", .{size});
    }
    return text.written();
}

/// foot's name for a field: `_` becomes `-`.
fn optionName(comptime name: []const u8) []const u8 {
    comptime {
        var text: [name.len]u8 = undefined;
        for (name, &text) |byte, *slot| slot.* = if (byte == '_') '-' else byte;
        const final = text;
        return &final;
    }
}

const testing = std.testing;
const adapter = @import("root.zig").adapter;

const Fixture = struct {
    tmp: testing.TmpDir,
    arena: std.heap.ArenaAllocator,
    plan: kosm.Plan,
    diagnostics: kosm.Diagnostics = .{},
    warnings: kosm.Warnings = undefined,
    home_buffer: [std.Io.Dir.max_path_bytes]u8 = undefined,
    output: kosm.Output = undefined,

    fn init(fixture: *Fixture) !void {
        fixture.* = .{ .tmp = testing.tmpDir(.{}), .arena = .init(testing.allocator), .plan = .init(testing.allocator, testing.io) };
        fixture.warnings = .init(fixture.arena.allocator());
        const length = try fixture.tmp.dir.realPath(testing.io, &fixture.home_buffer);
        fixture.output = .{
            .allocator = fixture.arena.allocator(),
            .home = fixture.home_buffer[0..length],
            .adapters = &.{adapter},
            .plan = &fixture.plan,
            .diagnostics = &fixture.diagnostics,
            .warnings = &fixture.warnings,
            .app = "foot",
        };
    }

    fn deinit(fixture: *Fixture) void {
        fixture.plan.deinit();
        fixture.arena.deinit();
        fixture.tmp.cleanup();
    }

    fn planned(fixture: *Fixture) []const u8 {
        for (fixture.plan.files.items) |file| {
            if (std.mem.eql(u8, file.display_path, "~/.config/foot/kosm.ini")) return file.new;
        }
        return "(not planned)";
    }
};

test "fonts in fallback order and the theme's colors in foot's spelling, extras last" {
    var fixture: Fixture = undefined;
    try fixture.init();
    defer fixture.deinit();
    var theme = kosm.Theme.from(.{ .black = kosm.hex("041c26"), .white = kosm.hex("a3c5cc"), .blue = kosm.hex("267180") }, .dark);
    theme.background_alpha = 0.8;
    var app = from(theme);
    app.main.font = &.{ .{ .family = "Maple Mono Normal NFP", .size = 13 }, .{ .family = "Noto Color Emoji" } };
    app.extra = &.{.{ .path = "main.pad", .value = .{ .raw = "10x10" } }};
    try app.apply(&fixture.output);

    const written = fixture.planned();
    try testing.expect(std.mem.startsWith(u8, written,
        \\[main]
        \\font=Maple Mono Normal NFP:size=13, Noto Color Emoji
        \\pad=10x10
        \\
        \\[colors-dark]
        \\alpha=0.8
        \\foreground=a3c5cc
        \\background=041c26
        \\cursor=041c26 a3c5cc
        \\
    ));
    try testing.expect(std.mem.indexOf(u8, written, "\nregular0=041c26\n") != null);
    try testing.expect(std.mem.indexOf(u8, written, "\nregular4=267180\n") != null);
    try testing.expect(std.mem.indexOf(u8, written, "\nbright7=") != null);
    try testing.expect(std.mem.indexOf(u8, written, "colors-light") == null);
}

test "App{} writes an empty file, and bad fonts or a clashing extra fail naming them" {
    var fixture: Fixture = undefined;
    try fixture.init();
    defer fixture.deinit();
    const empty: App = .{};
    try empty.apply(&fixture.output);
    try testing.expectEqualStrings("", fixture.planned());

    const comma: App = .{ .main = .{ .font_bold = &.{.{ .family = "A, B" }} } };
    try testing.expectError(error.AppFailed, comma.apply(&fixture.output));
    try testing.expectEqualStrings("'font-bold': font family 'A, B' is empty or holds ',' or ':', which foot reads as separators", fixture.diagnostics.message());
    const none: App = .{ .main = .{ .font = &.{} } };
    try testing.expectError(error.AppFailed, none.apply(&fixture.output));
    try testing.expectEqualStrings("'font' lists no fonts; leave it null to keep foot's own", fixture.diagnostics.message());
    const clash: App = .{ .colors_light = .{ .alpha = 1 }, .extra = &.{.{ .path = "colors-light.alpha", .value = .{ .float = 0.5 } }} };
    try testing.expectError(error.AppFailed, clash.apply(&fixture.output));
    try testing.expectEqualStrings("extra 'colors-light.alpha' and setting 'colors-light.alpha' write the same key, or one inside the other; keep one", fixture.diagnostics.message());
}
