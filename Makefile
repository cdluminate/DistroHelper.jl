.PHONY: test
test:
	export JULIA_LOAD_PATH=.
	julia test/runtests.jl
