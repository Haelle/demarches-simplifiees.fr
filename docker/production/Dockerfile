FROM ruby:3.3.3

WORKDIR /app

RUN apt-get update -yy && apt-get install -yy \
  build-essential \
  imagemagick \
  libpq-dev \
  postgresql-client \
  tmux \
  unzip

# try not to override installed files with local directory
# if we did some test builds
COPY . .

RUN curl -fsSL https://bun.sh/install | bash
ENV PATH="/root/.bun/bin:$PATH"
RUN bun install --production
RUN curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.39.7/install.sh | bash
RUN . ~/.bashrc && nvm install 18
RUN . ~/.bashrc && npm install --global yarn
RUN . ~/.bashrc && yarn install --production=true --non-interactive

RUN BUNDLER_VERSION=$(grep -A 1 "BUNDLED WITH" Gemfile.lock | tail -n 1 | xargs) && \
  gem install bundler:$BUNDLER_VERSION
RUN bundle install --deployment

EXPOSE 3001
