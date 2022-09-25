local set_lines = function(lines)
    vim.api.nvim_buf_set_lines(0, 0, -1, true, lines)
end

local wrapping = require("wrapping")

local setup = function(o)
    local opts = vim.tbl_deep_extend("keep", o or {}, {
        auto_set_mode_heuristically = false,
        notify_on_switch = false,
    })

    wrapping.setup(opts)
end

describe("detect wrapping mode", function()
    before_each(function()
        setup()
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
            string.rep("x", 500),
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
            string.rep("x", 500),
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
            string.rep("x", 500),
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

describe("detect wrapping mode with different softeners", function()
    it(
        "can detect hard mode when textwidth set globally but softener low",
        function()
            setup({ softener = { text = 0.1 } })
            vim.opt.textwidth = 80

            set_lines({
                "test1",
                "test2",
                "test3",
                "test4",
                string.rep("x", 500),
            })

            vim.opt_local.filetype = "text"
            wrapping.set_mode_heuristically()
            assert.are.same("hard", wrapping.get_current_mode())
        end
    )

    it(
        "can detect hard mode when textwidth set globally but softener false",
        function()
            setup({ softener = { text = false } })
            vim.opt.textwidth = 80

            set_lines({
                "test1",
                "test2",
                "test3",
                "test4",
                string.rep("x", 500),
            })

            vim.opt_local.filetype = "text"
            wrapping.set_mode_heuristically()
            assert.are.same("hard", wrapping.get_current_mode())
        end
    )

    it(
        "can detect soft mode when textwidth set globally but softener high",
        function()
            setup({ softener = { text = 999 } })
            vim.opt.textwidth = 80

            set_lines({
                "test1",
                "test2",
                "test3",
                "test4",
                "test5",
            })

            vim.opt_local.filetype = "text"
            wrapping.set_mode_heuristically()
            assert.are.same("soft", wrapping.get_current_mode())
        end
    )

    it(
        "can detect soft mode when textwidth set globally but softener true",
        function()
            setup({ softener = { text = true } })
            vim.opt.textwidth = 80

            set_lines({
                "test1",
                "test2",
                "test3",
                "test4",
                "test5",
            })

            vim.opt_local.filetype = "text"
            wrapping.set_mode_heuristically()
            assert.are.same("soft", wrapping.get_current_mode())
        end
    )

    it(
        "can detect hard mode when textwidth set globally but softener func that returns false",
        function()
            setup({
                softener = {
                    text = function()
                        return false
                    end,
                },
            })
            vim.opt.textwidth = 80

            set_lines({
                "test1",
                "test2",
                "test3",
                "test4",
                string.rep("x", 500),
            })

            vim.opt_local.filetype = "text"
            wrapping.set_mode_heuristically()
            assert.are.same("hard", wrapping.get_current_mode())
        end
    )

    it(
        "can detect soft mode when textwidth set globally but softener func that returns true",
        function()
            setup({
                softener = {
                    text = function()
                        return true
                    end,
                },
            })
            vim.opt.textwidth = 80

            set_lines({
                "test1",
                "test2",
                "test3",
                "test4",
                "test5",
            })

            vim.opt_local.filetype = "text"
            wrapping.set_mode_heuristically()
            assert.are.same("soft", wrapping.get_current_mode())
        end
    )
end)
