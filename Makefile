.PHONY: all clean test

test:
	nvim --headless --clean -u tests/init.vim -c "PlenaryBustedFile tests/all.lua"
