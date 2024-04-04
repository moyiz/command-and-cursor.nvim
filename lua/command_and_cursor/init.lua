local namespace

-- Returns positions and `regtype` of cursor or visual selection.
local function get_cursor_region()
  local mode = vim.fn.mode()

  local row_s, col_s = unpack(vim.api.nvim_win_get_cursor(0))
  row_s = row_s - 1
  local row_e, col_e

  -- "\22" <=> Ctrl-V
  if mode:match "^[vV]" or mode == "\22" then
    row_e, col_e = vim.fn.line "v", vim.fn.col "v"
    col_e = col_e - 1
    row_e = row_e - 1

    -- Cursor moved up, reverse `start` and `end`.
    if row_s > row_e then
      row_s, row_e = row_e, row_s
      col_s, col_e = col_e, col_s
    end
    if row_s == row_e and col_s > col_e then
      col_s, col_e = col_e, col_s
    end
  else
    -- Non-visual mode.
    row_e, col_e = row_s, col_s
  end

  local regtype = mode

  -- Visual block mode,
  if mode == "\22" then
    -- `col_s` must not be greater than `col_e`
    if col_s > col_e then
      col_s, col_e = col_e, col_s
    end
    -- `regtype` should include the block width.
    regtype = regtype .. (col_e - col_s + 1)
  end

  return row_s, col_s, row_e, col_e, regtype
end

local start_row, start_col, end_row, end_col, regtype = get_cursor_region()

M = {}

M.defaults = {
  hl_group = "TermCursor", -- The highlight group to use.
  inclusive = true, -- Highlight cursor with visual selection.
  debug_position = false, -- Show start and end positions with `vim.notify`.
}

function M.setup(options)
  M.defaults = vim.tbl_deep_extend("force", M.defaults, options or {})

  local augroup =
    vim.api.nvim_create_augroup("CommandAndCursor", { clear = true })

  namespace = vim.api.nvim_create_namespace "CommandAndCursor"

  vim.api.nvim_create_autocmd({ "CmdlineEnter" }, {
    group = augroup,
    callback = M.highlight,
  })

  vim.api.nvim_create_autocmd({ "CmdlineLeave" }, {
    group = augroup,
    callback = M.clear,
  })

  vim.api.nvim_create_autocmd({ "CursorMoved", "CursorMovedI" }, {
    group = augroup,
    callback = function()
      start_row, start_col, end_row, end_col, regtype = get_cursor_region()

      if not M.defaults.inclusive and start_col == end_col then
        end_col = end_col + 1
      end

      if M.defaults.debug_position then
        vim.notify(
          string.format(
            "%s %s %s %s %s",
            regtype,
            start_row,
            start_col,
            end_row,
            end_col
          )
        )
      end
    end,
  })
end

function M.highlight()
  vim.highlight.range(
    0,
    namespace,
    M.defaults.hl_group,
    { start_row, start_col },
    { end_row, end_col },

    {
      regtype = regtype,
      inclusive = M.defaults.inclusive,
      priority = 300,
    }
  )
  vim.cmd "redraw"
end

function M.clear()
  vim.api.nvim_buf_clear_namespace(0, namespace, 0, -1)
end

return M