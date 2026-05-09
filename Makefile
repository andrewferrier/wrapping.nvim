.PHONY: all clean test

test:
	nvim --headless --clean -u tests/run.lua
