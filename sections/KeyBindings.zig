//! foot's `[key-bindings]`. Each action is a list of key combinations in XKB names
//! (`Control+Shift+c`; with Shift, the key in lower case); empty writes `none`, unbinding it.
//! null leaves foot's default. A combination can run only one action, so unbind a default
//! before reusing its keys.

const values = @import("../values.zig");

/// Keys never sent to the program. null: none.
noop: ?[]const []const u8 = null,
/// Scrolls up one page. null: Shift+Page_Up Shift+KP_Page_Up.
scrollback_up_page: ?[]const []const u8 = null,
/// Scrolls up half a page. null: none.
scrollback_up_half_page: ?[]const []const u8 = null,
/// Scrolls up one line. null: none.
scrollback_up_line: ?[]const []const u8 = null,
/// Scrolls down one page. null: Shift+Page_Down Shift+KP_Page_Down.
scrollback_down_page: ?[]const []const u8 = null,
/// Scrolls down half a page. null: none.
scrollback_down_half_page: ?[]const []const u8 = null,
/// Scrolls down one line. null: none.
scrollback_down_line: ?[]const []const u8 = null,
/// Scrolls to the start of the scrollback. null: none.
scrollback_home: ?[]const []const u8 = null,
/// Scrolls to the bottom. null: none.
scrollback_end: ?[]const []const u8 = null,
/// Copies the selection to the clipboard. null: Control+Shift+c XF86Copy.
clipboard_copy: ?[]const []const u8 = null,
/// Pastes the clipboard. null: Control+Shift+v XF86Paste.
clipboard_paste: ?[]const []const u8 = null,
/// Pastes the primary selection. null: Shift+Insert.
primary_paste: ?[]const []const u8 = null,
/// Starts a scrollback search. null: Control+Shift+r.
search_start: ?[]const []const u8 = null,
/// Zooms in by `main.font_size_adjustment`. null: Control+plus Control+equal Control+KP_Add.
font_increase: ?[]const []const u8 = null,
/// Zooms out by `main.font_size_adjustment`. null: Control+minus Control+KP_Subtract.
font_decrease: ?[]const []const u8 = null,
/// Resets the font size. null: Control+0 Control+KP_0.
font_reset: ?[]const []const u8 = null,
/// Opens a new terminal, in the current directory with OSC 7. null: Control+Shift+n.
spawn_terminal: ?[]const []const u8 = null,
/// Minimizes the window. null: none.
minimize: ?[]const []const u8 = null,
/// Toggles maximized. null: none.
maximize: ?[]const []const u8 = null,
/// Toggles fullscreen. null: none.
fullscreen: ?[]const []const u8 = null,
/// Pipes the visible text to a command. Default: none.
pipe_visible: []const values.Pipe = &.{},
/// Pipes the whole scrollback to a command. Default: none.
pipe_scrollback: []const values.Pipe = &.{},
/// Pipes the selected text to a command. Default: none.
pipe_selected: []const values.Pipe = &.{},
/// Pipes the last command's output to a command; needs shell integration. Default: none.
pipe_command_output: []const values.Pipe = &.{},
/// Enters URL mode; a label opens its URL and leaves. null: Control+Shift+o.
show_urls_launch: ?[]const []const u8 = null,
/// Enters URL mode, staying after opening a URL. null: none.
show_urls_persistent: ?[]const []const u8 = null,
/// Enters URL mode; a label copies its URL, an uppercase one pastes it too. null: none.
show_urls_copy: ?[]const []const u8 = null,
/// Enters regex mode for a `[regex:name]` section; a label launches its match. Default: none.
regex_launch: []const values.RegexBinding = &.{},
/// Enters regex mode; a label copies its match, an uppercase one pastes it too. Default: none.
regex_copy: []const values.RegexBinding = &.{},
/// Jumps to the previous prompt; needs shell integration. null: Control+Shift+z.
prompt_prev: ?[]const []const u8 = null,
/// Jumps to the next prompt; needs shell integration. null: Control+Shift+x.
prompt_next: ?[]const []const u8 = null,
/// Inputs a character by its hex codepoint, ended by Enter or Space. null: Control+Shift+u.
unicode_input: ?[]const []const u8 = null,
/// Switches to `colors_dark`. null: none.
color_theme_switch_dark: ?[]const []const u8 = null,
/// Switches to `colors_light`. null: none.
color_theme_switch_light: ?[]const []const u8 = null,
/// Toggles between the two themes. null: none.
color_theme_toggle: ?[]const []const u8 = null,
/// Quits foot. null: none.
quit: ?[]const []const u8 = null,
