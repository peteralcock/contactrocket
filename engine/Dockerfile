FROM ruby:2.3.3
MAINTAINER Peter Alcock <admin@peteralcock.com>
RUN apt-get update -qq && apt-get install -qq -y --no-install-recommends build-essential nodejs libpq-dev make cmake autoconf automake libcurl3 zlib1g-dev libqt4-dev bison libpq-dev imagemagick libmagickwand-dev libkrb5-dev libicu-dev libssl-dev libyaml-dev zlib1g-dev libxml2-dev libxslt1-dev libcurl4-openssl-dev libqtwebkit-dev bison libssl-dev libc6-dev
ENV RACK_ENV production
ENV RAILS_ENV production
ENV INSTALL_PATH /app
RUN mkdir -p $INSTALL_PATH
WORKDIR $INSTALL_PATH
ADD . $INSTALL_PATH
COPY . .
COPY Gemfile Gemfile
COPY Gemfile.lock Gemfile.lock
RUN bundle install --without test development
COPY . .
CMD ['config/containers/app_cmd.sh']
