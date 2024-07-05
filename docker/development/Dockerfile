FROM ruby:3.3.3

WORKDIR /app

RUN apt-get update -yy && apt-get install -yy \
  build-essential \
  imagemagick \
  libpq-dev \
  nodejs \
  postgresql-client \
  tmux \
  unzip

COPY package.json bun.lockb ./
RUN curl -fsSL https://bun.sh/install | bash
ENV PATH="/root/.bun/bin:$PATH"
RUN bun install

RUN curl -L https://github.com/DarthSim/overmind/releases/download/v2.2.2/overmind-v2.2.2-linux-amd64.gz | gzip -d > /usr/local/bin/overmind && chmod +x /usr/local/bin/overmind

COPY Gemfile Gemfile.lock ./

RUN BUNDLER_VERSION=$(grep -A 1 "BUNDLED WITH" Gemfile.lock | tail -n 1 | xargs) && \
  gem install bundler:$BUNDLER_VERSION --conservative
RUN bundle install

COPY . .

EXPOSE 3000
