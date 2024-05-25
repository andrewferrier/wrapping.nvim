vim.opt.runtimepath:prepend(
    "~/.local/share/nvim/site/pack/vendor/start/nvim-treesitter"
)
vim.opt.runtimepath:prepend("../nvim-treesitter")

vim.cmd("runtime! plugin/nvim-treesitter.lua")

local install_parser_if_needed = function(filetype)
    if vim.tbl_contains(vim.tbl_keys(vim.fn.environ()), "GITHUB_WORKFLOW") then
        print("Running in GitHub; installing parser " .. filetype .. "...")
        vim.cmd("TSInstallSync! " .. filetype)
    else
        vim.cmd("new")
        vim.cmd("only")
        local ok, _ = pcall(vim.treesitter.get_parser, 0, filetype, {})
        if not ok then
            print("Cannot load parser for " .. filetype .. ", installing...")
            vim.cmd("TSInstallSync! " .. filetype)
        end
    end
end

install_parser_if_needed("markdown")

local common = require("tests.common")
local wrapping = require("wrapping")

describe("detect wrapping mode", function()
    before_each(function()
        common.setup()
    end)

    after_each(common.teardown)

    it("can detect hard mode when filetype not set", function()
        common.set_lines({
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
        common.set_lines({
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
        common.set_lines({
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

        common.set_lines({
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
        common.set_lines({
            "test1",
            "test2",
            "test3",
        })

        wrapping.soft_wrap_mode()
        assert.are.same("soft", wrapping.get_current_mode())
    end)

    it("can set hard mode explicitly", function()
        common.set_lines({
            "test1",
            "test2",
            "test3",
        })

        wrapping.hard_wrap_mode()
        assert.are.same("hard", wrapping.get_current_mode())
    end)

    it("can toggle mode explicitly", function()
        common.set_lines({
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

describe("detect wrapping mode with different softeners", function()
    after_each(common.teardown)

    it(
        "can detect hard mode when textwidth set globally but softener low",
        function()
            common.setup({ softener = { text = 0.1 } })
            vim.opt.textwidth = 80

            common.set_lines({
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
            common.setup({ softener = { text = false } })
            vim.opt.textwidth = 80

            common.set_lines({
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
            common.setup({ softener = { text = 999 } })
            vim.opt.textwidth = 80

            common.set_lines({
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
            common.setup({ softener = { text = true } })
            vim.opt.textwidth = 80

            common.set_lines({
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
            common.setup({
                softener = {
                    text = function()
                        return false
                    end,
                },
            })
            vim.opt.textwidth = 80

            common.set_lines({
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
            common.setup({
                softener = {
                    text = function()
                        return true
                    end,
                },
            })
            vim.opt.textwidth = 80

            common.set_lines({
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

describe("handle treesitter blocks", function()
    after_each(common.teardown)

    it("can exclude fenced code blocks - hard", function()
        common.setup()
        vim.opt.textwidth = 80

        common.set_lines({
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

    if
        vim.fn.has("nvim-0.10") == 1
        or (vim.fn.has("nvim-0.8") == 1 and vim.fn.has("nvim-0.9") ~= 1)
    then
        -- These tests seem to fail on NeoVim 0.9.x - I think there's some kind
        -- of parser issue

        it("can exclude fenced code blocks - soft", function()
            common.setup()
            vim.opt.textwidth = 80

            common.set_lines({
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
            common.setup()
            vim.opt.textwidth = 80

            common.set_lines({
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
    end

    it("wide tables make hard mode more likely", function()
        common.setup()
        vim.opt.textwidth = 80

        common.set_lines({
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
