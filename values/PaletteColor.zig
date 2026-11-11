//! A color of the 256-color palette past the 16 ANSI ones, written `index=color`.

const kosm = @import("kosm");

/// 16 to 255; 0 to 15 are the `regularN` and `brightN` fields.
index: u8,
color: kosm.Color,
