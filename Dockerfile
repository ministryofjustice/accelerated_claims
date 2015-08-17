FROM ministryofjustice/ruby:2.1.5-webapp-onbuild


ENV UNICORN_PORT 3000

ENV \
    STRIKE2_VERSION="0.6.2" \
    LEIN_ROOT=true \
    UNICORN_PORT="3000" \
    WEBUSER="moj" \
    ZENDESK_USERNAME="" \
    ZENDESK_TOKEN="" \
    NEW_RELIC_LICENSE_KEY="" \
    APPSIGNAL_PUSH_API_KEY="" \
    ANONYMOUS_PLACEHOLDER_EMAIL="" \
    RAILS_RELATIVE_URL_ROOT='' \
    PDFTK="/usr/bin/pdftk" \
    REDIS_STORE="redis://localhost:6379/1" \
 #  RAILS_ENV="development" \
    ENV_NAME="development" \
    GA_ID=""

# runit needs inittab
RUN touch /etc/inittab

RUN apt-get update && apt-get install -y \
      pdftk \
      openjdk-7-jdk

# Download and Compile 'strike2'
RUN mkdir -p /usr/local/bin \
    && wget -O /usr/local/bin/lein \
      https://raw.githubusercontent.com/technomancy/leiningen/2.4.2/bin/lein \
    && chmod +x /usr/local/bin/lein

RUN mkdir -p /srv/strike2 /etc/service/strike2 /etc/service/accelerated_claims
RUN git -C /srv clone -b v${STRIKE2_VERSION} https://github.com/ministryofjustice/strike2.git

RUN cd /srv/strike2 && pwd && ls -l && /usr/local/bin/lein deps && /usr/local/bin/lein ring uberjar

COPY ./docker/runit/strike2-service /etc/service/strike2/run
RUN chmod 777 ./log
RUN cd ./log
RUN chmod 777 ./*
COPY ./docker/runit/runit-service /etc/service/accelerated_claims/run

#SECRET_TOKEN set here because otherwise devise blows up during the precompile.
RUN bundle exec rake assets:precompile RAILS_ENV=production SECRET_TOKEN=blah

RUN chmod +x /etc/service/strike2/run /etc/service/accelerated_claims/run


EXPOSE $UNICORN_PORT

CMD ["/usr/bin/runsvdir", "-P", "/etc/service"]
