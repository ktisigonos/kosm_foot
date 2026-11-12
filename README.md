# kosm_foot

foot for kosm: the `foot` adapter (an INI dialect: `key=value`, `RRGGBB` colors, `yes`/`no`,
`#` comments) and the foot app, covering every section and option of foot.ini.

The app writes only the options that are set to `~/.config/foot/kosm.ini`. Make foot.ini read
it once, as the first line, and delete what foot.ini sets itself, since an option set later in
foot.ini wins:

```ini
include=~/.config/foot/kosm.ini
```

`from(theme)` fills `colors_dark`, the theme foot starts with: foreground and background from
the theme's roles, `alpha` from the theme's `background_alpha`, `regular0`
to `regular7` from the wheel and `bright0` to `bright7` one `lightness.bright` step brighter, `urls` from the link role.
Everything else is left to foot. foot reads its config only at start, so there is no reload.

## Fields

Every section is a field named like foot's (`key_bindings` for `[key-bindings]`), and every
option a field of it named like foot's option (`font_bold` for `font-bold`). Null options are
left to foot; each field's doc comment gives foot's default.

| Field | Holds |
|---|---|
| `file` | `~/.config/foot/kosm.ini` |
| `format` | the adapter's: `RRGGBB` lowercase, `yes`/`no` |
| `main` | shell, `include` paths, fonts (lists of `.{ .family, .size }` in fallback order), lengths (`.{ .points = 1.5 }`, `.{ .pixels = 2 }`), `pad` (`.all(10)`, `.symmetric(10, 5)`, or each side, plus `center`), window size and mode, title, app-id, selection and the rest of `[main]` |
| `environment` | `.{ .name, .value }` per variable |
| `security`, `bell`, `desktop_notifications`, `scrollback`, `url`, `cursor`, `mouse`, `touch` | their sections' options |
| `regex` | `.{ .name, .regex, .launch }` per `[regex:name]` section |
| `colors_dark`, `colors_light` | `alpha`, `alpha_mode`, `blur`, `foreground`, `background`, `regular0`..`regular7`, `bright0`..`bright7`, `dim0`..`dim7`, `dim_blend_towards`, `palette` (`.{ .index, .color }` for 16..255), `sixel0`..`sixel15`, `selection_foreground`, `selection_background`, `urls`, `flash`, `flash_alpha`, and the color pairs `cursor`, `jump_labels`, `scrollback_indicator`, `search_box_no_match`, `search_box_match` (`.{ .text, .background }`) |
| `csd` | the decorations' options; colors keep their alpha and are written `AARRGGBB` |
| `key_bindings`, `search_bindings`, `url_bindings`, `mouse_bindings` | each action a list of combinations (`&.{ "Control+Shift+c", "XF86Copy" }`); empty unbinds it (`none`). `pipe_*` take `.{ .command, .keys }` and `regex_launch`/`regex_copy` take `.{ .regex, .keys }`, one line each |
| `text_bindings` | `.{ .text, .keys }` per binding, bytes as `\x1b` |
| `extra` | none; options foot adds later, by `section.option`: `.{ .path = "main.future-option", .value = .{ .raw = "yes" } }` |

`pad` set without `center` never centers the text: that is foot's reading of a `pad` with no
centering word, while foot without any `pad` centers when maximized or fullscreen.
