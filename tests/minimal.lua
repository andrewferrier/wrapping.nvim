local common = require("tests.common")
local wrapping = require("wrapping")

describe("handle treesitter blocks", function()
    after_each(common.teardown)

    it("won't exclude fenced code blocks", function()
        common.setup()
        vim.opt.textwidth = 80

        common.set_lines({
            string.rep("x", 120),
            "```lua",
            "function x()",
            "end",
            "```",
        })

        vim.opt_local.filetype = "markdown"
        wrapping.set_mode_heuristically()
        assert.are.same("hard", wrapping.get_current_mode())
    end)
end)
