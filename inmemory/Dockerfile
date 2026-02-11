FROM redis:8.6.0-alpine

COPY ./conf/redis.conf /etc/redis/redis.conf

CMD [ "redis-server", "/etc/redis/redis.conf" ]