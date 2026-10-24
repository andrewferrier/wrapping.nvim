local wrapping = require("wrapping")
local support = require("tests.support")

describe("setup option validation", function()
    after_each(support.teardown)

    it("validates create_keymaps as a boolean", function()
        support.setup({ create_commands = false, create_keymaps = false })

        local ok = pcall(wrapping.setup, {
            auto_set_mode_heuristically = false,
            create_commands = false,
            create_keymaps = "false",
        })

        assert.is_false(ok)
    end)
end)
