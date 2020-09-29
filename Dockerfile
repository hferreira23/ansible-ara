FROM python:alpine

RUN apk update && \
    apk upgrade --available && \
    sync && \
    apk add postgresql-dev mariadb-dev bash build-base && \
    rm -rf /tmp/* /var/tmp/* /var/cache/apk/* /var/cache/distfiles/*

RUN pip install mysql psycopg2 gunicorn ara[server] PyYAML

ENV ARA_BASE_DIR=/opt/ara

COPY ara.sh ./ara.sh

EXPOSE 8000

ENTRYPOINT ["/bin/bash", "-c", "./ara.sh"]
