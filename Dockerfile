FROM python:alpine

RUN apk update && \
    apk upgrade --available && \
    sync && \
    apk add postgresql-dev mariadb-dev bash build-base yaml-dev && \
    rm -rf /tmp/* /var/tmp/* /var/cache/apk/* /var/cache/distfiles/*

RUN python3 -m pip install --no-cache-dir --no-binary PyYAML PyYAML

RUN python3 -m pip install mysql psycopg2 gunicorn ara[server]

ENV ARA_BASE_DIR=/opt/ara

COPY ara.sh ./ara.sh

EXPOSE 8000

ENTRYPOINT ["/bin/bash", "-c", "./ara.sh"]
