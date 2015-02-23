FROM ministryofjustice/ruby:2.1.5-webapp-onbuild

# runit needs inittab
RUN touch /etc/inittab

RUN apt-get update
RUN apt-get install -y pdftk

# runit setup for the application
RUN mkdir -p /etc/service/accelerated_claims
COPY ./docker/runit/runit-service /etc/service/accelerated_claims/run
RUN chmod +x /etc/service/accelerated_claims/run

ENV UNICORN_PORT 3000

EXPOSE $UNICORN_PORT

CMD ["/usr/bin/runsvdir", "-P", "/etc/service"]
