# command-and-cursor.nvim

Highlight cursor and visual selections when entering command mode (experimental).

## Demo
![Demo](./demo.svg)

## Features
- Highlight cursor in active buffer when entering command mode (`:/?`).
- Highlight visual selections and include cursor location by default
  (inclusive).
- Configure highlight group.
- Highlight initial visual selection prior to its expansion with incremental
  search.

## Motivation
- In normal mode, cursor "disappears" from buffer when entering `cmdline`.
- Visual selections are not inclusive (cursor).
- Visual selection highlight might be too subtle in a colorful "big" terminal.
- when expanding a visual selection with incremental search, the initial
  selection is "blended" with the expansion. 

## Installation
Use your favorite plugin manager:
### Lazy

```lua
{
  "moyiz/command-and-cursor.nvim",
  opts = {},
}
```

## Options
```lua
M.defaults = {
  hl_group = "TermCursor", -- The highlight group to use.
  inclusive = true,        -- Highlight cursor with visual selection.
  debug_position = false,  -- Show start and end positions with `vim.notify`.
}
````

## License

See [LICENSE](./LICENSE).
