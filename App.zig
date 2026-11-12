//! foot's settings: every section and option of foot.ini, named like foot's own in Zig casing
//! (`font_bold` for `font-bold`, `key_bindings` for `[key-bindings]`). `generate` writes the
//! set ones to `file`, which foot.ini includes (`include=~/.config/foot/kosm.ini`); null options
//! are left to foot.ini and foot's defaults.

const App = @This();

const std = @import("std");
const kosm = @import("kosm");
const settings = @import("settings.zig");

/// The values options take beyond numbers, text and colors.
pub const values = @import("values.zig");
pub const Main = @import("sections/Main.zig");
pub const Security = @import("sections/Security.zig");
pub const Bell = @import("sections/Bell.zig");
pub const DesktopNotifications = @import("sections/DesktopNotifications.zig");
pub const Scrollback = @import("sections/Scrollback.zig");
pub const Url = @import("sections/Url.zig");
pub const Cursor = @import("sections/Cursor.zig");
pub const Mouse = @import("sections/Mouse.zig");
pub const Touch = @import("sections/Touch.zig");
pub const Colors = @import("sections/Colors.zig");
pub const Csd = @import("sections/Csd.zig");
pub const KeyBindings = @import("sections/KeyBindings.zig");
pub const SearchBindings = @import("sections/SearchBindings.zig");
pub const UrlBindings = @import("sections/UrlBindings.zig");
pub const MouseBindings = @import("sections/MouseBindings.zig");

/// The file kosm owns; foot.ini includes it. Default: `~/.config/foot/kosm.ini`.
file: []const u8 = "~/.config/foot/kosm.ini",
/// How values are spelled. Null fields take the foot adapter's: `RRGGBB` lowercase, `yes`/`no`.
/// foot reads colors only without a `#`.
format: kosm.Format = .{},
/// `[main]`: the shell, fonts, padding and window.
main: Main = .{},
/// `[environment]`: variables set for the program foot runs. Default: none.
environment: []const values.EnvironmentVariable = &.{},
/// `[security]`.
security: Security = .{},
/// `[bell]`: what a BEL does.
bell: Bell = .{},
/// `[desktop-notifications]`.
desktop_notifications: DesktopNotifications = .{},
/// `[scrollback]`.
scrollback: Scrollback = .{},
/// `[url]`: URL mode.
url: Url = .{},
/// `[regex:name]` sections, for `regex_launch` and `regex_copy` bindings. Default: none.
regex: []const values.Regex = &.{},
/// `[cursor]`.
cursor: Cursor = .{},
/// `[mouse]`.
mouse: Mouse = .{},
/// `[touch]`.
touch: Touch = .{},
/// `[colors-dark]`: the theme foot starts with, unless `main.initial_color_theme` is light.
colors_dark: Colors = .{},
/// `[colors-light]`: the other theme, switched to by SIGUSR2 or the color theme bindings.
colors_light: Colors = .{},
/// `[csd]`: the decorations foot draws itself.
csd: Csd = .{},
/// `[key-bindings]`.
key_bindings: KeyBindings = .{},
/// `[search-bindings]`: keys in scrollback search.
search_bindings: SearchBindings = .{},
/// `[url-bindings]`: keys in URL mode.
url_bindings: UrlBindings = .{},
/// `[text-bindings]`: keys sending text to the program. Default: none.
text_bindings: []const values.TextBinding = &.{},
/// `[mouse-bindings]`.
mouse_bindings: MouseBindings = .{},
/// Options the app doesn't cover, by `section.option` with foot's own names:
/// `.{ .path = "main.future-option", .value = .{ .raw = "yes" } }`. One that repeats a set option
/// or another extra fails the apply. Default: none.
extra: []const kosm.Setting = &.{},

