FROM ruby:2.3.3
RUN apt-get update -qq && apt-get install -y --no-install-recommends build-essential \
     nodejs libpq-dev libcurl3 zlib1g-dev libqt4-dev bison libpq-dev libkrb5-dev libicu-dev \
     libssl-dev libyaml-dev libc6-dev libxml2-dev libxslt1-dev libcurl4-openssl-dev \
     make cmake autoconf automake libcurl3 zlib1g-dev libqt4-dev bison libpq-dev imagemagick libmagickwand-dev \
     libkrb5-dev libicu-dev libssl-dev libyaml-dev zlib1g-dev libxml2-dev libxslt1-dev libcurl4-openssl-dev \
     libqtwebkit-dev bison libssl-dev libc6-dev
ENV RACK_ENV production
ENV RAILS_ENV production

WORKDIR /tmp
COPY . .
COPY Gemfile Gemfile
COPY Gemfile.lock Gemfile.lock
RUN bundle install --without test development
COPY ./crm/lib lib
COPY ./crm/contact_rocket_crm.gemspec contact_rocket_crm.gemspec
COPY ./crm/Gemfile Gemfile
COPY ./crm/Gemfile.lock Gemfile.lock
RUN bundle install --without test development
COPY ./engine/Gemfile Gemfile
COPY ./engine/Gemfile.lock Gemfile.lock
RUN bundle install --without test development