local wrapping = require("wrapping")
local support = require("tests.support")

describe("detect wrapping mode", function()
    before_each(function()
        support.setup()
    end)

    after_each(support.teardown)

    it("can detect hard mode when filetype not set", function()
        support.set_lines({
            "test1",
            "test2",
            "test3",
            "test4",
            "test5",
        })

        wrapping.set_mode_heuristically()
        assert.are.same("hard", wrapping.get_current_mode())
    end)

    it("can detect hard mode when textwidth not set", function()
        support.set_lines({
            "test1",
            "test2",
            "test3",
            "test4",
            string.rep("x", 500),
        })

        vim.opt_local.filetype = "text"
        wrapping.set_mode_heuristically()
        assert.are.same("hard", wrapping.get_current_mode())
    end)

    it("can detect hard mode when textwidth set locally", function()
        support.set_lines({
            "test1",
            "test2",
            "test3",
            "test4",
            string.rep("x", 500),
        })

        vim.opt_local.filetype = "text"
        vim.opt_local.textwidth = 80
        wrapping.set_mode_heuristically()
        assert.are.same("hard", wrapping.get_current_mode())
    end)

    it("can detect soft mode when textwidth set globally", function()
        vim.opt.textwidth = 80

        support.set_lines({
            "test1",
            "test2",
            "test3",
            "test4",
            string.rep("x", 500),
        })

        vim.opt_local.filetype = "text"
        wrapping.set_mode_heuristically()
        assert.are.same("soft", wrapping.get_current_mode())
    end)

    it("can set soft mode explicitly", function()
        support.set_lines({
            "test1",
            "test2",
            "test3",
        })

        wrapping.soft_wrap_mode()
        assert.are.same("soft", wrapping.get_current_mode())
    end)

    it("can set hard mode explicitly", function()
        support.set_lines({
            "test1",
            "test2",
            "test3",
        })

        wrapping.hard_wrap_mode()
        assert.are.same("hard", wrapping.get_current_mode())
    end)

    it("can toggle mode explicitly", function()
        support.set_lines({
            "test1",
            "test2",
            "test3",
        })

        wrapping.set_mode_heuristically()
        assert.are.same("hard", wrapping.get_current_mode())
        wrapping.toggle_wrap_mode()
        assert.are.same("soft", wrapping.get_current_mode())
        wrapping.toggle_wrap_mode()
        assert.are.same("hard", wrapping.get_current_mode())
    end)
end)
