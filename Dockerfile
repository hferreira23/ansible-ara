FROM python:alpine as base

FROM base as builder

RUN apk add postgresql-dev mariadb-dev build-base yaml-dev && \
    rm -rf /tmp/* /var/tmp/* /var/cache/apk/* /var/cache/distfiles/*

RUN python3 -m pip install --prefix="/build" --no-cache-dir --no-binary PyYAML PyYAML

RUN python3 -m pip install --prefix="/build" mysql psycopg2 gunicorn ara[server]

FROM base

RUN echo "http://dl-cdn.alpinelinux.org/alpine/edge/community" >> /etc/apk/repositories && \
    echo "http://dl-cdn.alpinelinux.org/alpine/edge/main" >> /etc/apk/repositories && \
    echo "http://dl-cdn.alpinelinux.org/alpine/edge/testing" >> /etc/apk/repositories && \
    apk update && \
    apk upgrade --available && \
    apk add bash && \
    rm -rf /tmp/* /var/tmp/* /var/cache/apk/* /var/cache/distfiles/* && \
    sync

ENV ARA_BASE_DIR=/opt/ara

COPY --from=builder /build /usr/local
COPY ara.sh ./ara.sh

EXPOSE 8000

ENTRYPOINT ["/bin/bash", "-c", "./ara.sh"]
