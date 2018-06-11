FROM alpine:3.7

RUN apk add --update --no-cache tini squid=3.5.27-r0
RUN mv /etc/squid/squid.conf /etc/squid/squid.conf.dist

COPY squid.conf /etc/squid/squid.conf
COPY entrypoint.sh /

VOLUME /cache /logs

EXPOSE 3128/tcp

ENTRYPOINT ["tini", "--"]
CMD ["/entrypoint.sh"]
