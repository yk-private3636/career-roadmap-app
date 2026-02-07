FROM redis:8.4.0-bookworm

COPY ./conf/redis.conf /etc/redis/redis.conf

CMD [ "redis-server", "/etc/redis/redis.conf" ]