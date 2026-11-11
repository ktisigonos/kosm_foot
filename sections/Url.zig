//! foot's `[url]` options: URL mode.

/// The command opening a URL; `${url}` is replaced with it. null: foot's default, `xdg-open ${url}`.
launch: ?[]const u8 = null,
/// When OSC-8 links are underlined. null: foot's default, url-mode.
osc8_underline: ?Osc8Underline = null,
/// How URLs are underlined. null: foot's default, dotted.
style: ?Style = null,
/// The letters jump labels are made of; with `t`, rebind `url_bindings.toggle_url_visible`. null: foot's default, `sadfjklewcmpgh`.
label_letters: ?[]const u8 = null,
/// A POSIX extended regular expression finding URLs; its first marked subexpression is the URL. null: foot's own.
regex: ?[]const u8 = null,

pub const Osc8Underline = enum {
    /// Only in URL mode, like detected URLs.
    url_mode,
    always,
};

pub const Style = enum { none, single, double, curly, dotted, dashed };
