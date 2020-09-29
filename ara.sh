#!/bin/bash
/usr/local/bin/ara-manage migrate && /usr/local/bin/gunicorn --workers=4 --access-logfile - --bind 0.0.0.0:8000 ara.server.wsgi
