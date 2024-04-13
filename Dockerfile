FROM python:3.12-slim as base

FROM base as builder

RUN apt update && \
    apt install python3-dev libpq-dev default-libmysqlclient-dev build-essential pkg-config -y


RUN python3 -m pip install -U pip && \
    python3 -m pip install --prefix="/build" PyYAML mysql psycopg2 gunicorn ara[server]

FROM base

RUN apt update && apt full-upgrade -y && \
    apt install bash -y && \
    rm -rf /tmp/* /var/tmp/* /var/cache/* && \
    sync

ENV ARA_BASE_DIR=/opt/ara

COPY --from=builder /build /usr/local
COPY ara.sh ./ara.sh

EXPOSE 8000

ENTRYPOINT ["/bin/bash", "-c", "./ara.sh"]
