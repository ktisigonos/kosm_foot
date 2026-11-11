//! Two colors foot writes as `text background`: the cursor, jump labels, the scrollback
//! indicator and the search box.

const kosm = @import("kosm");

/// The text drawn on top.
text: kosm.Color,
/// What the text sits on: the cursor block, the label or the box itself.
background: kosm.Color,
