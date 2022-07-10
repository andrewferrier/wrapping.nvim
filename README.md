# wrapping.nvim

⚠️  **Note**: This plugin has been rewritten from VimL  (Vim and NeoVim) to lua
(just NeoVim), and renamed from `vim-wrapping-softhard` to `wrapping.nvim`. If
you are still using Vim, the
[vim-viml](https://github.com/andrewferrier/vim-wrapping-softhard/releases/tag/vim-viml)
tag is against the last VimL-based version suitable for using with vim.

***

This is a NeoVim plugin designed to make it easy to flip between 'soft' and
'hard' wrapping modes when editing text-like files (e.g. text, Markdown, LaTeX,
AsciiDoc, etc.). Typically one comes across some text-like files which have no
hard carriage returns to wrap text - each paragraph is one long line (some
Markdown files are like this). Other files use "hard" wrapping (like this
README, for example), where each line ending is "hard" wrapped using the
author's preference for line length (typically in the 78-80 character range).

This plugin makes it easy to flip between the two when files are open, setting
the relevant vim settings to make it "natural" to edit the file that way. It
also attempts to detect the natural wrapping style of the file when first
opening it if you use that feature (see below). It introduces the concept of a
soft or hard 'mode' per-file. It does *not* support modifying the content of the
file or converting between files of those types.

## What the Soft / Hard Mode Affects

At the moment, this plugin just sets the `textwidth` and `wrap/nowrap` settings
(locally to the file's buffer) when switching between hard and soft wrapping
modes. It will also re-map the `<Up>` and `<Down>` keys depending on the
wrapping style, so they move by screen line in soft mode. I would welcome issues
/ pull requests if there are other settings that would be useful to alter under
these different modes.

## Installation

**Requires NeoVim 0.7+.**

Example for [`packer.nvim`](https://github.com/wbthomason/packer.nvim):

```lua
packer.startup(function(use)

    ...

    use({
        "andrewferrier/vim-wrapping-softhard",
        config = function()
            require("wrapping").setup()
        end,
    })

    ...

end)
```

## Modifying the Default Behaviour

You can add an `opts` object to the setup method:

```lua
opts = { ... }

use({
    "andrewferrier/vim-wrapping-softhard",
    config = function()
        require("wrapping").setup(opts)
    end,
})
```

The sections below detail the allowed options.

### Commands and Keymappings

By default, the plugin will create the following commands to set/override a
wrapping mode:

*   `HardWrapMode`
*   `SoftWrapMode`
*   `ToggleWrapMode`

As well as the following normal-mode keymappings:

*   `[ow` (soft wrap mode)
*   `]ow` (hard wrap mode)
*   `yow` (toggle wrap mode)

(these are similar to [vim-unimpaired](https://github.com/tpope/vim-unimpaired))

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

### Automatic Heuristic Mode

By default, the plugin will set the hard or soft mode automatically when any
file loads (for a specific set of file types, see below), using the
`BufWinEnter` event in an autocmd. It uses a variety of heuristics (which aren't
documented in detail here as they will evolve over time as `wrapping.nvim`
becomes more sophisticated).

#### Disabling Heuristics or Controlling Filetypes it Triggers For

If you want to control the filetypes that the automatic heuristic mode triggers
for, you can change this list:

```lua
opts = {
    auto_set_mode_filetype_allowlist = {
        "asciidoc",
        "gitcommit",
        "mail",
        "markdown",
        "text",
        "tex",
    },
}
```

(the list above is the default list).

If you set `auto_set_mode_filetype_allowlist`) to `{}`, you can instead
set `auto_set_mode_filetype_denylist` to a list of filetypes, and any files
with a filetype *not* in that list will be heuristically detected.

If you want to disable automatic heuristics entirely, you can set:

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

#### If Files Are Detected Incorrectly

If it detects your file
incorrectly, you have two options:

1.  Override the 'softener' value for that file type. By default, this is `1.0`
    for every file. Setting the value higher makes it *more likely* that the
    file will be detected as having 'soft' line wrapping (this value is
    multiplied by the average line length and then compared to the `textwidth`
    in use for that filetype). For example, this sets the softener value to
    `1.3` for Markdown files:

```lua
    require("wrapping").setup({
        softener = { markdown = 1.3 },
    })
```

2.  [Open an issue](https://github.com/andrewferrier/wrapping.nvim/issues/new)
    with an example of the file that's being incorrectly detected and explain
    why you think it should be detected as having hard or soft line breaks.

## Status Lines

If you have a custom status line, you can get the current mode for a file -
`'hard'`, `'soft'`, or `''` by invoking
`require('wrapping').get_current_mode()`.
