.PHONY: all clean test

test:
	nvim --headless --clean -u tests/init.vim -c "PlenaryBustedFile tests/minimal.lua"
	nvim --headless --clean -u tests/init.vim -c "PlenaryBustedFile tests/treesitter.lua"
