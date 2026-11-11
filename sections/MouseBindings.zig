//! foot's `[mouse-bindings]`. Each action is a list of combinations of modifiers and a libinput
//! button with an optional click count (`Control+BTN_LEFT-2`; `BTN_WHEEL_BACK` scrolls up);
//! empty writes `none`, unbinding it. null leaves foot's default. Every key binding action
//! can be bound to the mouse too.

const values = @import("../values.zig");

/// Modifiers (`Shift`, `Mod1+Mod4`, or `none`) that select text even while a program grabs the
/// mouse; mouse bindings can't use them. Written first, since it affects the bindings after it. null: Shift.
selection_override_modifiers: ?[]const u8 = null,
/// Scrolls up; on the alternate screen, sends up keys in alternate scroll mode. null: BTN_WHEEL_BACK.
scrollback_up_mouse: ?[]const []const u8 = null,
/// Scrolls down; on the alternate screen, sends down keys in alternate scroll mode. null: BTN_WHEEL_FORWARD.
scrollback_down_mouse: ?[]const []const u8 = null,
/// Starts a selection. null: BTN_LEFT.
select_begin: ?[]const []const u8 = null,
/// Starts a block selection. null: Control+BTN_LEFT.
select_begin_block: ?[]const []const u8 = null,
/// Starts a word-wise selection, words split by `main.word_delimiters`. null: BTN_LEFT-2.
select_word: ?[]const []const u8 = null,
/// Starts a word-wise selection, words split by whitespace only. null: Control+BTN_LEFT-2.
select_word_whitespace: ?[]const []const u8 = null,
/// Selects inside the quotes around the pointer, else the row. null: BTN_LEFT-3.
select_quote: ?[]const []const u8 = null,
/// Starts a row-wise selection. null: BTN_LEFT-4.
select_row: ?[]const []const u8 = null,
/// Extends the selection in its own mode. null: BTN_RIGHT.
select_extend: ?[]const []const u8 = null,
/// Extends the selection character-wise. null: Control+BTN_RIGHT.
select_extend_character_wise: ?[]const []const u8 = null,
/// Combinations never sent to the program. null: none.
noop: ?[]const []const u8 = null,
/// Scrolls up one page. null: none.
scrollback_up_page: ?[]const []const u8 = null,
/// Scrolls up half a page. null: none.
scrollback_up_half_page: ?[]const []const u8 = null,
/// Scrolls up one line. null: none.
scrollback_up_line: ?[]const []const u8 = null,
/// Scrolls down one page. null: none.
scrollback_down_page: ?[]const []const u8 = null,
/// Scrolls down half a page. null: none.
scrollback_down_half_page: ?[]const []const u8 = null,
/// Scrolls down one line. null: none.
scrollback_down_line: ?[]const []const u8 = null,
/// Scrolls to the start of the scrollback. null: none.
scrollback_home: ?[]const []const u8 = null,
/// Scrolls to the bottom. null: none.
scrollback_end: ?[]const []const u8 = null,
/// Copies the selection to the clipboard. null: none.
clipboard_copy: ?[]const []const u8 = null,
/// Pastes the clipboard. null: none.
clipboard_paste: ?[]const []const u8 = null,
/// Pastes the primary selection. null: BTN_MIDDLE.
primary_paste: ?[]const []const u8 = null,
/// Starts a scrollback search. null: none.
search_start: ?[]const []const u8 = null,
/// Zooms in by `main.font_size_adjustment`. null: Control+BTN_WHEEL_BACK.
font_increase: ?[]const []const u8 = null,
/// Zooms out by `main.font_size_adjustment`. null: Control+BTN_WHEEL_FORWARD.
font_decrease: ?[]const []const u8 = null,
/// Resets the font size. null: none.
font_reset: ?[]const []const u8 = null,
/// Opens a new terminal, in the current directory with OSC 7. null: none.
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
/// Enters URL mode; a label opens its URL and leaves. null: none.
show_urls_launch: ?[]const []const u8 = null,
/// Enters URL mode, staying after opening a URL. null: none.
show_urls_persistent: ?[]const []const u8 = null,
/// Enters URL mode; a label copies its URL, an uppercase one pastes it too. null: none.
show_urls_copy: ?[]const []const u8 = null,
/// Enters regex mode for a `[regex:name]` section; a label launches its match. Default: none.
regex_launch: []const values.RegexBinding = &.{},
/// Enters regex mode; a label copies its match, an uppercase one pastes it too. Default: none.
regex_copy: []const values.RegexBinding = &.{},
/// Jumps to the previous prompt; needs shell integration. null: none.
prompt_prev: ?[]const []const u8 = null,
/// Jumps to the next prompt; needs shell integration. null: none.
prompt_next: ?[]const []const u8 = null,
/// Inputs a character by its hex codepoint, ended by Enter or Space. null: none.
unicode_input: ?[]const []const u8 = null,
/// Switches to `colors_dark`. null: none.
color_theme_switch_dark: ?[]const []const u8 = null,
/// Switches to `colors_light`. null: none.
color_theme_switch_light: ?[]const []const u8 = null,
/// Toggles between the two themes. null: none.
color_theme_toggle: ?[]const []const u8 = null,
/// Quits foot. null: none.
quit: ?[]const []const u8 = null,
