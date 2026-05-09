local wrapping = require("wrapping")
local support = require("tests.support")

describe("detect wrapping mode with different softeners", function()
    after_each(support.teardown)

    it(
        "can detect hard mode when textwidth set globally but softener low",
        function()
            support.setup({ softener = { text = 0.1 } })
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
            assert.are.same("hard", wrapping.get_current_mode())
        end
    )

    it(
        "can detect hard mode when textwidth set globally but softener false",
        function()
            support.setup({ softener = { text = false } })
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
            assert.are.same("hard", wrapping.get_current_mode())
        end
    )

    it(
        "can detect soft mode when textwidth set globally but softener high",
        function()
            support.setup({ softener = { text = 999 } })
            vim.opt.textwidth = 80

            support.set_lines({
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
            support.setup({ softener = { text = true } })
            vim.opt.textwidth = 80

            support.set_lines({
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
            support.setup({
                softener = {
                    text = function()
                        return false
                    end,
                },
            })
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
            assert.are.same("hard", wrapping.get_current_mode())
        end
    )

    it(
        "can detect soft mode when textwidth set globally but softener func that returns true",
        function()
            support.setup({
                softener = {
                    text = function()
                        return true
                    end,
                },
            })
            vim.opt.textwidth = 80

            support.set_lines({
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
