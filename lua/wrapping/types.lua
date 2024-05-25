-- See https://luals.github.io/wiki/annotations/

---@meta types

---@class Softener
---@field default number

---@class Options
---@field set_nvim_opt_defaults boolean
---@field softener Softener
---@field create_commands boolean
---@field create_keymaps boolean
---@field auto_set_mode_heuristically boolean
---@field auto_set_mode_filetype_allowlist string[]
---@field auto_set_mode_filetype_denylist string[]
---@field buftype_allowlist string[]
---@field excluded_treesitter_queries table[]
---@field notify_on_switch boolean
---@field log_path string
