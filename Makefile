.PHONY: test
test:
	JULIA_LOAD_PATH=. julia test/runtests.jl
