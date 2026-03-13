vim.g.neovide_padding_top = 8
vim.g.neovide_padding_bottom = 8
vim.g.neovide_padding_left = 8
vim.g.neovide_padding_right = 8

vim.g.neovide_blur_amount_x = 8.0
vim.g.neovide_blur_amount_y = 8.0
vim.g.neovide_opacity = 0.65

vim.cmd.colorscheme('default')
local term_bg = 'none';
if vim.g.neovide then
  -- to make neovide look the same as opening nvim in a term
  term_bg = '#0E0E1E' -- TODO: pull this from home cfg
end
vim.api.nvim_set_hl(0, 'Normal', { bg = term_bg })
vim.api.nvim_set_hl(0, 'NormalNC', { bg = term_bg })
vim.api.nvim_set_hl(0, 'NormalFloat', { bg = term_bg })
vim.api.nvim_set_hl(0, 'EndOfBuffer', { bg = term_bg })

vim.opt.tabstop = 2
vim.opt.shiftwidth = 2
vim.opt.expandtab = true

vim.lsp.config('nixd', {
  cmd = { 'nixd' },
  filetypes = { 'nix' },
  root_markers = { 'flake.nix', '.git' },
  settings = {
    nixd = {
      nixpkgs = {
        expr = "import (builtins.getFlake \".\").inputs.nixpkgs {}",
      },
      formatting = {
        command = { "nixfmt" },
      },
    },
  },
})

vim.lsp.enable('nixd')

-- completion
require("blink.cmp").setup({
  keymap = { preset = 'super-tab' },
  sources = {
    default = { 'lsp', 'path', 'buffer' },
  },
})

-- formatting — nixd handles nix, nixfmt as fallback
require("conform").setup({
  formatters_by_ft = {
    nix = { "nixd_fmt" },
  },
  formatters = {
    nixd_fmt = {
      command = "nixd",
      args = { "--format" },
    },
  },
  format_on_save = {
    timeout_ms = 500,
    lsp_fallback = true, -- falls back to nixfmt if nixd isn't available
  },
})
