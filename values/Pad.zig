//! The space between the window's border and the text, in pixels (scaled with the output).
//! Written `XxY` when left equals right and top equals bottom, else `LEFTxTOPxRIGHTxBOTTOM`.

const Pad = @This();

left: u32 = 0,
top: u32 = 0,
right: u32 = 0,
bottom: u32 = 0,
/// When the text is centered in the window. null: never, which is what foot does once `pad`
/// is set without it (foot's default with no `pad` at all centers when maximized or fullscreen).
center: ?Center = null,

/// When foot centers the text grid instead of anchoring it to the top left corner.
pub const Center = enum {
    /// Always; may make the text jump while resizing.
    center,
    /// Only while fullscreen.
    center_when_fullscreen,
    /// Only while maximized or fullscreen.
    center_when_maximized_and_fullscreen,
};

/// The same space on every side.
pub fn all(pixels: u32) Pad {
    return .{ .left = pixels, .top = pixels, .right = pixels, .bottom = pixels };
}

/// `horizontal` on the left and right, `vertical` on the top and bottom.
pub fn symmetric(horizontal: u32, vertical: u32) Pad {
    return .{ .left = horizontal, .top = vertical, .right = horizontal, .bottom = vertical };
}
