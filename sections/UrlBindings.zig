//! foot's `[url-bindings]`: keys in URL mode. Each is a list of key combinations in XKB names;
//! empty writes `none`, unbinding the action. null leaves foot's default. Keep clear of `url.label_letters`.

/// Leaves URL mode without opening one. null: Control+g Control+c Control+d Escape.
cancel: ?[]const []const u8 = null,
/// Shows or hides the URL on jump labels. null: t.
toggle_url_visible: ?[]const []const u8 = null,
