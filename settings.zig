//! Turns the app's section structs into the value tree `generate` writes, spelled the way
//! foot reads it: options with `-` for `_`, enum values likewise, `none` for an empty binding.

const std = @import("std");
const kosm = @import("kosm");
const values = @import("values.zig");

const Value = kosm.Value;
const Entry = Value.Entry;

/// The section being written, for allocation and messages.
pub const Context = struct {
    output: *kosm.Output,
    /// The file the section goes to.
    file: []const u8,
    /// The section's foot name, `key-bindings`.
    section: []const u8,
    /// Writes colors `AARRGGBB` instead of in the file's format, as `[csd]` takes them.
    alpha_first: bool = false,

    fn allocator(context: Context) std.mem.Allocator {
        return context.output.allocator;
    }

    /// Fails the apply naming the option as `section.option`.
    fn fail(context: Context, option: []const u8, comptime format: []const u8, arguments: anytype) kosm.Output.Error {
        return context.output.fail(context.file, "'{s}.{s}': " ++ format, .{ context.section, option } ++ arguments);
    }
};

/// The set options of `options`, a section struct, in declaration order. Optional fields are
/// left out when null, list fields write one line per item.
pub fn section(context: Context, options: anytype) kosm.Output.Error![]const Entry {
    var entries: std.ArrayList(Entry) = .empty;
    const fields = @typeInfo(@TypeOf(options)).@"struct";
    inline for (fields.field_names) |name| {
        try appendOption(context, &entries, comptime optionName(name), @field(options, name));
    }
    return entries.items;
}

/// `[environment]`: one line per variable.
pub fn environment(context: Context, variables: []const values.EnvironmentVariable) kosm.Output.Error![]const Entry {
    var entries: std.ArrayList(Entry) = .empty;
    for (variables) |variable| {
        if (variable.name.len == 0) return context.output.fail(context.file, "'environment': a variable's name is empty", .{});
        try entries.append(context.allocator(), .{ .key = variable.name, .value = textValue(variable.value) });
    }
    return entries.items;
}

/// `[text-bindings]`: one line per text, its keys as the value.
pub fn textBindings(context: Context, bindings: []const values.TextBinding) kosm.Output.Error![]const Entry {
    var entries: std.ArrayList(Entry) = .empty;
    for (bindings) |binding| {
        if (binding.keys.len == 0) return context.fail(binding.text, "lists no keys; a text binding needs at least one", .{});
        try entries.append(context.allocator(), .{ .key = binding.text, .value = try keys(context, binding.text, binding.keys) });
    }
    return entries.items;
}

/// One `[regex:name]` section per regex, failing on an empty or repeated name.
pub fn regexSections(context: Context, regexes: []const values.Regex) kosm.Output.Error![]const Entry {
    var entries: std.ArrayList(Entry) = .empty;
    for (regexes, 0..) |regex, index| {
        if (regex.name.len == 0) return context.output.fail(context.file, "'regex': a regex's name is empty", .{});
        for (regexes[0..index]) |earlier| {
            if (std.mem.eql(u8, earlier.name, regex.name))
                return context.output.fail(context.file, "'regex': '{s}' is named twice; foot reads one section per name", .{regex.name});
        }
        var options: std.ArrayList(Entry) = .empty;
        try options.append(context.allocator(), .{ .key = "regex", .value = .{ .string = regex.regex } });
        if (regex.launch) |launch| try options.append(context.allocator(), .{ .key = "launch", .value = .{ .string = launch } });
        const name = try context.allocator().print("regex:{s}", .{regex.name});
        try entries.append(context.allocator(), .{ .key = name, .value = .{ .table = options.items } });
    }
    return entries.items;
}

fn appendOption(context: Context, entries: *std.ArrayList(Entry), comptime name: []const u8, option: anytype) kosm.Output.Error!void {
    const allocator = context.allocator();
    switch (@TypeOf(option)) {
        []const []const u8 => for (option) |text| try entries.append(allocator, .{ .key = name, .value = .{ .string = text } }),
        []const values.Pipe => for (option) |pipe| {
            if (pipe.command.len == 0) return context.fail(name, "a pipe's command is empty", .{});
            try entries.append(allocator, .{ .key = name, .value = try bracketed(context, name, pipe.command, pipe.keys) });
        },
        []const values.RegexBinding => for (option) |binding| {
            if (binding.regex.len == 0) return context.fail(name, "a binding's regex name is empty", .{});
            try entries.append(allocator, .{ .key = name, .value = try bracketed(context, name, binding.regex, binding.keys) });
        },
        []const values.PaletteColor => try appendPalette(context, entries, option),
        else => if (option) |set| try entries.append(allocator, .{ .key = name, .value = try value(context, name, set) }),
    }
}

/// One set option's value, by its type.
fn value(context: Context, comptime name: []const u8, option: anytype) kosm.Output.Error!Value {
    const T = @TypeOf(option);
    return switch (T) {
        bool => .{ .boolean = option },
        u8, u32 => .{ .integer = option },
        f64 => .{ .float = option },
        []const u8 => textValue(option),
        kosm.Color => try color(context, option),
        values.ColorPair => try joined(context, &.{ try color(context, option.text), .{ .raw = " " }, try color(context, option.background) }),
        values.Length => switch (option) {
            .points => |points| .{ .float = points },
            .pixels => |pixels| try joined(context, &.{ .{ .float = pixels }, .{ .raw = "px" } }),
        },
        values.FontSizeAdjustment => switch (option) {
            .points => |points| .{ .float = points },
            .pixels => |pixels| try joined(context, &.{ .{ .float = pixels }, .{ .raw = "px" } }),
            .percent => |percent| try joined(context, &.{ .{ .float = percent }, .{ .raw = "%" } }),
        },
        values.Pad => try pad(context, option),
        values.WindowSize => try joined(context, &.{ .{ .integer = option.width }, .{ .raw = "x" }, .{ .integer = option.height } }),
        []const values.Font => .{ .string = try fontList(context, name, option) },
        []const []const u8 => try keys(context, name, option),
        else => if (@typeInfo(T) == .@"enum") .{ .raw = enumName(option) } else @compileError("no foot spelling for " ++ @typeName(T)),
    };
}

