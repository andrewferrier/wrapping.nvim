local wrapping = require("wrapping")
local support = require("tests.support")

describe("WrappingSet User event", function()
    after_each(support.teardown)

    it("emits event when soft mode is set manually", function()
        support.setup()
        local event_fired = false
        local event_data = nil

        vim.api.nvim_create_autocmd("User", {
            pattern = "WrappingSet",
            callback = function(args)
                event_fired = true
                event_data = args.data
            end,
        })

        support.set_lines({
            "test1",
            "test2",
            "test3",
        })

        wrapping.soft_wrap_mode()

        assert.is_true(event_fired)
        assert.is_not_nil(event_data)
        ---@diagnostic disable: need-check-nil
        assert.are.same("soft", event_data.mode)
        assert.are.same(vim.api.nvim_get_current_buf(), event_data.buf)
        assert.are.same(vim.api.nvim_get_current_win(), event_data.win)
        ---@diagnostic enable: need-check-nil
    end)

    it("emits event when mode is set heuristically to hard", function()
        support.setup()
        local event_fired = false
        local event_data = nil

        vim.api.nvim_create_autocmd("User", {
            pattern = "WrappingSet",
            callback = function(args)
                event_fired = true
                event_data = args.data
            end,
        })

        support.set_lines({
            "test1",
            "test2",
            "test3",
            "test4",
            "test5",
        })

        wrapping.set_mode_heuristically()

        assert.is_true(event_fired)
        assert.is_not_nil(event_data)
        ---@diagnostic disable: need-check-nil
        assert.are.same("hard", event_data.mode)
        assert.are.same(vim.api.nvim_get_current_buf(), event_data.buf)
        assert.are.same(vim.api.nvim_get_current_win(), event_data.win)
        ---@diagnostic enable: need-check-nil
    end)
end)
