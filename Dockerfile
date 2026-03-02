# Postgres 18 image includes pg_dump 18.x (matches your server 18.1)
FROM postgres:18

# Install rclone + gzip (postgres image already has pg_dump/pg_restore)
RUN apt-get update && apt-get install -y --no-install-recommends \
    rclone \
    gzip \
    ca-certificates \
  && rm -rf /var/lib/apt/lists/*

WORKDIR /app
COPY backup.sh /app/backup.sh
RUN chmod +x /app/backup.sh

CMD ["/bin/bash", "-lc", "/app/backup.sh"]