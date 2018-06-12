# docker-caching-proxy

Configures a transparent squid proxy to be used automatically by local containers, reducing
bandwidth and build time. It is intended for development use only.

The included docker-compose definition launches a container in privileged mode so that the required
netfilter rules may be set on the docker host. This project is therefore completely unsuitable for
production environments.

## Prerequisites

* GNU Make
* docker-compose (version 3.6+)
* [optional] python and virutalenv (for `make test`)

## Launch the caching proxy

```
make up  # wrapper for `docker-compose build` and `docker-compuse up`
```

## Troubleshoot

See the [SquidFaq](https://wiki.squid-cache.org/SquidFaq/TroubleShooting) for more
troubleshooting information. Squid logs are written to the local `logs/` directory.

## Clean up

To delete logs, cache and other build artifacts:

```
make clean
```

## Run the demo

This project includes a sample benchmark that exercises the cache. To run the test:

```
make test
```

## Prior art

* [jpetazzo/squid-in-a-can](https://github.com/jpetazzo/squid-in-a-can)
* [docker-scripts/squid](https://github.com/docker-scripts/squid)
* [komlevv/docker-squid-cache](https://github.com/komlevv/docker-squid-cache)
