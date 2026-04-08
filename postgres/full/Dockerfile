FROM --platform=linux/amd64 postgis/postgis:17-3.5

COPY postgres_full_entrypoint.sh /usr/local/bin/postgres_full_entrypoint.sh
RUN chmod +x /usr/local/bin/postgres_full_entrypoint.sh

RUN set -eux; \
  apt-get update; \
  apt-get install -y --no-install-recommends \
    build-essential \
    ca-certificates \
    curl \
    postgresql-server-dev-17; \
  rm -rf /var/lib/apt/lists/*; \
  mkdir -p /tmp/postgresql_anonymizer; \
  (curl -fsSL "https://codeload.github.com/daamien/postgresql_anonymizer/tar.gz/refs/heads/master" | tar -xz -C /tmp/postgresql_anonymizer --strip-components=1) || \
  (curl -fsSL "https://codeload.github.com/daamien/postgresql_anonymizer/tar.gz/refs/heads/main" | tar -xz -C /tmp/postgresql_anonymizer --strip-components=1); \
  make -C /tmp/postgresql_anonymizer install; \
  rm -rf /tmp/postgresql_anonymizer; \
  apt-get purge -y --auto-remove \
    build-essential \
    curl \
    postgresql-server-dev-17; \
  rm -rf /var/lib/apt/lists/*

