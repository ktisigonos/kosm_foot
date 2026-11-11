//! One font of a fallback list, written `Family:size=13`.

/// The fontconfig family name. It may not hold `,` or `:`, which separate fonts and options.
family: []const u8,
/// The size in points. null: foot's.
size: ?f64 = null,
