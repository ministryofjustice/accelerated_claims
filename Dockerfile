FROM ministryofjustice/ruby:2.1.5-webapp-onbuild

# runit needs inittab
RUN touch /etc/inittab

RUN apt-get update
RUN apt-get install -y pdftk openjdk-7-jdk

ENV STRIKE2_VERSION 0.6.2

# Download and Compile 'strike2'
RUN mkdir -p /usr/local/bin \
    && wget -O /usr/local/bin/lein \
      https://raw.githubusercontent.com/technomancy/leiningen/2.4.2/bin/lein \
    && chmod +x /usr/local/bin/lein

RUN mkdir -p /srv/strike2 /etc/service/strike2
RUN git -C /srv clone -b v${STRIKE2_VERSION} https://github.com/ministryofjustice/strike2.git

ENV LEIN_ROOT true

RUN cd /srv/strike2 && pwd && ls -l && /usr/local/bin/lein deps && /usr/local/bin/lein ring uberjar

COPY ./docker/runit/strike2-service /etc/service/strike2/run
RUN chmod +x /etc/service/strike2/run

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
