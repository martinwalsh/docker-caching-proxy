include .makefiles/ludicrous.mk
include .makefiles/virtualenv.mk

cache logs:
	@mkdir -p $@

#> run `docker-compose build`
build: | _program_docker-compose
	docker-compose build
.PHONY: build

#> run `docker-compose up -d`
up: | cache logs build
	docker-compose up -d
.PHONY: up

#> run `docker-compose down`
down: | _program_docker-compose
	docker-compose down
.PHONY: down

#> run `docker-compose ps`
status: | _program_docker-compose
	docker-compose ps
.PHONY: status

#> wait for squid to report a service up message
#>   set `TIMEOUT=n` where `n` is the
#>   number of seconds to wait for the service
wait: TIMEOUT := 10
wait: | up
	$(call log,waiting for squid service to start)
	@( \
		tail -n0 -f logs/cache.log | \
		grep -q 'Accepting NAT intercepted HTTP Socket connections' \
	) & pid=$$! ; ( \
			sleep $(TIMEOUT) && ($(call _error,timeout while waiting for squid service) && kill -HUP $$pid) \
		) 2> /dev/null & tpid=$$! ; \
		wait $$pid 2> /dev/null  && kill -HUP $$tpid

export PYTHONDONTWRITEBYTECODE := 1

ifdef VERBOSE
	TEST_OPTS += -v
endif

#> run caching performance test
test: | virtualenv
	$(call log,resetting cache)
	@$(MAKE) --no-print-directory purge wait
	$(call log,running first test)
	.env/bin/py.test -v tests/test_*.py $(TEST_OPTS) --benchmark-autosave
	$(call log,running second test)
	.env/bin/py.test -v tests/test_*.py $(TEST_OPTS) --benchmark-compare=0001 --benchmark-compare-fail=mean:000000000000.1
.PHONY: test

shell:
	bin/shell.sh
.PHONY: shell

#> down the service and clear its cache
purge: | down
	rm -rf cache .benchmarks .pytest_cache

clean::
	rm -rf cache logs .benchmarks .pytest_cache
.PHONY: clean
