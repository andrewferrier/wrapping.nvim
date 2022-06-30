# vim-wrapping-softhard

⚠️  **Note**: This plugin has been rewritten from VimL (Vim) to lua (for NeoVim
only). If you are still using Vim, the last VimL-based version suitable for
using for vim is tagged with the
[vim-viml](https://github.com/andrewferrier/vim-wrapping-softhard/releases/tag/vim-viml)
tag.

---

This is a NeoVim plugin designed to make it easy to flip between 'soft' and
'hard' wrapping when editing text-like files. Typically one comes across some
text-like files which have no hard carriage returns to wrap text - each
paragraph is one long line (some Markdown files are like this). Other files use
"hard" wrapping (like this README, for example), where each line ending is
"hard" wrapped using the author's preference for line length (typically in the
78-80 character range).

This plugin makes it easy to flip between the two when files are open,
setting the relevant vim settings to make it "natural" to edit the file that
way. It also attempts to detect the natural wrapping style of the file when
first opening it if you use that feature (see below). It introduces the concept
of a soft or hard 'mode' per-file.

## What the Soft Hard Mode Affects

At the moment, this plugin just changes the `textwidth` and `wrap/nowrap`
settings when switching between modes. It will also re-map the `<Up>` and
`<Down>` keys depending on the wrapping style, so they move by screen line in
soft mode.

## Installation

Example for `packer.nvim`:

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

## Modifying the Default Behaviour

You can add an `opts` object to the setup method:

    opts = { ... }

    use({
        "andrewferrier/vim-wrapping-softhard",
        config = function()
            require("wrapping").setup(opts)
        end,
    })

The sections below detail the allowed options.

### Commands

By default, the plugin will create the following commands to set/override a
wrapping mode:

    HardWrapMode
    SoftWrapMode
    ToggleWrapMode

Disable these commands by setting:

    opts = {
        create_commands = false,
        ...
    }

### Keymappings

By default, the plugin will create the following keymappings to set/override a
wrapping mode:

    [ow (soft wrap mode)
    ]ow (hard wrap mode)
    yow (toggle wrap mode)

(these are similar to [vim-unimpaired](https://github.com/tpope/vim-unimpaired))

Disable these keymappings by setting:

    opts = {
        create_keymappings = false,
        ...
    }

### Automatic Heuristic Mode

By default, the plugin will set the hard or soft mode automatically when any
type of file loads, using the `BufRead` event in an autocmd. You might want to
stop this behaviour, or ...

TODO

## Other Extensions

* How to get the mode for status line
