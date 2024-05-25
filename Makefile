.PHONY: all clean test

test:
	nvim --headless --clean -u tests/init.vim -c "PlenaryBustedFile tests/minimal.lua" || true
	# nvim --headless --clean -u tests/init.vim -c "PlenaryBustedFile tests/treesitter.lua"
	cat $(HOME)/.local/state/nvim/wrapping.nvim.log
