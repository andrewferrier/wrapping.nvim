local wrapping = require("wrapping")
local support = require("tests.support")

describe("handle treesitter blocks", function()
    after_each(support.teardown)

    it("can exclude fenced code blocks - hard", function()
        support.setup()
        vim.opt.textwidth = 80

        support.set_lines({
            string.rep("x", 79),
            "```lua",
            "function x()",
            "end",
            "```",
        })

        vim.opt_local.filetype = "markdown"
        wrapping.set_mode_heuristically()
        assert.are.same("hard", wrapping.get_current_mode())
    end)

    it("can exclude fenced code blocks - soft", function()
        support.setup()
        vim.opt.textwidth = 80

        support.set_lines({
            string.rep("x", 81),
            "```lua",
            "function x()",
            "end",
            "```",
        })

        vim.opt_local.filetype = "markdown"
        wrapping.set_mode_heuristically()
        assert.are.same("soft", wrapping.get_current_mode())
    end)

    it("can exclude 2 fenced code blocks", function()
        support.setup()
        vim.opt.textwidth = 80

        support.set_lines({
            "```lua",
            "function x()",
            "end",
            "```",
            string.rep("x", 120),
            "```lua",
            "function x()",
            "end",
            "```",
        })

        vim.opt_local.filetype = "markdown"
        wrapping.set_mode_heuristically()
        assert.are.same("soft", wrapping.get_current_mode())
    end)

    it("wide tables make hard mode more likely", function()
        support.setup()
        vim.opt.textwidth = 80

        support.set_lines({
            "# ABC",
            string.rep("x", 79),
            "| Foo                                      | Bar                                  | ABC                         | XYZ |",
            "| ---------------------------------------- | ------------------------------------ | --------------------------- | --- |",
            "| foo                                      | bar                                  | abc                         | xyz |",
        })

        vim.opt_local.filetype = "markdown"
        wrapping.set_mode_heuristically()
        assert.are.same("hard", wrapping.get_current_mode())
    end)
end)
