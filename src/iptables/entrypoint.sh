#!/bin/sh

function setUp {
  tearDown
  echo "-----> adding redirects to port 3129"
  /sbin/iptables -t nat -A PREROUTING -p tcp --dport 80 -j REDIRECT --to 3129 -w
}

function tearDown {
  /sbin/iptables -t nat -D PREROUTING -p tcp --dport 80 -j REDIRECT --to 3129 -w 2> /dev/null
}

function finalize {
  echo "-----> cleaning up redirects"
  tearDown
  exit 0
}

trap finalize SIGTERM

setUp

exec /usr/bin/tail -f /dev/null & wait $!