/// Text as a string; empty as `""`, since foot refuses a key with nothing after the `=`.
fn textValue(option: []const u8) Value {
    return if (option.len == 0) .{ .raw = "\"\"" } else .{ .string = option };
}

fn joined(context: Context, parts: []const Value) std.mem.Allocator.Error!Value {
    return .{ .joined = try context.allocator().dupe(Value, parts) };
}

/// The file's color format, or `AARRGGBB` where foot takes alpha first.
fn color(context: Context, option: kosm.Color) std.mem.Allocator.Error!Value {
    if (!context.alpha_first) return .{ .color = option };
    const alpha: u8 = @intFromFloat(@round(std.math.clamp(option.alpha, 0, 1) * 255));
    const alpha_text = try context.allocator().print("{x:0>2}", .{alpha});
    return joined(context, &.{ .{ .raw = alpha_text }, .{ .color = option } });
}

/// `XxY` when the sides pair up, else `LEFTxTOPxRIGHTxBOTTOM`, then the centering.
fn pad(context: Context, option: values.Pad) std.mem.Allocator.Error!Value {
    var parts: std.ArrayList(Value) = .empty;
    const allocator = context.allocator();
    if (option.left == option.right and option.top == option.bottom) {
        try parts.appendSlice(allocator, &.{ .{ .integer = option.left }, .{ .raw = "x" }, .{ .integer = option.top } });
    } else {
        try parts.appendSlice(allocator, &.{ .{ .integer = option.left }, .{ .raw = "x" }, .{ .integer = option.top }, .{ .raw = "x" }, .{ .integer = option.right }, .{ .raw = "x" }, .{ .integer = option.bottom } });
    }
    if (option.center) |center| try parts.appendSlice(allocator, &.{ .{ .raw = " " }, .{ .raw = enumName(center) } });
    return .{ .joined = parts.items };
}

/// Key or mouse combinations separated by spaces, `none` for an empty list.
fn keys(context: Context, option: []const u8, combinations: []const []const u8) kosm.Output.Error!Value {
    if (combinations.len == 0) return .{ .raw = "none" };
    var text: std.Io.Writer.Allocating = .init(context.allocator());
    for (combinations, 0..) |combination, index| {
        if (combination.len == 0 or std.mem.indexOfAny(u8, combination, " \t") != null)
            return context.fail(option, "key combination '{s}' is empty or holds a space, which foot reads as a separator", .{combination});
        if (index != 0) text.writer.writeByte(' ') catch return error.OutOfMemory;
        text.writer.writeAll(combination) catch return error.OutOfMemory;
    }
    return .{ .raw = text.written() };
}

/// `[inside] keys`, for pipes and regex bindings; foot ends `inside` at the last `]`.
fn bracketed(context: Context, option: []const u8, inside: []const u8, combinations: []const []const u8) kosm.Output.Error!Value {
    const combined = try keys(context, option, combinations);
    return joined(context, &.{ .{ .raw = "[" }, .{ .raw = inside }, .{ .raw = "] " }, combined });
}

fn appendPalette(context: Context, entries: *std.ArrayList(Entry), palette: []const values.PaletteColor) kosm.Output.Error!void {
    for (palette, 0..) |entry, index| {
        if (entry.index < 16) return context.fail("palette", "index {d} is one of the 16 ANSI colors; set it through regularN or brightN", .{entry.index});
        for (palette[0..index]) |earlier| {
            if (earlier.index == entry.index) return context.fail("palette", "index {d} is set twice", .{entry.index});
        }
        const key = try context.allocator().print("{d}", .{entry.index});
        try entries.append(context.allocator(), .{ .key = key, .value = try color(context, entry.color) });
    }
}

/// `Family:size=13, Fallback:size=13`, failing on an empty list or a family foot would split.
fn fontList(context: Context, option: []const u8, fonts: []const values.Font) kosm.Output.Error![]const u8 {
    if (fonts.len == 0) return context.fail(option, "lists no fonts; leave it null to keep foot's own", .{});
    var text: std.Io.Writer.Allocating = .init(context.allocator());
    for (fonts, 0..) |font, index| {
        if (font.family.len == 0 or std.mem.indexOfAny(u8, font.family, ",:") != null)
            return context.fail(option, "font family '{s}' is empty or holds ',' or ':', which foot reads as separators", .{font.family});
        if (index != 0) text.writer.writeAll(", ") catch return error.OutOfMemory;
        text.writer.writeAll(font.family) catch return error.OutOfMemory;
        if (font.size) |size| text.writer.print(":size={d}", .{size}) catch return error.OutOfMemory;
    }
    return text.written();
}

/// An enum value as foot spells it: `palette_based` is `palette-based`.
fn enumName(option: anytype) []const u8 {
    return switch (option) {
        inline else => |tag| comptime optionName(@tagName(tag)),
    };
}

/// foot's name for a field: `_` becomes `-`.
pub fn optionName(comptime name: []const u8) []const u8 {
    comptime {
        var text: [name.len]u8 = undefined;
        for (name, &text) |byte, *slot| slot.* = if (byte == '_') '-' else byte;
        const final = text;
        return &final;
    }
}
