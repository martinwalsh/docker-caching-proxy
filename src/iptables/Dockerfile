FROM alpine:3.7
RUN apk add --no-cache iptables ip6tables tini

COPY entrypoint.sh /

ENTRYPOINT ["tini", "--"]
CMD ["/entrypoint.sh"]
