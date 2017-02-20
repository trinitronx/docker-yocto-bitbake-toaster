FROM grahamdumpleton/mod-wsgi-docker:python-2.7-onbuild

#RUN chgrp -R www-data: /app/lib/toaster/

RUN mkdir -p /var/www/static/

ENV PYTHONPATH=/app/lib/toaster:/usr/local/python/lib/python2.7/site-packages:
ENV TOASTER_DIR=/data
WORKDIR /app/lib/toaster
RUN python manage.py migrate && chown -R whiskey $TOASTER_DIR
RUN python manage.py collectstatic -link --noinput

CMD [ "--url-alias", "/static", "/var/www/static/", "/app/lib/toaster/toastermain/wsgi.py" ]
