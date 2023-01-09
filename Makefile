# Run benchmark
.PHONY: bench
bench:
	resty -I lib benchmark/match-params.lua
	@echo ""
	resty -I lib benchmark/match-static.lua
	@echo ""
	resty -I lib benchmark/match-wildcard.lua
	@echo ""
