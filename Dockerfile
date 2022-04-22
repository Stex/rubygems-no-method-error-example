FROM ruby:3.1.2
WORKDIR /app

COPY ./ ./
RUN bundle config set --local path '/gems'
RUN bundle install

CMD ["/bin/bash"]
