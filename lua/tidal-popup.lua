-- lua/tidal-popup.lua
_G.TidalPopupShow = function()
  local buf = vim.api.nvim_create_buf(false, true)
  local lines = {
    "TidalCycles Cheat Sheet:",
    "",
    "  fast n       — speed up pattern by factor n",
    "  slow n       — slow down pattern by factor n",
    "  (# sound \"bd\") — apply function",
    "  (|+| speed 2) — add functionally",
    "",
    "More: https://tidalcycles.org/docs/reference/cycles",
  }

  vim.api.nvim_buf_set_lines(buf, 0, -1, false, lines)

  local width = 60
  local height = #lines
  local opts = {
    relative = 'editor',
    width = width,
    height = height,
    col = (vim.o.columns - width) / 2,
    row = (vim.o.lines - height) / 2,
    style = 'minimal',
    border = 'rounded',
  }

  vim.api.nvim_open_win(buf, true, opts)
end
