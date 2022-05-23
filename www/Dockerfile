FROM ruby:2.3.3
RUN apt-get update -qq && apt-get install -y --no-install-recommends build-essential \
 nodejs libpq-dev libcurl3 zlib1g-dev libqt4-dev bison libpq-dev libkrb5-dev libicu-dev \
  libssl-dev libyaml-dev libc6-dev libxml2-dev libxslt1-dev libcurl4-openssl-dev

RUN sudo ln -s `which nodejs` /usr/bin/node

ENV RACK_ENV production
ENV RAILS_ENV production
ENV INSTALL_PATH /app

WORKDIR /tmp
COPY Gemfile Gemfile
COPY Gemfile.lock Gemfile.lock
RUN bundle install --without test development

ADD . $INSTALL_PATH
WORKDIR $INSTALL_PATH

COPY . .
RUN bundle install --without test development
COPY Gemfile Gemfile
COPY Gemfile.lock Gemfile.lock
RUN bundle install --deployment
CMD ['config/containers/app_cmd.sh']
