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

ENV WEBUSER="moj" \
    ZENDESK_USERNAME="" \
    ZENDESK_TOKEN="" \
    NEW_RELIC_LICENSE_KEY="" \
    APPSIGNAL_PUSH_API_KEY="" \
    ANONYMOUS_PLACEHOLDER_EMAIL="" \
    RAILS_RELATIVE_URL_ROOT='/accelerated-possession-eviction' \
    PDFTK="/usr/bin/pdftk" \
    REDIS_STORE="redis://localhost:6379/1" \
    RAILS_ENV="development" \
    ENV_NAME="development" \
    GA_ID=""

EXPOSE $UNICORN_PORT

CMD ["/usr/bin/runsvdir", "-P", "/etc/service"]