/// Colors from the theme into `colors_dark`, foot's starting theme, whatever the mode:
/// foreground and background from their roles, the background's
/// translucency from the theme's `background_alpha`, regular colors from the wheel and bright
/// ones from the theme's `lightness.bright`, URLs from the link role. Everything else is left to foot.
pub fn from(theme: kosm.Theme) App {
    const palette = theme.palette;
    const variations = theme.variations;
    const foreground = theme.roles.foreground;
    const background = theme.roles.background;
    const regular = [_]kosm.Color{ palette.black, palette.red, palette.green, palette.yellow, palette.blue, palette.magenta, palette.cyan, palette.white };
    var colors: Colors = .{
        .alpha = theme.background_alpha,
        .foreground = foreground,
        .background = background,
        .cursor = .{ .text = background, .background = foreground },
        .selection_foreground = variations.emphasis.strong.apply(foreground),
        .selection_background = variations.state.selected.apply(background),
        .urls = theme.roles.link,
    };
    inline for (regular, 0..) |color, index| {
        @field(colors, std.fmt.comptimePrint("regular{d}", .{index})) = color;
        @field(colors, std.fmt.comptimePrint("bright{d}", .{index})) = variations.lightness.bright.apply(color);
    }
    return .{ .colors_dark = colors };
}

/// The sections in the order foot.ini(5) lists them.
const section_order = [_][]const u8{
    "main",           "environment", "security",     "bell",            "desktop_notifications", "scrollback",
    "url",            "regex",       "cursor",       "mouse",           "touch",                 "colors_dark",
    "colors_light",   "csd",         "key_bindings", "search_bindings", "url_bindings",          "text_bindings",
    "mouse_bindings",
};

/// Writes every set option to `file`, then the extras. foot reads its config only at start,
/// so running terminals keep their settings until restarted.
pub fn apply(self: App, output: *kosm.Output) !void {
    if (self.main.initial_window_size_pixels != null and self.main.initial_window_size_chars != null)
        return output.fail(self.file, "'main.initial-window-size-pixels' and 'main.initial-window-size-chars' are both set; foot takes one", .{});
    var sections: std.ArrayList(kosm.Value.Entry) = .empty;
    inline for (section_order) |name| {
        const context: settings.Context = .{
            .output = output,
            .file = self.file,
            .section = comptime settings.optionName(name),
            .alpha_first = comptime std.mem.eql(u8, name, "csd"),
        };
        if (comptime std.mem.eql(u8, name, "regex")) {
            try sections.appendSlice(output.allocator, try settings.regexSections(context, self.regex));
        } else {
            const entries = if (comptime std.mem.eql(u8, name, "environment"))
                try settings.environment(context, self.environment)
            else if (comptime std.mem.eql(u8, name, "text_bindings"))
                try settings.textBindings(context, self.text_bindings)
            else
                try settings.section(context, @field(self, name));
            if (entries.len != 0) try sections.append(output.allocator, .{ .key = context.section, .value = .{ .table = entries } });
        }
    }
    const own = try kosm.Setting.leaves(output.allocator, .{ .table = sections.items });
    const all = try kosm.Setting.withExtras(output, self.file, own, self.extra, .{});
    try output.generate(.{ .file = self.file, .lang = "foot", .format = self.format }, try kosm.Setting.tree(output.allocator, all));
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

    fn expectFailure(fixture: *Fixture, app: App, message: []const u8) !void {
        try testing.expectError(error.AppFailed, app.apply(&fixture.output));
        try testing.expectEqualStrings(message, fixture.diagnostics.message());
    }
};

