# FROM decidim/decidim:latest
FROM ruby:2.7.5-slim
LABEL maintainer="info@codegram.com"

ENV LANG C.UTF-8
ENV LC_ALL C.UTF-8
ENV RAILS_ENV production
ENV PORT 3000
ENV SECRET_KEY_BASE=no_need_for_such_secrecy
ENV RAILS_SERVE_STATIC_FILES=true

RUN apt-get update -y && apt-get install -y git imagemagick wget \
	&& apt-get clean

RUN curl -sL https://deb.nodesource.com/setup_16.x | bash - \
	&& apt-get install -y nodejs \
	&& apt-get clean

RUN npm install -g yarn

RUN gem install bundler

WORKDIR /code
COPY . .

# These two lines below will remove the `require` in `decidim-dev.gemspec`, which seems to be
# causing issues in certain circumstances using bundler. They should not be needed at all, so
# it's worth removing them in the future and checking out they work.
# RUN sed -i '/require/d' decidim-dev/decidim-dev.gemspec
# RUN sed -i "s/Decidim::Dev.version/\"$(cat .decidim-version)\"/g" decidim-dev/decidim-dev.gemspec

# WORKDIR /code/decidim_app-design

RUN bundle install
RUN bundle exec rails assets:precompile

ENTRYPOINT []

CMD bundle exec puma -C config/puma.rb