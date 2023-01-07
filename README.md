# wrapping.nvim

This is a NeoVim plugin designed to make it easy to use appropriate settings for
'soft' and 'hard' wrapping modes when editing text-like files (e.g. text,
Markdown, LaTeX, AsciiDoc, etc.). Some "soft" text-like files have no hard
carriage returns to wrap text - each paragraph is one long line (some Markdown
files are like this). Other files use "hard" wrapping (like this README, for
example), where each line ending is "hard" wrapped using the author's preference
for line length (typically in the 78-80 character range).

`wrapping.nvim` attempts to detect the natural wrapping style of text-like files
when first opening them, setting the relevant NeoVim settings to make it
"natural" to edit the file that way (this automatic detection can be disabled).
It also makes it easy to toggle between the relevant NeoVim settings on the
occasion that the wrong mode is detected. It does *not* (currently) support
modifying the content of the file or converting between files of those types.

⚠️  **Note**: This plugin used to be called `vim-wrapping-softhard`, and has been
renamed to `wrapping.nvim` and rewritten in Lua, so is only suitable for NeoVim.
If you are still using Vim, the
[vim-viml](https://github.com/andrewferrier/vim-wrapping-softhard/releases/tag/vim-viml)
tag is against the last VimL-based version suitable for using with vim.

## Demo

<div align="center">
  <video src="https://user-images.githubusercontent.com/107015/211163072-69d0f3e6-57b3-4ec3-9fc1-7d5902372edf.mp4" type="video/mp4"></video>
</div>

## What the Mode Affects

At the moment, this plugin sets the `textwidth` and `wrap/nowrap` settings
(locally to the file's buffer) when switching between hard and soft wrapping
modes, which makes lines reflow naturally in 'soft' mode. It will also re-map
the `<Up>` and `<Down>` keys depending on the wrapping style, so they move by
screen line in soft mode. I would welcome issues / pull requests if there are
other settings that would be useful to alter under these different modes.

## Installation

**Requires NeoVim 0.7+.**

`wrapping.nvim` is a standard NeoVim plugin and can be installed using any
standard package manager.

Example for
[`lazy.nvim`](https://github.com/folke/lazy.nvim/tree/4f76b431f73c912a7021bc17384533fbad96fba7):

```lua
require("lazy").setup({
    ...
    {
        "andrewferrier/wrapping.nvim",
        config = function()
            require("wrapping").setup()
        end
    },
    ...
}
```

Example for [`packer.nvim`](https://github.com/wbthomason/packer.nvim):

```lua
packer.startup(function(use)
    ...
    use({
        "andrewferrier/wrapping.nvim",
        config = function()
            require("wrapping").setup()
        end,
    })
    ...
end)
```

## Changing the Defaults

`wrapping.nvim` attempts to do the right thing out of the box, and tries to
detect and set the wrapping mode if the filetype matches a built-in allowlist of
files it considers 'textual'. However, you can customize a variety of options.

To do this, add an `opts` object to the setup method:

```lua
opts = { ... }

use({
    "andrewferrier/wrapping.nvim",
    config = function()
        require("wrapping").setup(opts)
    end,
})
```

The sections below detail the allowed options.

### Commands and Keymappings

By default, the plugin will create the following commands to set/override a
wrapping mode in case it is not autodetected correctly:

*   `HardWrapMode`
*   `SoftWrapMode`
*   `ToggleWrapMode`

As well as the following normal-mode keymappings:

*   `[ow` (soft wrap mode)
*   `]ow` (hard wrap mode)
*   `yow` (toggle wrap mode)

(these are similar to [vim-unimpaired](https://github.com/tpope/vim-unimpaired))

And the following utility command to open a debug log showing what
`wrapping.nvim` is doing:

*   `WrappingOpenLog`

Disable these commands and/or keymappings by setting these options accordingly:

```lua
opts = {
    create_commands = false,
    create_keymappings = false,
    ...
}
```

You can create your own instead by invoking these functions:

*   `require('wrapping').hard_wrap_mode()`
*   `require('wrapping').soft_wrap_mode()`
*   `require('wrapping').toggle_wrap_mode()`

### Notifications

By default, `wrapping.nvim` will output a message to the command line when the
hard or soft mode is set. You can disable this with:

```lua
opts = {
    notify_on_switch = false
    ...
}
```

### Automatic Heuristic Mode

By default, the plugin will set the hard or soft mode automatically when any
file loads (for a specific set of file types, see below), using the
`BufWinEnter` event in an autocmd. It uses a variety of heuristics (which aren't
documented in detail here as they will evolve over time as `wrapping.nvim`
becomes more sophisticated).

#### Controlling Filetypes that Trigger Heuristics

If you want to control the filetypes that the automatic heuristic mode triggers
for, you can change this list:

```lua
opts = {
    auto_set_mode_filetype_allowlist = {
        "asciidoc",
        "gitcommit",
        "latex",
        "mail",
        "markdown",
        "rst",
        "tex",
        "text",
    },
}
```

(the list above is the default list; if you are aware of other filetypes
supported by NeoVim which are typically treated as text, please [open an
issue](https://github.com/andrewferrier/wrapping.nvim/issues/new) so we can add
it to this default list).

If you set `auto_set_mode_filetype_allowlist` to `{}`, you can instead
set `auto_set_mode_filetype_denylist` to a list of filetypes, and any files
with a filetype *not* in that list will be heuristically detected instead.

#### Disabling Heuristics Entirely

To disable automatic heuristics entirely, you can set:

```lua
opts = {
    auto_set_mode_heuristically = false
    ...
}
```

You can then trigger the automatic logic yourself from wherever you want - e.g.
from a `ftdetect` plugin. Note that this will *ignore* the
`auto_set_mode_filetype_allowlist` and `auto_set_mode_filetype_denylist`
options.

```lua
require('wrapping').set_mode_heuristically()
```

You can also ignore heuristics entirely and just use the commands and/or
keymappings listed above to switch between modes for a file.

#### If Heuristics Make the Wrong Choice

You have two options:

1.  Override the 'softener' value for that file type. By default, this is `1.0`
    for every file. Setting the value higher makes it *more likely* that the
    file will be detected as having 'soft' line wrapping (this value is
    multiplied by the average line length and then compared to the `textwidth`
    in use for that filetype). Setting it to `true` means that files of that
    type will *always* be treated as having soft line endings. Setting it to
    `false` means that files of that type will *always* be treated as having
    hard line endings. For example, this sets the softener value to `1.3` for
    Markdown files:

    ```lua
        require("wrapping").setup({
            softener = { markdown = 1.3 },
        })
    ```

    For more advanced use cases, you can set this 'softener' value to a callback
    function that performs some of your own custom logic. It should then return
    `true`, `false`, or a numeric value (interpreted the same way as described
    above). Example:

    ```lua
        require("wrapping").setup({
            softener = {
                markdown = function()
                    -- Some custom logic
                    return value
                end
            }
        })
    ```

    Note that certain heuristics are evaluated *before* the softener value, in
    which case it will have no effect. These should be 'foolproof', but if they
    are not, and you are sure a file is being detected incorrectly, please move
    to option (2)…

2.  [Open an issue](https://github.com/andrewferrier/wrapping.nvim/issues/new)
    with an example of the file that's being incorrectly detected and explain
    why you think it should be detected as having hard or soft line breaks, and
    we'll review to see if there are ways to improve the heuristics of
    `wrapping.nvim`. In this case, please also run the command
    `WrappingOpenLog`, and include the relevant sections of the log file that's
    displayed, to help diagnose why `wrapping.nvim` isn't doing what you want.

#### Modifying Treesitter Queries (Advanced)

By default, `wrapping.nvim` excludes some lines from the softening calculation
based on treesitter queries (the defaults can be seen in the
[init.lua](lua/wrapping/init.lua) file, in the `OPTION_DEFAULTS` object, and
this currently only supports Markdown files). If you wish, you can modify/add to
these in the `opts` object. Details are left as an exercise for the advanced
reader! Please open an issue if you wish to do this and the process is not
obvious.

### Disable NeoVim defaults change

By default, `wrapping.nvim` will tweak some NeoVim defaults (`linebreak` and
`wrap`) to make it operate more smoothly. If for some reason you don't want this
to happen:

```lua
opts = {
    set_nvim_opt_defaults = false
    ...
}
```

## Status Lines

If you have a custom status line, you can get the current mode for a file -
`'hard'`, `'soft'`, or `''` (`wrapping.nvim` not activated for that file) by
invoking `require('wrapping').get_current_mode()`.
