FROM node:25.5.0-slim

RUN --mount=type=cache,target=/var/cache/apt \
    apt-get update && apt-get install -y --no-install-recommends \
    ca-certificates dnsutils iputils-ping lsof net-tools \
    git vim nano curl wget jq bash-completion unzip  \
    yamllint shellcheck \
    libpng-dev && \
    rm -rf /var/lib/apt/lists/*

# renovate: datasource=github-releases depName=npm packageName=npm/cli
ENV NPM_VERSION=11.6.0
RUN npm install -g "npm@${NPM_VERSION}"

# renovate: datasource=github-releases depName=dotenv-linter packageName=dotenv-linter/dotenv-linter
ENV DOTENV_LINTER_VERSION=v4.0.0
RUN curl -sSfL "https://raw.githubusercontent.com/dotenv-linter/dotenv-linter/${DOTENV_LINTER_VERSION}/install.sh" | sh -s -- -b /usr/bin

COPY docker/dev.bashrc /usr/local/etc/
RUN echo '. /usr/local/etc/dev.bashrc' >> /etc/bash.bashrc

RUN npm completion > /etc/bash_completion.d/npm
RUN chmod go+w /etc/bash_completion.d

WORKDIR /app

RUN git config --global --add safe.directory /app
RUN npm config --global set engine-strict=true
RUN npm config --global set logs-max=0

EXPOSE 9000
