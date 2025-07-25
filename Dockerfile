FROM ruby:3.1.3-alpine

WORKDIR /usr/src/app

RUN apk update && apk add build-base

COPY Gemfile Gemfile.lock ./
RUN bundle install

COPY . .

EXPOSE 4000

ENTRYPOINT [ "bundle", "exec", "jekyll" ]
CMD [ "serve", "--host", "0.0.0.0", "--port", "4000", "--watch" ]
