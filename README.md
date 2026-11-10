# kosm_foot

foot for kosm: the `foot` adapter (an INI dialect: `key=value`, `RRGGBB` colors, `yes`/`no`)
and the foot app, covering foot's fonts and its two color themes.

The app writes only the options that are set to `~/.config/foot/kosm.ini`. Make foot.ini read
it once, as the first line, and delete the fonts and colors foot.ini sets itself, since an
option set later in foot.ini wins:

```ini
include=~/.config/foot/kosm.ini
```

`from(theme)` fills `colors_dark`, the theme foot starts with: foreground and background from
white and black (swapped in light mode), `alpha` from the theme's `background_alpha`, `regular0`
to `regular7` from the wheel and `bright0` to `bright7` one `lightness.bright` step brighter.
Fonts are left alone. foot reads its config only at start, so there is no reload.

## Fields

| Field | Default |
|---|---|
| `file` | `~/.config/foot/kosm.ini` |
| `format` | the adapter's: `RRGGBB` lowercase, `yes`/`no` |
| `main.font`, `font_bold`, `font_italic`, `font_bold_italic` | null; a list of `.{ .family, .size }` in fallback order |
| `colors_dark`, `colors_light` | `alpha`, `foreground`, `background`, `cursor` (`.{ .text, .cursor }`), `selection_foreground`, `selection_background`, `urls`, `regular0`..`regular7`, `bright0`..`bright7`; null leaves each to foot |
| `extra` | none; other options by `section.option`: `.{ .path = "main.pad", .value = .{ .raw = "10x10" } }` |
