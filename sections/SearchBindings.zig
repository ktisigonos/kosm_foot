//! foot's `[search-bindings]`: keys in scrollback search mode, written like `[key-bindings]`.
//! Each is a list of key combinations in XKB names; empty writes `none`, unbinding the action.
//! null leaves foot's default.

/// Leaves search, restoring the view and the primary selection. null: Control+g Control+c Escape.
cancel: ?[]const []const u8 = null,
/// Leaves search, copying the match to the primary selection. null: Return KP_Enter.
commit: ?[]const []const u8 = null,
/// Finds the previous match. null: Control+r.
find_prev: ?[]const []const u8 = null,
/// Finds the next match. null: Control+s.
find_next: ?[]const []const u8 = null,
/// Moves the search cursor one character left. null: Left Control+b.
cursor_left: ?[]const []const u8 = null,
/// Moves the search cursor one word left. null: Control+Left Mod1+b.
cursor_left_word: ?[]const []const u8 = null,
/// Moves the search cursor one character right. null: Right Control+f.
cursor_right: ?[]const []const u8 = null,
/// Moves the search cursor one word right. null: Control+Right Mod1+f.
cursor_right_word: ?[]const []const u8 = null,
/// Moves the search cursor to the start. null: Home Control+a.
cursor_home: ?[]const []const u8 = null,
/// Moves the search cursor to the end. null: End Control+e.
cursor_end: ?[]const []const u8 = null,
/// Deletes the character before the cursor. null: BackSpace.
delete_prev: ?[]const []const u8 = null,
/// Deletes the word before the cursor. null: Mod1+BackSpace Control+BackSpace.
delete_prev_word: ?[]const []const u8 = null,
/// Deletes the character after the cursor. null: Delete.
delete_next: ?[]const []const u8 = null,
/// Deletes the word after the cursor. null: Mod1+d Control+Delete.
delete_next_word: ?[]const []const u8 = null,
/// Deletes the input before the cursor. null: Control+u.
delete_to_start: ?[]const []const u8 = null,
/// Deletes the input after the cursor. null: Control+k.
delete_to_end: ?[]const []const u8 = null,
/// Extends the selection one character right. null: Shift+Right.
extend_char: ?[]const []const u8 = null,
/// Extends the selection right to the next word boundary. null: Control+w Control+Shift+Right.
extend_to_word_boundary: ?[]const []const u8 = null,
/// Extends the selection right to the next whitespace. null: Control+Shift+w.
extend_to_next_whitespace: ?[]const []const u8 = null,
/// Extends the selection one line down. null: Shift+Down.
extend_line_down: ?[]const []const u8 = null,
/// Extends the selection one character left. null: Shift+Left.
extend_backward_char: ?[]const []const u8 = null,
/// Extends the selection left to the next word boundary. null: Control+Shift+Left.
extend_backward_to_word_boundary: ?[]const []const u8 = null,
/// Extends the selection left to the next whitespace. null: none.
extend_backward_to_next_whitespace: ?[]const []const u8 = null,
/// Extends the selection one line up. null: Shift+Up.
extend_line_up: ?[]const []const u8 = null,
/// Pastes the clipboard into the search. null: Control+v Control+y Control+Shift+v XF86Paste.
clipboard_paste: ?[]const []const u8 = null,
/// Pastes the primary selection into the search. null: Shift+Insert.
primary_paste: ?[]const []const u8 = null,
/// Inputs a character by its hex codepoint. null: none.
unicode_input: ?[]const []const u8 = null,
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
