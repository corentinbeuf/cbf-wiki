FROM ubuntu:26.04

RUN apt update && apt upgrade -y
RUN apt-get install ruby-full build-essential zlib1g-dev -y
RUN gem install jekyll bundler

WORKDIR /
RUN jekyll new /opt/data

WORKDIR /data

EXPOSE 4000

CMD if [ ! -f /data/Gemfile ]; then cp -a /opt/data/. /data/; fi && bundle install && bundle exec jekyll serve --host=0.0.0.0 --port=4000 --force_polling