test "fonts in fallback order and the theme's colors in foot's spelling, extras last" {
    var fixture: Fixture = undefined;
    try fixture.init();
    defer fixture.deinit();
    var theme = kosm.Theme.from(.{ .palette = .{ .black = kosm.hex("041c26"), .white = kosm.hex("a3c5cc"), .blue = kosm.hex("267180") }, .mode = .dark });
    theme.background_alpha = 0.8;
    var app = from(theme);
    app.main.font = &.{ .{ .family = "Maple Mono Normal NFP", .size = 13 }, .{ .family = "Noto Color Emoji" } };
    app.extra = &.{.{ .path = "main.future-option", .value = .{ .raw = "yes" } }};
    try app.apply(&fixture.output);

    const written = fixture.planned();
    try testing.expect(std.mem.startsWith(u8, written,
        \\[main]
        \\font=Maple Mono Normal NFP:size=13, Noto Color Emoji
        \\future-option=yes
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

test "every kind of option in foot's spelling, sections in foot's order" {
    var fixture: Fixture = undefined;
    try fixture.init();
    defer fixture.deinit();
    const app: App = .{
        .main = .{
            .include = &.{ "~/a.ini", "~/b.ini" },
            .font_size_adjustment = .{ .percent = 7.5 },
            .line_height = .{ .pixels = 17 },
            .letter_spacing = .{ .points = -0.5 },
            .pad = .{ .left = 1, .top = 2, .right = 3, .bottom = 4, .center = .center_when_fullscreen },
            .initial_window_size_chars = .{ .width = 80, .height = 24 },
            .bold_text_in_bright = .palette_based,
            .workers = 0,
        },
        .environment = &.{ .{ .name = "EDITOR", .value = "nvim" }, .{ .name = "EMPTY", .value = "" } },
        .desktop_notifications = .{ .close = "" },
        .security = .{ .osc52 = .copy_enabled },
        .regex = &.{.{ .name = "hashes", .regex = "([a-f0-9]{7,40})", .launch = "git show ${match}" }},
        .cursor = .{ .style = .beam, .beam_thickness = .{ .pixels = 2 } },
        .colors_light = .{ .jump_labels = .{ .text = kosm.hex("000000"), .background = kosm.hex("ffff00") }, .palette = &.{.{ .index = 16, .color = kosm.hex("101010") }} },
        .csd = .{ .preferred = .client, .color = kosm.hex("#ff000080") },
        .key_bindings = .{
            .search_start = &.{},
            .clipboard_copy = &.{ "Control+Shift+c", "XF86Copy" },
            .pipe_visible = &.{ .{ .command = "sh -c \"xurls | fuzzel\"", .keys = &.{"Control+Print"} }, .{ .command = "wl-copy" } },
            .regex_copy = &.{.{ .regex = "hashes", .keys = &.{"Control+Mod1+Shift+q"} }},
        },
        .text_bindings = &.{.{ .text = "\\x1b[A", .keys = &.{"Mod4+k"} }},
        .mouse_bindings = .{ .selection_override_modifiers = "Shift", .select_word = &.{"BTN_LEFT-2"} },
    };
    try app.apply(&fixture.output);
    try testing.expectEqualStrings(
        \\[main]
        \\include=~/a.ini
        \\include=~/b.ini
        \\font-size-adjustment=7.5%
        \\line-height=17px
        \\letter-spacing=-0.5
        \\pad=1x2x3x4 center-when-fullscreen
        \\initial-window-size-chars=80x24
        \\bold-text-in-bright=palette-based
        \\workers=0
        \\
        \\[environment]
        \\EDITOR=nvim
        \\EMPTY=""
        \\
        \\[security]
        \\osc52=copy-enabled
        \\
        \\[desktop-notifications]
        \\close=""
        \\
        \\[regex:hashes]
        \\regex=([a-f0-9]{7,40})
        \\launch=git show ${match}
        \\
        \\[cursor]
        \\style=beam
        \\beam-thickness=2px
        \\
        \\[colors-light]
        \\16=101010
        \\jump-labels=000000 ffff00
        \\
        \\[csd]
        \\preferred=client
        \\color=80ff0000
        \\
        \\[key-bindings]
        \\clipboard-copy=Control+Shift+c XF86Copy
        \\search-start=none
        \\pipe-visible=[sh -c "xurls | fuzzel"] Control+Print
        \\pipe-visible=[wl-copy] none
        \\regex-copy=[hashes] Control+Mod1+Shift+q
        \\
        \\[text-bindings]
        \\\x1b[A=Mod4+k
        \\
        \\[mouse-bindings]
        \\selection-override-modifiers=Shift
        \\select-word=BTN_LEFT-2
        \\
    , fixture.planned());
}

test "pad pairs its sides when it can and leaves centering off unless set" {
    var fixture: Fixture = undefined;
    try fixture.init();
    defer fixture.deinit();
    const app: App = .{ .main = .{ .pad = .all(10) } };
    try app.apply(&fixture.output);
    try testing.expectEqualStrings("[main]\npad=10x10\n", fixture.planned());
}

test "App{} writes an empty file, and bad fonts or a clashing extra fail naming them" {
    var fixture: Fixture = undefined;
    try fixture.init();
    defer fixture.deinit();
    const empty: App = .{};
    try empty.apply(&fixture.output);
    try testing.expectEqualStrings("", fixture.planned());

    try fixture.expectFailure(.{ .main = .{ .font_bold = &.{.{ .family = "A, B" }} } }, "'main.font-bold': font family 'A, B' is empty or holds ',' or ':', which foot reads as separators");
    try fixture.expectFailure(.{ .csd = .{ .font = &.{} } }, "'csd.font': lists no fonts; leave it null to keep foot's own");
    try fixture.expectFailure(
        .{ .colors_light = .{ .alpha = 1 }, .extra = &.{.{ .path = "colors-light.alpha", .value = .{ .float = 0.5 } }} },
        "extra 'colors-light.alpha' and setting 'colors-light.alpha' write the same key, or one inside the other; keep one",
    );
}

test "options foot would misread fail the apply naming them" {
    var fixture: Fixture = undefined;
    try fixture.init();
    defer fixture.deinit();
    try fixture.expectFailure(
        .{ .main = .{ .initial_window_size_pixels = .{ .width = 1, .height = 1 }, .initial_window_size_chars = .{ .width = 1, .height = 1 } } },
        "'main.initial-window-size-pixels' and 'main.initial-window-size-chars' are both set; foot takes one",
    );
    try fixture.expectFailure(.{ .key_bindings = .{ .quit = &.{"Control+ q"} } }, "'key-bindings.quit': key combination 'Control+ q' is empty or holds a space, which foot reads as a separator");
    try fixture.expectFailure(.{ .key_bindings = .{ .pipe_selected = &.{.{ .command = "" }} } }, "'key-bindings.pipe-selected': a pipe's command is empty");
    try fixture.expectFailure(.{ .colors_dark = .{ .palette = &.{.{ .index = 3, .color = kosm.hex("000000") }} } }, "'colors-dark.palette': index 3 is one of the 16 ANSI colors; set it through regularN or brightN");
    try fixture.expectFailure(
        .{ .colors_dark = .{ .palette = &.{ .{ .index = 20, .color = kosm.hex("000000") }, .{ .index = 20, .color = kosm.hex("ffffff") } } } },
        "'colors-dark.palette': index 20 is set twice",
    );
    try fixture.expectFailure(.{ .regex = &.{ .{ .name = "a", .regex = "x" }, .{ .name = "a", .regex = "y" } } }, "'regex': 'a' is named twice; foot reads one section per name");
    try fixture.expectFailure(.{ .text_bindings = &.{.{ .text = "a", .keys = &.{} }} }, "'text-bindings.a': lists no keys; a text binding needs at least one");
}

test "a value foot would cut at a comment fails" {
    var fixture: Fixture = undefined;
    try fixture.init();
    defer fixture.deinit();
    const app: App = .{ .bell = .{ .command = "notify-send bell # loud" } };
    try testing.expectError(error.UnsupportedValue, app.apply(&fixture.output));
    try testing.expect(std.mem.indexOf(u8, fixture.diagnostics.message(), "comment") != null);
}
