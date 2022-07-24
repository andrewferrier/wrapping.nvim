local set_lines = function(lines)
    vim.api.nvim_buf_set_lines(0, 0, -1, true, lines)
end

local string_of_length = function(length)
    local res = ""

    for _ = 1, length do
        res = res .. "x"
    end

    return res
end

local wrapping = require("wrapping")

describe("detect wrapping mode", function()
    before_each(function()
        wrapping.setup({
            auto_set_mode_heuristically = false,
            notify_on_switch = false,
        })
    end)

    it("can detect hard mode when filetype not set", function()
        set_lines({
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
        set_lines({
            "test1",
            "test2",
            "test3",
            "test4",
            string_of_length(500),
        })

        vim.opt_local.filetype = "text"
        wrapping.set_mode_heuristically()
        assert.are.same("hard", wrapping.get_current_mode())
    end)

    it("can detect hard mode when textwidth set locally", function()
        set_lines({
            "test1",
            "test2",
            "test3",
            "test4",
            string_of_length(500),
        })

        vim.opt_local.filetype = "text"
        vim.opt_local.textwidth = 80
        wrapping.set_mode_heuristically()
        assert.are.same("hard", wrapping.get_current_mode())
    end)

    it("can detect soft mode when textwidth set globally", function()
        vim.opt.textwidth = 80

        set_lines({
            "test1",
            "test2",
            "test3",
            "test4",
            string_of_length(500),
        })

        vim.opt_local.filetype = "text"
        wrapping.set_mode_heuristically()
        assert.are.same("soft", wrapping.get_current_mode())
    end)

    it("can set soft mode explicitly", function()
        set_lines({
            "test1",
            "test2",
            "test3",
        })

        wrapping.soft_wrap_mode()
        assert.are.same("soft", wrapping.get_current_mode())
    end)

    it("can set hard mode explicitly", function()
        set_lines({
            "test1",
            "test2",
            "test3",
        })

        wrapping.hard_wrap_mode()
        assert.are.same("hard", wrapping.get_current_mode())
    end)

    it("can toggle mode explicitly", function()
        set_lines({
            "test1",
            "test2",
            "test3",
        })

        assert.are.same("hard", wrapping.get_current_mode())
        wrapping.toggle_wrap_mode()
        assert.are.same("soft", wrapping.get_current_mode())
        wrapping.toggle_wrap_mode()
        assert.are.same("hard", wrapping.get_current_mode())
    end)
end)
