FROM debian:bookworm-slim

RUN apt-get update && apt-get install -y \
    postgresql-client \
    rclone \
    ca-certificates \
    gzip \
  && rm -rf /var/lib/apt/lists/*

WORKDIR /app
COPY backup.sh /app/backup.sh
RUN chmod +x /app/backup.sh

CMD ["/app/backup.sh"]