FROM grahamdumpleton/mod-wsgi-docker:python-2.7-onbuild

#RUN chgrp -R www-data: /app/lib/toaster/

RUN mkdir -p /var/www/static/

ENV PYTHONPATH=/app/lib/toaster:
ENV TOASTER_DIR=/data
WORKDIR /app/lib/toaster
RUN python manage.py migrate
RUN python manage.py collectstatic -link --noinput

CMD [ "/app/lib/toaster/toastermain/wsgi.py" ]
