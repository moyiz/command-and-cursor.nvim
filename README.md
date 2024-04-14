# command-and-cursor.nvim

Highlight cursor and visual selections when entering command mode (experimental).

## Demo
![Demo](./demo.svg)

## Features
- Highlight cursor in active buffer when entering command mode (`:/?`).
- Highlight visual selections and include cursor location by default
  (inclusive).
- Highlight initial visual selection prior to its expansion with incremental
  search.
- Configure highlight group.

## Motivation
- In normal mode, cursor "disappears" from buffer when entering `cmdline`.
- Visual selection highlight is not inclusive (cursor).
- Visual selection highlight might be too subtle in a colorful "big" terminal.
- When expanding a visual selection with incremental search, there is no
  indication of the original selection.

## Installation
Use your favorite plugin manager:
### Lazy

```lua
{
  "moyiz/command-and-cursor.nvim",
  event = "VeryLazy",
  opts = {},
}
```

## Options
```lua
M.defaults = {
  hl_group = "TermCursor", -- The highlight group to use.
  hl_priority = 300,       -- Priority of highlight
  inclusive = true,        -- Highlight cursor with visual selection.
  debug_position = false,  -- Show start and end positions with `vim.notify`.
}
````

## License

See [LICENSE](./LICENSE).
