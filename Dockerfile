FROM docker.io/library/ruby:3.4-slim

WORKDIR /app

COPY Gemfile Gemfile.lock ./
RUN bundle config set without 'test' \
  && bundle install

COPY . .

RUN mkdir -p /app/store \
  && printf '{ "tasks": [] }\n' > /app/store/tasks.json \
  && chmod +x /app/docker-entrypoint.sh

ENTRYPOINT ["/app/docker-entrypoint.sh"]
CMD ["list"]
